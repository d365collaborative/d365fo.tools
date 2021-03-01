
<#
    .SYNOPSIS
        Invoke the synchronization process used in Visual Studio
        
    .DESCRIPTION
        Uses the sync.exe (engine) to synchronize the database for the environment
        
    .PARAMETER SyncMode
        The sync mode the sync engine will use
        
        Default value is: "PartialList"
        
    .PARAMETER SyncList
        The list of objects that you want to pass on to the database synchronoziation engine
        
    .PARAMETER SyncExtensionsList
        The list of extension objects that you want to pass on to the database synchronoziation engine
        
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
        PS C:\> Invoke-D365DBSyncPartial -SyncList "CustCustomerEntity","SalesTable"
        
        This will invoke the sync engine and have it work against the database.
        It will run with the default value "PartialList" as the SyncMode.
        It will run the sync process against "CustCustomerEntity" and "SalesTable"
        
    .EXAMPLE
        PS C:\> Invoke-D365DBSyncPartial -SyncList "CustCustomerEntity","SalesTable" -Verbose
        
        This will invoke the sync engine and have it work against the database.
        It will run with the default value "PartialList" as the SyncMode.
        It will run the sync process against "CustCustomerEntity" and "SalesTable"
        
        It will output the same level of details that Visual Studio would normally do.
        
    .EXAMPLE
        PS C:\> Invoke-D365DBSyncPartial -SyncList "CustCustomerEntity","SalesTable" -SyncExtensionsList "CaseLog.Extension","CategoryTable.Extension" -Verbose
        
        This will invoke the sync engine and have it work against the database.
        It will run with the default value "PartialList" as the SyncMode.
        It will run the sync process against "CustCustomerEntity", "SalesTable", "CaseLog.Extension" and "CategoryTable.Extension"
        
        It will output the same level of details that Visual Studio would normally do.
        
    .NOTES
        Tags: Database, Sync, SyncDB, Synchronization, Servicing
        
        Author: Mötz Jensen (@Splaxi)
        
        Author: Jasper Callens - Cegeka
        
        Inspired by:
        https://axdynamx.blogspot.com/2017/10/how-to-synchronize-manually-database.html
        
#>

function Invoke-D365DbSyncPartial {
    [CmdletBinding()]
    param (
        [string[]] $SyncList,

        [string[]] $SyncExtensionsList,

        #[ValidateSet('None', 'PartialList','InitialSchema','FullIds','PreTableViewSyncActions','FullTablesAndViews','PostTableViewSyncActions','KPIs','AnalysisEnums','DropTables','FullSecurity','PartialSecurity','CleanSecurity','ADEs','FullAll','Bootstrap','LegacyIds','Diag')]
        [string] $SyncMode = 'PartialList',

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

    process {
        Invoke-TimeSignal -Start
        
        #! The way the sync engine works is that it uses the connection string for some operations,
        #! but for FullSync / FullAll it depends on the database details from the same assemblies that
        #! we rely on. So the testing of how to run this cmdlet is a bit different than others

        Write-PSFMessage -Level Debug -Message "Testing if run on LocalHostedTier1 and console isn't elevated"
        if ($Script:EnvironmentType -eq [EnvironmentType]::LocalHostedTier1 -and !$script:IsAdminRuntime) {
            Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and on a <c='em'>local VM / local vhd</c>. Being on a local VM / local VHD requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
        elseif (!$script:IsAdminRuntime -and $Script:UserIsAdmin -and $Script:EnvironmentType -ne [EnvironmentType]::LocalHostedTier1) {
            Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and as an <c='em'>administrator</c>. You should either logon as a non-admin user account on this machine or run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`" or simply logon as another user"
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }

        $executable = Join-Path -Path $BinDirTools -ChildPath "SyncEngine.exe"
        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }
        if (-not (Test-PathExists -Path $MetadataDir -Type Container)) { return }

        Write-PSFMessage -Level Debug -Message "Testing if the SyncEngine is already running."
        $syncEngine = Get-Process -Name "SyncEngine" -ErrorAction SilentlyContinue
        
        if ($null -ne $syncEngine) {
            Write-PSFMessage -Level Host -Message "A instance of SyncEngine is <c='em'>already running</c>. Please <c='em'>wait</c> for it to finish or <c='em'>kill it</c>."
            Stop-PSFFunction -Message "Stopping because SyncEngine.exe already running"
            return
        }
        
        Write-PSFMessage -Level Debug -Message "Build the parameters for the command to execute."
        $params = @("-syncmode=$($SyncMode.ToLower())",
            "-synclist=`"$($SyncList -join ",")`"",
            "-tableextensionlist=`"$($SyncExtensionsList -join ',')`"",
            "-verbosity=$($Verbosity.ToLower())",
            "-metadatabinaries=`"$MetadataDir`"",
            "-connect=`"server=$DatabaseServer;Database=$DatabaseName; User Id=$SqlUser;Password=$SqlPwd;`""
        )

        Write-PSFMessage -Level Debug -Message "Starting the SyncEngine with the parameters." -Target $param
        #! We should consider to redirect the standard output & error like this: https://stackoverflow.com/questions/8761888/capturing-standard-out-and-error-with-start-process
        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
        
        Invoke-TimeSignal -End
    }
}