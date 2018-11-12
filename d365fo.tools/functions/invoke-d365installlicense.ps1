
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
        
    .EXAMPLE
        PS C:\> Invoke-D365InstallLicense -Path c:\temp\d365fo.tools\license.txt
        
        This will use the default paths and start the Microsoft.Dynamics.AX.Deployment.Setup.exe with the needed parameters to import / install the license file.
        
    .NOTES
        Tags: License, Install, ISV, 3. Party, Servicing
        
        Author: Mötz Jensen (@splaxi)
        
#>
function Invoke-D365InstallLicense {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Parameter(Mandatory = $false, Position = 6 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, Position = 7 )]
        [string] $BinDir = "$Script:BinDir"
    )

    $executable = Join-Path $BinDir "bin\Microsoft.Dynamics.AX.Deployment.Setup.exe"

    if (-not (Test-PathExists -Path $MetaDataDir,$BinDir -Type Container)) {return}
    if (-not (Test-PathExists -Path $Path,$executable -Type Leaf)) {return}

    $params = @("-isemulated", "true",
        "-sqluser", "$SqlUser",
        "-sqlpwd", "$SqlPwd",
        "-sqlserver", "$DatabaseServer",
        "-sqldatabase", "$DatabaseName",
        "-metadatadir", "$MetaDataDir",
        "-bindir", "$BinDir",
        "-setupmode", "importlicensefile",
        "-licensefilename", "`"$Path`"")

    Start-Process -FilePath $executable -ArgumentList ($params -join " ") -NoNewWindow -Wait
}