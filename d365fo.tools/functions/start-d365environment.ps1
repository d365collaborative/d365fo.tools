
<#
    .SYNOPSIS
        Cmdlet to start the different services in a Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Can start all relevant services that is running in a D365FO environment
        
    .PARAMETER ComputerName
        An array of computers that you want to start services on.
        
    .PARAMETER All
        Set when you want to start all relevant services
        
        Includes:
        Aos
        Batch
        Financial Reporter
        
    .PARAMETER Aos
        Start the Aos (iis) service
        
    .PARAMETER Batch
        Start the batch service
        
    .PARAMETER FinancialReporter
        Start the financial reporter (Management Reporter 2012) service
        
    .PARAMETER DMF
        Start the Data Management Framework service
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .EXAMPLE
        PS C:\> Start-D365Environment
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will start all D365FO services on the machine.

    .EXAMPLE
        PS C:\> Start-D365Environment -ShowOriginalProgress
        
        This will run the cmdlet with the default parameters.
        Default is "-All".
        This will start all D365FO services on the machine.
        The progress of starting the different services will be written to the console / host.

    .EXAMPLE
        PS C:\> Start-D365Environment -All
        
        This will start all D365FO services on the machine.
        
    .EXAMPLE
        PS C:\> Start-D365Environment -Aos -Batch
        
        This will start the Aos & Batch D365FO services on the machine.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Start-D365Environment {
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
        [switch] $ShowOriginalProgress
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = $false
    }

    if ( (-not ($All)) -and (-not ($Aos)) -and (-not ($Batch)) -and (-not ($FinancialReporter)) -and (-not ($DMF))) {
        Write-PSFMessage -Level Host -Message "You have to use at least <c='em'>one switch</c> when running this cmdlet. Please run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $warningActionValue = "SilentlyContinue"
    if ($ShowOriginalProgress) {$warningActionValue = "Continue"}

    $Params = Get-DeepClone $PSBoundParameters
    if ($Params.ContainsKey("ComputerName")) {$null = $Params.Remove("ComputerName")}
    if ($Params.ContainsKey("ShowOriginalProgress")) {$null = $Params.Remove("ShowOriginalProgress")}

    $Services = Get-ServiceList @Params

    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - starting services"
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | Start-Service -ErrorAction SilentlyContinue -WarningAction $warningActionValue
    }

    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - listing services"
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }

    Write-PSFMessage -Level Verbose "Results are: $Results" -Target ($Results.Name -join ",")

    $Results | Select-PSFObject -TypeName "D365FO.TOOLS.Environment.Service" Server, DisplayName, Status, Name
}