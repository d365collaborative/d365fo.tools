
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
        
    .PARAMETER ActionHistoryId
        The unique id of the action that you started from the Invoke-D365LcsDeployment cmdlet
        
    .PARAMETER EnvironmentId
        The unique id of the environment that you want to work against
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER WaitForCompletion
        Instruct the cmdlet to wait for the deployment process to complete
        
        The cmdlet will sleep for 300 seconds, before requesting the status of the deployment process from LCS
        
    .PARAMETER SleepInSeconds
        Time in secounds that you want the cmdlet to use as the sleep timer between each request against the LCS endpoint
        
        Default value is 300
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ProjectId 123456789 -ActionHistoryId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "Bearer JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the deployment status of specific activity against an environment.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The activity is identified by the ActionHistoryId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "Bearer JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ActionHistoryId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will check the deployment status of specific activity against an environment.
        The activity is identified by the ActionHistoryId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsDeploymentStatus -ActionHistoryId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -WaitForCompletion
        
        This will check the deployment status of specific activity against an environment.
        The activity is identified by the ActionHistoryId 123456789, which is obtained from the Invoke-D365LcsDeployment execution.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The cmdlet will every 300 seconds contact the LCS API endpoint and check if the status of the deployment is either success or failure.
        
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
        [string] $ActionHistoryId,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $WaitForCompletion,

        [int] $SleepInSeconds = 300
    )

    process {
        Invoke-TimeSignal -Start

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        do {
            Write-PSFMessage -Level Verbose -Message "Sleeping before hitting the LCS API for Deployment Status"

            Start-Sleep -Seconds $SleepInSeconds
            $deploymentStatus = Get-LcsDeploymentStatus -BearerToken $BearerToken -ProjectId $ProjectId -ActionHistoryId $ActionHistoryId -EnvironmentId $EnvironmentId -LcsApiUri $LcsApiUri
        }
        while ((($deploymentStatus.LcsEnvironmentActionStatus -eq "InProgress") -or ($deploymentStatus.LcsEnvironmentActionStatus -eq "NotStarted") -or ($deploymentStatus.LcsEnvironmentActionStatus -eq "PreparingEnvironment")) -and $WaitForCompletion)

        Invoke-TimeSignal -End

        $deploymentStatus
    }
}