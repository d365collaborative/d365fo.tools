
<#
    .SYNOPSIS
        Import an user from an external Azure Active Directory (AAD)
        
    .DESCRIPTION
        Imports an user from an AAD that is NOT the same as the AAD tenant that the D365FO environment is running under
        
    .PARAMETER Id
        The internal Id that the user must be imported with
        
        The Id has to unique across the entire user base
        
    .PARAMETER Name
        The display name of the user inside the D365FO environment
        
    .PARAMETER Email
        The email address of the user that you want to import
        
        This is also the sign-in user name / e-mail address to gain access to the system
        
        If the external AAD tenant has multiple custom domain names, you have to use the domain that they have configured as default
        
    .PARAMETER Company
        Default company that should be configured for the user, for when they sign-in to the D365 environment
        
        Default value is "DAT"
        
    .PARAMETER Language
        Language that should be configured for the user, for when they sign-in to the D365 environment
        
        Default value is "en-US"
        
    .PARAMETER Enabled
        Should the imported user be enabled or not?
        
        Default value is 1, which equals true / yes
        
    .PARAMETER UpdateObjectId
        Switch to look up the user's Azure AD ObjectId from Microsoft Graph and store it in D365FO.
        
        When this switch is enabled, the cmdlet calls Microsoft Graph
        (https://graph.microsoft.com/v1.0/users) to resolve the ObjectId for the given Email address
        and passes it to the underlying SQL import. This fixes a known issue where restoring a
        Tier-2 database to a Tier-1 environment causes user sign-in failures because the UserInfo
        table's OBJECTID column is incorrectly copied from the admin user.
        
        Requires an active Azure connection (Connect-AzAccount) before calling this cmdlet.
        
        Without this switch, ObjectId is left empty and existing behavior is preserved.
        
    .PARAMETER ObjectId
        Explicitly provide the Azure AD ObjectId for the user being imported.
        
        Use this when you already know the ObjectId and want to avoid the Graph API call.
        If both -UpdateObjectId and -ObjectId are specified, the explicitly provided -ObjectId
        value takes precedence and no Graph lookup is performed.
        
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
        
    .EXAMPLE
        PS C:\> Import-D365ExternalUser -Id "John" -Name "John Doe" -Email "John@contoso.com"
        
        This will import an user from an external Azure Active Directory.
        The new user will get the system wide Id "John".
        The name of the new user will be "John Doe".
        The e-mail address / sign-in e-mail address will be registered as "John@contoso.com".
        
    .EXAMPLE
        PS C:\> Import-D365ExternalUser -Id "John" -Name "John Doe" -Email "John@contoso.com" -UpdateObjectId
        
        This will import an user from an external Azure Active Directory and resolve the user's
        ObjectId from Microsoft Graph to store in D365FO.
        
        Connect-AzAccount is required before using -UpdateObjectId.
        
        Resolving the ObjectId is necessary to avoid login failures in environments that have had
        their database restored from a Tier-2 environment, where the UserInfo OBJECTID column would
        otherwise be copied from the environment's admin user.
        
    .EXAMPLE
        PS C:\> Import-D365ExternalUser -Id "John" -Name "John Doe" -Email "John@contoso.com" -ObjectId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
        
        This will import an user from an external Azure Active Directory and use the supplied
        ObjectId directly, without making a Microsoft Graph API call.
        
    .NOTES
        Tags: User, Users, Security, Configuration, Permission, AAD, Azure Active Directory
        
        Author: Anderson Joyle (@AndersonJoyle)
        
        Author: MÃ¶tz Jensen (@Splaxi)
#>

function Import-D365ExternalUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Id,

        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $Email,

        [Parameter(Mandatory = $false)]
        [int] $Enabled = 1,

        [Parameter(Mandatory = $false)]
        [string] $Company = "DAT",

        [Parameter(Mandatory = $false)]
        [string] $Language = "en-us",

        [Parameter(Mandatory = $false)]
        [switch] $UpdateObjectId,

        [Parameter(Mandatory = $false)]
        [string] $ObjectId,

        [Parameter(Mandatory = $false)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false)]
        [string]$SqlPwd = $Script:DatabaseUserPassword
    )

    begin {
        Invoke-TimeSignal -Start

        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $SqlParams = @{ DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd
        }

        $SqlCommand = Get-SqlCommand @SqlParams -TrustedConnection $UseTrustedConnection

        try {
            $sqlCommand.Connection.Open()
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        try {
            $userAuth = Get-D365UserAuthenticationDetail $Email

            $provider = $userAuth.IdentityProvider
            $networkDomain = $userAuth.NetworkDomain
            $sid = $userAuth.SID

            Write-PSFMessage -Level Verbose -Message "Extracted sid: $sid"

            # Resolve ObjectId: caller-supplied value takes precedence; if -UpdateObjectId is set
            # and no explicit -ObjectId was provided, look it up from Microsoft Graph.
            $resolvedObjectId = ""

            if ($PSBoundParameters.ContainsKey("ObjectId")) {
                $resolvedObjectId = $ObjectId
                Write-PSFMessage -Level Verbose -Message "Using caller-supplied ObjectId: $resolvedObjectId"
            }
            elseif ($UpdateObjectId) {
                Write-PSFMessage -Level Verbose -Message "Looking up ObjectId for $Email from Microsoft Graph"

                $resObj = Invoke-AzRestMethod -Uri "https://graph.microsoft.com/v1.0/users?`$filter=mail eq '$Email' or userPrincipalName eq '$Email'"

                if ($resObj.StatusCode -like "2**") {
                    $aadUser = $resObj.Content | ConvertFrom-Json | Select-Object -ExpandProperty value | Select-Object -First 1

                    if ($null -ne $aadUser) {
                        $resolvedObjectId = $aadUser.id
                        Write-PSFMessage -Level Verbose -Message "Resolved ObjectId: $resolvedObjectId"
                    }
                    else {
                        Write-PSFMessage -Level Warning -Message "Microsoft Graph returned no user matching '$Email'. Proceeding without ObjectId."
                    }
                }
                else {
                    Write-PSFMessage -Level Warning -Message "Microsoft Graph lookup failed for '$Email' (HTTP $($resObj.StatusCode)). Proceeding without ObjectId."
                }
            }

            Import-AadUserIntoD365FO -SqlCommand $SqlCommand -SignInName $Email -Name $Name -Id $Id -SID $SID -StartUpCompany $Company -IdentityProvider $provider -NetworkDomain $networkDomain -Language $Language -ObjectId $resolvedObjectId

            if (Test-PSFFunctionInterrupt) { return }
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

    end {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()

        Invoke-TimeSignal -End
    }
}
