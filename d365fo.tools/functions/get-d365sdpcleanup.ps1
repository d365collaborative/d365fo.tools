
<#
    .SYNOPSIS
        Get the cleanup retention period
        
    .DESCRIPTION
        Gets the configured retention period before updates are deleted
        
    .EXAMPLE
        PS C:\> Get-D365SDPCleanUp
        
        This will get the configured retention period from the registry
        
    .NOTES
        Tags: CleanUp, Retention, Servicing, Cut Off, DeployablePackage, Deployable Package
        
        Author: Mötz Jensen (@Splaxi)
        
        This cmdlet is based on the findings from Alex Kwitny (@AlexOnDAX)
        
        See his blog for more info:
        http://www.alexondax.com/2018/04/msdyn365fo-how-to-adjust-your.html
        
#>
function Get-D365SDPCleanUp {
    [CmdletBinding()]
    param (
        
    )
    
    $RegSplat = @{
        Path = "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\"
        Name = "CutoffDaysForCleanup"
    }
    
    [PSCustomObject] @{
        CutoffDaysForCleanup = $( if (Test-RegistryValue @RegSplat) {Get-ItemPropertyValue @RegSplat} else {""} )
    }
}