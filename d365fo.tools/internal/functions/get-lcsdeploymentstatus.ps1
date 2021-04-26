
<#
    .SYNOPSIS
        Get the status of a LCS deployment
        
    .DESCRIPTION
        Get the deployment status for an environment in LCS
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ActivityId
        The unique id of the action you got from when starting the deployment to the environment
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-LcslcsResponseObject -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -ActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
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
        [string] $ActivityId,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $lcsRequestUri = "$LcsApiUri/environment/v2/fetchstatus/project/$($ProjectId)/environment/$($EnvironmentId)/operationactivity/$($ActivityId)"

    $request = New-JsonRequest -Uri $lcsRequestUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        try {
            $lcsResponseObject = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $lcsResponseObject
        
        #This IF block might be obsolute based on the V2 implementation
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if ($lcsResponseObject) {
                $errorText = ""
                if ($lcsResponseObject.ActivityId) {
                    $errorText = "Error $( $lcsResponseObject.ErrorMessage) in request for status of environment servicing action: '$($lcsResponseObject.ErrorMessage)' (Activity Id: '$($lcsResponseObject.ActivityId)')"
                }
                else {
                    $errorText = "Error $( $lcsResponseObject.ErrorMessage) in request for status of environment servicing action: '$($lcsResponseObject.ErrorMessage)'"
                }
            }
            elseif ($lcsResponseObject.ActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($lcsResponseObject.ActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error fetching environment servicing status." -Target $($lcsResponseObject.Message)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors"
        }

        if (-not ($lcsResponseObject.OperationStatus)) {
            if ($lcsResponseObject.Message) {
                $errorText = "Error in request for status of environment servicing action: '$($lcsResponseObject.Message)')"
            }
            elseif ($lcsResponseObject.ErrorMessage) {
                $errorText = "Error in request for status of environment servicing action: '$($lcsResponseObject.ErrorMessage)' (ActivityId: '$($lcsResponseObject.ActivityId)' - OperationActivityId: '$($lcsResponseObject.OperationActivityId)')"
            }
            elseif ($lcsResponseObject.OperationActivityId -or $lcsResponseObject.ActivityId) {
                $errorText = "Error in request for status of environment servicing action. (ActivityId: '$($lcsResponseObject.ActivityId)' - OperationActivityId: '$($lcsResponseObject.OperationActivityId)')"
            }
            else {
                $errorText = "Unknown error in request for status of environment servicing action"
            }

            Write-PSFMessage -Level Host -Message "Unknown error fetching environment servicing status." -Target $lcsResponseObject
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors"
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        if ($client) {
            $client.Dispose()
            $client = $null
        }
    }
    
    Invoke-TimeSignal -End
    
    $lcsResponseObject
}