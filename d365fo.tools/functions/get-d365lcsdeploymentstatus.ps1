
<#
    .SYNOPSIS
        Get the Deployment status from LCS
        
    .DESCRIPTION
        Get the Deployment status for activity against an environment from the Dynamics LCS Portal
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER ActivityId
        The unique id of the action that you started from the Invoke-D365LcsDeployment cmdlet
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER WaitForCompletion
        Instruct the cmdlet to wait for the deployment process to complete
        
        The cmdlet will sleep for 300 seconds, before requesting the status of the deployment process from LCS
        
    .PARAMETER SleepInSeconds
        Time in secounds that you want the cmdlet to use as the sleep timer between each request against the LCS endpoint
        
        Default value is 300
        
    .PARAMETER FailOnErrorMessage
        Instruct the cmdlet to write logging information to the console, if there is an error message in the response from the LCS endpoint
        
        Used in combination with either Enable-D365Exception cmdlet, or the -EnableException directly on this cmdlet, it will throw an exception and break/stop execution of the script
        This allows you to implement custom retry / error handling logic
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ProjectId 123456789 -ActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the deployment status of specific activity against an environment.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The activity is identified by the ActivityId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will check the deployment status of specific activity against an environment.
        The activity is identified by the ActivityId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -WaitForCompletion
        
        This will check the deployment status of specific activity against an environment.
        The activity is identified by the ActivityId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The cmdlet will every 300 seconds contact the LCS API endpoint and check if the status of the deployment is either success or failure.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -RetryTimeout "00:01:00"
        
        This will check the deployment status of specific activity against an environment, and allow for the cmdlet to retry for no more than 1 minute.
        The activity is identified by the ActivityId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsDeployment
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Url, Config, Configuration, LCS, Upload, Api, AAD, Token, Deployment, Deploy
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsDeploymentStatus {
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param(
        [Parameter(Mandatory = $false)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ActionHistoryId')]
        [string] $ActivityId,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $WaitForCompletion,

        [int] $SleepInSeconds = 300,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    process {
        Invoke-TimeSignal -Start

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        do {
            Write-PSFMessage -Level Verbose -Message "Sleeping before hitting the LCS API for Deployment Status"

            Start-Sleep -Seconds $SleepInSeconds
            $deploymentStatus = Get-LcsDeploymentStatusV2 -BearerToken $BearerToken -ProjectId $ProjectId -ActivityId $ActivityId -EnvironmentId $EnvironmentId -LcsApiUri $LcsApiUri -RetryTimeout $RetryTimeout
      
            if (Test-PSFFunctionInterrupt) { return }

            if ($FailOnErrorMessage -and $deploymentStatus.ErrorMessage) {
                $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($deploymentStatus.ErrorMessage)</c>."
                $errorMessagePayload = "`r`n$($deploymentStatus | ConvertTo-Json)"
                Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
                Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
            }
        }
        while ((($deploymentStatus.OperationStatus -eq "InProgress") -or ($deploymentStatus.OperationStatus -eq "NotStarted") -or ($deploymentStatus.OperationStatus -eq "PreparingEnvironment")) -and $WaitForCompletion)
    
        Invoke-TimeSignal -End

        $deploymentStatus | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Deployment.Operation.Status"
    }
}