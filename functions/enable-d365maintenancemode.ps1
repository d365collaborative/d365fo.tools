<#
.SYNOPSIS
Sets the environment into maintenance mode

.DESCRIPTION
Sets the Dynamics 365 environment into maintenance mode to enable the user to update the license configuration

.PARAMETER MetaDataDir
The path to the meta data directory for the environment 

Default path is the same as the aos service packageslocaldirectory 

.PARAMETER BinDir
The path to the bin directory for the environment

Default path is the same as the aos service packageslocaldirectory\bin

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
Enable-D365MaintenanceMode

This will execute the Microsoft.Dynamics.AX.Deployment.Setup.exe with the default values 
that was pulled from the environment and put the environment into the operate / running state

.NOTES
The cmdlet wraps the execution of Microsoft.Dynamics.AX.Deployment.Setup.exe and parses the parameters needed

Author: Mötz Jensen (@splaxi)

#>
function Enable-D365MaintenanceMode {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $BinDir = "$Script:BinDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 5 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 6 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword
    )
    
    if(-not ($Script:IsAdminRuntime)) {    
        
        Write-PSFMessage -Level Verbose -Message "Setting Maintenance Mode without using executable (requires local admin)."
        
        Stop-D365Environment -All
        
        $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

        $Params = @{
            DatabaseServer = $DatabaseServer
            DatabaseName   = $DatabaseName
            SqlUser        = $SqlUser
            SqlPwd         = $SqlPwd        
        }

        Invoke-D365SqlScript @Params -FilePath $("$script:PSModuleRoot\internal\sql\enable-maintenancemode.sql") -TrustedConnection $UseTrustedConnection

        Start-D365Environment -All
    }
    else {

        $executable = Join-Path $BinDir "bin\Microsoft.Dynamics.AX.Deployment.Setup.exe"

        if (!(Test-PathExists -Path $MetaDataDir,$BinDir -Type Container)) {return}
        if (!(Test-PathExists -Path $executable -Type Leaf)) {return}

        $params = @("-isemulated", "true", 
            "-sqluser", "$SqlUser", 
            "-sqlpwd", "$SqlPwd",
            "-sqlserver", "$DatabaseServer", 
            "-sqldatabase", "$DatabaseName", 
            "-metadatadir", "$MetaDataDir", 
            "-bindir", "$BinDir",
            "-setupmode", "maintenancemode", 
            "-isinmaintenancemode", "true")

        Start-Process -FilePath $executable -ArgumentList ($params -join " ") -NoNewWindow -Wait
    }
}