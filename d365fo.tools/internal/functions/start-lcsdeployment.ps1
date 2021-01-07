
<#
    .SYNOPSIS
        Start LCS deployment
        
    .DESCRIPTION
        Start the deployment of a deployable package from the LCS API
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to deploy from LCS
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER UpdateName
        Name of the update when you are working against Self-Service environments
        
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

function Start-LcsDeployment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Parameter(Mandatory = $true)]
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(Mandatory = $true)]
        [string] $AssetId,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,
        
        [Parameter(Mandatory = $false)]
        [string] $UpdateName,

        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $lcsRequestUri = "$LcsApiUri/environment/v2/applyupdate/project/$($ProjectId)/environment/$($EnvironmentId)/asset/$($AssetId)?updateName=$($UpdateName)"

    $request = New-JsonRequest -Uri $lcsRequestUri -Token $BearerToken -HttpMethod "POST"

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
            if (($lcsResponseObject) -and ($lcsResponseObject.Message)) {
        
                if ($lcsResponseObject.ActivityId) {
                    $errorText = "Error $( $lcsResponseObject.LcsErrorCode) in request for status of environment servicing action: '$( $lcsResponseObject.Message)' (Activity Id: '$( $lcsResponseObject.ActivityId)')"
                }
                else {
                    $errorText = "Error $( $lcsResponseObject.LcsErrorCode) in request for status of environment servicing action: '$( $lcsResponseObject.Message)'"
                }
            }
            elseif ($lcsResponseObject.ActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($lcsResponseObject.ActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error creating new file lcsResponseObject." -Target $($lcsResponseObject.Message)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors"
        }

        
        if (-not ( $lcsResponseObject.OperationStatus)) {
            if ( $lcsResponseObject.Message) {
                $errorText = "Error in request for deploying asset to enviroment: '$($lcsResponseObject.Message)')"
            }
            elseif ( $lcsResponseObject.ErrorMessage) {
                $errorText = "Error in request for deploying asset to enviroment: '$($lcsResponseObject.ErrorMessage)' (OperationActivityId: '$($lcsResponseObject.OperationActivityId)')"
            }
            elseif ($lcsResponseObject.OperationActivityId -or $lcsResponseObject.ActivityId) {
                $errorText = "Error in request for deploying asset to environment. (OperationActivityId: '$($lcsResponseObject.OperationActivityId)')"
            }
            else {
                $errorText = "Unknown in request for deploying asset to environment."
            }

            Write-PSFMessage -Level Host -Message "Unknown in request for deploying asset to environment." -Target $lcsResponseObject
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
    
    $lcsResponseObject
}