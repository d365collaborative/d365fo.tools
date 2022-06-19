
<#
    .SYNOPSIS
        Cmdlet to stop the different services in a Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Can stop all relevant services that is running in a D365FO environment
        
    .PARAMETER ComputerName
        An array of computers that you want to stop services on.
        
    .PARAMETER All
        Set when you want to stop all relevant services
        
        Includes:
        Aos
        Batch
        Financial Reporter
        
    .PARAMETER Aos
        Stop the Aos (iis) service
        
    .PARAMETER Batch
        Stop the batch service
        
    .PARAMETER FinancialReporter
        Start the financial reporter (Management Reporter 2012) service
        
    .PARAMETER DMF
        Start the Data Management Framework service
        
    .PARAMETER Kill
        Instructs the cmdlet to kill the service(s) that you want to stop
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .EXAMPLE
        PS C:\> Stop-D365Environment
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will stop all D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -ShowOriginalProgress
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will Stop all D365FO services on the machine.
        The progress of Stopping the different services will be written to the console / host.
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -All
        
        This will stop all D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -Aos -Batch
        
        This will stop the Aos & Batch D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -FinancialReporter -DMF
        
        This will stop the FinancialReporter and DMF services on the machine.
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -All -Kill
        
        This will stop all D365FO services on the machine.
        It will use the Kill parameter to make sure that the services is stopped.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Stop-D365Environment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
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

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 6 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [switch] $Kill,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 7 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 7 )]
        [switch] $ShowOriginalProgress
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = $false
    }

    if ((-not ($All)) -and (-not ($Aos)) -and (-not ($Batch)) -and (-not ($FinancialReporter)) -and (-not ($DMF))) {
        Write-PSFMessage -Level Host -Message "You have to use at least <c='em'>one switch</c> when running this cmdlet. Please run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $warningActionValue = "SilentlyContinue"
    if ($ShowOriginalProgress) { $warningActionValue = "Continue" }

    $Params = Get-DeepClone $PSBoundParameters
    if ($Params.ContainsKey("ComputerName")) { $null = $Params.Remove("ComputerName") }
    if ($Params.ContainsKey("ShowOriginalProgress")) { $null = $Params.Remove("ShowOriginalProgress") }
    if ($Params.ContainsKey("Kill")) { $null = $Params.Remove("Kill") }

    $Services = Get-ServiceList @Params
    
    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - stopping services"

        if (-not $Kill) {
            Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue -WarningAction $warningActionValue
        }
        else {
            Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | ForEach-Object {
                $service = Get-CimInstance -ClassName "win32_service" -Filter "Name = '$($_.Name)'"

                Stop-Process -Id "$($service.ProcessId)" -Force -ErrorAction SilentlyContinue -WarningAction $warningActionValue
            }
        }
    }

    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - listing services"
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | Select-Object @{Name = "Server"; Expression = { $Server } }, Name, Status, StartType, DisplayName
    }
    
    Write-PSFMessage -Level Verbose "Results are: $Results" -Target ($Results.Name -join ",")
    
    $Results | Select-PSFObject -TypeName "D365FO.TOOLS.Environment.Service" Server, DisplayName, Status, StartType, Name
}