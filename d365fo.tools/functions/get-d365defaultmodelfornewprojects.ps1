
<#
    .SYNOPSIS
        Get the default model used creating new projects in Visual Studio
        
    .DESCRIPTION
        Get the registered default model that is used across all new projects that are created inside Visual Studio when working with D365FO project types
        
    .EXAMPLE
        PS C:\> Get-D365DefaultModelForNewProjects
        
        This will display the current default module registered in the "DynamicsDevConfig.xml" file.
        Located in Documents\Visual Studio Dynamics 365\ or in Documents\Visual Studio 2015\Settings\ depending on the version.
        
    .NOTES
        Tag: Model, Models, Development, Default Model, Module, Project
        
        Author: Mötz Jensen (@Splaxi)
        
        The work for this cmdlet / function was inspired by Robin Kretzschmar (@DarkSmile92) blog post about changing the default model.
        
        The direct link for his blog post is: https://robscode.onl/d365-set-default-model-for-new-projects/
        
        His main blog can found here: https://robscode.onl/
        
#>

function Get-D365DefaultModelForNewProjects {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param ()

    $filePath = "$env:UserProfile\Documents\Visual Studio Dynamics 365\DynamicsDevConfig.xml"
    if (-not (Test-PathExists -Path $filePath -Type Leaf)) {
        $filePath = "$env:UserProfile\Documents\Visual Studio 2015\Settings\DynamicsDevConfig.xml"
    }
    if (-not (Test-PathExists -Path $filePath -Type Leaf)) { return }

    if (Test-PSFFunctionInterrupt) { return }

    $namespace = @{ns = "http://schemas.microsoft.com/dynamics/2012/03/development/configuration" }
    $defaultModel = Select-Xml -XPath "/ns:DynamicsDevConfig/ns:DefaultModelForNewProjects" -Path $filePath -Namespace $namespace

    $modelName = $defaultModel.Node.InnerText
    [PSCustomObject] @{DefaultModelForNewProjects = $modelName }
}