
<#
    .SYNOPSIS
        Used to import Aad guest users into D365FO
        
    .DESCRIPTION
        Provides a method for importing a comma separated list of Aad guest users into D365FO.
        
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
        Available options 'Login' / 'FirstName'
        
        Default is 'Login'
        
    .PARAMETER NameValue
        Specify which field to use as NAME value when importing the users.
        Available options 'FirstName' / 'DisplayName'
        
        Default is 'DisplayName'
        
    .PARAMETER AzureAdCredential
        Use a PSCredential object for connecting with AzureAd
        
    .PARAMETER TenantId
        The TenantId to use when connecting to Azure Active Directory
        
        Uses the tenant id of the current environment if not specified.
        
    .EXAMPLE
        PS C:\> Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com"
        
        Imports Claire and Allen as guest users
        
    .EXAMPLE
        PS C:\> $myPassword = ConvertTo-SecureString "MyPasswordIsSecret" -AsPlainText -Force
        PS C:\> $myCredentials = New-Object System.Management.Automation.PSCredential ("MyEmailIsAlso", $myPassword)
        
        PS C:\> Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com" -AzureAdCredential $myCredentials
        
        This will import Claire and Allen as guest users.
        
    .EXAMPLE
        PS C:\> Import-D365AadGuestUser -Users "Claire@contoso.com","Allen@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
        
        Imports Claire and Allen as guest users. Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999"
        when connecting to Azure Active Directory(AAD).
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Guest
        
        Author: Mötz Jensen (@Splaxi)
        
        At no circumstances can this cmdlet be used to import users into a PROD environment.
        
        Only guest users from an Azure Active Directory that you have access to, can be imported.
        
        Every imported users will get the System Administration / Administrator role assigned on import
        
#>

function Import-D365AadGuestUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
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
        [ValidateSet('Login', 'FirstName')]
        [string] $IdValue = "Login",

        [Parameter(Mandatory = $false, Position = 10)]
        [ValidateSet('FirstName', 'DisplayName')]
        [string] $NameValue = "DisplayName",

        [Parameter(Mandatory = $false, Position = 11)]
        [PSCredential] $AzureAdCredential,

        [Parameter(Mandatory = $false, Position = 12)]
        [string] $TenantId = $Script:TenantId
    )

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd
    }

    $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

    $canonicalProvider = Get-CanonicalIdentityProvider

    try {
        Write-PSFMessage -Level Verbose -Message "Trying to connect to the Azure Active Directory with tenant id '$TenantId'"

        if ($PSBoundParameters.ContainsKey("AzureAdCredential") -eq $true) {
            Connect-AzAccount -Credential $AzureAdCredential -ErrorAction Stop -TenantId $TenantId
        }
        else {
            Connect-AzAccount -ErrorAction Stop -TenantId $TenantId
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while connecting to Azure Active Directory" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    $azureAdUsers = New-Object -TypeName "System.Collections.ArrayList"

    $aadUserProperties = @{
        Property = "Id as ObjectId", "mail", "givenName", "displayName"
    }

    foreach ($user in $Users) {
        $aadUser = $null
        
        $guestUpnPrefix = [uri]::EscapeDataString(($user -replace '@', '_') + '#EXT#')
        $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/users?`$filter=mail eq '$user' or startswith(userPrincipalName,'$guestUpnPrefix')"

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

    try {
        $sqlCommand.Connection.Open()

        foreach ($user in $azureAdUsers) {

            $identityProvider = $canonicalProvider
            $networkDomain = $canonicalProvider

            Write-PSFMessage -Level Verbose -Message "Getting sid from  $($user.Mail) and identity provider : $identityProvider."
            $sid = Get-UserSIDFromAad $user.Mail $identityProvider
            
            Write-PSFMessage -Level Verbose -Message "Generated SID : $sid"
            $id = ""

            if ($IdValue -eq 'Login') {
                $id = $IdPrefix + $(Get-LoginFromEmail $user.Mail)
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

            $email = $user.Mail

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