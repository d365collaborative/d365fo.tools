
<#
    .SYNOPSIS
        Used to import Aad users into D365FO
        
    .DESCRIPTION
        Provides a method for importing a AAD UserGroup or a comma separated list of AadUsers into D365FO.
        
    .PARAMETER AadGroupName
        Azure Active directory user group containing users to be imported
        
    .PARAMETER Users
        Array of users that you want to import into the D365FO environment
        
    .PARAMETER StartupCompany
        Startup company of users imported.
        
        Default is DAT
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER IdPrefix
        A text that will be prefixed into the ID field. E.g. -IdPrefix "EXT-" will import users and set ID starting with "EXT-..."
        
    .PARAMETER NameSuffix
        A text that will be suffixed into the NAME field. E.g. -NameSuffix "(Contoso)" will import users and append "(Contoso)"" to the NAME
        
    .PARAMETER IdValue
        Specify which field to use as ID value when importing the users.
        Available options 'Login' / 'FirstName' / 'UserPrincipalName'
        
        Default is 'Login'
        
    .PARAMETER NameValue
        Specify which field to use as NAME value when importing the users.
        Available options 'FirstName' / 'DisplayName'
        
        Default is 'DisplayName'
        
    .PARAMETER AzureAdCredential
        Use a PSCredential object for connecting with AzureAd
        
    .PARAMETER SkipAzureAd
        Switch to instruct the cmdlet to skip validating against the Azure Active Directory
        
    .PARAMETER ForceExactAadGroupName
        Force to find the exact name of the Azure Active Directory Group
        
    .PARAMETER AadGroupId
        Azure Active directory user group ID containing users to be imported
        
    .PARAMETER EmailValue
        Specify which field to use as EMAIL value when importing the users.
        Available options 'Mail' / 'UserPrincipalName'
        
        Default is 'Mail'
        
    .PARAMETER TenantId
        The TenantId to use when connecting to Azure Active Directory
        
        Uses the tenant id of the current environment if not specified.
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com"
        
        Imports Claire and Allen as users
        
    .EXAMPLE
        PS C:\> $myPassword = ConvertTo-SecureString "MyPasswordIsSecret" -AsPlainText -Force
        PS C:\> $myCredentials = New-Object System.Management.Automation.PSCredential ("MyEmailIsAlso", $myPassword)
        
        PS C:\> Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -AzureAdCredential $myCredentials
        
        This will import Claire and Allen as users.
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -AadGroupName "CustomerTeam1"
        
        if more than one group match the AadGroupName, you can use the ExactAadGroupName parameter
        Import-D365AadUser -AadGroupName "CustomerTeam1" -ForceExactAadGroupName
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -AadGroupName "CustomerTeam1" -ForceExactAadGroupName
        
        This is used to force the cmdlet to find the exact named group in Azure Active Directory.
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -AadGroupId "99999999-aaaa-bbbb-cccc-9999999999"
        
        Imports all the users that is present in the AAD Group called CustomerTeam1
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -SkipAzureAd
        
        Imports Claire and Allen as users.
        Will NOT make you connect to the Azure Active Directory(AAD).
        The needed details will be based on the e-mail address only, and the rest will be blanked.
        
    .EXAMPLE
        PS C:\> Import-D365AadUser -Users "Claire@contoso.com","Allen@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
        
        Imports Claire and Allen as users. Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999"
        when connecting to Azure Active Directory(AAD).
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Group, Groups
        
        Author: Rasmus Andersen (@ITRasmus)
        Author: Charles Colombel (@dropshind)
        Author: Mötz Jensen (@Splaxi)
        Author: Miklós Molnár (@scifimiki)
        Author: Gert Van der Heyden (@gertvdh)
        Author: Florian Hopfner (@FH-Inway)
        
        At no circumstances can this cmdlet be used to import users into a PROD environment.
        
        Only users from an Azure Active Directory that you have access to, can be imported.
        Use AAD B2B implementation if you want to support external people.
        
        Every imported users will get the System Administration / Administrator role assigned on import
        
#>

function Import-D365AadUser {
    [CmdletBinding(DefaultParameterSetName = 'UserListImport')]
    param (
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "GroupNameImport")]
        [String] $AadGroupName,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "UserListImport")]
        [string[]]$Users,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $StartupCompany = 'DAT',

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 6)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, Position = 7)]
        [string] $IdPrefix = "",

        [Parameter(Mandatory = $false, Position = 8)]
        [string] $NameSuffix = "",

        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateSet('Login', 'FirstName', 'UserPrincipalName')]
        [string] $IdValue = "Login",

        [Parameter(Mandatory = $false, Position = 10)]
        [ValidateSet('FirstName', 'DisplayName')]
        [string] $NameValue = "DisplayName",

        [Parameter(Mandatory = $false, Position = 11)]
        [PSCredential] $AzureAdCredential,

        [Parameter(Mandatory = $false, Position = 12, ParameterSetName = "UserListImport")]
        [switch] $SkipAzureAd,

        [Parameter(Mandatory = $false, Position = 13, ParameterSetName = "GroupNameImport")]
        [switch] $ForceExactAadGroupName,

        [Parameter(Mandatory = $true, Position = 14, ParameterSetName = "GroupIdImport")]
        [string] $AadGroupId,

        [Parameter(Mandatory = $false, Position = 15)]
        [ValidateSet('Mail', 'UserPrincipalName')]
        [string] $EmailValue = "Mail",

        [Parameter(Mandatory = $false, Position = 16)]
        [string] $TenantId = $Script:TenantId
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $instanceProvider = Get-InstanceIdentityProvider
    $canonicalProvider = Get-CanonicalIdentityProvider

    try {
        Write-PSFMessage -Level Verbose -Message "Trying to connect to the Azure Active Directory with tenant id '$TenantId'"

        if ($PSBoundParameters.ContainsKey("AzureAdCredential") -eq $true) {
            Connect-AzAccount -Credential $AzureAdCredential -ErrorAction Stop -TenantId $TenantId
        }
        else {
            if ($SkipAzureAd -eq $false) {
                Connect-AzAccount -ErrorAction Stop -TenantId $TenantId
            }
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while connecting to Azure Active Directory" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    $azureAdUsers = New-Object -TypeName "System.Collections.ArrayList"

    $aadUserProperties = @{
        Property = "Id as ObjectId", "mail", "givenName", "displayName", "userPrincipalName"
    }
    if (( $PSCmdlet.ParameterSetName -eq "GroupNameImport") -or ($PSCmdlet.ParameterSetName -eq "GroupIdImport")) {

        if ($PSCmdlet.ParameterSetName -eq 'GroupIdImport') {
            Write-PSFMessage -Level Verbose -Message "Search AadGroup by its ID : $AadGroupId"

            $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/groups/$AadGroupId"

            if ($resObj.StatusCode -like "2**") {
                $group = $resObj.Content | ConvertFrom-Json
            }
        }
        else {
            if ($ForceExactAadGroupName) {
                Write-PSFMessage -Level Verbose -Message "Search AadGroup by its exactly name : $AadGroupName"

                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/groups?`$filter=DisplayName eq '$AadGroupName'"

                if ($resObj.StatusCode -like "2**") {
                    $group = $resObj.Content | ConvertFrom-Json | Select-Object -ExpandProperty value
                }
            }
            else {
                Write-PSFMessage -Level Verbose -Message "Search AadGroup by searching with its name : $AadGroupName"

                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/groups?`$filter=startswith(DisplayName,'$AadGroupName')"

                if ($resObj.StatusCode -like "2**") {
                    $group = $resObj.Content | ConvertFrom-Json | Select-Object -ExpandProperty value
                }
            }
        }

        if ($null -eq $group) {
            Write-PSFMessage -Level Host -Message "Unable to find the specified group in the AAD. Please ensure the group exists and that you have enough permissions to access it."
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        else {
            Write-PSFMessage -Level Host -Message "Processing Azure AD user Group `"$($group[0].DisplayName)`""
        }

        if ($group.Length -gt 1) {
            Write-PSFMessage -Level Host -Message "More than one group found"
            foreach ($foundGroup in $group) {
                Write-PSFMessage -Level Host -Message "Group found $($foundGroup.DisplayName)"
            }
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        $resMembersObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/groups/$($group.id)/members"

        if ($resMembersObj.StatusCode -like "2**") {
            $userlist = $resMembersObj.Content | ConvertFrom-Json | Select-Object -ExpandProperty value
        }

        foreach ($user in $userlist) {
            if ($user.'@odata.type' -eq "#microsoft.graph.user") {

                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/users/$($user.id)"

                if ($resObj.StatusCode -like "2**") {
                    $azureAdUser = $resObj.Content |
                        ConvertFrom-Json |
                        Select-Object -First 1 |
                        Select-PSFObject @aadUserProperties
                }

                if ($null -eq $azureAdUser.mail) {
                    Write-PSFMessage -Level Critical "User $($user.ObjectId) did not have an Mail"
                }
                else {
                    $null = $azureAdUsers.Add($azureAdUser)
                }
            }
        }
    }
    else {
        foreach ($user in $Users) {

            if ($SkipAzureAd -eq $true) {
                $name = Get-LoginFromEmail $user
                $null = $azureAdUsers.Add([PSCustomObject]@{
                        mail              = $user
                        givenName         = $name
                        displayName       = $name
                        ObjectId          = ''
                        userPrincipalName = $user
                    })
            }
            else {
                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/users?`$filter=mail eq '$user' or userPrincipalName eq '$user'"

                if ($resObj.StatusCode -like "2**") {
                    $aadUser = $resObj.Content |
                        ConvertFrom-Json |
                        Select-Object -ExpandProperty value |
                        Select-Object -First 1 |
                        Select-PSFObject @aadUserProperties
                }

                if ($null -eq $aadUser) {
                    Write-PSFMessage -Level Critical "Could not find user $user in AzureAAd"
                }
                else {
                    $null = $azureAdUsers.Add($aadUser)
                }
            }
        }
    }

    try {
        $sqlCommand.Connection.Open()

        foreach ($user in $azureAdUsers) {

            $identityProvider = $canonicalProvider

            Write-PSFMessage -Level Verbose -Message "Getting tenant from $($user.Mail)."
            $tenant = Get-TenantFromEmail $user.Mail

            Write-PSFMessage -Level Verbose -Message "Getting domain from $($user.Mail)."
            $networkDomain = Get-NetworkDomain $user.Mail

            Write-PSFMessage -Level Verbose -Message "InstanceProvider : $InstanceProvider"
            Write-PSFMessage -Level Verbose -Message "Tenant : $Tenant"

            if ($user.Mail.ToLower().Contains("outlook.com") -eq $true) {
                $identityProvider = "live.com"
            }
            else {
                if ($instanceProvider.ToLower().Contains($tenant.ToLower()) -ne $True) {
                    Write-PSFMessage -Level Verbose -Message "Getting identity provider from  $($user.Mail)."
                    $identityProvider = Get-IdentityProvider $user.Mail
                }
            }

            Write-PSFMessage -Level Verbose -Message "Getting sid from  $($user.Mail) and identity provider : $identityProvider."
            $sid = Get-UserSIDFromAad $user.Mail $identityProvider
            Write-PSFMessage -Level Verbose -Message "Generated SID : $sid"
            $id = ""
            if ($IdValue -eq 'Login') {
                $id = $IdPrefix + $(Get-LoginFromEmail $user.Mail)
            }
            elseif ($IdValue -eq 'UserPrincipalName') {
                $id = $IdPrefix + $user.UserPrincipalName
            }
            else {
                $id = $IdPrefix + $user.GivenName
            }

            if ($id.Length -gt 20) {
                $oldId = $id
                $id = $id -replace '^(.{0,20}).*', '$1'
                Write-PSFMessage -Level Host -Message "The id <c='em'>'$oldId'</c> does not fit the <c='em'>20 character limit</c> on UserInfo table's ID field and will be truncated to <c='em'>'$id'</c>"
            }


            $name = ""
            if ($NameValue -eq 'DisplayName') {
                $name = $user.DisplayName + $NameSuffix
            }
            else {
                $name = $user.GivenName + $NameSuffix
            }

            $email = ""
            if ($EmailValue -eq 'Mail') {
                $email = $user.Mail
            }
            else {
                $email = $user.UserPrincipalName
            }

            Write-PSFMessage -Level Verbose -Message "Id for user $email : $id"
            Write-PSFMessage -Level Verbose -Message "Name for user $email : $name"
            Write-PSFMessage -Level Verbose -Message "Importing $email - SID $sid - Provider $identityProvider"

            Import-AadUserIntoD365FO $SqlCommand $email $name $id $sid $StartupCompany $identityProvider $networkDomain $user.ObjectId

            if (Test-PSFFunctionInterrupt) { return }
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