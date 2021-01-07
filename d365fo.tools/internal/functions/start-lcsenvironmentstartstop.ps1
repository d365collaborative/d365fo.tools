
<#
    .SYNOPSIS
        Start or stop a given environment using LCS
        
    .DESCRIPTION
        Start or stop a specified IAAS environment that is Microsoft managed or customer managed through the LCS API.
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to take action upon
        
        The Id can be located inside the LCS portal
        
    .PARAMETER IsStop
        When set to True, the environment will be stopped. When set to False, the environment will be started.
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending where your LCS project is located, there are several valid URI's / URL's
        
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
        PS C:\> Start-LcsEnvironmentStartStop -ProjectId 123456789 -EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -IsStop $False -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will trigger the environment start operation upon the given environment through the LCS APIs
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com"
                
    .EXAMPLE
        PS C:\> Start-LcsEnvironmentStartStop -ProjectId 123456789 -EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -IsStop $True -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will trigger the environment stop operation upon the given environment through the LCS APIs
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
    .NOTES
        Tags: Environment, Stop, Start, LCS, Api, AAD, Token
        
        Author: Billy Richardson (jorichar)
#>

function Start-LcsEnvironmentStartStop {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Parameter(Mandatory = $true)]
        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,

        [Parameter(Mandatory = $true)]
        [boolean] $IsStop,

        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Json payload for LCS generated." -Target $jsonFile
    
    $client = New-Object -TypeName System.Net.Http.HttpClient
    $client.DefaultRequestHeaders.Clear()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("d365fo.tools via PowerShell")
    
    $internalAction = "start";
    
    if ($IsStop -eq $True) {
        $internalAction = "stop";
    }
    
    $deployUri = "$LcsApiUri/environment/v1/$($internalAction)/project/$($ProjectId)/environment/$($EnvironmentId)"

    $request = New-JsonRequest -Uri $deployUri -Token $BearerToken -HttpMethod "POST"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        try {
            $operationJob = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $operationJob
        
        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($operationJob) -and ($operationJob.ErrorMessage)) {
                $errorText = ""
                if ($operationJob.OperationActivityId) {
                    $errorText = "Error in $($internalAction) request for environment: '$( $operationJob.ErrorMessage)' (Activity Id: '$( $operationJob.OperationActivityId)')"
                }
                else {
                    $errorText = "Error in $($internalAction) request for environment: '$( $operationJob.ErrorMessage)'"
                }
            }
            elseif ($operationJob.OperationActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($operationJob.OperationActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error performing $($internalAction) request for environment." -Target $($operationJob.ErrorMessage)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }

        
        if (-not ($operationJob.IsSuccess)) {
            if ( $operationJob.ErrorMessage) {
                $errorText = "Error in $($internalAction) request for environment: '$( $operationJob.ErrorMessage)' (Activity Id: '$( $operationJob.OperationActivityId)')"
            }
            elseif ( $operationJob.OperationActivityId) {
                $errorText = "Error in $($internalAction) request for environment. Activity Id: '$($activity.OperationActivityId)'"
            }
            else {
                $errorText = "Unknown error in request for environment:."
            }

            Write-PSFMessage -Level Host -Message "Unknown error during $($internalAction) request for environment." -Target $operationJob
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
    
    $operationJob
}