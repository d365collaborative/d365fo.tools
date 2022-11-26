
<#
    .SYNOPSIS
        Invoke the sqlpackage executable
        
    .DESCRIPTION
        Invoke the sqlpackage executable and pass the necessary parameters to it
        
    .PARAMETER Action
        Can either be import or export
        
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
        
    .PARAMETER TrustedConnection
        Should the sqlpackage work with TrustedConnection or not
        
    .PARAMETER FilePath
        Path to the file, used for either import or export
        
    .PARAMETER Properties
        Array of all the properties that needs to be parsed to the sqlpackage.exe
        
    .PARAMETER DiagnosticFile
        Path to where you want the SqlPackage to output a diagnostics file to assist you in troubleshooting
        
    .PARAMETER ModelFile
        Path to the model file that you want the SqlPackage.exe to use instead the one being part of the bacpac file
        
        This is used to override SQL Server options, like collation and etc
        
    .PARAMETER MaxParallelism
        Sets SqlPackage.exe's degree of parallelism for concurrent operations running against a database
        
        The default value is 8
        
    .PARAMETER PublishFile
        Path to the profile / publish xml file that contains all the advanced configuration instructions for the SqlPackage
        
        Used only in combination with the Publish action
        
    .PARAMETER LogPath
        The path where the log file(s) will be saved
        
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
        PS C:\> $BaseParams = @{
        DatabaseServer = $DatabaseServer
        DatabaseName   = $DatabaseName
        SqlUser        = $SqlUser
        SqlPwd         = $SqlPwd
        }
        
        PS C:\> $ImportParams = @{
        Action   = "import"
        FilePath = $BacpacFile
        }
        
        PS C:\> Invoke-SqlPackage @BaseParams @ImportParams
        
        This will start the sqlpackage.exe file and pass all the needed parameters.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
#>
function Invoke-SqlPackage {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [ValidateSet("Import", "Export", "Publish")]
        [string] $Action,
        
        [string] $DatabaseServer,
        
        [string] $DatabaseName,
        
        [string] $SqlUser,
        
        [string] $SqlPwd,
        
        [string] $TrustedConnection,
        
        [string] $FilePath,
        
        [string[]] $Properties,

        [string] $DiagnosticFile,

        [string] $ModelFile,

        [int] $MaxParallelism,

        [Alias("ProfileFile")]
        [string] $PublishFile,

        [string] $LogPath,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $EnableException
    )
              
    $executable = $Script:SqlPackagePath

    Invoke-TimeSignal -Start

    if (!(Test-PathExists -Path $executable -Type Leaf)) { return }

    Write-PSFMessage -Level Verbose -Message "Starting to prepare the parameters for sqlpackage.exe"

    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    if ($Action -eq "export") {
        $null = $Params.Add("/Action:export")
        $null = $Params.Add("/SourceServerName:$DatabaseServer")
        $null = $Params.Add("/SourceDatabaseName:$DatabaseName")
        $null = $Params.Add("/SourceTrustServerCertificate:True")
        $null = $Params.Add("/TargetFile:`"$FilePath`"")
        $null = $Params.Add("/Properties:CommandTimeout=0")
    
        if (!$UseTrustedConnection) {
            $null = $Params.Add("/SourceUser:$SqlUser")
            $null = $Params.Add("/SourcePassword:$SqlPwd")
        }
        
        Remove-Item -Path $FilePath -ErrorAction SilentlyContinue -Force
    }
    elseif ($Action -eq "import") {
        $null = $Params.Add("/Action:import")
        $null = $Params.Add("/TargetServerName:$DatabaseServer")
        $null = $Params.Add("/TargetDatabaseName:$DatabaseName")
        $null = $Params.Add("/TargetTrustServerCertificate:True")
        $null = $Params.Add("/SourceFile:`"$FilePath`"")
        $null = $Params.Add("/Properties:CommandTimeout=0")
        
        if (!$UseTrustedConnection) {
            $null = $Params.Add("/TargetUser:$SqlUser")
            $null = $Params.Add("/TargetPassword:$SqlPwd")
        }
    }
    elseif ($Action -eq "publish") {
        $Params.Add("/Action:Publish") > $null
        $Params.Add("/TargetServerName:$DatabaseServer") > $null
        $Params.Add("/TargetDatabaseName:$DatabaseName") > $null
        $Params.Add("/TargetTrustServerCertificate:True") > $null
        $Params.Add("/SourceFile:`"$FilePath`"") > $null
        $Params.Add("/Properties:CommandTimeout=0") > $null
        
        if (-not $UseTrustedConnection) {
            $Params.Add("/TargetUser:$SqlUser") > $null
            $Params.Add("/TargetPassword:$SqlPwd") > $null
        }

        if ($PublishFile) {
            $Params.Add("/Profile:`"$PublishFile`"") > $null
        }
    }

    foreach ($item in $Properties) {
        $Params.Add("/Properties:$item") > $null
    }

    if ($DiagnosticFile) {
        $Params.Add("/Diagnostics:true") > $null
        $Params.Add("/DiagnosticsFile:`"$DiagnosticFile`"") > $null
    }
    
    if ($ModelFile) {
        $Params.Add("/ModelFilePath:`"$ModelFile`"") > $null
    }

    if ($MaxParallelism) {
        $Params.Add("/MaxParallelism:$MaxParallelism") > $null
    }

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
    
    if (Test-PSFFunctionInterrupt) {
        Write-PSFMessage -Level Critical -Message "The SqlPackage.exe exited with an error."
        Stop-PSFFunction -Message "Stopping because of errors." -StepsUpward 1
        return
    }

    Invoke-TimeSignal -End
}