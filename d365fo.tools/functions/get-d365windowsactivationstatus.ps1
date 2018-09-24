<#
.SYNOPSIS
Get activation status

.DESCRIPTION
Get all the important license and activation information from the machine

.EXAMPLE
Get-D365WindowsActivationStatus

This will get the remaining grace and rearm activation information for the machine
.NOTES
The cmdlet uses WMI objects to access the activation details 
#>
function Get-D365WindowsActivationStatus {
    [CmdletBinding()]
    param ()

    begin {}

    process {
        $a = Get-WmiObject -Class SoftwareLicensingProduct -Namespace root/cimv2 -ComputerName . -Filter "Name LIKE '%Windows%'" 
        $b = Get-WmiObject -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName . 

        $res = [PSCustomObject]@{ Name = $a.Name 
            Description = $a.Description 
            "Grace Periode (days)" =  [math]::Round(($a.graceperiodremaining / 1440))
        }

        $res | Add-Member -MemberType NoteProperty -Name 'ReArms left' -Value $b.RemainingWindowsReArmCount
 
        $res
    }

    end {}
}