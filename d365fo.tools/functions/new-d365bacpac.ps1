
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
        The password for the SQL Server user
        
    .PARAMETER BackupDirectory
        The path where to store the temporary backup file when the script needs to handle that
        
    .PARAMETER NewDatabaseName
        The name for the database the script is going to create when doing the restore process
        
    .PARAMETER BacpacFile
        The path where you want the cmdlet to store the bacpac file that will be generated
        
    .PARAMETER CustomSqlFile
        The path to a custom sql server script file that you want executed against the database before it is exported
        
    .PARAMETER DiagnosticFile
        Path to where you want the export to output a diagnostics file to assist you in troubleshooting the export
        
    .PARAMETER ExportOnly
        Switch to instruct the cmdlet to either just create a dump bacpac file or run the prepping process first
        
    .PARAMETER MaxParallelism
        Sets SqlPackage.exe's degree of parallelism for concurrent operations running against a database. The default value is 8.
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallSqlPackage
        
        You should always install the latest version of the SqlPackage.exe, which is used by New-D365Bacpac.
        
        This will fetch the latest .Net Core Version of SqlPackage.exe and install it at "C:\temp\d365fo.tools\SqlPackage".
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac"
        
        Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
        Will run the prepping process against the restored database.
        Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
        Will delete the restored database.
        It will use trusted connection (Windows authentication) while working against the SQL Server.
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier2 -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac
        
        Will create a copy the db database on the dbserver1 in Azure.
        Will run the prepping process against the copy database.
        Will export a bacpac file.
        Will delete the copy database.
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac"
        
        Normally used for a Tier-2 export and preparation for Tier-1 import
        
        Will create a copy of the registered D365 database on the registered D365 Azure SQL DB instance.
        Will run the prepping process against the copy database.
        Will export a bacpac file.
        Will delete the copy database.
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier2 -SqlUser User123 -SqlPwd "Password123" -NewDatabaseName Testing1 -BacpacFile C:\Temp\Bacpac\Testing1.bacpac -ExportOnly
        
        Will export a bacpac file.
        The bacpac should be able to restore back into the database without any preparing because it is coming from the environment from the beginning
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac" -DiagnosticFile "C:\temp\ExportLog.txt"
        
        Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
        Will run the prepping process against the restored database.
        Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
        Will delete the restored database.
        It will use trusted connection (Windows authentication) while working against the SQL Server.
        
        It will output a diagnostic file to "C:\temp\ExportLog.txt".
        
    .EXAMPLE
        PS C:\> New-D365Bacpac -ExportModeTier1 -BackupDirectory c:\Temp\backup\ -NewDatabaseName Testing1 -BacpacFile "C:\Temp\Bacpac\Testing1.bacpac" -MaxParallelism 32
        
        Will backup the "AXDB" database and restore is as "Testing1" again the localhost SQL Server.
        Will run the prepping process against the restored database.
        Will export a bacpac file to "C:\Temp\Bacpac\Testing1.bacpac".
        Will delete the restored database.
        It will use trusted connection (Windows authentication) while working against the SQL Server.
        
        It will use 32 connections against the database server while generating the bacpac file.
        
    .NOTES
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-D365Bacpac {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseProcessBlockForPipelineCommand", "")]
    [CmdletBinding(DefaultParameterSetName = 'ExportTier2')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier1', Position = 0)]
        [switch] $ExportModeTier1,

        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', Position = 0)]
        [switch] $ExportModeTier2,

        [Parameter(Position = 1 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Position = 2 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 3 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', ValueFromPipelineByPropertyName = $true, Position = 3)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'ExportTier2', ValueFromPipelineByPropertyName = $true, Position = 4)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(ParameterSetName = 'ExportTier1', Position = 5 )]
        [string] $BackupDirectory = "C:\Temp\d365fo.tools\SqlBackups",

        [Parameter(Position = 6 )]
        [string] $NewDatabaseName = "$Script:DatabaseName`_export",

        [Parameter(Position = 7 )]
        [Alias('File')]
        [string] $BacpacFile = "C:\Temp\d365fo.tools\$DatabaseName.bacpac",

        [Parameter(Position = 8 )]
        [string] $CustomSqlFile,

        [string] $DiagnosticFile,

        [switch] $ExportOnly,

        [int] $MaxParallelism = 8,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $EnableException
    )
    
    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    
    if ($PSBoundParameters.ContainsKey("CustomSqlFile")) {
        if (-not (Test-PathExists -Path $CustomSqlFile -Type Leaf)) { return }
        $ExecuteCustomSQL = $true
    }

    if ($BacpacFile -notlike "*.bacpac") {
        Write-PSFMessage -Level Host -Message "The path for the bacpac file must contain the <c='em'>.bacpac</c> extension. Please update the <c='em'>BacpacFile</c> parameter and try again."
        Stop-PSFFunction -Message "The BacpacFile path was not correct."
        return
    }

    if ($PSBoundParameters.ContainsKey("BackupDirectory") -or $ExportModeTier1) {
        if (-not (Test-PathExists -Path $BackupDirectory -Type Container -Create)) { return }
    }
    
    if (-not (Test-PathExists -Path (Split-Path $BacpacFile -Parent) -Type Container -Create)) { return }

    # Work around to make sure to keep Storage when using the non-core version of the SqlPackage
    $executable = $Script:SqlPackagePath
    $classicPattern = "C:\Program Files*\Microsoft SQL Server\1*0\DAC\bin\SqlPackage.exe"

    [System.Collections.ArrayList] $Properties = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Properties.Add("VerifyFullTextDocumentTypesSupported=false")

    if($executable -like $classicPattern) {
        Write-PSFMessage -Level Verbose -Message "Looks like we are running against the non-core version of SqlPackage.exe. Then we need to support the Storage=File property."
        $null = $Properties.Add("Storage=File")
    }

    $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd
    }

    $ExportParams = @{
        Action     = "export"
        FilePath   = $BacpacFile
        Properties = $Properties.ToArray()
        MaxParallelism = $MaxParallelism
    }

    if (-not [system.string]::IsNullOrEmpty($DiagnosticFile)) {
        if (-not (Test-PathExists -Path (Split-Path $DiagnosticFile -Parent) -Type Container -Create)) { return }
        $ExportParams.DiagnosticFile = $DiagnosticFile
    }

    if ($ExportOnly) {
        
        Write-PSFMessage -Level Verbose -Message "Invoking the export of the bacpac file only."

        Write-PSFMessage -Level Verbose -Message "Invoking the sqlpackage with parameters" -Target $BaseParams
        Invoke-SqlPackage @BaseParams @ExportParams -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

        if ($OutputCommandOnly) { return }

        if (Test-PSFFunctionInterrupt) { return }

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
            
            if (-not $OutputCommandOnly) {
                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - SQL backup & restore process"
                $res = Invoke-SqlBackupRestore @BaseParams @Params

                if ((Test-PSFFunctionInterrupt) -or (-not $res)) { return }

                $Params = Get-DeepClone $BaseParams
                $Params.DatabaseName = $NewDatabaseName

                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Clear SQL objects"
                $res = Invoke-ClearSqlSpecificObjects @Params

                if ((Test-PSFFunctionInterrupt) -or (-not $res)) { return }

                if ($ExecuteCustomSQL) {
                    Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Execution of custom SQL script"
                    $res = Invoke-D365SqlScript @Params -FilePath $CustomSqlFile

                    if (Test-PSFFunctionInterrupt) { return }
                }
            }
            else {
                $Params = Get-DeepClone $BaseParams
                $Params.DatabaseName = $NewDatabaseName
            }

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Export of the bacpac file from SQL"
            Invoke-SqlPackage @Params @ExportParams -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
            
            if ($OutputCommandOnly) { return }

            if (Test-PSFFunctionInterrupt) { return }

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 1 - Remove database from SQL"
            Remove-D365Database @Params

            [PSCustomObject]@{
                File     = $BacpacFile
                Filename = (Split-Path $BacpacFile -Leaf)
            }
        }
        else {
            $Params = @{
                NewDatabaseName = $NewDatabaseName
            }

            if (-not $OutputCommandOnly) {
                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Creation of Azure DB copy"
                $res = Invoke-AzureBackupRestore @BaseParams @Params
            
                if ((Test-PSFFunctionInterrupt) -or (-not $res)) { return }
            
                $Params = Get-DeepClone $BaseParams
                $Params.DatabaseName = $NewDatabaseName
                Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Clear Azure DB objects"
                $res = Invoke-ClearAzureSpecificObjects @Params

                if ((Test-PSFFunctionInterrupt) -or (-not $res)) { return }

                if ($ExecuteCustomSQL) {
                    Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Execution of custom SQL script"
                    $res = Invoke-D365SqlScript @Params -FilePath $CustomSqlFile -TrustedConnection $false

                    if (!$res) { return }
                }
            }

            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Export of the bacpac file from Azure DB"
            Invoke-SqlPackage @Params @ExportParams -TrustedConnection $false -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

            if ($OutputCommandOnly) { return }

            if (Test-PSFFunctionInterrupt) { return }
            
            Write-PSFMessage -Level Verbose -Message "Invoking the Tier 2 - Remove database from Azure DB"
            Remove-D365Database @Params

            if (Test-PSFFunctionInterrupt) {
                $messageString = "The bacpac file was created correctly, but there was an error while <c='em'>removing</c> the cloned database."
                Write-PSFMessage -Level Host -Message $messageString
            }

            [PSCustomObject]@{
                File     = $BacpacFile
                Filename = (Split-Path $BacpacFile -Leaf)
            }
        }
    }

    Invoke-TimeSignal -End
}