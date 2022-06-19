
<#
    .SYNOPSIS
        Import a model into Dynamics 365 for Finance & Operations
        
    .DESCRIPTION
        Import a model into a Dynamics 365 for Finance & Operations environment
        
    .PARAMETER Path
        Path to the axmodel file that you want to import
        
    .PARAMETER Model
        Name of the model that you want to work against
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER Replace
        Instruct the cmdlet to replace an already existing model
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Import-D365Model -Path c:\temp\d365fo.tools\CustomModel.axmodel
        
        This will import the "c:\temp\d365fo.tools\CustomModel.axmodel" model into the PackagesLocalDirectory location.
        
    .EXAMPLE
        PS C:\> Import-D365Model -Path c:\temp\d365fo.tools\CustomModel.axmodel -Replace
        
        This will import the "c:\temp\d365fo.tools\CustomModel.axmodel" model into the PackagesLocalDirectory location.
        If the model already exists it will replace it.
        
    .NOTES
        Tags: ModelUtil, Axmodel, Model, Import, Replace, Source Control, Vsts, Azure DevOps
        
        Author: Mötz Jensen (@Splaxi)
#>

function Import-D365Model {
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $Replace,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ModelUtilImport"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    Invoke-TimeSignal -Start
    
    if($Replace) {
        Invoke-ModelUtil -Command "Replace" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
    }
    else {
        Invoke-ModelUtil -Command "Import" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
    }

    Invoke-TimeSignal -End
}