
<#
    .SYNOPSIS
        Set the web server type to be used to run the D365FO instance
        
    .DESCRIPTION
        Set the web server which will be used to run D365FO: Either IIS or IIS Express.
        Newly deployed development machines will have this set to IIS Express by default.

        It will backup the current "DynamicsDevConfig.xml" file, for you to revert the changes if anything should go wrong.
        
    .PARAMETER RuntimeHostType
        The type of web server you want to use.

        Valid options are:
        "IIS"
        "IISExpress"
        
    .EXAMPLE
        PS C:\> Set-D365WebServerType -RuntimeHostType "IIS"
        
        This will update the current web server type registered in the "DynamicsDevConfig.xml" file.
        This file is located "K:\AosService\PackagesLocalDirectory\bin".
        It will backup the current "DynamicsDevConfig.xml" file.
        It will replace the value inside the "RuntimeHostType" tag.
        
    .NOTES
        Tag: Web Server, IIS, IIS Express, Development
        
        Author: Sander Holvoet (@smholvoet)
      
#>

function Set-D365WebServerType {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [ValidateSet('IIS', 'IISExpress')]
        [string] $RuntimeHostType
    )

    begin {
        $filePath = "K:\AosService\PackagesLocalDirectory\bin\DynamicsDevConfig.xml"

        if (-not (Test-PathExists -Path $filePath -Type Leaf)) { return }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        $filePathBackup = $filePath.Replace(".xml", ".xml$((Get-Date).Ticks)")
        Copy-Item -Path $filePath -Destination $filePathBackup -Force

        $namespace = @{ns = "http://schemas.microsoft.com/dynamics/2012/03/development/configuration" }

        $xmlDoc = [xml] (Get-Content -Path $filePath)
        $runtimeHostType = Select-Xml -Xml $xmlDoc -XPath "/ns:DynamicsDevConfig/ns:RuntimeHostType" -Namespace $namespace

        $oldValue = $runtimeHostType.Node.InnerText

        Write-PSFMessage -Level Verbose -Message "Old value found in the file was: $oldValue" -Target $oldValue

        $runtimeHostType.Node.InnerText = $RuntimeHostType
        $xmlDoc.Save($filePath)
    }

    end {
        Get-D365WebServerType
    }
}