
<#
    .SYNOPSIS
        Set the default model used creating new projects in Visual Studio
        
    .DESCRIPTION
        Set the registered default model that is used across all new projects that are created inside Visual Studio when working with D365FO project types
        
        It will backup the current "DynamicsDevConfig.xml" file, for you to revert the changes if anything should go wrong
        
    .PARAMETER Module
        The name of the module / model that you want to be the default model for all new projects used inside Visual Studio when working with D365FO project types
        
    .EXAMPLE
        PS C:\> Set-D365DefaultModelForNewProjects -Model "FleetManagement"
        
        This will update the current default module registered in the "DynamicsDevConfig.xml" file.
        This file is located in Documents\Visual Studio Dynamics 365\ or in Documents\Visual Studio 2015\Settings\ depending on the version.
        It will backup the current "DynamicsDevConfig.xml" file.
        It will replace the value inside the "DefaultModelForNewProjects" tag.
        
    .NOTES
        Tag: Model, Models, Development, Default Model, Module, Project
        
        Author: Mötz Jensen (@Splaxi)
        
        The work for this cmdlet / function was inspired by Robin Kretzschmar (@DarkSmile92) blog post about changing the default model.
        
        The direct link for his blog post is: https://robscode.onl/d365-set-default-model-for-new-projects/
        
        His main blog can found here: https://robscode.onl/
        
#>

function Set-D365DefaultModelForNewProjects {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [Alias('Model')]
        [string] $Module
    )

    begin {
        $filePath = "$env:UserProfile\Documents\Visual Studio Dynamics 365\DynamicsDevConfig.xml"
        if (-not (Test-PathExists -Path $filePath -Type Leaf)) {
            $filePath = "$env:UserProfile\Documents\Visual Studio 2015\Settings\DynamicsDevConfig.xml"
        }

        if (-not (Test-PathExists -Path $filePath -Type Leaf)) { return }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Backup-D365DevConfig

        $namespace = @{ns = "http://schemas.microsoft.com/dynamics/2012/03/development/configuration" }

        $xmlDoc = [xml] (Get-Content -Path $filePath)
        $defaultModel = Select-Xml -Xml $xmlDoc -XPath "/ns:DynamicsDevConfig/ns:DefaultModelForNewProjects" -Namespace $namespace

        $oldValue = $defaultModel.Node.InnerText

        Write-PSFMessage -Level Verbose -Message "Old value found in the file was: $oldValue" -Target $oldValue

        $defaultModel.Node.InnerText = $Module
        $xmlDoc.Save($filePath)
    }

    end {
        Get-D365DefaultModelForNewProjects
    }
}