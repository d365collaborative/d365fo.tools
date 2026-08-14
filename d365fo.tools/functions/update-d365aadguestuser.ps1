
<#
    .SYNOPSIS
        Updates the guest user details in the database
        
    .DESCRIPTION
        Is capable of updating the identity provider, network domain and object id inside the UserInfo table for AAD guest users
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER Email
        The search string to select which user(s) should be updated.
        
        The parameter supports wildcards. E.g. -Email "*@contoso.com*"
        
    .PARAMETER AzureAdCredential
        Use a PSCredential object for connecting with AzureAd
        
    .PARAMETER TenantId
        The TenantId to use when connecting to Azure Active Directory
        
        Uses the tenant id of the current environment if not specified.
        
    .EXAMPLE
        PS C:\> Update-D365AadGuestUser -Email "claire@contoso.com"
        
        This will search for the user with the e-mail address claire@contoso.com and update it with the identity provider, network domain and object id needed for an AAD guest user
        
    .EXAMPLE
        PS C:\> Update-D365AadGuestUser -Email "*contoso.com"
        
        This will search for all users with an e-mail address containing 'contoso.com' and update them with the identity provider, network domain and object id needed for an AAD guest user
        
    .EXAMPLE
        PS C:\> Update-D365AadGuestUser -Email "claire@contoso.com" -TenantId "99999999-aaaa-bbbb-cccc-9999999999"
        
        This will search for the user with the e-mail address claire@contoso.com and update it with the identity provider, network domain and object id needed for an AAD guest user.
        Uses tenant id "99999999-aaaa-bbbb-cccc-9999999999" when connecting to Azure Active Directory(AAD).
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory, Guest
        
        Author: Mötz Jensen (@Splaxi)
        
        At no circumstances can this cmdlet be used to update users in a PROD environment.
        
#>
function Update-D365AadGuestUser {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string]$DatabaseServer = $Script:DatabaseServer,

        [string]$DatabaseName = $Script:DatabaseName,

        [string]$SqlUser = $Script:DatabaseUserName,

        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Email,

        [PSCredential] $AzureAdCredential,

        [string] $TenantId = $Script:TenantId
    )
    begin {
        Invoke-TimeSignal -Start

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

            $sqlCommand.Connection.Open()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against Azure Active Directory or the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        $users = Get-D365User -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd -Email $Email

        if (Test-PSFFunctionInterrupt) { return }

        try {
            foreach ($user in $users) {
                $aadUser = $null

                $guestUpnPrefix = [uri]::EscapeDataString(($user.Email -replace '@', '_') + '#EXT#')
                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/users?`$filter=mail eq '$($user.Email)' or startswith(userPrincipalName,'$guestUpnPrefix')"

                if ($resObj.StatusCode -like "2**") {
                    $aadUser = $resObj.Content |
                        ConvertFrom-Json |
                        Select-Object -ExpandProperty value |
                        Select-Object -First 1
                }

                if ($null -eq $aadUser) {
                    Write-PSFMessage -Level Critical "Could not find user $($user.Email) in AzureAAd"
                    continue
                }

                $provider = $canonicalProvider
                $networkDomain = $canonicalProvider
                $resolvedObjectId = $aadUser.id

                Write-PSFMessage -Level Verbose -Message "Updating $($user.Email) - Provider $provider - ObjectId $resolvedObjectId"

                Update-AadGuestUserInD365FO -SqlCommand $SqlCommand -Id $user.UserId -IdentityProvider $provider -NetworkDomain $networkDomain -ObjectId $resolvedObjectId

                if (Test-PSFFunctionInterrupt) { return }

                Write-PSFMessage -Level Host -Message "User $($user.Email) Updated"
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against Azure Active Directory or the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()

        Invoke-TimeSignal -End
    }
}