
<#
    .SYNOPSIS
        Get the default web server to be used
        
    .DESCRIPTION
        Get the web server which will be used to run D365FO: Either IIS or IIS Express.
        Newly deployed development machines will have this set to IIS Express by default.

    .EXAMPLE
        PS C:\> Get-D365WebServerType
        
        This will display the current web server type registered in the "DynamicsDevConfig.xml" file.
        Located in "K:\AosService\PackagesLocalDirectory\bin".
        
    .NOTES
        Tag: Web Server, IIS, IIS Express, Development
        
        Author: Sander Holvoet (@smholvoet)
   
#>

function Get-D365WebServerType {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param ()

    $filePath = "K:\AosService\PackagesLocalDirectory\bin\DynamicsDevConfig.xml"
    if (-not (Test-PathExists -Path $filePath -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    $namespace = @{ns = "http://schemas.microsoft.com/dynamics/2012/03/development/configuration" }
    $runtimeHostType = Select-Xml -XPath "/ns:DynamicsDevConfig/ns:RuntimeHostType" -Path $filePath -Namespace $namespace

    $runtimeHostTypeValue = $runtimeHostType.Node.InnerText
    [PSCustomObject] @{RuntimeHostType = $runtimeHostTypeValue }
}