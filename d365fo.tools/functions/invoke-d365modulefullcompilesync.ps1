
<#
    .SYNOPSIS
        Compile and sync a module
        
    .DESCRIPTION
        Compile and sync a package using
        - Invoke-D365ModuleFullCompile function
        - Invoke-D365DBSyncPartial to sync the table and extension elements for module
        
    .PARAMETER ModuleName
        Name of the module that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all modules
        
    .PARAMETER OutputDir
        The path to the folder to save assemblies
        
    .PARAMETER LogDir
        The path to the folder to save logs
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
    .PARAMETER ReferenceDir
        The full path of a folder containing all assemblies referenced from X++ code
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleFullCompileSync -ModuleName MyModel
        
        This will use the default paths and start:
        * Invoke-D365ModuleFullCompile with the needed parameters to compile MyModel package.
        * Invoke-D365DBSyncPartial with the needed parameters to sync MyModel table and extesion elements.
        
        The default output from all the different steps will be silenced.
        
    .EXAMPLE
        PS C:\> Invoke-D365ModuleFullCompileSync -ModuleName "Application*Adaptor"
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        For every value of the list perform the following:
        * Invoke-D365ModuleFullCompile with the needed parameters to compile current module value package.
        * Invoke-D365DBSyncPartial with the needed parameters to sync current module value table and extesion elements.
        
        The default output from all the different steps will be silenced.
        
    .NOTES
        Tags: Compile, Model, Servicing, Database, Synchronization
        
        Author: Jasper Callens - Cegeka
#>

function Invoke-D365ModuleFullCompileSync {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [Alias('Output')]
        [string] $OutputDir = $Script:MetaDataDir,

        [string] $LogDir = $Script:DefaultTempPath,

        [string] $MetaDataDir = $Script:MetaDataDir,

        [string] $ReferenceDir = $Script:MetaDataDir,

        [string] $BinDir = $Script:BinDirTools,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start
    }

    process {
        # Retrieve all modules that match provided $ModuleName
        $moduleResults = Get-D365Module -Name $ModuleName

        # Output information on which modules that will be compiled and synced
        Write-PSFMessage -Level Debug -Message "Modules retrieved: "
        $moduleResults | ForEach-Object {
            Write-PSFMessage -Level Debug -Message "$($_.Module) "
        }
        
        # Create empty lists for all sync-base and sync-extension elements
        $syncList = @()
        $syncExtensionsList = @()

        foreach($moduleElement in $moduleResults)
        {
            Write-PSFMessage -Level Debug -Message "Processing module: $($moduleElement.Module)"

            # Build parameters for the full compile function
            $fullCompileParams = @{
                Module=$moduleElement.Module;
                OutputDir=$OutputDir;
                LogDir=$LogDir;
                MetaDataDir=$MetaDataDir;
                ReferenceDir=$ReferenceDir;
                BinDir=$BinDir;
                ShowOriginalProgress=$ShowOriginalProgress;
                OutputCommandOnly=$OutputCommandOnly
            }

            # Call the full compile using required parameters
            $resModuleCompileFull = Invoke-D365ModuleFullCompile @fullCompileParams

            # Retrieve the sync element of current module
            $moduleSyncElements = Get-SyncElements -ModuleName $moduleElement.Module

            # Add base and extensions elements to the sync lists
            $syncList +=$moduleSyncElements.BaseSyncElements
            $syncExtensionsList += $moduleSyncElements.ExtensionSyncElements
    
            # Output results of full compile and partial sync
            $resModuleCompileFull
            
        }

        # Build parameters for the partial sync function
        $syncParams = @{
            SyncList=$syncList;
            SyncExtensionsList = $syncExtensionsList;
            BinDirTools=$BinDir;
            MetadataDir=$MetaDataDir;
            ShowOriginalProgress=$ShowOriginalProgress;
            OutputCommandOnly=$OutputCommandOnly
        }

        # Call the partial sync using required parameters
        $resSyncModule = Invoke-D365DBSyncPartial @syncParams

        $resSyncModule
    }

    end {
        Invoke-TimeSignal -End
    }
}