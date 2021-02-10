
<#
    .SYNOPSIS
        Restart the different services
        
    .DESCRIPTION
        Restart the different services in a Dynamics 365 Finance & Operations environment
        
    .PARAMETER ComputerName
        An array of computers that you want to work against
        
    .PARAMETER All
        Instructs the cmdlet work against all relevant services
        
        Includes:
        Aos
        Batch
        Financial Reporter
        DMF
        
    .PARAMETER Aos
        Instructs the cmdlet to work against the AOS (IIS) service
        
    .PARAMETER Batch
        Instructs the cmdlet to work against the Batch service
        
    .PARAMETER FinancialReporter
        Instructs the cmdlet to work against the Financial Reporter (Management Reporter 2012)
        
    .PARAMETER DMF
        Instructs the cmdlet to work against the DMF service
        
    .PARAMETER Kill
        Instructs the cmdlet to kill the service(s) that you want to restart
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -All
        
        This will stop all services and then start all services again.
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -All -ShowOriginalProgress
        
        This will stop all services and then start all services again.
        The progress of Stopping the different services will be written to the console / host.
        The progress of Starting the different services will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All
        
        This will work against the machines: "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1".
        This will stop all services and then start all services again.
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -Aos -Batch
        
        This will stop the AOS and Batch services and then start the AOS and Batch services again.
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -FinancialReporter -DMF
        
        This will stop the FinancialReporter and DMF services and then start the FinancialReporter and DMF services again.
        
    .EXAMPLE
        PS C:\> Restart-D365Environment -All -Kill
        
        This will stop all services and then start all services again.
        It will use the Kill parameter to make sure that the services is stopped.
        
    .NOTES
        Tags: Environment, Service, Services, Aos, Batch, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Restart-D365Environment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 1 )]
        [string[]] $ComputerName = @($env:computername),

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [switch] $All = $true,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 4 )]
        [switch] $FinancialReporter,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 5 )]
        [switch] $DMF,

        [switch] $Kill,

        [Parameter(Mandatory = $False)]
        [switch] $ShowOriginalProgress
    )

    Stop-D365Environment @PSBoundParameters | Format-Table
    
    $parms = Get-DeepClone $PSBoundParameters
    if ($parms.ContainsKey("Kill")) { $null = $Params.Remove("Kill") }

    Start-D365Environment @parms | Format-Table
}