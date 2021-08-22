
<#
    .SYNOPSIS
        Get LCS environment meta data from within a project
        
    .DESCRIPTION
        Get all meta data details for environments from within a LCS project
        
        It supports listing all environments, but also supports single / specific environments by searching based on EnvironmentId or EnvironmentName
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
        Default value can be configured using Set-D365LcsApiConfig
        
    .PARAMETER EnvironmentId
        Id of the environment that you want to be working against
        
    .PARAMETER EnvironmentName
        Name of the environment that you want to be working against
        
    .PARAMETER TraverseAllPages
        Instruct the cmdlet to fetch all pages, until there isn't more data available
        
        This can be a slow operation, as it has to call the LCS API multiple times, fetching a single page per call
        
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
        An example
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365LcsEnvironmentMetadata {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType('PSCustomObject')]
    param(
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(ParameterSetName = 'SearchByEnvironmentId')]
        [string] $EnvironmentId,

        [Parameter(ParameterSetName = 'SearchByEnvironmentName')]
        [string] $EnvironmentName,
      
        [Parameter(ParameterSetName = 'Pagination')]
        [switch] $TraverseAllPages,

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
        $parms.LcsApiUri = $LcsApiUri
        $parms.RetryTimeout = $RetryTimeout
        $parms.EnableException = $EnableException
        
        if ($PSCmdlet.ParameterSetName -eq "SearchByEnvironmentId") {
            $parms.EnvironmentId = $EnvironmentId
        }
        elseif ($PSCmdlet.ParameterSetName -eq "SearchByEnvironmentName") {
            $parms.EnvironmentName = $EnvironmentName
        }

        [System.Collections.Generic.List[System.Object]] $resArray = @()
        $page = 1

        do {
            $metadata = Get-LcsEnvironmentMetadata @parms

            $resArray.AddRange($metadata.Data)

            if ($metadata.ResultHasMorePages -eq $true) {
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
        while (($metadata.ResultHasMorePages -eq $true) -and $TraverseAllPages)
    
        $res = $null

        if ($resArray.Count -gt 0) {
            $res = $resArray.ToArray()
        }
        
        Invoke-TimeSignal -End

        $res | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Environment.Metadata"
    }
}