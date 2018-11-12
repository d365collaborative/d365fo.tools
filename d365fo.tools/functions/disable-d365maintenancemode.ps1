
<#
    .SYNOPSIS
        Sets the environment back into operating state
        
    .DESCRIPTION
        Sets the Dynamics 365 environment back into operating / running state after been in maintenance mode
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory\bin
        
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
        PS C:\> Disable-D365MaintenanceMode
        
        This will execute the Microsoft.Dynamics.AX.Deployment.Setup.exe with the default values that was pulled from the environment and put the environment into the operate / running state.
        
    .NOTES
        Tags: MaintenanceMode, Maintenance, License, Configuration, Servicing
        
        Author: Mötz Jensen (@splaxi)
        Author: Tommy Skaue (@skaue)
        
        With administrator privileges:
        The cmdlet wraps the execution of Microsoft.Dynamics.AX.Deployment.Setup.exe and parses the parameters needed.
        
        Without administrator privileges:
        Will stop all services, execute a Sql script and start all services.
#>
function Disable-D365MaintenanceMode {
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
    
    if ((Get-Process -Name "devenv" -ErrorAction SilentlyContinue).Count -gt 0) {
        Write-PSFMessage -Level Host -Message "It seems that you have a <c='em'>Visual Studio</c> running. Please <c='em'>exit</c> Visual Studio and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of running Visual Studio."
        return
    }

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

        Invoke-D365SqlScript @Params -FilePath $("$script:ModuleRoot\internal\sql\disable-maintenancemode.sql") -TrustedConnection $UseTrustedConnection

        Start-D365Environment -All
    }
    else {

        $executable = Join-Path $BinDir "bin\Microsoft.Dynamics.AX.Deployment.Setup.exe"

        if (-not (Test-PathExists -Path $MetaDataDir,$BinDir -Type Container)) { return }
        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }

        $params = @("-isemulated", "true",
            "-sqluser", "$SqlUser",
            "-sqlpwd", "$SqlPwd",
            "-sqlserver", "$DatabaseServer",
            "-sqldatabase", "$DatabaseName",
            "-metadatadir", "$MetaDataDir",
            "-bindir", "$BinDir",
            "-setupmode", "maintenancemode",
            "-isinmaintenancemode", "false")

        Stop-D365Environment -All

        Start-Process -FilePath $executable -ArgumentList ($params -join " ") -NoNewWindow -Wait

        Start-D365Environment -All
    }
}