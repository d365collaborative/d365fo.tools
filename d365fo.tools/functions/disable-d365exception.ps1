
<#
    .SYNOPSIS
        Disables throwing of exceptions
        
    .DESCRIPTION
        Restore the default exception behavior of the module to not support throwing exceptions
        
        Useful when the default behavior was changed with Enable-D365Exception and the default behavior should be restored
        
    .EXAMPLE
        PS C:\>Disable-D365Exception
        
        This will restore the default behavior of the module to not support throwing exceptions.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        
        Author: Florian Hopfner (@FH-Inway)
        
    .LINK
        Enable-D365Exception
#>

function Disable-D365Exception {
    [CmdletBinding()]
    param ()

    Write-PSFMessage -Level Verbose -Message "Disabling exception across the entire module." -Target $configurationValue

    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "D365fo.tools"
    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $false -ModuleName "PSOAuthHelper"
    $PSDefaultParameterValues['*:EnableException'] = $false
}