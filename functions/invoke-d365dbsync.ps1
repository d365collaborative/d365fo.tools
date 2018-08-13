<#
.SYNOPSIS
Invoke the synchronization process used in Visual Studio

.DESCRIPTION
Uses the sync.exe (engine) to synchronize the database for the environment

.PARAMETER BinDirTools
Path to where the tools on the machine can be found

Default value is normally the AOS Service PackagesLocalDirectory\bin

.PARAMETER BinDir
Path to where the tools on the machine can be found

Default value is normally the AOS Service PackagesLocalDirectory

.PARAMETER LogPath
The path where the log file will be saved

.PARAMETER SyncMode
The sync mode the sync engine will use

Default value is: "FullAll"
.PARAMETER Verbosity
Parameter used to instruct the level of verbosity the sync engine has to report back

Default value is: "Normal"

.PARAMETER DatabaseServer
The name of the database server

If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).

If Azure use the full address to the database server, e.g. server.database.windows.net

.PARAMETER DatabaseName
The name of the database

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user.

.EXAMPLE
Invoke-D365DBSync

This will invoke the sync engine and have it work against the database

.EXAMPLE
Invoke-D365DBSync -Verbose

This will invoke the sync engine and have it work against the database. It will output the
same level of details that Visual Studio would normally do

.NOTES
#>
function Invoke-D365DBSync {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false, Position = 0)]
        [string]$BinDirTools = $Script:BinDirTools,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$MetadataDir = $Script:MetaDataDir,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$LogPath = "C:\temp\D365FO.Tools\Sync",

        [Parameter(Mandatory = $false, Position = 3)]
        #[ValidateSet('None', 'PartialList','InitialSchema','FullIds','PreTableViewSyncActions','FullTablesAndViews','PostTableViewSyncActions','KPIs','AnalysisEnums','DropTables','FullSecurity','PartialSecurity','CleanSecurity','ADEs','FullAll','Bootstrap','LegacyIds','Diag')]
        [string]$SyncMode = 'FullAll',
        
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateSet('Normal', 'Quiet', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
        [string]$Verbosity = 'Normal',

        [Parameter(Mandatory = $false, Position = 5)]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 6)]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 7)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 8)]
        [string]$SqlPwd = $Script:DatabaseUserPassword        
    )

    #! The way the sync engine works is that it uses the connection string for some operations, 
    #! but for FullSync / FullAll it depends on the database details from the same assemblies that 
    #! we rely on. So the testing of how to run this cmdlet is a bit different than others

    Write-PSFMessage -Level Debug -Message "Testing if run on LocalHostedTier1 and console isn't elevated"
    if ($Script:EnvironmentType -eq [EnvironmentType]::LocalHostedTier1 -and !$script:IsAdminRuntime){
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and on a <c='em'>local VM / local vhd</c>. Being on a local VM / local VHD requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }
    elseif (!$script:IsAdminRuntime -and $Script:UserIsAdmin -and $Script:EnvironmentType -ne [EnvironmentType]::LocalHostedTier1) {
        Write-PSFMessage -Level Host -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c> and as an <c='em'>administrator</c>. You should either logon as a non-admin user account on this machine or run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`" or simply logon as another user"
        Stop-PSFFunction -Message "Stopping because of missing parameters"
        return
    }

    Write-PSFMessage -Level Debug -Message "Testing if the path exists or not." -Target $command
    $command = Join-Path $BinDirTools "SyncEngine.exe"
    if ((Test-Path -Path $command -PathType Leaf) -eq $false) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>SyncEngine.exe</c> in the specified path. Please ensure that the path exists and you have permissions to access it."
            
        Stop-PSFFunction -Message "Stopping because unable to locate SyncEngine.exe" -Target $command
        return
    }

    Write-PSFMessage -Level Debug -Message "Testing if the SyncEngine is already running."
    $syncEngine = Get-Process -Name "SyncEngine" -ErrorAction SilentlyContinue
    if ($null -ne $syncEngine) {
        Write-PSFMessage -Level Host -Message "A instance of SyncEngine is <c='em'>already running</c>. Please <c='em'>wait</c> for it to finish or <c='em'>kill it</c>."
            
        Stop-PSFFunction -Message "Stopping because SyncEngine.exe already running"
        return
    }

    Write-PSFMessage -Level Debug -Message "Testing if the path exists or not." -Target $MetadataDir 
    if ((Test-Path -Path $MetadataDir -PathType Container) -eq $false) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>BinDir(metadatabinaries)</c> in the specified path. Please ensure that the path exists and you have permissions to access it."
            
        Stop-PSFFunction -Message "Stopping because unable to locate the BinDir path" -Target $MetadataDir
        return
    }
    
    Write-PSFMessage -Level Debug -Message "Build the parameters for the command to execute."
    $param = " -syncmode=$($SyncMode.ToLower())"
    $param += " -verbosity=$($Verbosity.ToLower())"
    $param += " -metadatabinaries=`"$MetadataDir`""
    $param += " -connect=`"server=$DatabaseServer;Database=$DatabaseName; User Id=$SqlUser;Password=$SqlPwd;`""    

    Write-PSFMessage -Level Debug -Message "Testing if the path exists or not." -Target $LogPath
    if ((Test-Path -Path $LogPath.Trim() -PathType Leaf) -eq $false) {
        Write-PSFMessage -Level Debug -Message "Creating the path." -Target $LogPath
        $null = New-Item -Path $LogPath -ItemType directory -Force -ErrorAction Stop
    }
    
    Write-PSFMessage -Level Debug -Message "Starting the SyncEngine with the parameters." -Target $param
    $process = Start-Process -FilePath $command -ArgumentList  $param -PassThru -RedirectStandardOutput "$LogPath\output.log" -RedirectStandardError "$LogPath\error.log" -WindowStyle "Hidden"  
    
    $lineTotalCount = 0
    $lineCount = 0
    Write-Verbose "Process Started"
    Write-Verbose $process

    $StartTime = Get-Date

    while ($process.HasExited -eq $false) {
        foreach ($line in Get-Content "$LogPath\output.log") {
            $lineCount++
            if ($lineCount -gt $lineTotalCount) {
                Write-Verbose $line
                $lineTotalCount++
            }
        }
        $lineCount = 0
        Start-Sleep -Seconds 2

    }

    foreach ($line in Get-Content "$LogPath\output.log") {
        $lineCount++
        if ($lineCount -gt $lineTotalCount) {
            Write-Verbose $line
            $lineTotalCount++
        }
    }

    foreach ($line in Get-Content "$LogPath\error.log") {        
        Write-PSFMessage -Level Critical -Message "$line"
    }

    $EndTime = Get-Date

    $TimeSpan = New-TimeSpan -End $EndTime -Start $StartTime

    Write-PSFMessage -Level Verbose -Message "Total time for sync was $TimeSpan" -Target $TimeSpan
}