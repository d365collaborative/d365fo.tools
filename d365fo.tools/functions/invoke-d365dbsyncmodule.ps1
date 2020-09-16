
<#
    .SYNOPSIS
        Synchronize all sync base and extension elements based on a modulename
        
    .DESCRIPTION
        Retrieve the list of installed packages / modules where the name fits the ModelName parameter.
        
        It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions,
        view-extensions and data entities-extensions of every iterated model
        
    .PARAMETER Module
        Name of the model you want to sync tables and table extensions
        
        Supports an array of module names
        
    .PARAMETER LogPath
        The path where the log file will be saved
        
    .PARAMETER Verbosity
        Parameter used to instruct the level of verbosity the sync engine has to report back
        
        Default value is: "Normal"
        
    .PARAMETER BinDirTools
        Path to where the tools on the machine can be found
        
        Default value is normally the AOS Service PackagesLocalDirectory\bin
        
    .PARAMETER MetadataDir
        Path to where the tools on the machine can be found
        
        Default value is normally the AOS Service PackagesLocalDirectory
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
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
        PS C:\> Invoke-D365DbSyncModule -Module "MyModel1"
        
        It will start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of MyModel1.
        
    .EXAMPLE
        PS C:\> Invoke-D365DbSyncModule -Module "MyModel1","MyModel2"
        
        It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of every iterated model.
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name "MyModel*" | Invoke-D365DbSyncModule
        
        Retrieve the list of installed packages / modules where the name fits the search "MyModel*".
        
        The result is:
        MyModel1
        MyModel2
        
        It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions, view-extensions and data entities-extensions of every iterated model.
        
    .NOTES
        Tags: Database, Sync, SyncDB, Synchronization, Servicing
        
        Author: Jasper Callens - Cegeka
        
        Author: Caleb Blanchard (@daxcaleb)
        
        Author: Mötz Jensen (@Splaxi)
#>

function Invoke-D365DbSyncModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("ModuleName")]
        [string[]] $Module,

        [ValidateSet('Normal', 'Quiet', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Normal',

        [string] $BinDirTools = $Script:BinDirTools,

        [string] $MetadataDir = $Script:MetaDataDir,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\DbSync"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        Invoke-TimeSignal -Start

        [System.Collections.Generic.List[System.String]] $modules = @()
    }

    process {
        foreach ($moduleLocal in $Module) {
            $modules.Add($moduleLocal)
        }
    }

    end {
        # Retrieve all sync elements of provided module name
        $allModelSyncElements = $modules.ToArray() | Get-SyncElements

        # Build parameters for the partial sync function
        $syncParams = @{
            SyncList             = $allModelSyncElements.BaseSyncElements;
            SyncExtensionsList   = $allModelSyncElements.ExtensionSyncElements;
            Verbosity            = $Verbosity;
            BinDirTools          = $BinDirTools;
            MetadataDir          = $MetadataDir;
            DatabaseServer       = $DatabaseServer;
            DatabaseName         = $DatabaseName;
            SqlUser              = $SqlUser;
            SqlPwd               = $SqlPwd;
            LogPath              = $LogPath;
            ShowOriginalProgress = $ShowOriginalProgress;
            OutputCommandOnly    = $OutputCommandOnly;
        }

        # Call the partial sync using required parameters
        $resSyncModule = Invoke-D365DBSyncPartial @syncParams

        $resSyncModule

        Invoke-TimeSignal -End
    }
}