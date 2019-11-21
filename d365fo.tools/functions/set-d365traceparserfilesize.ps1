
<#
    .SYNOPSIS
        Configue a new maximum file size for the TraceParser
        
    .DESCRIPTION
        Change the maximum file size that the TraceParser generates
        
    .PARAMETER FileSizeInMB
        The maximum size that you want to allow the TraceParser file to grow to
        
        Original value inside the configuration is 1024 (MB)
        
    .PARAMETER Path
        The path to the TraceParser.config file that you want to edit
        
        The default path is: "\AosService\Webroot\Services\TraceParserService\TraceParserService.config"
        
    .EXAMPLE
        PS C:\> Set-D365TraceParserFileSize -FileSizeInMB 2048
        
        This will configure the maximum TraceParser file to 2048 MB.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365TraceParserFileSize {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $FileSizeInMB,
        
        [string] $Path = (Join-Path $Script:AOSPath "Services\TraceParserService\TraceParserService.config")
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    $xmlDoc = [xml] (Get-Content -Path $Path)

    $fileSize = Select-Xml -Xml $xmlDoc -XPath "/Microsoft.Dynamics.AX.Services.Tracing.TraceParser.Properties.Settings/setting[@name='MaximumEtlFileSizeInMb']/value"
    
    $fileSize.Node."#text" = "$FileSizeInMB"

    $xmlDoc.Save($Path)
}