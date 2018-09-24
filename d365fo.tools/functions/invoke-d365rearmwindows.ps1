<#
.SYNOPSIS
Invokes the Rearm of Windows license

.DESCRIPTION
Function used for invoking the rearm functionality inside Windows

.PARAMETER Restart
Instruct the cmdlet to restart the machine

.EXAMPLE
Invoke-D365ReArmWindows

This will re arm the Windows installation if there is any activation
retries left

.EXAMPLE
Invoke-D365ReArmWindows -Restart

This will re arm the Windows installation if there is any activation
retries left and restart the computer

.NOTES

#>

function Invoke-D365ReArmWindows {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]        
        [switch]$Restart
    )

    Write-Verbose "Invoking the rearm process."

    (Get-WmiObject -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName .).ReArmWindows()
  
    if ($Restart.IsPresent) {
        Restart-Computer -Force
    }
}