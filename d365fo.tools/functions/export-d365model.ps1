<#
.SYNOPSIS
Export a model from Dynamics 365 for Finance & Operations

.DESCRIPTION
Export a model from a Dynamics 365 for Finance & Operations environment

.PARAMETER Path
Path to the folder where you want to save the model file

.PARAMETER Model
Name of the model that you want to work against

    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine

    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory

.EXAMPLE
PS C:\> Export-D365Model -Path c:\temp\d365fo.tools -Model CustomModelName

This will export the "CustomModelName" model from the default PackagesLocalDirectory path.
It export the model to the "c:\temp\d365fo.tools" location.

.NOTES
Tags: ModelUtil, Axmodel, Model, Export
        
        Author: Mötz Jensen (@Splaxi)

#>

function Export-D365Model {
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $True, Position = 2 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 4 )]
        [string] $MetaDataDir = "$Script:MetaDataDir"
    )

    Invoke-TimeSignal -Start
    
    Invoke-ModelUtil -Command "Export" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model
    
    Invoke-TimeSignal -End
}