<#
.SYNOPSIS
Invokes the Rearm of Windows license

.DESCRIPTION
Function used for invoking the rearm functionality inside Windows

.PARAMETER Restart
Instruct the cmdlet to restart the machine

.EXAMPLE
Invoke-D365ReArmWindows

.EXAMPLE
Invoke-D365ReArmWindows -Restart

.NOTES

#>

function Invoke-D365ReArmWindows {
    param(
        [Parameter(Mandatory = $false, Position = 1)]        
        [switch]$Restart
    )

    Write-Verbose "Invoking the rearm process."

    (Get-WmiObject -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName .).ReArmWindows()
  
    if ($Restart.IsPresent) {
        Restart-Computer -Force
    }
}