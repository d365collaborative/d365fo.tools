
<#
    .SYNOPSIS
        Test if any D365 assemblies are loaded
        
    .DESCRIPTION
        Test if any D365 assemblies are loaded into memory and will be a blocking issue
        
    .EXAMPLE
        PS C:\> Test-AssembliesLoaded
        
        This will test in any D365 specific assemblies are loaded into memory.
        If is, a Stop-PSFFunction test will state that we should stop execution.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Test-AssembliesLoaded {
    [CmdletBinding()]
    [OutputType()]
    param (
    )

    Invoke-TimeSignal -Start

    $assembliesLoaded = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location -ne $null

    $assembliesBlocking = $assembliesLoaded.location -match "AOSService|Dynamics|PackagesLocalDirectory"

    if ($assembliesBlocking.Count -gt 0) {
        Stop-PSFFunction -Message "Stopping because some assembly (DLL) files seems to be loaded into memory." -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
}