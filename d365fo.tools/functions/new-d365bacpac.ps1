<#
.SYNOPSIS
Generate a bacpac file from a database

.DESCRIPTION
Takes care of all the details and steps that is needed to create a valid bacpac file to move between Tier 1 (onebox or Azure hosted) and Tier 2 (MS hosted), or vice versa

Supports to create a raw bacpac file without prepping. Can be used to automate backup from Tier 2 (MS hosted) environment

.PARAMETER ExportModeTier1
Switch to instruct the cmdlet that the export will be done against a classic SQL Server installation

.PARAMETER ExportModeTier2
Switch to instruct the cmdlet that the export will be done against an Azure SQL DB instance

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

.PARAMETER BackupDirectory
The path where to store the temporary backup file when the script needs to handle that

.PARAMETER NewDatabaseName
The name for the database the script is going to create when doing the restore process

.PARAMETER BacpacFile
The path where you want the cmdlet to store the bacpac file that will be generated

.PARAMETER CustomSqlFile
The path to a custom sql server script file that you want executed against the database

.PARAMETER ExportOnly
Switch to instruct the cmdlet to either just create a dump bacpac file or run the prepping process first

.EXAMPLE
New-D365Bacpac -ExportModeTier1 -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac

Will backup and restore the db database again the localhost server.
Will run the prepping process against the restored database.
Will export a bacpac file.
Will delete the restored database.

.EXAMPLE
New-D365Bacpac -ExportModeTier2 -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac

Will create a copy the db database on the dbserver1 in Azure.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.

.EXAMPLE
New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BackupDirectory c:\Temp\backup\ -BacpacFile C:\Temp\Bacpac\Testing1.bacpac

Normally used for a Tier-2 export and preparation for Tier-1 import

Will create a copy of the registered D365 database on the registered D365 Azure SQL DB instance.
Will run the prepping process against the copy database.
Will export a bacpac file.
Will delete the copy database.


.EXAMPLE
New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BackupDirectory c:\Temp\backup\ -BacpacFile C:\Temp\Bacpac\Testing1.bacpac -ExportOnly

Will export a bacpac file.
The bacpac should be able to restore back into the database without any preparing because it is coming from the environment from the beginning

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
#>
function New-D365Bacpac {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'ExportTier2')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier1', Position = 0)]
        [switch]$ExportModeTier1,

        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', Position = 0)]
        [switch]$ExportModeTier2,

        [Parameter(Mandatory = $false, Position = 1 )]
        [string]$DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string]$DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, Position = 5 )]
        [string]$BackupDirectory = "C:\Temp\d365fo.tools\SqlBackups",

        [Parameter(Mandatory = $false, Position = 6 )]
        [string]$NewDatabaseName = "$Script:DatabaseName`_export",

        [Parameter(Mandatory = $false, Position = 7 )]
        [Alias('File')]
        [string]$BacpacFile = "C:\Temp\d365fo.tools\$DatabaseName.bacpac",

        [Parameter(Mandatory = $false, Position = 8 )]
        [string]$CustomSqlFile,

        [switch]$ExportOnly

    )
    
    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    $ExecuteCustomSQL = $false

    if ($PSBoundParameters.ContainsKey("CustomSqlFile")) {
        if ((Test-Path $CustomSqlFile -PathType Leaf) -eq $false) {
            Write-PSFMessage -Level Host -Message "You used the <c='em'>CustomSqlFile</c> parameter, but the cmdlet is unable to locate the file on the machine. Please make sure that the path exists and you have enough permissions."
            Stop-PSFFunction -Message "The CustomSqlFile path was not located."
            return
        }
        else {
            $ExecuteCustomSQL = $true
        }
    }

    if($BacpacFile -notlike "*.bacpac") {
        Write-PSFMessage -Level Host -Message "The path for the bacpac file must contain the <c='em'>.bacpac</c> extension. Please update the <c='em'>BacpacFile</c> parameter and try again."
        Stop-PSFFunction -Message "The BacpacFile path was not correct."
        return
    }

    if ((Test-path $BackupDirectory -PathType Container) -eq $false) { $null = new-item -ItemType directory -path $BackupDirectory }
    if ((Test-path (Split-Path $BacpacFile -Parent) -PathType Container) -eq $false) { 
        $null = new-item -ItemType directory -path (Split-Path $BacpacFile -Parent) 
    }
    

    $Properties = @("VerifyFullTextDocumentTypesSupported=false",
        "Storage=File"
    )

    $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd        
    }

    $ExportParams = @{
        Action     = "export"
        FilePath   = $BacpacFile
        Properties = $Properties
    }

    if ($ExportOnly.IsPresent) {
        
        Write-PSFMessage -Level Verbose -Message "Invoking the export of the bacpac file only."

        Write-PSFMessage -Level Verbose -Message "Invoking the sqlpackage with parameters" -Target $BaseParams
        $res = Invoke-SqlPackage @BaseParams @ExportParams

        if (!$res) {return}

        [PSCustomObject]@{
            File     = $BacpacFile
            Filename = (Split-Path $BacpacFile -Leaf)
        }
    }
    else {
        if ($ExportModeTier1) {
            $Params = @{
                BackupDirectory   = $BackupDirectory
                NewDatabaseName   = $NewDatabaseName
                TrustedConnection = $UseTrustedConnection
            }
            
            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - SQL backup & restore process"
            $res = Invoke-SqlBackupRestore @BaseParams @Params

            if(!$res) {return}

            $Params = Get-DeepClone $BaseParams
            $Params.DatabaseName = $NewDatabaseName

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Clear SQL objects"
            $res = Invoke-ClearSqlSpecificObjects @Params -TrustedConnection $UseTrustedConnection

            if (Test-PSFFunctionInterrupt -or (-not $res)) { return }

            if ($ExecuteCustomSQL) {
                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Execution of custom SQL script"
                $res = Invoke-CustomSqlScript @Params -FilePath $CustomSqlFile -TrustedConnection $UseTrustedConnection

                if(!$res) {return}
            }

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Export of the bacpac file from SQL"
            $res = Invoke-SqlPackage @Params @ExportParams -TrustedConnection $UseTrustedConnection
            
            if (!$res) {return}

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Remove database from SQL"
            Remove-D365Database @Params -TrustedConnection $UseTrustedConnection

            [PSCustomObject]@{
                File     = $BacpacFile
                Filename = (Split-Path $BacpacFile -Leaf)
            }
        }
        else {
            $Params = @{
                NewDatabaseName = $NewDatabaseName
            }

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Creation of Azure DB copy"
            $res = Invoke-AzureBackupRestore @BaseParams @Params
            
            if (Test-PSFFunctionInterrupt -or (-not $res)) { return }
            
            $Params = Get-DeepClone $BaseParams
            $Params.DatabaseName = $NewDatabaseName
            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Clear Azure DB objects"
            $res = Invoke-ClearAzureSpecificObjects @Params

            if (Test-PSFFunctionInterrupt -or (-not $res)) { return }

            if ($ExecuteCustomSQL) {
                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Execution of custom SQL script"
                $res = Invoke-CustomSqlScript @Params -FilePath $CustomSqlFile -TrustedConnection $false

                if(!$res) {return}
            }
            
            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Export of the bacpac file from Azure DB"
            $res = Invoke-SqlPackage @Params @ExportParams -TrustedConnection $false

            if (!$res) {return}

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Remove database from Azure DB"
            Remove-D365Database @Params

            [PSCustomObject]@{
                File     = $BacpacFile
                Filename = (Split-Path $BacpacFile -Leaf)
            }
        }
    }

    Invoke-TimeSignal -End
}