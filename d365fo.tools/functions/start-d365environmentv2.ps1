
<#
    .SYNOPSIS
        Cmdlet to start the different services in a Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Can start all relevant services that is running in a D365FO environment
        
    .PARAMETER All
        Set when you want to start all relevant services
        
        Includes:
        Aos
        Batch
        Financial Reporter
        Data Management Framework
        
    .PARAMETER Aos
        Start the Aos (iis) service
        
    .PARAMETER Batch
        Start the batch service
        
    .PARAMETER FinancialReporter
        Start the financial reporter (Management Reporter 2012) service
        
    .PARAMETER DMF
        Start the Data Management Framework service
        
    .PARAMETER OnlyStartTypeAutomatic
        Instruct the cmdlet to filter out services that are set to manual start or disabled
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will start all D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2 -OnlyStartTypeAutomatic
        
        This will start all D365FO services on the machine that are configured for Automatic startup.
        It will exclude all services that are either manual or disabled in their startup configuration.
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2 -ShowOriginalProgress
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will start all D365FO services on the machine.
        The progress of starting the different services will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2 -All
        
        This will start all D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2 -Aos -Batch
        
        This will start the Aos & Batch D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Start-D365EnvironmentV2 -FinancialReporter -DMF
        
        This will start the FinancialReporter and DMF services on the machine.
        
    .EXAMPLE
        PS C:\> Enable-D365Exception
        PS C:\> Start-D365EnvironmentV2
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will start all D365FO services on the machine.
        If a service does not start, it will throw an exception.
        
    .NOTES
        Author: Vincent Verweij (@VincentVerweij)
        
#>
function Start-D365EnvironmentV2 {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [switch] $All = $true,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 1 )]
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]
        [switch] $FinancialReporter,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 4 )]
        [switch] $DMF,

        [switch] $OnlyStartTypeAutomatic,

        [switch] $ShowOriginalProgress
    )

    Import-Module -Name "WebAdministration" -Scope "Local"

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = $false
    }

    if ( (-not ($All)) -and (-not ($Aos)) -and (-not ($Batch)) -and (-not ($FinancialReporter)) -and (-not ($DMF))) {
        Write-PSFMessage -Level Host -Message "You have to use at least <c='em'>one switch</c> when running this cmdlet. Please run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $ComputerName = @($env:computername)
    $warningActionValue = "SilentlyContinue"
    if ($ShowOriginalProgress) { $warningActionValue = "Continue" }

    $Params = Get-DeepClone $PSBoundParameters
    if ($Params.ContainsKey("ShowOriginalProgress")) { $null = $Params.Remove("ShowOriginalProgress") }
    if ($Params.ContainsKey("OnlyStartTypeAutomatic")) { $null = $Params.Remove("OnlyStartTypeAutomatic") }

    $psItemExceptionsFromStartServices = New-Object -TypeName "System.Collections.ArrayList"
    $didServiceStartThrowException = $false

    $Services = Get-ServiceList @Params

    Write-PSFMessage -Level Verbose -Message "Working against: $ComputerName - starting services"
    $temp = Get-Service -ComputerName $ComputerName -Name $Services -ErrorAction SilentlyContinue
    
    if ($OnlyStartTypeAutomatic) {
        $temp = $temp | Where-Object StartType -eq "Automatic"
    }

    try {
        $temp | Start-Service -WarningAction $warningActionValue
    }
    catch {
        $didServiceStartThrowException = $true
        $psItemExceptionsFromStartServices.Add($PSItem.Exception)
    }

    if (($($temp -join ",") -like "*w3svc*")) {
        Start-Website -Name "AOSService"
    }

    Write-PSFMessage -Level Verbose -Message "Working against: $ComputerName - listing services"
    $temp = Get-Service -ComputerName $ComputerName -Name $Services -ErrorAction SilentlyContinue
    
    if ($OnlyStartTypeAutomatic) {
        $temp = $temp | Where-Object StartType -eq "Automatic"
    }

    $Results = $temp | Select-Object @{Name = "Server"; Expression = { $ComputerName } }, Name, Status, StartType, DisplayName

    Write-PSFMessage -Level Verbose "Results are: $Results" -Target ($Results.Name -join ",")

    $Results | Select-PSFObject -TypeName "D365FO.TOOLS.Environment.Service" Server, DisplayName, Status, StartType, Name

    if ($didServiceStartThrowException) {
        foreach ($psItemException in $psItemExceptionsFromStartServices) {
            Write-PSFMessage -Level Host -Message "Something went wrong while starting the service(s) on computer '$($ComputerName)'" -Exception $psItemException
        }
    }
}