
<#
    .SYNOPSIS
        Invoke the ModelUtil.exe
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process
        
    .PARAMETER Command
        Instruct the cmdlet to what process you want to execute against the ModelUtil tool
        
        Valid options:
        Import
        Export
        Delete
        Replace
        
    .PARAMETER Path
        Used for import to point where to import from
        Used for export to point where to export the model to
        
        The cmdlet only supports an already extracted ".axmodel" file
        
    .PARAMETER Model
        Name of the model that you want to work against
        
        Used for export to select the model that you want to export
        Used for delete to select the model that you want to delete
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-ModelUtil -Command Import -Path "c:\temp\d365fo.tools\CustomModel.axmodel"
        
        This will execute the import functionality of ModelUtil.exe and have it import the "CustomModel.axmodel" file.
        
    .EXAMPLE
        PS C:\> Invoke-ModelUtil -Command Export -Path "c:\temp\d365fo.tools" -Model CustomModel
        
        This will execute the export functionality of ModelUtil.exe and have it export the "CustomModel" model.
        The file will be placed in "c:\temp\d365fo.tools".
        
    .EXAMPLE
        PS C:\> Invoke-ModelUtil -Command Delete -Model CustomModel
        
        This will execute the delete functionality of ModelUtil.exe and have it delete the "CustomModel" model.
        The folders in PackagesLocalDirectory for the "CustomModel" will NOT be deleted
        
    .EXAMPLE
        PS C:\> Invoke-ModelUtil -Command Replace -Path "c:\temp\d365fo.tools\CustomModel.axmodel"
        
        This will execute the replace functionality of ModelUtil.exe and have it replace the "CustomModel" model.
        
    .NOTES
        Tags: AXModel, Model, ModelUtil, Servicing, Import, Export, Delete, Replace
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-ModelUtil {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Import', 'Export', 'Delete', 'Replace')]
        [string] $Command,

        [Parameter(Mandatory = $True, ParameterSetName = 'Import', Position = 1 )]
        [Parameter(Mandatory = $True, ParameterSetName = 'Export', Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $True, ParameterSetName = 'Export', Position = 2 )]
        [Parameter(Mandatory = $True, ParameterSetName = 'Delete', Position = 1 )]
        [string] $Model,

        [string] $BinDir = "$Script:PackageDirectory\bin",

        [string] $MetaDataDir = "$Script:MetaDataDir",

        [string] $LogPath,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    Invoke-TimeSignal -Start
    
    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
    }

    $executable = Join-Path -Path $BinDir -ChildPath "ModelUtil.exe"
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
    }

    $params = New-Object System.Collections.Generic.List[string]

    Write-PSFMessage -Level Verbose -Message "Building the parameter options."
    switch ($Command.ToLowerInvariant()) {
        'import' {
            if (-not (Test-PathExists -Path $Path -Type Leaf)) {
                Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
            }

            $params.Add("-import")
            $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $params.Add("-file=`"$Path`"")
        }
        'export' {
            $params.Add("-export")
            $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $params.Add("-outputpath=`"$Path`"")
            $params.Add("-modelname=`"$Model`"")
        }
        'delete' {
            $params.Add("-delete")
            $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $params.Add("-modelname=`"$Model`"")
        }
        'replace' {
            if (-not (Test-PathExists -Path $Path -Type Leaf)) {
                Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
            }

            $params.Add("-replace")
            $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $params.Add("-file=`"$Path`"")
        }
        
    }

    Write-PSFMessage -Level Verbose -Message "Starting the $executable with the parameter options." -Target $($params.ToArray() -join " ")
    
    Invoke-Process -Executable $executable -Params $params.ToArray() -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

    if (Test-PSFFunctionInterrupt) {
        Stop-PSFFunction -Message "Stopping because of 'ModelUtil.exe' failed its execution." -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
}