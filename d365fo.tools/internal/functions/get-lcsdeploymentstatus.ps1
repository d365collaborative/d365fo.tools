
<#
    .SYNOPSIS
        Get the status of a LCS deployment
        
    .DESCRIPTION
        Get the deployment status for an environment in LCS
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER ActionHistoryId
        The unique id of the action you got from when starting the deployment to the environment
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
    .EXAMPLE
        PS C:\> Get-LcsDeploymentStatus -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -ActionHistoryId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the deployment of the file located in the Asset Library with the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in the LCS project with Id 123456789.
        The http request will be using the "Bearer JldjfafLJdfjlfsalfd..." token for authentication against the LCS API.
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .LINK
        Start-LcsDeployment

    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deployable Package
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsDeploymentStatus {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(Mandatory = $true)]
        [string] $ActionHistoryId,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()

    $deployStatusUri = "$LcsApiUri/environment/servicing/v1/monitorupdate/$($ProjectId)?environmentId=$EnvironmentId&actionHistoryId=$ActionHistoryId"

    $request = New-JsonRequest -Uri $deployStatusUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        $deploymentStatus = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
    
        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($deploymentStatus) -and ($deploymentStatus.Message)) {
                $errorText = ""
                if ($deploymentStatus.ActivityId) {
                    $errorText = "Error $( $deploymentStatus.LcsErrorCode) in request for status of environment servicing action: '$( $deploymentStatus.Message)' (Activity Id: '$( $deploymentStatus.ActivityId)')"
                }
                else {
                    $errorText = "Error $( $deploymentStatus.LcsErrorCode) in request for status of environment servicing action: '$( $deploymentStatus.Message)'"
                }
            }
            elseif ($deploymentStatus.ActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($deploymentStatus.ActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error creating new file asset." -Target $($deploymentStatus.Message)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors"
        }

        
        if (-not ( $deploymentStatus.LcsEnvironmentActionStatus)) {
            if ( $deploymentStatus.Message) {
                $errorText = "Error in request for status of environment servicing action: '$( $deploymentStatus.Message)' (Activity Id: '$( $deploymentStatus.ActivityId)')"
            }
            elseif ( $deploymentStatus.ActivityId) {
                $errorText = "Error in request for status of environment servicing action. Activity Id: '$($activity.ActivityId)'"
            }
            else {
                $errorText = "Unknown error in request for status of environment servicing action"
            }

            Write-PSFMessage -Level Host -Message "Unknown error creating new file asset." -Target $deploymentStatus
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    Invoke-TimeSignal -End
    
    $deploymentStatus
}