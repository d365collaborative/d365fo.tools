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

.PARAMETER Aos
Query the Aos (iis) service

.PARAMETER Batch
Query the batch service

.PARAMETER FinancialReporter
Query the financial reporter (Management Reporter 2012)

.EXAMPLE
Get-D365Environment -All

Will query all D365FO service on the machine

.EXAMPLE
Get-D365Environment -ComputerName "TEST-SB-AOS1","TEST-SB-AOS2","TEST-SB-BI1" -All

Will query all D365FO service on the different machines


.EXAMPLE
Get-D365Environment -Aos -Batch

Will query the Aos & Batch services on the machine

.NOTES

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
        [switch] $FinancialReporter
    )

    if ($PSCmdlet.ParameterSetName -eq "Specific") {
        $All = ![switch]::Present
    }

    if (!$All.IsPresent -and !$Aos.IsPresent -and !$Batch.IsPresent -and !$FinancialReporter.IsPresent) {
        Write-Error "You have to use at least one switch when running this cmdlet. Please run the cmdlet again." -ErrorAction Stop
    }

    $aosname = "w3svc"
    $batchname = "DynamicsAxBatch"
    $financialname = "MR2012ProcessService"
    
    [System.Collections.ArrayList]$Services = New-Object -TypeName "System.Collections.ArrayList"

    if ($All.IsPresent) {
        $null = $Services.AddRange(@($aosname, $batchname, $financialname))
    }    
    else {
        if ($Aos.IsPresent) {
            $null = $Services.Add($aosname)
        }
        if ($Batch.IsPresent) {
            $null = $Services.Add($batchname)
        }
        if ($FinancialReporter.IsPresent) {
            $null = $Services.Add($financialname)
        }
    }

    $Results = foreach ($server in $ComputerName) {
        Get-Service -ComputerName $server -Name $Services.ToArray() -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }
    
    $Results | Select-Object Server, Name, Status, DisplayName
}
