
<#
    .SYNOPSIS
        Start a database export from an environment
        
    .DESCRIPTION
        Start a database export from an environment from a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER SourceEnvironmentId
        The unique id of the environment that you want to use as the source for the database export
        
        The Id can be located inside the LCS portal
        
    .PARAMETER BackupName
        Name of the backup file when it is being exported from the environment

        The file shouldn't contain any extension at all, just the desired file name
        
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
        PS C:\> Invoke-D365LcsDatabaseExport -ProjectId 123456789 -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will start the database export from the Source environment.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi"
        
        This will start the database export from the Source environment.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> $databaseExport = Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -SkipInitialStatusFetch
        PS C:\> $databaseExport | Get-D365LcsDatabaseOperationStatus -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e9" -SleepInSeconds 60
        
        This will start the database export from the Source environment.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
        It will skip the first database operation status fetch and only output the details from starting the export.
        
        The output from Invoke-D365LcsDatabaseExport is stored in the $databaseExport. This will enable you to pass the $databaseExport variable to other cmdlets which should make things easier for you.
        
        Will pipe the $databaseExport variable to the Get-D365LcsDatabaseOperationStatus cmdlet and get the status from the database export job.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Invoke-D365LcsDatabaseExport -SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae" -BackupName "BackupViaApi" -SkipInitialStatusFetch
        
        This will start the database export from the Source environment.
        The source environment is identified by the SourceEnvironmentId "958ae597-f089-4811-abbd-c1190917eaae", which can be obtained in the LCS portal.
        The backup name is identified by the BackupName "BackupViaApi", which instructs the API to save the backup with that filename.
        It will skip the first database operation status fetch and only output the details from starting the export.
        
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
        Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Bacpac
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365LcsDatabaseExport {
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
        [string] $BackupName,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $SkipInitialStatusFetch
    )

    Invoke-TimeSignal -Start

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    $refreshJob = Start-LcsDatabaseExport -ProjectId $ProjectId -BearerToken $BearerToken -SourceEnvironmentId $SourceEnvironmentId -BackupName $BackupName -LcsApiUri $LcsApiUri

    if (Test-PSFFunctionInterrupt) { return }

    $refreshJob

    if (-not $SkipInitialStatusFetch) {
        Get-D365LcsDatabaseOperationStatus -ProjectId $ProjectId -BearerToken $BearerToken -OperationActivityId $($refreshJob.OperationActivityId) -EnvironmentId $SourceEnvironmentId -LcsApiUri $LcsApiUri -WaitForCompletion:$false -SleepInSeconds 60
    }

    Invoke-TimeSignal -End
}