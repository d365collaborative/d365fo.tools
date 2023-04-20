
<#
    .SYNOPSIS
        Adds a ModuleToRemove.txt file to a deployable package
        
    .DESCRIPTION
        Modifies an existing deployable package and adds a ModuleToRemove.txt file to it.
        
    .PARAMETER ModuleToRemove
        Path to the ModuleToRemove.txt file that you want to have inside a deployable package
        
    .PARAMETER DeployablePackage
        Path to the deployable package file where the ModuleToRemove.txt file should be added
        
    .PARAMETER OutputPath
        Path where you want the generated deployable package to be stored
        
        Default value is the same as the "DeployablePackage" parameter
        
    .EXAMPLE
        PS C:\> Add-D365ModuleToRemove -ModuleToRemove "C:\temp\ModuleToRemove.txt" -DeployablePackage "C:\temp\DeployablePackage.zip"
        
        This will take the "C:\temp\ModuleToRemove.txt" file and add it to the "C:\temp\DeployablePackage.zip" deployable package in the "AOSService/Scripts" folder.
        
    .EXAMPLE
        PS C:\> New-D365ModuleToRemove -Path C:\Temp -Modules "MyRemovedModule1","MySecondRemovedModule" | Add-D365ModuleToRemove -DeployablePackage C:\Temp\DeployablePackage.zip
        
        This will create a new ModuleToRemove.txt file and fill in "MyRemovedModule1" and "MySecondRemovedModule" as the modules to remove. The file is then added to the "C:\Temp\DeployablePackage.zip" deployable package.
        
    .LINK
        New-D365ModuleToRemove
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Add-D365ModuleToRemove {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (

        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true)]
        [string] $ModuleToRemove,

        [Parameter(Mandatory = $true, Position = 2)]
        [string] $DeployablePackage,

        [string] $OutputPath = $DeployablePackage

    )

    begin {
        $oldprogressPreference = $global:progressPreference
        $global:progressPreference = 'silentlyContinue'
    }

    process {
        Add-FileToPackage -File $ModuleToRemove -Archive $DeployablePackage -Path "AosService\Scripts" -OutputPath $OutputPath
    }

    end {
        $global:progressPreference = $oldprogressPreference
    }
}