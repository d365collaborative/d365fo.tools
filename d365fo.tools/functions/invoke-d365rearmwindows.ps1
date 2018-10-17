
<#
    .SYNOPSIS
        Invokes the Rearm of Windows license
        
    .DESCRIPTION
        Function used for invoking the rearm functionality inside Windows
        
    .PARAMETER Restart
        Instruct the cmdlet to restart the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365ReArmWindows
        
        This will re arm the Windows installation if there is any activation retries left
        
    .EXAMPLE
        PS C:\> Invoke-D365ReArmWindows -Restart
        
        This will re arm the Windows installation if there is any activation retries left and restart the computer.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Invoke-D365ReArmWindows {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]$Restart
    )

    Write-PSFMessage -Level Verbose -Message "Invoking the rearm process."

    $instance = Get-CimInstance -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName .
    Invoke-CimMethod -InputObject $instance -MethodName ReArmWindows
    
    if ($Restart) {
        Restart-Computer -Force
    }
}