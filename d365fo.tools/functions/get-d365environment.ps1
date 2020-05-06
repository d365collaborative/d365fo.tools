
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
        Instruct the cmdlet to query the AOS (IIS) service
        
    .PARAMETER Batch
        Instruct the cmdlet query the batch service
        
    .PARAMETER FinancialReporter
        Instruct the cmdlet query the financial reporter (Management Reporter 2012)
        
    .PARAMETER DMF
        Instruct the cmdlet query the DMF service
        
    .PARAMETER OnlyStartTypeAutomatic
        Instruct the cmdlet to filter out services that are set to manual start or disabled
        
    .PARAMETER OutputServiceDetailsOnly
        Instruct the cmdlet to exclude the server name from the output
        
    .EXAMPLE
        PS C:\> Get-D365Environment
        
        Will query all D365FO service on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -All
        
        Will query all D365FO service on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -OnlyStartTypeAutomatic
        
        Will query all D365FO service on the machine.
        It will filter out all services that are either configured as manual or disabled.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All
        
        Will query all D365FO service on the different machines.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -Aos -Batch
        
        Will query the Aos & Batch services on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -FinancialReporter -DMF
        
        Will query the FinancialReporter & DMF services on the machine.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -OutputServiceDetailsOnly
        
        Will query all D365FO service on the machine.
        Will omit the servername from the output.
        
    .EXAMPLE
        PS C:\> Get-D365Environment -FinancialReporter | Set-Service -StartupType Manual
        
        This will configure the Financial Reporter services to be start type manual.
        
    .NOTES
        Tags: Environment, Service, Services, Aos, Batch, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365Environment {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 1 )]
        [string[]] $ComputerName = @($env:computername),

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [switch] $All = $true,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific')]
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific')]
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific')]
        [switch] $FinancialReporter,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific')]
        [switch] $DMF,

        [switch] $OnlyStartTypeAutomatic,

        [switch] $OutputServiceDetailsOnly
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = $false
    }

    if ( (-not ($All)) -and (-not ($Aos)) -and (-not ($Batch)) -and (-not ($FinancialReporter)) -and (-not ($DMF))) {
        Write-PSFMessage -Level Host -Message "You have to use at least one switch when running this cmdlet. Please run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    $Params = Get-DeepClone $PSBoundParameters
    if($Params.ContainsKey("ComputerName")){$null = $Params.Remove("ComputerName")}
    if($Params.ContainsKey("OutputServiceDetailsOnly")){$null = $Params.Remove("OutputServiceDetailsOnly")}
    if($Params.ContainsKey("OnlyStartTypeAutomatic")){$null = $Params.Remove("OnlyStartTypeAutomatic")}

    $Services = Get-ServiceList @Params

    $Results = foreach ($server in $ComputerName) {
        Get-Service -ComputerName $server -Name $Services -ErrorAction SilentlyContinue | Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, StartType, DisplayName
    }
    
    $outputTypeName = "D365FO.TOOLS.Environment.Service"

    if($OutputServiceDetailsOnly) {
        $outputTypeName = "D365FO.TOOLS.Environment.Service.Minimal"
    }

    if($OnlyStartTypeAutomatic){
        $Results = $Results | Where-Object StartType -eq "Automatic"
    }

    $Results | Select-PSFObject -TypeName $outputTypeName Server, DisplayName, Status, StartType, Name
}