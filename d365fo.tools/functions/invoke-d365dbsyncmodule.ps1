
<#
    .SYNOPSIS
        Synchronize all sync base and extension elements based on a modulename
        
    .DESCRIPTION
        Retrieve the list of installed packages / modules where the name fits the ModelName parameter.
        
        It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions,
        view-extensions and data entities-extensions of every iterated model
        
    .PARAMETER ModuleName
        Name of the model you want to sync tables and table extensions
        
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
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .EXAMPLE
        PS C:\> Invoke-D365DbSyncModule -ModuleName "Application*Adaptor"
        
        Retrieve the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        It will run loop over the list and start the sync process against all tables, views, data entities, table-extensions,
        view-extensions and data entities-extensions of every iterated model
        
    .NOTES
        Tags: Database, Sync, SyncDB, Synchronization, Servicing
        
        Author: Jasper Callens - Cegeka
#>

function Invoke-D365DbSyncModule {
    [CmdletBinding()]
    param (
        [string] $ModuleName,

        [string] $LogPath = "C:\temp\D365FO.Tools\Sync",

        [ValidateSet('Normal', 'Quiet', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string] $Verbosity = 'Normal',

        [string] $BinDirTools = $Script:BinDirTools,

        [string] $MetadataDir = $Script:MetaDataDir,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    process {
        Invoke-TimeSignal -Start
        
        # Retrieve all sync elements of provided module name
        $allModelSyncElements = Get-SyncElements -ModuleName $ModuleName
        
        # Build parameters for the partial sync function
        $syncParams = @{
            SyncList=$allModelSyncElements.BaseSyncElements;
            SyncExtensionsList = $allModelSyncElements.ExtensionSyncElements;
            Verbosity = $Verbosity;
            BinDirTools=$BinDirTools;
            MetadataDir=$MetadataDir;
            DatabaseServer=$DatabaseServer;
            DatabaseName=$DatabaseName;
            SqlUser=$SqlUser;
            SqlPwd=$SqlPwd;
            ShowOriginalProgress=$ShowOriginalProgress;
            OutputCommandOnly=$OutputCommandOnly
        }

        # Call the partial sync using required parameters
        $resSyncModule = Invoke-D365DBSyncPartial @syncParams

        $resSyncModule

        Invoke-TimeSignal -End
    }
}