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

    .PARAMETER Path
        Path to the model package/file that you want to want to work against

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
        
    .EXAMPLE
        PS C:\> Invoke-ModelUtil -Path "c:\temp\d365fo.tools\ApplicationSuiteModernDesigns_App73.axmodel"
        
        This will execute the import functionality of ModelUtil.exe and have it import the "ApplicationSuiteModernDesigns_App73.axmodel" file.
        
    .NOTES
        Tags: AXModel, Model, ModelUtil, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-ModelUtil {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    
    param (
        [Parameter(Mandatory = $true, Position = 1 )]
        [ValidateSet('Import', 'Export', 'Delete', 'Replace')]
        [string] $Command,

        [Parameter(Mandatory = $True, ParameterSetName = 'Import', Position = 1 )]
        [Parameter(Mandatory = $True, ParameterSetName = 'Export', Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $True, ParameterSetName = 'Export', Position = 2 )]
        [Parameter(Mandatory = $True, ParameterSetName = 'Delete', Position = 1 )]
        [string] $Model,

        [Parameter(Mandatory = $false)]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false)]
        [string] $MetaDataDir = "$Script:MetaDataDir"
    )

    Invoke-TimeSignal -Start
    
    if (-not (Test-PathExists -Path $MetaDataDir, $BinDir -Type Container)) {
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
    }

    $executable = Join-Path $BinDir "ModelUtil.exe"
    if (-not (Test-PathExists -Path $executable -Type Leaf)) {
        Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
    }



    [System.Collections.ArrayList] $params = New-Object -TypeName "System.Collections.ArrayList"
    
    Write-PSFMessage -Level Verbose -Message "Building the parameter options."
    switch ($Command.ToLowerInvariant()) {
        'import' {
            if (-not (Test-PathExists -Path $Path -Type Leaf)) {
                Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
            }

            $null = $params.Add("-import")
            $null = $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $null = $params.Add("-file=`"$Path`"")
        }
        'export' {
            $null = $params.Add("-export")
            $null = $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $null = $params.Add("-outputpath=`"$Path`"")
            $null = $params.Add("-modelname=`"$Model`"")
        }
        'delete' {
            $null = $params.Add("-delete")
            $null = $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $null = $params.Add("-modelname=`"$Model`"")
        }
        'replace' {
            if (-not (Test-PathExists -Path $Path -Type Leaf)) {
                Stop-PSFFunction -Message "Stopping because of missing paths." -StepsUpward 1
            }

            $null = $params.Add("-replace")
            $null = $params.Add("-metadatastorepath=`"$MetaDataDir`"")
            $null = $params.Add("-file=`"$Path`"")
        }
    }

    Write-PSFMessage -Level Verbose -Message "Starting the $executable with the parameter options." -Target $($params.ToArray() -join " ")
    Start-Process -FilePath $executable -ArgumentList ($($params.ToArray() -join " ")) -NoNewWindow -Wait

    Invoke-TimeSignal -End
}