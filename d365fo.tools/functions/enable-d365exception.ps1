
<#
    .SYNOPSIS
        Enable exceptions to be thrown
        
    .DESCRIPTION
        Change the default exception behavior of the module to support throwing exceptions
        
        Useful when the module is used in an automated fashion, like inside Azure DevOps pipelines and large PowerShell scripts
        
    .EXAMPLE
        PS C:\>Enable-D365Exception
        
        This will for the rest of the current PowerShell session make sure that exceptions will be thrown.
        
    .NOTES
        Tags: Exception, Exceptions, Warning, Warnings
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Disable-D365Exception
#>

function Enable-D365Exception {
    [CmdletBinding()]
    param ()

    Write-PSFMessage -Level Verbose -Message "Enabling exception across the entire module." -Target $configurationValue

    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $true -ModuleName "D365fo.tools"
    Set-PSFFeature -Name 'PSFramework.InheritEnableException' -Value $true -ModuleName "PSOAuthHelper"
    $PSDefaultParameterValues['*:EnableException'] = $true
}