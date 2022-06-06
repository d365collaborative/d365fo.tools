
<#
    .SYNOPSIS
        Get history for a given environment within a LCS project
        
    .DESCRIPTION
        Get history details for a given environment from within a LCS project
        
        There can be multiple pages of data, which requires you to use the TraverseAllPages parameter, if you want all data to be shown
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
        
    .PARAMETER EnvironmentId
        Id of the environment that you want to be working against
        
    .PARAMETER TraverseAllPages
        Instruct the cmdlet to fetch all pages, until there isn't more data available
        
        This can be a slow operation, as it has to call the LCS API multiple times, fetching a single page per call
        
    .PARAMETER FirstPages
        Instruct the cmdlet how many pages that you want it to retrieve from the LCS API
        
        Can only be used in combination with -TraverseAllPages
        
        The default value is: 99 pages, which should be more than enough
        
        Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint
        
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
        PS C:\> Get-D365LcsEnvironmentHistory -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will list the first page of Environment History Data from the LCS API.
        The LCS project is identified by the ProjectId "123456789", which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
        A result set example:
        
        Name             : Service Update - 10.0.19
        Type             : SFBinaryHotfix
        TypeDisplay      : Binary hotfix
        StartDateTimeUTC : 2021-07-11T00:01:57.423
        EndDateTimeUTC   : 2021-07-11T05:01:12.97
        Status           : Completed
        ActivityId       : e3509860-61d4-4003-9b45-6ea7d89aea30
        EnvironmentId    : 13cc7700-c13b-4ea3-81cd-2d26fa72ec5e
        ProjectId        : 123456789
        
        Name             : Refresh database
        Type             : SFSourceDbToSandbox
        TypeDisplay      : Refresh database
        StartDateTimeUTC : 2021-06-06T15:17:48.87
        EndDateTimeUTC   : 2021-06-06T16:33:40.367
        Status           : Completed
        ActivityId       : e3509860-61d4-4003-9b45-6ea7d89aea31
        EnvironmentId    : 13cc7700-c13b-4ea3-81cd-2d26fa72ec5e
        ProjectId        : 123456789
        
        Name             : Export database
        Type             : SFExportSandboxDb
        TypeDisplay      : Export database
        StartDateTimeUTC : 2021-04-27T22:08:01.103
        EndDateTimeUTC   : 2021-04-28T23:30:06.623
        Status           : RollbackCompleted
        ActivityId       : e3509860-61d4-4003-9b45-6ea7d89aea32
        EnvironmentId    : 13cc7700-c13b-4ea3-81cd-2d26fa72ec5e
        ProjectId        : 123456789
        
        Name             : Main_2021.1.1.1
        Type             : SFApplicationHotfix
        TypeDisplay      : Application deployable package
        StartDateTimeUTC : 2021-03-04T21:44:20.793
        EndDateTimeUTC   : 2021-03-04T22:48:17.303
        Status           : Completed
        ActivityId       : e3509860-61d4-4003-9b45-6ea7d89aea33
        EnvironmentId    : 13cc7700-c13b-4ea3-81cd-2d26fa72ec5e
        ProjectId        : 123456789
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentHistory -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -TraverseAllPages
        
        This will list the all the pages of Environment History Data from the LCS API.
        The LCS project is identified by the ProjectId "123456789", which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The cmdlet will TraverseAllPages from the LCS API.
        It will use the default value for the maximum number of pages to return, 99 pages.
        
        TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
        Please be patient and let the system work for you.
        
        Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentHistory -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e" -TraverseAllPages -FirstPages 2
        
        This will list the all the pages of Environment History Data from the LCS API.
        The LCS project is identified by the ProjectId "123456789", which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        The cmdlet will TraverseAllPages from the LCS API.
        The cmdlet will be fetching the FirstPages 2, to limit the output from the cmdlet to only the newest 2 pages.
        
        TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
        Please be patient and let the system work for you.
        
        Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365LcsEnvironmentHistory {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType('PSCustomObject')]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true)]
        [string] $EnvironmentId,

        [Parameter(ParameterSetName = 'Pagination')]
        [switch] $TraverseAllPages,

        [Parameter(ParameterSetName = 'Pagination')]
        [int] $FirstPages = 99,

        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $FailOnErrorMessage,
        
        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    process {
        Invoke-TimeSignal -Start

        if (-not ($BearerToken.StartsWith("Bearer "))) {
            $BearerToken = "Bearer $BearerToken"
        }

        $parms = @{}
        $parms.ProjectId = $ProjectId
        $parms.BearerToken = $BearerToken
        $parms.EnvironmentId = $EnvironmentId
        $parms.LcsApiUri = $LcsApiUri
        $parms.RetryTimeout = $RetryTimeout
        $parms.EnableException = $EnableException

        [System.Collections.Generic.List[System.Object]] $resArray = @()
        $page = 1

        do {
            $history = Get-LcsEnvironmentHistory @parms

            $resArray.AddRange($history.Data)

            if ($history.ResultHasMorePages -eq $true) {
                $page += 1
                $parms.Page = $page
            }

            if (Test-PSFFunctionInterrupt) { return }

            if ($FailOnErrorMessage -and $deploymentStatus.ErrorMessage) {
                $messageString = "The request against LCS succeeded, but the response was an error message for the operation: <c='em'>$($deploymentStatus.ErrorMessage)</c>."
                $errorMessagePayload = "`r`n$($deploymentStatus | ConvertTo-Json)"
                Write-PSFMessage -Level Host -Message $messageString -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
                Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($errorMessagePayload))) -Target $deploymentStatus
            }
        }
        while (($history.ResultHasMorePages -eq $true) -and $TraverseAllPages -and $page -le $FirstPages)
    
        $res = $null

        if ($resArray.Count -gt 0) {
            $res = $resArray.ToArray()
        }
        
        Invoke-TimeSignal -End

        $res | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Environment.History"
    }
}