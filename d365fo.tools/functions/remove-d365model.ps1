
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
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
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
        [Parameter(Mandatory = $true)]
        [string] $Model,

        [Parameter(Mandatory = $false)]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false)]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $DeleteFolders,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    Invoke-TimeSignal -Start
    
    Invoke-ModelUtil -Command "Delete" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

    if (Test-PSFFunctionInterrupt) { return }

    $modelPath = Join-Path $MetaDataDir $Model

    if ($DeleteFolders) {
        if (-not (Test-PathExists -Path $modelPath -Type Container)) { return }

        Remove-Item $modelPath -Force  -Recurse -ErrorAction SilentlyContinue
    }

    Invoke-TimeSignal -End
}