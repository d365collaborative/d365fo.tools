
<#
    .SYNOPSIS
        Start LCS deployment
        
    .DESCRIPTION
        Start the deployment of a deployable package from the LCS API
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER SourceEnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal

    .PARAMETER TargetEnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
    .EXAMPLE
        PS C:\> Start-LcsDeployment -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the deployment of the file located in the Asset Library.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The file is identified by the AssetId "958ae597-f089-4811-abbd-c1190917eaae", which is obtained either by earlier upload or simply looking in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deployable Package
        
        Author: Mötz Jensen (@Splaxi)
#>

function Start-LcsDatabaseRefresh {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Parameter(Mandatory = $true)]
        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $SourceEnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $TargetEnvironmentId,

        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $deployUri = "$LcsApiUri/databasemovement/v1/refresh/project//$($ProjectId)/source/$($SourceEnvironmentId)/target/$($TargetEnvironmentId)"

    $request = New-JsonRequest -Uri $deployUri -Token $BearerToken -HttpMethod "POST"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        $refreshJob = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
    
        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($refreshJob) -and ($refreshJob.ErrorMessage)) {
                $errorText = ""
                if ($refreshJob.OperationActivityId) {
                    $errorText = "Error in request for database refresh of environment: '$( $refreshJob.ErrorMessage)' (Activity Id: '$( $refreshJob.OperationActivityId)')"
                }
                else {
                    $errorText = "Error in request for database refresh of environment: '$( $refreshJob.ErrorMessage)'"
                }
            }
            elseif ($refreshJob.OperationActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($refreshJob.OperationActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error performing database refresh of environment." -Target $($refreshJob.ErrorMessage)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }

        
        if (-not ($refreshJob.IsSuccess)) {
            if ( $refreshJob.ErrorMessage) {
                $errorText = "Error in request for database refresh of environment: '$( $refreshJob.ErrorMessage)' (Activity Id: '$( $refreshJob.OperationActivityId)')"
            }
            elseif ( $refreshJob.OperationActivityId) {
                $errorText = "Error in request for database refresh of environment. Activity Id: '$($activity.OperationActivityId)'"
            }
            else {
                $errorText = "Unknown error in request for database refresh."
            }

            Write-PSFMessage -Level Host -Message "Unknown error requesting database refresh." -Target $refreshJob
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
    
    $refreshJob
}