
<#
    .SYNOPSIS
        Import dacpac file to a database
        
    .DESCRIPTION
        Import a dacpac file into a database, using the publish feature of SqlPackage.exe
        
        If the database doesn't exists, it will be created
        
        If the database exists, the publish process from the dacpac file will make sure to align the different tables inside the database
        
    .PARAMETER Path
        Path to the dacpac file that you want to import
        
    .PARAMETER ModelFile
        Path to the model file that you want the SqlPackage.exe to use instead the one being part of the dacpac file
        
        This is used to override SQL Server options, like collation and etc
        
        This is also used to support single table import / restore from a dacpac file
        
    .PARAMETER PublishFile
        Path to the publish / profile file that contains extended parameters for the SqlPackage.exe assembly
        
    .PARAMETER DiagnosticFile
        Path to where you want the import to output a diagnostics file to assist you in troubleshooting the import
        
    .PARAMETER MaxParallelism
        Sets SqlPackage.exe's degree of parallelism for concurrent operations running against a database
        
        The default value is 8
        
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
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
        When running without the ShowOriginalProgress parameter, the log files will be the standard output and the error output from the underlying tool executed
        
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
        PS C:\> Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -ModelFile "c:\Temp\dbo.salestable.model.xml"
        
        This will import the dacpac file and use the modified model file while doing so.
        It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
        It will use the "c:\Temp\dbo.salestable.model.xml" as the ModelFile parameter.
        
        This is used to enable single table restore / publish.
        
    .EXAMPLE
        PS C:\> Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -ModelFile "c:\Temp\dbo.salestable.model.xml" -DiagnosticFile "C:\temp\ImportLog.txt" -MaxParallelism 32
        
        This will import the dacpac file and use the modified model file while doing so.
        It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
        It will use the "c:\Temp\dbo.salestable.model.xml" as the ModelFile parameter.
        It will use the "C:\temp\ImportLog.txt" as the DiagnosticFile parameter, where the diagnostic file will be stored.
        
        It will use 32 connections against the database server while importing the bacpac file.
        
        This is used to enable single table restore / publish.
        
    .EXAMPLE
        PS C:\> Import-D365Dacpac -Path "c:\Temp\AxDB.dacpac" -PublishFile "c:\Temp\publish.xml"
        
        This will import the dacpac file and use the Publish file which contains advanced configuration instructions for SqlPackage.exe.
        It will use the "c:\Temp\AxDB.dacpac" as the Path parameter.
        It will use the "c:\Temp\publish.xml" as the PublishFile parameter, which contains advanced configuration instructions for SqlPackage.exe.
        
        This is used to enable full restore / publish, but to avoid some of the common pitfalls.
        
    .NOTES
        Tags: Database, Dacpac, Tier1, Tier2, Golden Config, Config, Configuration
        
        Author: Mötz Jensen (@Splaxi)
#>
function Import-D365Dacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("Dacpac")]
        [Alias("File")]
        [string] $Path,

        [string] $ModelFile,

        [Alias("ProfileFile")]
        [string] $PublishFile,

        [string] $DiagnosticFile,

        [int] $MaxParallelism = 8,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\ImportDacpac"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $EnableException
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) {
        return
    }

    Invoke-TimeSignal -Start
    
    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd
    }

    $ImportParams = @{
        Action         = "Publish"
        FilePath       = $Path
        MaxParallelism = $MaxParallelism
    }

    if ($DiagnosticFile) {
        if (-not (Test-PathExists -Path (Split-Path $DiagnosticFile -Parent) -Type Container -Create)) { return }
        
        $ImportParams.DiagnosticFile = $DiagnosticFile
    }

    if ($ModelFile) {
        if (-not (Test-PathExists -Path $ModelFile -Type Leaf)) { return }

        $ImportParams.ModelFile = $ModelFile
    }

    if ($PublishFile) {
        if (-not (Test-PathExists -Path $PublishFile -Type Leaf)) { return }

        $ImportParams.PublishFile = $PublishFile
    }

    if (Test-PSFFunctionInterrupt) { return }
    
    Write-PSFMessage -Level Verbose "Start publishing the dacpac"
    Invoke-SqlPackage @BaseParams @ImportParams -TrustedConnection $UseTrustedConnection -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

    if ($OutputCommandOnly) { return }

    if (Test-PSFFunctionInterrupt) { return }
    
    Write-PSFMessage -Level Verbose "Importing completed"

    Invoke-TimeSignal -End
}