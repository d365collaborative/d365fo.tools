
<#
    .SYNOPSIS
        Request just in time (JIT) database access for a unified development environment (UDE)
        
    .DESCRIPTION
        Utilize the D365FO Power Platform OData API to request just in time access (JIT) to a UDE database
        
        This will allow you to get temporary database credentials for connecting to the database directly
        
        If no credentials are provided (ClientId/ClientSecret or Credential), the function will automatically use interactive authentication via Azure PowerShell.
        
    .PARAMETER Url
        URL / URI for the D365FO Power Platform environment that provides the JIT access API.
        
        Note: This is not the URL of the D365FO environment itself (aka the Finance and Operations URL). Instead, it is the URL of the Power Platform environment (aka the Environment URL) that the D365FO environment is integrated with.
        
        For example: "https://operations-acme-uat.crm4.dynamics.com/"
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecretAsPlainString
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
        This is the plain text version of the ClientSecret parameter.
        
        Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.
        
    .PARAMETER ClientSecretAsSecureString
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
        This is the secure string version of the ClientSecret parameter.
        
        Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.
        
    .PARAMETER Credential
        The Credential object containing Username (ClientId) and Password (ClientSecret)
        
        The Username will be used as ClientId
        The Password will be used as ClientSecret
        
        Either ClientSecretAsPlainString, ClientSecretAsSecureString, or Credential must be provided.
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access
        
    .PARAMETER ClientIPAddress
        The IP address of the client that needs database access
        
        Default value is "127.0.0.1" which will be replaced with the public IP address of the client as determined by querying "https://icanhazip.com"
        
    .PARAMETER Role
        The database role to assign to the JIT access
        
        Valid options are "Reader" and "Writer"
        
        Default value is "Reader"
        
    .PARAMETER Reason
        The reason for requesting JIT database access
        
        Default value is "Administrative access via d365fo.tools"
        
    .PARAMETER SQLServerManagementStudioPath
        The full path to the SQL Server Management Studio executable (ssms.exe)
        
        If provided, the function will automatically open SQL Server Management Studio and connect to the database using the obtained credentials.
        
        Example: "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe"
        
        Note: Since version 18, SQL Server Management Studio does no longer allow providing the password directly in the command line. The password will be copied to clipboard instead for easy pasting. It will be cleared from clipboard after 60 seconds.
        
        Note: After SQL Server Management Studio has been started this way, it will display a "Connect to the following server?" warning dialog. Confirm it with "Yes". Next, because of the missing password, a "Connect to server" error dialog will be shown. Confirm it with "OK". Finally, a "Connect to server" form will be shown where the password can be pasted and the connection be established with the "Connect" button. Answering "No" on the first warning dialog will take you directly to the "Connect to server" form, but the database information will not be pre-filled.
        
        Note: The connection may fail at first because it takes some time until the client's IP address is whitelisted in the Azure SQL Database firewall rules. If that happens, just try again after a minute or so.
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from the endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        Usually this parameter is not used directly, but via the Enable-D365Exception cmdlet
        See https://github.com/d365collaborative/d365fo.tools/wiki/Exception-handling#what-does-the--enableexception-parameter-do for further information
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111"
        
        This will request JIT database access for the D365FO environment using interactive authentication.
        It will prompt you to sign in with your Azure AD credentials if not already signed in.
        It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will request JIT database access for the D365FO environment.
        It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -ClientIPAddress "192.168.1.100" -Role "Writer" -Reason "Development work"
        
        This will request JIT database access for the D365FO environment with Writer privileges.
        It will use the client IP address "192.168.1.100", role "Writer", and reason "Development work".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -OutputAsJson
        
        This will request JIT database access for the D365FO environment and display the result as json.
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsPlainString "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -RawOutput
        
        This will request JIT database access for the D365FO environment and display the result as object with the content as it was received from the endpoint.
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecretAsPlainString parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> $clientSecretSecure = Read-Host -AsSecureString "Enter the Client Secret"
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecretAsSecureString $clientSecretSecure
        
        This will prompt the user to enter the client secret securely (the input will be masked).
        Then it will request JIT database access for the D365FO environment using the secure string for authentication.
        It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the client secret provided through the secure prompt.
        
    .EXAMPLE
        PS C:\> $credential = Get-Credential -UserName "dea8d7a9-1602-4429-b138-111111111111" -Message "Enter the Client Secret"
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -Credential $credential
        
        This will prompt the user to enter the client secret through a secure credential dialog (using the ClientId as the username).
        Then it will request JIT database access for the D365FO environment using the credential for authentication.
        It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the client id and secret provided through the credential object.
        
    .EXAMPLE
        PS C:\> Request-D365DatabaseJITAccess -Url "https://operations-acme-uat.crm4.dynamics.com/" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -SQLServerManagementStudioPath "C:\Program Files\Microsoft SQL Server Management Studio 21\Release\Common7\IDE\SSMS.exe"
        
        This will request JIT database access for the D365FO environment using interactive authentication.
        It will open SQL Server Management Studio and connect to the database using the obtained credentials.
        It will use the client's IP address, role "Reader", and reason "Administrative access via d365fo.tools".
        It will contact the D365FO instance specified in the Url parameter: "https://operations-acme-uat.crm4.dynamics.com/".
        It will authenticate against the Azure Active Directory with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        
    .NOTES
        Tags: JIT, Database, Access, UDE, OData, RestApi
        
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Request-D365DatabaseJITAccess {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingConvertToSecureStringWithPlainText', '',
        Justification = 'Converting plain text to Secure.String provides protection against accidental exposure in logs etc. when used correctly. Encrypting the plain text first would make it too difficult to use.')]
    [CmdletBinding(DefaultParameterSetName = 'ByInteractiveLogin')]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Url,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByClientSecretAsPlainString')]
        [Parameter(Mandatory = $true, ParameterSetName = 'ByClientSecretAsSecureString')]
        [string] $ClientId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByClientSecretAsPlainString')]
        [string] $ClientSecretAsPlainString,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByClientSecretAsSecureString')]
        [System.Security.SecureString] $ClientSecretAsSecureString,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByCredential')]
        [System.Management.Automation.PSCredential] $Credential,

        [Parameter(Mandatory = $true)]
        [string] $Tenant, # TODO This could be preset from $Script.TenantId once UDE support is added (see https://github.com/d365collaborative/d365fo.tools/pull/868)

        [string] $ClientIPAddress = "127.0.0.1",

        [ValidateSet("Reader", "Writer")]
        [string] $Role = "Reader",

        [string] $Reason = "Administrative access via d365fo.tools",

        [string] $SQLServerManagementStudioPath,

        [switch] $RawOutput,

        [switch] $OutputAsJson,

        [switch] $EnableException
    )

    begin {
        # Extract ClientId and ClientSecret from credential if provided
        if ($PSCmdlet.ParameterSetName -eq 'ByCredential') {
            $ClientId = $Credential.UserName
            $ClientSecretAsPlainString = $Credential.GetNetworkCredential().Password
        }
        # Convert SecureString to plain text if ClientSecretAsSecureString is provided
        elseif ($PSCmdlet.ParameterSetName -eq 'ByClientSecretAsSecureString') {
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ClientSecretAsSecureString)
            $ClientSecretAsPlainString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
        }

        # Clean up the URL to ensure it ends with a slash
        if (-not $Url.EndsWith('/')) {
            $Url = $Url + '/'
        }

        # Replace default IP address with IP address from icanhazip.com
        if ($ClientIPAddress -eq "127.0.0.1") {
            try {
                $ClientIPAddress = (Invoke-RestMethod -Uri "https://icanhazip.com" -UseBasicParsing).Trim()
                Write-PSFMessage -Level Verbose -Message "Detected public IP address: $ClientIPAddress"
            }
            catch {
                Write-PSFMessage -Level Warning -Message "Could not determine public IP address from icanhazip.com. Falling back to default IP address: $ClientIPAddress"
            }
        }
    }

    process {
        # Get authentication token based on the parameter set
        if ($PSCmdlet.ParameterSetName -ne 'ByInteractiveLogin') {
            $bearerParms = @{
                Resource        = $Url
                ClientId        = $ClientId
                ClientSecret    = $ClientSecretAsPlainString
                AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"
            }
            
            $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken
        }
        else {
            try {
                # Check if already connected
                $context = Get-AzContext
                if (-not $context) {
                    Write-PSFMessage -Level Verbose -Message "Not connected to Azure. Initiating login..."
                    Connect-AzAccount -Tenant $Tenant -ErrorAction Stop
                }
                elseif ($context.Tenant.Id -ne $Tenant) {
                    Write-PSFMessage -Level Verbose -Message "Connected to different tenant. Reconnecting to specified tenant..."
                    Connect-AzAccount -Tenant $Tenant -ErrorAction Stop
                }
                else {
                    Write-PSFMessage -Level Verbose -Message "Already connected to Azure tenant $Tenant"
                }

                # Get access token for the Power Platform API
                Write-PSFMessage -Level Verbose -Message "Requesting access token for resource: $Url"
                $token = Get-AzAccessToken -ResourceUrl $Url -AsSecureString -ErrorAction Stop
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token.Token)
                $tokenAsPlainString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
                $bearer = "Bearer $($tokenAsPlainString)"
            }
            catch {
                Write-PSFMessage -Level Host -Message "Failed to authenticate using interactive login" -Exception $PSItem.Exception
                Stop-PSFFunction -Message "Stopping because of authentication errors"
                return
            }
        }

        $headers = @{
            'Authorization' = $bearer
            'Accept'        = 'application/json'
            'Content-Type'  = 'application/json; charset=utf-8'
        }

        $requestUrl = $Url + "api/data/v9.2/msprov_getfinopssqljitaccessasync"

        $body = @{
            "sqljitclientipaddress" = $ClientIPAddress
            "sqljitreason"          = $Reason
            "sqljitrole"            = $Role
        } | ConvertTo-Json -Depth 3

        try {
            Write-PSFMessage -Level Verbose -Message "Requesting JIT database access from endpoint: $requestUrl"
            Write-PSFMessage -Level Verbose -Message "Request body: $body"

            $response = Invoke-RestMethod -Uri $requestUrl -Method Post -Headers $headers -Body $body

            if ($SQLServerManagementStudioPath -and (Test-Path -Path $SQLServerManagementStudioPath)) {
                # Open SQL Management Studio and connect to the database using the obtained credentials
                # Use the server name, database name, username, and password from the $response object
                $serverName = $response.servername
                $databaseName = $response.databasename
                $username = $response.sqljitusername
                $password = $response.sqljitpassword

                # Copy the password to clipboard for easy pasting
                $password | Set-Clipboard
                Read-Host "Password copied to clipboard. Once you confirm this message, SQL Server Management Studio will be started with the database connection. Read the -SQLServerManagementStudioPath parameter description before you confirm with Enter. Press Enter to continue."
                & $SQLServerManagementStudioPath -S $serverName -d $databaseName -U $username
                for ($i = 60; $i -gt 0; $i--) {
                    Write-Progress -Activity "JIT Database Access" -Status "Waiting for $i seconds before clearing clipboard..." -PercentComplete ((60 - $i) / 60 * 100)
                    Start-Sleep -Seconds 1
                }
                Set-Clipboard " "
            }

            $result = $response
            if (-not $RawOutput) {
                # Extract the relevant information from the response
                $selectParams = @{
                    TypeName = "D365FO.TOOLS.UDE.JITDatabaseAccess"
                    Property = @{Name = "SQLJITCredential"; Expression = {
                        $password = $_.sqljitpassword | ConvertTo-SecureString -AsPlainText -Force
                        New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($_.sqljitusername, $password)
                        }},
                        "servername as ServerName",
                        "databasename as DatabaseName",
                        "databasetype as DatabaseType",
                        "ipaddress as IPAddress",
                        "sqljitrole as SQLJITRole",
                        "sqljitexpiration as SQLJITExpirationTime to DateTime",
                        "operationhistoryid as OperationHistoryId"
                }
                $result = $response | Select-PSFObject @selectParams
            }

            if ($OutputAsJson) {
                $result = $result | ConvertTo-Json -Depth 10
            }

            $result
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while requesting JIT database access" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        if ($PSCmdlet.ParameterSetName -ne 'ByClientSecretAsPlainString') {
            # Clear sensitive variables
            $ClientSecretAsPlainString = $null
        }
    }
}