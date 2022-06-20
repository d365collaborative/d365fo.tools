
<#
    .SYNOPSIS
        Get the status of a database operation from LCS
        
    .DESCRIPTION
        Get the current status of a database operation against an environment from a LCS project
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER OperationActivityId
        The unique id of the operaction activity that identitfies the database operation
        
        It will be part of the output from the different Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets
        
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
        Time in seconds that you want the cmdlet to use as the sleep timer between each request against the LCS endpoint
        
        Default value is 300
        
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
        PS C:\> Get-D365LcsDatabaseOperationStatus -ProjectId 123456789 -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the database operation status of a specific OperationActivityId against an environment.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .EXAMPLE
        PS C:\> Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will check the database operation status of a specific OperationActivityId against an environment.
        The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -WaitForCompletion
        
        This will check the database operation status of a specific OperationActivityId against an environment.
        The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The cmdlet will every 300 seconds contact the LCS API endpoint and check if the status of the database operation status is either success or failure.
        
        All default values will come from the configuration available from Get-D365LcsApiConfig.
        
        The default values can be configured using Set-D365LcsApiConfig.
        
    .EXAMPLE
        PS C:\> Get-D365LcsDatabaseOperationStatus -OperationActivityId 123456789 -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -RetryTimeout "00:01:00"
        
        This will check the database operation status of a specific OperationActivityId against an environment, and allow for the cmdlet to retry for no more than 1 minute.
        The OperationActivityId is identified by the OperationActivityId 123456789, which is obtained from executing either the Invoke-D365LcsDatabaseExport or Invoke-D365LcsDatabaseRefresh cmdlets.
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
        Tags: Environment, Config, Configuration, LCS, Database backup, Api, Backup, Restore, Refresh
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsDatabaseOperationStatus {
    [CmdletBinding()]
    [OutputType('PSCustomObject')]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ActivityId')]
        [string] $OperationActivityId,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('SourceEnvironmentId')]
        [string] $EnvironmentId,

        [Parameter(Mandatory = $false)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $WaitForCompletion,

        [int] $SleepInSeconds = 300,

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
            $databaseOperationStatus = Get-LcsDatabaseOperationStatusV2 -BearerToken $BearerToken -ProjectId $ProjectId -OperationActivityId $OperationActivityId -EnvironmentId $EnvironmentId -LcsApiUri $LcsApiUri -RetryTimeout $RetryTimeout

            Write-PSFMessage -Level Verbose -Message "Database Operation Status is: $($databaseOperationStatus.OperationStatus)"
        
            if (Test-PSFFunctionInterrupt) { return }
        }
        while ((($databaseOperationStatus.OperationStatus -eq "InProgress") -or ($databaseOperationStatus.OperationStatus -eq "NotStarted") -or ($databaseOperationStatus.OperationStatus -eq "RollbackInProgress")) -and $WaitForCompletion)

        Invoke-TimeSignal -End

        $databaseOperationStatus | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Database.Operation.Status"
    }
}