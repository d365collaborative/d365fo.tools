
<#
    .SYNOPSIS
        Process a specific or multiple modules (compile, deploy reports and sync)
        
    .DESCRIPTION
        Process a specific or multiple modules by invoking the following functions (based on flags)
        - Invoke-D365ModuleFullCompile function
        - Publish-D365SsrsReport to deploy the reports of a module
        - Invoke-D365DBSyncPartial to sync the table and extension elements for module
        
    .PARAMETER ModuleName
        Name of the module that you want to process
        
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
        PS C:\> Invoke-D365ProcessModules -ModuleName "Application*Adaptor" -ExecuteCompile
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        For every value of the list perform the following:
        * Invoke-D365ModuleFullCompile with the needed parameters to compile current module value package.
        
        The default output from all the different steps will be silenced.

    .EXAMPLE
        PS C:\> Invoke-D365ProcessModules -ModuleName "Application*Adaptor" -ExecuteSync
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        For every value of the list perform the following:
        * Invoke-D365DBSyncPartial with the needed parameters to sync current module value table and extension elements.
        
        The default output from all the different steps will be silenced.

    .EXAMPLE
        PS C:\> Invoke-D365ProcessModules -ModuleName "Application*Adaptor" -ExecuteDeployReports
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        For every value of the list perform the following:
        * Publish-D365SsrsReport with the required parameters to deploy all reports of current module
        
        The default output from all the different steps will be silenced.

    .EXAMPLE
        PS C:\> Invoke-D365ProcessModules -ModuleName "Application*Adaptor" -ExecuteCompile -ExecuteSync -ExecuteDeployReports
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        For every value of the list perform the following:
        * Invoke-D365ModuleFullCompile with the needed parameters to compile current module package.
        * Invoke-D365DBSyncPartial with the needed parameters to sync current module table and extension elements.
        * Publish-D365SsrsReport with the required parameters to deploy all reports of current module
        
        The default output from all the different steps will be silenced.
        
    .NOTES
        Tags: Compile, Model, Servicing, Database, Synchronization
        
        Author: Jasper Callens - Cegeka
#>

function Invoke-D365ProcessModules {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModuleName,

        [switch] $ExecuteCompile = $false,

        [switch] $ExecuteSync = $false,

        [switch] $ExecuteDeployReports = $false,

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
        # Only execute the code if any of the flags are set
        if($ExecuteCompile -or $ExecuteSync -or $ExecuteDeployReports)
        {
            # Retrieve all modules that match provided $ModuleName
            $moduleResults = Get-D365Module -Name $ModuleName

            # Output information on which modules that will be compiled and synced
            Write-PSFMessage -Level Host -Message "Modules to process: "
            $moduleResults | ForEach-Object {
                Write-PSFMessage -Level Host -Message " - $($_.Module) "
            }

            # Empty list for all modules that have to be compiled
            $modulesToCompile = @()
            
            # Empty list for all modules of which the reports have to be deployed
            $modulesToDeployReports = @()

            # Create empty lists for all sync-base and sync-extension elements
            $syncList = @()
            $syncExtensionsList = @()

            # Loop every resulting module result and fill the required 'processing' lists based on the flags
            foreach($moduleElement in $moduleResults)
            {
                if($ExecuteCompile)
                {
                    $modulesToCompile += $moduleElement
                }

                if($ExecuteDeployReports)
                {
                    $modulesToDeployReports += $moduleElement
                }

                if($ExecuteSync)
                {
                    # Retrieve the sync element of current module
                    $moduleSyncElements = Get-SyncElements -ModuleName $moduleElement.Module

                    # Add base and extensions elements to the sync lists
                    $syncList +=$moduleSyncElements.BaseSyncElements
                    $syncExtensionsList += $moduleSyncElements.ExtensionSyncElements
                }
            }

            if($ExecuteCompile)
            {
                # Loop over every module to compile and execute compile function
                foreach($moduleToCompile in $modulesToCompile)
                {
                    # Build parameters for the full compile function
                    $fullCompileParams = @{
                        Module=$moduleToCompile.Module;
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

                    # Output results of full compile
                    $resModuleCompileFull
                }
            }
            
            if($ExecuteDeployReports)
            {
                # Loop over every module to deploy reports and execute deploy report function
                foreach($moduleToDeployReports in $modulesToDeployReports)
                {
                    # Build parameters for the model report deployment
                    $fullDeployParams = @{
                        Module=$moduleToDeployReports.Module;
                        LogFile="$LogDir\$($moduleToDeployReports.Module).log";
                    }
                    
                    if($OutputCommandOnly)
                    {
                        Write-PSFMessage -Level Host -Message "Publish-D365SsrsReport $($fullDeployParams -join ' ')"
                    }
                    else
                    {
                        $resModuleDeployReports = Publish-D365SsrsReport @fullDeployParams
                        $resModuleDeployReports
                    }
                }
            }

            if($ExecuteSync)
            {
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
        }
        else
        {
            Write-PSFMessage -Level Output -Message "No process flags were set. Nothing will be processed"
        }
    }

    end {
        Invoke-TimeSignal -End
    }
}