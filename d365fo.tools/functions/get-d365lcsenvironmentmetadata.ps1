
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
        PS C:\> Get-D365LcsEnvironmentMetadata -ProjectId "123456789"
        
        This will show metadata for every available environment from the LCS project.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        
        The request time for completion is directly impacted by the number of environments within the LCS project.
        Please be patient and let the system work for you.
        
        You might experience that not all environments are listed with this request, that would indicate that the LCS project has many environments. Please use the -TraverseAllPages parameter to ensure that all environments are outputted.
        
        A result set example (Tier1):
        
        EnvironmentId                  : c6566087-23bd-4561-8247-4d7f4efd3172
        EnvironmentName                : DevBox-01
        ProjectId                      : 123456789
        EnvironmentInfrastructure      : CustomerManaged
        EnvironmentType                : DevTestDev
        EnvironmentGroup               : Primary
        EnvironmentProduct             : Finance and Operations
        EnvironmentEndpointBaseUrl     : https://devbox-4d7f4efd3172devaos.cloudax.dynamics.com/
        DeploymentState                : Stopped
        TopologyDisplayName            : Finance and Operations - Develop (10.0.18 with Platform update 42)
        CurrentApplicationBuildVersion : 10.0.793.41
        CurrentApplicationReleaseName  : 10.0.18
        CurrentPlatformReleaseName     : Update42
        CurrentPlatformVersion         : 7.0.5968.16999
        DeployedOnUTC                  : 7/5/2021 11:19 AM
        CloudStorageLocation           : West Europe
        DisasterRecoveryLocation       : North Europe
        DeploymentStatusDisplay        : Stopped
        CanStart                       : True
        CanStop                        : False
        
        A result set example (Tier2+):
        
        EnvironmentId                  : e7c53b85-8b6a-4ab9-8985-1e1ea89a0f0a
        EnvironmentName                : Contoso-SIT
        ProjectId                      : 123456789
        EnvironmentInfrastructure      : SelfService
        EnvironmentType                : Sandbox
        EnvironmentGroup               : Primary
        EnvironmentProduct             : Finance and Operations
        EnvironmentEndpointBaseUrl     : https://Contoso-SIT.sandbox.operations.dynamics.com/
        DeploymentState                : Finished
        TopologyDisplayName            : AXHA
        CurrentApplicationBuildVersion : 10.0.761.10019
        CurrentApplicationReleaseName  : 10.0.17
        CurrentPlatformReleaseName     : PU41
        CurrentPlatformVersion         : 7.0.5934.35741
        DeployedOnUTC                  : 4/1/2020 9:35 PM
        CloudStorageLocation           : West Europe
        DisasterRecoveryLocation       :
        DeploymentStatusDisplay        : Deployed
        CanStart                       : False
        CanStop                        : False
        
        A result set example (PROD):
        
        EnvironmentId                  : a8aab4f4-d4f3-41f0-af80-54cea83b50d2
        EnvironmentName                : Contoso-PROD
        ProjectId                      : 123456789
        EnvironmentInfrastructure      : SelfService
        EnvironmentType                : Production
        EnvironmentGroup               : Primary
        EnvironmentProduct             : Finance and Operations
        EnvironmentEndpointBaseUrl     : https://Contoso-PROD.operations.dynamics.com/
        DeploymentState                : Finished
        TopologyDisplayName            : AXHA
        CurrentApplicationBuildVersion : 10.0.886.48
        CurrentApplicationReleaseName  : 10.0.20
        CurrentPlatformReleaseName     : PU44
        CurrentPlatformVersion         : 7.0.6060.45
        DeployedOnUTC                  : 4/9/2020 12:11 PM
        CloudStorageLocation           : West Europe
        DisasterRecoveryLocation       :
        DeploymentStatusDisplay        : Deployed
        CanStart                       : False
        CanStop                        : False
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -TraverseAllPages
        
        This will show metadata for every available environment from the LCS project, across multiple pages.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        It will use the default value for the maximum number of pages to return, 99 pages.
        
        TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
        Please be patient and let the system work for you.
        
        Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e"
        
        This will show metadata for every available environment from the LCS project.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentId "13cc7700-c13b-4ea3-81cd-2d26fa72ec5e", which can be obtained in the LCS portal.
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -EnvironmentName "Contoso-SIT"
        
        This will show metadata for every available environment from the LCS project.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        The environment is identified by the EnvironmentName "Contoso-SIT", which can be obtained in the LCS portal.
        
    .EXAMPLE
        PS C:\> Get-D365LcsEnvironmentMetadata -ProjectId "123456789" -TraverseAllPages -FirstPages 2
        
        This will show metadata for every available environment from the LCS project, across multiple pages.
        The LCS project is identified by the ProjectId 123456789, which can be obtained in the LCS portal.
        It will use the default value for the maximum number of pages to return, 99 pages.
        The cmdlet will be fetching the FirstPages 2, to limit the output from the cmdlet to only the newest 2 pages.
        
        TraverseAllPages will increase the request time for completion, based on how many entries there is in the history.
        Please be patient and let the system work for you.
        
        Please note that when fetching more than 6-7 pages, you will start hitting the 429 throttling from the LCS API endpoint
        
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
        while (($metadata.ResultHasMorePages -eq $true) -and $TraverseAllPages -and $page -le $FirstPages)
    
        $res = $null

        if ($resArray.Count -gt 0) {
            $res = $resArray.ToArray()
        }
        
        Invoke-TimeSignal -End

        $res | Select-PSFObject * -TypeName "D365FO.TOOLS.LCS.Environment.Metadata"
    }
}