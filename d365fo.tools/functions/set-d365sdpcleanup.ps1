
<#
    .SYNOPSIS
        Set the cleanup retention period
        
    .DESCRIPTION
        Sets the configured retention period before updates are deleted
        
    .PARAMETER NumberOfDays
        Number of days that deployable software packages should remain on the server
        
    .EXAMPLE
        PS C:\> Set-D365SDPCleanUp -NumberOfDays 10
        
        This will set the retention period to 10 days inside the the registry
        
        The cmdlet REQUIRES elevated permissions to run, otherwise it will fail
        
    .NOTES
        This cmdlet is based on the findings from Alex Kwitny (@AlexOnDAX)
        
        See his blog for more info:
        http://www.alexondax.com/2018/04/msdyn365fo-how-to-adjust-your.html
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365SDPCleanUp {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [int] $NumberOfDays = 30
    )

    if (-not ($Script:IsAdminRuntime)) {
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c>. Making changes to the registry requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment" -Name "CutoffDaysForCleanup" -Type STRING -Value "$NumberOfDays" -Force
}