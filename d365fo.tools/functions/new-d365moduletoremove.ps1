
<#
    .SYNOPSIS
        Create a new ModuleToRemove.txt file
        
    .DESCRIPTION
        Create a new ModuleToRemove.txt file based on a list of module names
        
    .PARAMETER Path
        Path to the ModuleToRemove.txt file
        
    .PARAMETER Modules
        The array with all the module names that you want to fill into the ModuleToRemove.txt file
        
    .EXAMPLE
        PS C:\> New-D365ModuleToRemove -Path C:\Temp -Modules "MyRemovedModule1","MySecondRemovedModule"
        
        This will create a new ModuleToRemove.txt file and fill in "MyRemovedModule1" and "MySecondRemovedModule" as the modules to remove.
        The new file is stored at "C:\Temp\ModuleToRemove.txt"
        
    .EXAMPLE
        PS C:\> New-D365ModuleToRemove -Path C:\Temp -Modules "MyRemovedModule1","MySecondRemovedModule" | Add-D365ModuleToRemove -DeployablePackage C:\Temp\DeployablePackage.zip
        
        This will create a new ModuleToRemove.txt file and fill in "MyRemovedModule1" and "MySecondRemovedModule" as the modules to remove. The file is then added to the "C:\Temp\DeployablePackage.zip" deployable package.
        
    .LINK
        Add-D365ModuleToRemove
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
        
#>
function New-D365ModuleToRemove {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [alias('Folder')]
        [string] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]
        [string[]] $Modules
    )

    begin {
    }

    process {

        if (Test-PathExists -Path $Path -Type Container) {
            Remove-Item -Path $Path\ModuleToRemove.txt -Force -ErrorAction SilentlyContinue

            $Modules | ForEach-Object {
                Add-Content -Path $Path\ModuleToRemove.txt -Value $_
            }

            Write-PSFMessage -Level Host -Message "ModuleToRemove.txt created at $Path" -Target $Path

            [PSCustomObject]@{
                ModuleToRemove = "$Path\ModuleToRemove.txt"
            }

        }
        else {
            Write-PSFMessage -Level Warning -Message "The path $Path does not exist" -Target $Path
        }
    }

    end {
    }
}