
<#
    .SYNOPSIS
        Get activation status
        
    .DESCRIPTION
        Get all the important license and activation information from the machine
        
    .EXAMPLE
        PS C:\> Get-D365WindowsActivationStatus
        
        This will get the remaining grace and rearm activation information for the machine
        
    .NOTES
        Tags: Windows, License, Activation, Arm, Rearm
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet uses CIM objects to access the activation details
#>
function Get-D365WindowsActivationStatus {
    [CmdletBinding()]
    param ()

    begin {}

    process {
        $a = Get-CimInstance -Class SoftwareLicensingProduct -Namespace root/cimv2 -ComputerName . -Filter "Name LIKE '%Windows%'"
        $b = Get-CimInstance -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName .

        $res = [PSCustomObject]@{ Name = $a.Name
            Description = $a.Description
            "Grace Periode (days)" =  [math]::Round(($a.graceperiodremaining / 1440))
        }

        $res | Add-Member -MemberType NoteProperty -Name 'ReArms left' -Value $b.RemainingWindowsReArmCount
 
        $res
    }

    end {}
}