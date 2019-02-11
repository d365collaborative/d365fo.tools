<#
.SYNOPSIS
Remove a model from Dynamics 365 for Finance & Operations

.DESCRIPTION
Remove a model from a Dynamics 365 for Finance & Operations environment

.PARAMETER Model
Name of the model that you want to work against

    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine

    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory

.PARAMETER DeleteFolders
Instruct the cmdlet to delete the model folder

This is useful when you are trying to clean up the folders in your source control / branch

.EXAMPLE
PS C:\> Remove-D365Model -Model CustomModelName

This will remove the "CustomModelName" model from the D365FO environment.
It will NOT remove the folders inside the PackagesLocalDirectory location.

.EXAMPLE
PS C:\> Remove-D365Model -Model CustomModelName -DeleteFolders

This will remove the "CustomModelName" model from the D365FO environment.
It will remove the folders inside the PackagesLocalDirectory location.
This is helpful when dealing with source control and you want to remove the model entirely.

.NOTES
Tags: ModelUtil, Axmodel, Model, Remove, Delete, Source Control, Vsts, Azure DevOps
        
        Author: Mötz Jensen (@Splaxi)
#>

function Remove-D365Model {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $DeleteFolders
    )

    Invoke-TimeSignal -Start
    
    Invoke-ModelUtil -Command "Delete" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model

    if (Test-PSFFunctionInterrupt) { return }

    $modelPath = Join-Path $MetaDataDir $Model

    if ($DeleteFolders) {
        if (-not (Test-PathExists -Path $modelPath -Type Container)) { return }

        Remove-Item $modelPath -Force  -Recurse -ErrorAction SilentlyContinue
    }

    Invoke-TimeSignal -End
}