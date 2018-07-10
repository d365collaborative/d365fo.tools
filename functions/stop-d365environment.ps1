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
Stop the financial reporter (Management Reporter 2012)

.EXAMPLE
Stop-D365Environment -All

Will stop all D365FO service on the machine

.EXAMPLE
Stop-D365Environment -Aos -Batch

Will stop Aos & Batch services on the machine

.NOTES

#>
function Stop-D365Environment {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]                    
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 1 )]                    
        [string[]] $ComputerName = @($env:computername),

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]                    
        [switch] $All,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]                    
        [switch] $Aos,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]                    
        [switch] $Batch,

        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 4 )]                    
        [switch] $FinancialReporter
    )

    if (!$All.IsPresent -and !$Aos.IsPresent -and !$Batch.IsPresent -and !$FinancialReporter.IsPresent) {
        Write-Error "You have to use at least one switch when running this cmdlet. Please run the cmdlet again." -ErrorAction Stop
    }

    $aosname = "w3svc"
    $batchname = "DynamicsAxBatch"
    $financialname = "MR2012ProcessService"
    
    [System.Collections.ArrayList]$Services = New-Object -TypeName "System.Collections.ArrayList"

    if ($All.IsPresent) {
        $Services.AddRange(@($aosname, $batchname, $financialname))
    }    
    else {
        if ($Aos.IsPresent) {
            $Services.Add($aosname)
        }
        if ($Batch.IsPresent) {
            $Services.Add($batchname)
        }
        if ($FinancialReporter.IsPresent) {
            $Services.Add($financialname)
        }
    }
    
    Get-Service -ComputerName $ComputerName -Name $Services.ToArray() -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue

    $Results = foreach ($server in $ComputerName) {
        Get-Service -ComputerName $server -Name $Services.ToArray() -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }
    
    $Results | Select-Object Server,Name,Status,DisplayName
}
