<#
    .SYNOPSIS
        Compile and sync a module
        
    .DESCRIPTION
        Compile and sync a package using 
            - Invoke-D365ModuleFullCompile function
            - "syncengine.exe" to sync the table and extension elements for module
        
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
        
    .NOTES
        Tags: Compile, Model, Servicing, Database, Synchronization
        
        Author: Jasper Callens        
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

            # Build parameters for the partial sync function
            $syncParams = @{
                ModelName=$moduleElement.Module;
                BinDirTools=$BinDir;
                MetadataDir=$MetaDataDir;
                ShowOriginalProgress=$ShowOriginalProgress;
                OutputCommandOnly=$OutputCommandOnly
            }

            # Call the full compile using required parameters
            $resModuleCompileFull = Invoke-D365ModuleFullCompile @fullCompileParams

            # Call the partial sync using required parameters
            $resSyncModule = Invoke-D365DBSyncPartial @syncParams
    
            # Output results of full compile and partial sync
            $resModuleCompileFull    
            $resSyncModule
        }  
    }

    end {
        Invoke-TimeSignal -End
    }
}