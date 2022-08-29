
<#
    .SYNOPSIS
        Function for renaming computer.
        Renames Computer and changes the SSRS Configration
        
    .DESCRIPTION
        When doing development on-prem, there is as need for changing the Computername.
        Function both changes Computername and SSRS Configuration
        
    .PARAMETER NewName
        The new name for the computer
        
    .PARAMETER SSRSReportDatabase
        Name of the SSRS reporting database
        
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
        PS C:\> Rename-D365ComputerName -NewName "Demo-8.1" -SSRSReportDatabase "ReportServer"
        
        This will rename the local machine to the "Demo-8.1" as the new Windows machine name.
        It will update the registration inside the SQL Server Reporting Services configuration to handle the new name of the machine.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Rename-D365ComputerName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $NewName,

        [string] $SSRSReportDatabase = "DynamicsAxReportServer",

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,

        [Alias('LogDir')]
        [string] $LogPath = $(Join-Path -Path $Script:DefaultTempPath -ChildPath "Logs\RsConfig"),

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly,

        [switch] $EnableException
    )

    Write-PSFMessage -Level Verbose -Message "Testing for elevated runtime"
    
    if (!$script:IsAdminRuntime) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    $executable = "$Script:SSRSTools\rsconfig.exe"
    $SSRSInstance = "SSRS"

    if (-not (Test-PathExists -Path $executable -Type Leaf)) {
        $executable = "$Script:SQLTools\rsconfig.exe" # fall back to pre 10.0.24
        $SSRSInstance = ""  # no instance name needed for old VMs

        if (-not (Test-PathExists -Path $executable -Type Leaf)) { return }
    }

    if (Test-PSFFunctionInterrupt) { return }

    Write-PSFMessage -Level Verbose -Message "Renaming computer to $NewName"

    Rename-Computer -NewName $NewName -Force

    Write-PSFMessage -Level Verbose -Message "Renaming local server name inside SQL Server to $NewName"

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
    
    $Params = @{DatabaseServer = $DatabaseServer; DatabaseName = $DatabaseName;
        SqlUser = $SqlUser; SqlPwd = $SqlPwd; TrustedConnection = $UseTrustedConnection;
    }

    $oldComputerName = $env:COMPUTERNAME

    $sqlCommand = Get-SQLCommand @Params

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\rename-computer.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@OldComputerName', $oldComputerName)
    $commandText = $commandText.Replace('@NewComputerName', $NewName)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        $messageString = "Something went wrong while working against the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }

    $sqlCommand = Get-SQLCommand @Params

    Write-PSFMessage -Level Verbose -Message "Setting SSRS Reporting server database server to localhost"

    $params = New-Object System.Collections.Generic.List[string]
    $params.Add("-s")
    $params.Add("localhost")
    $params.Add("-a")
    $params.Add("Windows")
    $params.Add("-c")
    $params.Add("-d")
    $params.Add("`"$SSRSReportDatabase`"")

    if ($SSRSInstance) {
        $params.Add("-i")
        $params.Add("`"$SSRSInstance`"")
    }

    Invoke-Process -Executable $executable -Params $params.ToArray() -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath

    if (-not $OutputCommandOnly) {
        Write-PSFMessage -Level Host -Message "Computer has been <c='em'>renamed</c>. Please <c='em'>restart the computer</c> to make sure that all changes are being applied correctly."
    }
}