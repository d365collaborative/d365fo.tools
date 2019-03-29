
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
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -All
        
        Will stop all D365FO service on the machine
        
    .EXAMPLE
        PS C:\> Stop-D365Environment -Aos -Batch
        
        Will stop Aos & Batch services on the machine
        
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
    if ($ShowOriginalProgress) {$warningActionValue = "Continue"}

    $Params = Get-DeepClone $PSBoundParameters
    if ($Params.ContainsKey("ComputerName")) {$null = $Params.Remove("ComputerName")}
    if ($Params.ContainsKey("ShowOriginalProgress")) {$null = $Params.Remove("ShowOriginalProgress")}

    $Services = Get-ServiceList @Params
    
    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - stopping services"
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue -WarningAction $warningActionValue
    }

    $Results = foreach ($server in $ComputerName) {
        Write-PSFMessage -Level Verbose -Message "Working against: $server - listing services"
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }
    
    Write-PSFMessage -Level Verbose "Results are: $Results" -Target ($Results.Name -join ",")
    
    $Results | Select-PSFObject -TypeName "D365FO.TOOLS.Environment.Service" Server, DisplayName, Status, Name
}