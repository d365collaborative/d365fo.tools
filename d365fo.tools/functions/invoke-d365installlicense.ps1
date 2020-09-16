
<#
    .SYNOPSIS
        Install a license for a 3. party solution
        
    .DESCRIPTION
        Install a license for a 3. party solution using the builtin "Microsoft.Dynamics.AX.Deployment.Setup.exe" executable
        
    .PARAMETER Path
        Path to the license file
        
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
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
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
        PS C:\> Invoke-D365InstallLicense -Path c:\temp\d365fo.tools\license.txt
        
        This will use the default paths and start the Microsoft.Dynamics.AX.Deployment.Setup.exe with the needed parameters to import / install the license file.
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallLicense -Path c:\temp\d365fo.tools\license.txt -ShowOriginalProgress
        
        This will use the default paths and start the Microsoft.Dynamics.AX.Deployment.Setup.exe with the needed parameters to import / install the license file.
        The output from the installation process will be written to the console / host.
        
    .NOTES
        Tags: License, Install, ISV, 3. Party, Servicing
        
        Author: Mötz Jensen (@splaxi)
        
#>
function Invoke-D365InstallLicense {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [Alias('File')]
        [string] $Path,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [string] $MetaDataDir = "$Script:MetaDataDir",

        [string] $BinDir = "$Script:BinDir",

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\InstallLicense"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    $executable = Join-Path -Path $BinDir -ChildPath "bin\Microsoft.Dynamics.AX.Deployment.Setup.exe"

    if (-not (Test-PathExists -Path $MetaDataDir,$BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $Path,$executable -Type Leaf)) {return}

    Invoke-TimeSignal -Start

    $params = @("-isemulated", "true",
        "-sqluser", "$SqlUser",
        "-sqlpwd", "$SqlPwd",
        "-sqlserver", "$DatabaseServer",
        "-sqldatabase", "$DatabaseName",
        "-metadatadir", "$MetaDataDir",
        "-bindir", "$BinDir",
        "-setupmode", "importlicensefile",
        "-licensefilename", "`"$Path`"")

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

    Invoke-TimeSignal -End
}