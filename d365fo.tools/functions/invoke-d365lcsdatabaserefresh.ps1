
<#
    .SYNOPSIS
        Start a database refresh between 2 environments
        
    .DESCRIPTION
        Start a database refresh between 2 environments from a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER SourceEnvironmentId
        The unique id of the environment that you want to use as the source for the database refresh
        
        The Id can be located inside the LCS portal
        
    .PARAMETER TargetEnvironmentId
        The unique id of the environment that you want to use as the target for the database refresh
        
        The Id can be located inside the LCS portal
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER SkipInitialStatusFetch
        Instruct the cmdlet to skip the first fetch of the database refresh status
        
        Useful when you have a large script that handles this status validation and you don't want to spend time with this cmdlet
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -ProjectId 123456789 -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the database refresh between the Source and Target environments.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> $databaseRefresh = Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
        PS C:\> $databaseRefresh | Get-D365LcsDatabaseRefreshStatus -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e9" -SleepInSeconds 60
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        It will skip the first database refesh status fetch and only output the details from starting the refresh.
        
        The output from Invoke-D365LcsDatabaseRefresh is stored in the $databaseRefresh. This will enable you to pass the $databaseRefresh variable to other cmdlets which should make things easier for you.
        
        Will pipe the $databaseRefresh variable to the Get-D365LcsDatabaseRefreshStatus cmdlet and get the status from the database refresh job.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
        
        $databaseRefresh = Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId be9aa4a4-7621-4b7e-b6f5-d518bf0012de -TargetEnvironmentId 43bcc00a-d94c-47cd-a20f-3c7aee98b5a9
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseRefresh -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -SkipInitialStatusFetch
        
        This will start the database refresh between the Source and Target environments.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The target environment is identified by the TargetEnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        It will skip the first database refesh status fetch and only output the details from starting the refresh.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .LINK
        Get-D365LcsApiConfig
        
    .LINK
        Get-D365LcsApiToken
        
    .LINK
        Get-D365LcsAssetValidationStatus
        
    .LINK
        Get-D365LcsDeploymentStatus
        
    .LINK
        Invoke-D365LcsApiRefreshToken
        
    .LINK
        Invoke-D365LcsUpload
        
    .LINK
        Set-D365LcsApiConfig
        
    .NOTES
        Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Restore, Refresh
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsDatabaseRefresh {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $SourceEnvironmentId,
        
        [Parameter(Mandatory = $true)]
        [string] $TargetEnvironmentId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $SkipInitialStatusFetch
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $refreshJob = Start-LcsDatabaseRefresh -ProjectId $ProjectId -BearerToken $BearerToken -SourceEnvironmentId $SourceEnvironmentId -TargetEnvironmentId $TargetEnvironmentId -LcsApiUri $LcsApiUri

    if (Test-PSFFunctionInterrupt) { return }

    $refreshJob

    if (-not $SkipInitialStatusFetch) {
        Get-D365LcsDatabaseRefreshStatus -ProjectId $ProjectId -BearerToken $BearerToken -OperationActivityId $($refreshJob.OperationActivityId) -EnvironmentId $TargetEnvironmentId -LcsApiUri $LcsApiUri -WaitForCompletion:$false -SleepInSeconds 60
    }

    Invoke-TimeSignal -End
}