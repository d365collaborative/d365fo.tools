
<#
    .SYNOPSIS
        Get the status of a LCS database operation
        
    .DESCRIPTION
        Get the database operation status for an environment in LCS
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER OperationActivityId
        The unique id of the action you got from when starting the database operation against the environment
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
   .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts

    .EXAMPLE
        PS C:\> Get-LcsDatabaseOperationStatus -ProjectId 123456789 -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -Token "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the database operation status of a specific OperationActivityId against an environment.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .LINK
        Start-LcsDatabaseRefresh
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deployable Package
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsDatabaseOperationStatus {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
    
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(Mandatory = $true)]
        [string] $OperationActivityId,

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
    
    $databaseOperationStatusUri = "$LcsApiUri/databasemovement/v1/fetchstatus/project/$($ProjectId)/environment/$($EnvironmentId)/operationactivity/$($OperationActivityId)"
    
    $request = New-JsonRequest -Uri $databaseOperationStatusUri -Token $BearerToken -HttpMethod "GET"

    try {
        Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
        $result = Get-AsyncResult -task $client.SendAsync($request)

        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS."
        $responseString = Get-AsyncResult -task $result.Content.ReadAsStringAsync()

        try {
            $operationStatus = ConvertFrom-Json -InputObject $responseString -ErrorAction SilentlyContinue
        }
        catch {
            Write-PSFMessage -Level Critical -Message "$responseString"
        }
    
        Write-PSFMessage -Level Verbose -Message "Extracting the response received from LCS." -Target $operationStatus

        if (-not ($result.StatusCode -eq [System.Net.HttpStatusCode]::OK)) {
            if (($operationStatus) -and ($operationStatus.ErrorMessage)) {
                $errorText = ""
                if ($operationStatus.OperationActivityId) {
                    $errorText = "Error in request for database refresh status of environment: '$( $operationStatus.ErrorMessage)' (Activity Id: '$( $operationStatus.OperationActivityId)')"
                }
                else {
                    $errorText = "Error in request for database refresh status of environment: '$( $operationStatus.ErrorMessage)'"
                }
            }
            elseif ($operationStatus.OperationActivityId) {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase) (Activity Id: '$($operationStatus.OperationActivityId)')"
            }
            else {
                $errorText = "API Call returned $($result.StatusCode): $($result.ReasonPhrase)"
            }

            Write-PSFMessage -Level Host -Message "Error getting database refresh status." -Target $($operationStatus.ErrorMessage)
            Write-PSFMessage -Level Host -Message $errorText -Target $($result.ReasonPhrase)
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        }

        
        if (-not ($operationStatus.IsSuccess)) {
            if ($operationStatus.ErrorMessage) {
                $errorText = "Error in request for database refresh status of environment: '$( $operationStatus.ErrorMessage)' (Activity Id: '$( $operationStatus.OperationActivityId)')"
            }
            elseif ( $operationStatus.OperationActivityId) {
                $errorText = "Error in request for database refresh status of environment. Activity Id: '$($activity.OperationActivityId)'"
            }
            else {
                $errorText = "Unknown error in request for database refresh status."
            }

            Write-PSFMessage -Level Host -Message "Unknown error requesting database refresh status." -Target $operationStatus
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
    
    $operationStatus
}