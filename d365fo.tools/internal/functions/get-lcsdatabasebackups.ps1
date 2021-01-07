
<#
    .SYNOPSIS
        Get database backups from LCS project
        
    .DESCRIPTION
        Get the available database backups from the Asset Library in LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsDatabaseBackups -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will get all available database backups from the Asset Library inside LCS.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, LCS, Api, AAD, Token, Bacpac, Backup
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsDatabaseBackups {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $deployStatusUri = "$LcsApiUri/databasemovement/v1/databases/project/$($ProjectId)"
    
    $request = New-JsonRequest -Uri $deployStatusUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        try {
            $databasesObject = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $databasesObject
        
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($databasesObject) -and ($databasesObject.ErrorMessage)) {
                $errorText = ""
                if ($databasesObject.OperationActivityId) {
                    $errorText = "Error $( $databasesObject.ErrorMessage) in request for listing all bacpacs and backup from the asset library of LCS: '$( $databasesObject.ErrorMessage)' (Activity Id: '$( $databasesObject.OperationActivityId)')"
                }
                else {
                    $errorText = "Error $( $databasesObject.ErrorMessage) in request for listing all bacpacs and backup from the asset library of LCS: '$( $databasesObject.ErrorMessage)'"
                }
            }
            elseif ($databasesObject.OperationActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($databasesObject.OperationActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error listing bacpacs and backups from asset library." -Target $($databasesObject.ErrorMessage)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }

        
        if (-not ( $databasesObject.IsSuccess)) {
            if ( $databasesObject.ErrorMessage) {
                $errorText = "Error in request for listing all bacpacs and backup from the asset library of LCS: '$( $databasesObject.ErrorMessage)' (Activity Id: '$( $databasesObject.OperationActivityId)')"

            }
            elseif ( $databasesObject.OperationActivityId) {
                $errorText = "Error in request for listing all bacpacs and backup from the asset library of LCS. Activity Id: '$($activity.OperationActivityId)'"
            }
            else {
                $errorText = "Unknown error in request for listing all bacpacs and backup from the asset library of LCS"
            }

            Write-PSFMessage -Level Host -Message "Unknown error while listing all bacpacs and backups from asset library." -Target $databasesObject
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
    
    $databasesObject
}