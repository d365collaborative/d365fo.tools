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
Start the financial reporter (Management Reporter 2012)

.EXAMPLE
Start-D365Environment -All

Will start all D365FO service on the machine

.EXAMPLE
Start-D365Environment -Aos -Batch

Will start Aos & Batch services on the machine

.NOTES

#>


function Start-D365Environment {
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

    $aosName = "w3svc"
    $batchName = "DynamicsAxBatch"
    $financialName = "MR2012ProcessService"

    [System.Collections.ArrayList]$Services = New-Object -TypeName "System.Collections.ArrayList"

    if ($All.IsPresent) {
        $Services.AddRange(@($aosName, $batchName, $financialName))
    }
    else {
        if ($Aos.IsPresent) {
            $Services.Add($aosName)
        }
        if ($Batch.IsPresent) {
            $Services.Add($batchName)
        }
        if ($FinancialReporter.IsPresent) {
            $Services.Add($financialName)
        }
    }

    Get-Service -ComputerName $ComputerName -Name $Services.ToArray() -ErrorAction SilentlyContinue | Start-Service -ErrorAction SilentlyContinue

    $Results = foreach ($server in $ComputerName) {
        Get-Service -ComputerName $server -Name $Services.ToArray() -ErrorAction SilentlyContinue| Select-Object @{Name = "Server"; Expression = {$Server}}, Name, Status, DisplayName
    }

    $Results | Select-Object Server, Name, Status, DisplayName
}
