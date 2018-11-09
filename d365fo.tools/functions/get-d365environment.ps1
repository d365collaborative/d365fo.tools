
<#
    .SYNOPSIS
        Cmdlet to get the current status for the different services in a Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        List status for all relevant services that is running in a D365FO environment
        
    .PARAMETER ComputerName
        An array of computers that you want to query for the services status on.
        
    .PARAMETER All
        Set when you want to query all relevant services
        
        Includes:
        Aos
        Batch
        Financial Reporter
        DMF
        
    .PARAMETER Aos
        Switch to instruct the cmdlet to query the AOS (IIS) service
        
    .PARAMETER Batch
        Switch to instruct the cmdlet query the batch service
        
    .PARAMETER FinancialReporter
        Switch to instruct the cmdlet query the financial reporter (Management Reporter 2012)
        
    .PARAMETER DMF
        Switch to instruct the cmdlet query the DMF service
        
    .EXAMPLE
        PS C:\> Get-D365Environment -All
        
        Will query all D365FO service on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All
        
        Will query all D365FO service on the different machines
        
    .EXAMPLE
        PS C:\> Get-D365Environment -Aos -Batch
        
        Will query the Aos & Batch services on the machine
        
    .NOTES
        Tags: Environment, Service, Services, Aos, Batch, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365Environment {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 1 )]
        [string[]] $ComputerName = @($env:computername),

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [switch] $All = [switch]::Present,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 4 )]
        [switch] $FinancialReporter,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 5 )]
        [switch] $DMF
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = ![switch]::Present
    }

    if (!$All.IsPresent -and !$Aos.IsPresent -and !$Batch.IsPresent -and !$FinancialReporter.IsPresent -and !$DMF.IsPresent) {
        Write-PSFMessage -Level Host -Message "You have to use at least one switch when running this cmdlet. Please run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $Params = Get-DeepClone $PSBoundParameters
    if($Params.ContainsKey("ComputerName")){$Params.Remove("ComputerName")}

    $Services = Get-ServiceList @Params

    $Results = foreach ($server in $ComputerName) {
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }
    
    $Results | Select-Object Server, DisplayName, Status, Name
}