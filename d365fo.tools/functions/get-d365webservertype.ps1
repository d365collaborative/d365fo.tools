
<#
    .SYNOPSIS
        Get the default web server to be used
        
    .DESCRIPTION
        Get the web server which will be used to run D365FO: Either IIS or IIS Express.
        Newly deployed development machines will have this set to IIS Express by default.
        
        It will look for the file located in the default Package Directory.
        
    .EXAMPLE
        PS C:\> Get-D365WebServerType
        
        This will display the current web server type registered in the "DynamicsDevConfig.xml" file.
        Located in "K:\AosService\PackagesLocalDirectory\bin".
        
    .NOTES
        Tag: Web Server, IIS, IIS Express, Development
        
        Author: Sander Holvoet (@smholvoet)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365WebServerType {
    [CmdletBinding()]
    param ()

    if (-not ($script:IsAdminRuntime)) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    $filePath = Join-Path -Path (Join-Path -Path $Script:PackageDirectory -ChildPath "bin") -ChildPath $Script:DevConfig

    if (-not (Test-PathExists -Path $filePath -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    $namespace = @{ns = "http://schemas.microsoft.com/dynamics/2012/03/development/configuration" }
    $runtimeHostType = Select-Xml -XPath "/ns:DynamicsDevConfig/ns:RuntimeHostType" -Path $filePath -Namespace $namespace

    $runtimeHostTypeValue = $runtimeHostType.Node.InnerText
    [PSCustomObject] @{RuntimeHostType = $runtimeHostTypeValue }
}