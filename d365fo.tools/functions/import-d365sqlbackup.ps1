
<#
    .SYNOPSIS
        Import a database backup
        
    .DESCRIPTION
        Import a database backup into the D365FO SQL Server database

    .PARAMETER SqlBackupFile
        Path to the SQL backup file you want to import into the database

    .PARAMETER ImportDatabaseName
        The name of the database where the backup file will be imported in
        
    .PARAMETER DatabaseServer
        The name of the database server

    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
    
    .PARAMETER SQLBinDirTools
        Path to where the SQL tools on the machine can be found
        
        Default value is normally Program Files\Microsoft SQL Server\140\SDK\Assemblies
                
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output

    .EXAMPLE
        PS C:\> Import-D365SqlBackup -SqlBackupFile "J:\MSSQL_BACKUP\AxDB.bak"
        
        Start the import of the backup file at "J:\MSSQL_BACKUP\AxDB.bak" and import it to database with auto
        generated name "AxDB_ddMMyyyy_HH_mm_ss" (using current date time)

    .EXAMPLE
        PS C:\> Import-D365SqlBackup -SqlBackupFile "J:\MSSQL_BACKUP\AxDB.bak" -ImportDatabaseName "AxDB_Import"
        
        Start the import of the backup file at "J:\MSSQL_BACKUP\AxDB.bak" and import it to database with name "AxDB_Import"
        
    .EXAMPLE
        PS C:\> Import-D365SqlBackup -SqlBackupFile "J:\MSSQL_BACKUP\AxDB.bak" -ImportDatabaseName "AxDB_Import" -ShowOriginalProgress
        
        Start the import of the backup file at "J:\MSSQL_BACKUP\AxDB.bak" and import it to database with name "AxDB_Import".
        Show the progress of the Restore process while it is running.
    
    .NOTES
        Tags: Database, SqlBackup, Configuration, Restore
        
        Author: Jasper Callens (@JCThugPotato) - Cegeka
        
        Doc: https://gist.github.com/sheldonhull/08fe28dd236a239f25821378268ef8e5
#>
function Import-D365SqlBackup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [string] $SqlBackupFile,
        
        [string] $ImportDatabaseName,

        [string] $DatabaseServer = $Script:DatabaseServer,
        
        [string] $SqlUser = $Script:DatabaseUserName,
        
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [string] $SQLBinDirTools = $Script:SQLBinDirTools,

        [switch] $ShowOriginalProgress
    )

    begin
    {
        Invoke-TimeSignal -Start

        # Import all required SQL (tool) assemblies required for database restore
        $assemblies2Process = New-Object -TypeName "System.Collections.ArrayList"
                
        $null = $assemblies2Process.Add((Join-Path $SQLBinDirTools "Microsoft.SqlServer.Smo.dll"))
        $null = $assemblies2Process.Add((Join-Path $SQLBinDirTools "Microsoft.SqlServer.SmoExtended.dll"))

        Import-AssemblyFileIntoMemory -Path $($assemblies2Process.ToArray())
    }

    process
    {
         # Initialize the SQL service instance (for provided database)
        $srv = [Microsoft.SqlServer.Management.Smo.Server]::New($DatabaseServer)

        # Initialize naming and path variables
        if([string]::IsNullOrEmpty($ImportDatabaseName))
        {
            $ImportDatabaseName = "AxDB_$(Get-Date -format "ddMMyyyy_HH_mm_ss")"
        }
        $handlerLogFunctionName = "Import-D365SqlBackup - Restore"

        $sqlDataFolder = $srv.Settings.DefaultFile
        $sqlLogFolder = $srv.Settings.DefaultLog

        $dataFileName = "$($ImportDatabaseName)_data"
        $logFileName = "$($ImportDatabaseName)_log"
        
        # Initialize the restore instance
        $restore = [Microsoft.SqlServer.Management.Smo.Restore]::new()

        # Set the backupfile and new database name
        $restore.Devices.AddDevice($SqlBackupFile, [Microsoft.SqlServer.Management.Smo.DeviceType]::File)
        $restore.Database = $ImportDatabaseName

        # Initialize potentialy required string where SqlVerify error will be placed
        $sqlVerifyError = [string]::Empty

        # Validate the SqlBackupFile before Restore process starts
        if($restore.SqlVerify($srv, [ref]$sqlVerifyError))
        {
            # In case we have multiple data and log files to replace, we need to count them (for suffix)
            $replaceDataFileCount = 1;
            $replaceLogFileCount = 1;

            # Show actual progress of Restore process if ShowOriginalProgress is enabled
            if($ShowOriginalProgress)
            {
                # Create Eventhandler so progress can be monitored
                $percentEventHandler = [Microsoft.SqlServer.Management.Smo.PercentCompleteEventHandler]  {
                    Write-PSFMessage -Level Host -Message "Restoring $($ImportDatabaseName) - $($_.Percent)%" -FunctionName $handlerLogFunctionName
                }

                # Create Eventhandler so completion can be monitored
                $completedEventHandler = [Microsoft.SqlServer.Management.Common.ServerMessageEventHandler] {
                    Write-PSFMessage -Level Host -Message ("Import backup database $($ImportDatabaseName) completed") -FunctionName $handlerLogFunctionName
                }

                # Add eventhandlers to restore instance
                $restore.add_PercentComplete($percentEventHandler)
                $restore.add_Complete($completedEventHandler)
                $restore.PercentCompleteNotification = 1
            }
        
            # Loop over every file (data and log) and create relocating file with requested name
            # This way we don't have to override any existing database (and database files) but just create a unique new one
            foreach ($file in $restore.ReadFileList($srv))
            {
                $relocateFile = [Microsoft.SqlServer.Management.Smo.RelocateFile]::new()
                $relocateFile.LogicalFileName = $file.LogicalName

                # Files can be type 'D' or 'L' (Data or Log). Relocating files must be processed accordingly
                if ($file.Type -eq 'D')
                {
                    $relocateFile.PhysicalFileName = [io.path]::combine($sqlDataFolder, "$($dataFileName)_$($replaceDataFileCount).mdf")
                    $replaceDataFileCount++
                }
                else
                {
                    $relocateFile.PhysicalFileName = [io.path]::combine($sqlLogFolder, "$($logFileName)_$($replaceLogFileCount).ldf")
                    $replaceLogFileCount++
                }

                $null = $restore.RelocateFiles.Add($relocateFile)
            }

            # Start the restore process
            Write-PSFMessage -Level Verbose -Message "Starting import SQL Backup for file $($SqlBackupFile) to database $($restore.Database)."
            $restore.SqlRestore($srv)
        }
        else
        {
            Write-PSFMessage -Level Host -Message "Import SQL backup cannot be executed. Error: $($sqlVerifyError)"
        }
    }

    end
    {
        Invoke-TimeSignal -End
    }
}