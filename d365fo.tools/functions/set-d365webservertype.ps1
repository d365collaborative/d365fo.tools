
<#
    .SYNOPSIS
        Set the web server type to be used to run the D365FO instance
        
    .DESCRIPTION
        Set the web server which will be used to run D365FO: Either IIS or IIS Express.
        Newly deployed development machines will have this set to IIS Express by default.
        
        It will backup the current "DynamicsDevConfig.xml" file, for you to revert the changes if anything should go wrong.
        
        It will look for the file located in the default Package Directory.
        
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
        
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365WebServerType {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [ValidateSet('IIS', 'IISExpress')]
        [string] $RuntimeHostType
    )

    begin {
        if (-not ($script:IsAdminRuntime)) {
            Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
            Stop-PSFFunction -Message "Stopping because the function is not run elevated"
            return
        }
    
        $filePath = Join-Path -Path (Join-Path -Path $Script:PackageDirectory -ChildPath "bin") -ChildPath $Script:DevConfig
    
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