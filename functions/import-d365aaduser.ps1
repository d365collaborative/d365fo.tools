<#
.SYNOPSIS
Used to import Aad users into D365FO

.DESCRIPTION
Provides a method for importing a AAD UserGroup or a comma separated list of AadUsers into D365FO.

.PARAMETER AadGroupName
Azure Active directory user group containing users to be imported

.PARAMETER UserList
A comma separated list of Aad users to be imported into D365FO

.PARAMETER StartupCompany
Startup company of users imported.

Default is DAT

.PARAMETER DatabaseServer
Alternative SQL Database server, Default is the one provided by the DataAccess object

.PARAMETER DatabaseName
Alternative SQL Database, Default is the one provided by the DataAccess object

.PARAMETER SqlUser
Alternative SQL user, Default is the one provided by the DataAccess object

.PARAMETER SqlPwd
Alternative SQL user password, Default is the one provided by the DataAccess object

.PARAMETER IdPrefix
A text that will be prefixed into the ID field. E.g. -IdPrefix "EXT-" will import users and set ID starting with "EXT-..."

.PARAMETER NameSuffix
A text that will be suffixed into the NAME field. E.g. -NameSuffix "(Contoso)" will import users and append "(Contoso)"" to the NAME

.PARAMETER IdValue
Specify which field to use as ID value when importing the users.
Available options 'Login' / 'FirstName'

Default is 'Login'

.PARAMETER NameValue
Specify which field to use as NAME value when importing the users.
Available options 'FirstName' / 'DisplayName'

Default is 'DisplayName'

.EXAMPLE
Import-D365AadUser -Userlist "Claire@contoso.com,Allen@contoso.com"

Imports Claire and Allen as users.

.EXAMPLE
Import-D365AadUser -AadGroupName "CustomerTeam1"

Imports all the users that is present in the AAD Group called CustomerTeam1

.NOTES
At no circumstances can this cmdlet be used to import users into a PROD environment.

Only users from an Azure Active Directory that you have access to, can be imported.
Use AAD B2B implementation if you want to support external people.

Every imported users will get the System Administration / Administrator role assigned on import
#>

function Import-D365AadUser {
    [CmdletBinding(DefaultParameterSetName = 'UserListImport')]
    param (
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "GroupImport")]
        [String]$AadGroupName,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "UserListImport")]
        [string]$UserList,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$StartupCompany = 'DAT',

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 6)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, Position = 7)]
        [string]$IdPrefix = "",

        [Parameter(Mandatory = $false, Position = 8)]
        [string]$NameSuffix = "",

        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateSet('Login', 'FirstName')]
        [string]$IdValue = "Login",

        [Parameter(Mandatory = $false, Position = 10)]
        [ValidateSet('FirstName', 'DisplayName')]
        [string]$NameValue = "DisplayName"
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd 
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $instanceProvider = Get-InstanceIdentityProvider
    $canonicalProvider = Get-CanonicalIdentityProvider

    Write-PSFMessage -Level Verbose -Message "CanonicalIdentityProvider: $Provider"

    try {
        Write-PSFMessage -Level Verbose -Message "Trying to connect to the Azure Active Directory"

        Connect-MsolService -ErrorAction Stop
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while connecting to Azure Active Directory" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    

    $msolUsers = New-Object -TypeName "System.Collections.ArrayList"

    if ( $PSCmdlet.ParameterSetName -eq "GroupImport") {

        $group = Get-MsolGroup -SearchString $AadGroupName

        if ($null -eq $group) {
            Write-PSFMessage -Level Host -Message "Unable to find the specified group in the AAD. Please ensure the group exists and that you have enough permissions to access it."
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        $users = Get-MsolGroupMember -GroupObjectId $group[0].ObjectId

        foreach ($user in $users) {
            if ($user.GroupMemberType -eq "User") {
                $null = $msolUsers.Add((Get-MsolUser -ObjectId $user.ObjectId))
            }
        }
    }
    else {
        $usersFromList = $UserList.Split(";")

        foreach ($str in $usersFromList) {
            $null = $msolUsers.Add((Get-MsolUser -SearchString $str))
        }
    }

    try {
        $sqlCommand.Connection.Open()

        foreach ($user in $msolUsers) {

            $identityProvider = $canonicalProvider

            Write-PSFMessage -Level Verbose -Message "Getting tenant from sign in name."
            $tenant = Get-TenantFromEmail $user.SignInName

            Write-PSFMessage -Level Verbose -Message "Getting domain from sign in name."
            $networkDomain = get-NetworkDomain $user.SignInName
    
            if ($instanceProvider.ToLower().Contains($tenant.ToLower()) -ne $True) {
                Write-PSFMessage -Level Verbose -Message "Getting identity provider from sign in name."
                $identityProvider = Get-IdentityProvider $user.SignInName
            }
    
            Write-PSFMessage -Level Verbose -Message "Getting sig from sign in name and identity provider."
            $sid = Get-UserSIDFromAad $user.SignInName $identityProvider

            $id = ""
            if ($IdValue -eq 'Login') {
                $id = $IdPrefix + $(Get-LoginFromEmail $user.SignInName)
            }
            else {
                $id = $IdPrefix + $user.FirstName
            }
    
            $name = ""
            if ($NameValue -eq 'DisplayName') {
                $name = $user.DisplayName + $NameSuffix
            }
            else {
                $name = $user.FirstName + $NameSuffix
            }
    
            Write-PSFMessage -Level Verbose -Message "Importing $($user.SignInName) - SID $sid - Provider $identityProvider"
            Import-AadUserIntoD365FO $SqlCommand $user.SignInName $name $id $sid $StartupCompany $identityProvider $networkDomain $user.ObjectId
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()    
        }
        $sqlCommand.Dispose()
    }
}

