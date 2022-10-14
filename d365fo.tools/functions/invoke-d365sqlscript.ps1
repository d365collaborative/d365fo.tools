
<#
    .SYNOPSIS
        Execute a SQL Script or a SQL Command
        
    .DESCRIPTION
        Execute a SQL Script or a SQL Command against the D365FO SQL Server database
        
    .PARAMETER FilePath
        Path to the file containing the SQL Script that you want executed
        
    .PARAMETER Command
        SQL command that you want executed
        
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
        Switch to instruct the cmdlet whether the connection should be using Windows Authentication or not
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .PARAMETER NoPooling
        Should the connection use connection pooling or not
        
    .EXAMPLE
        PS C:\> Invoke-D365SqlScript -FilePath "C:\temp\d365fo.tools\DeleteUser.sql"
        
        This will execute the "C:\temp\d365fo.tools\DeleteUser.sql" against the registered SQL Server on the machine.
        
    .EXAMPLE
        PS C:\> Invoke-D365SqlScript -Command "DELETE FROM SALESTABLE WHERE RECID = 123456789"
        
        This will execute "DELETE FROM SALESTABLE WHERE RECID = 123456789" against the registered SQL Server on the machine.
        
    .EXAMPLE
        PS C:\> Invoke-D365SqlScript -Command "DELETE FROM SALESTABLE WHERE RECID = 123456789" -NoPooling
        
        This will execute "DELETE FROM SALESTABLE WHERE RECID = 123456789" against the registered SQL Server on the machine.
        It will not use connection pooling.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
        Author: Caleb Blanchard (@daxcaleb)
#>
Function Invoke-D365SqlScript {
    [Alias("Invoke-D365SqlCmd")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "FilePath" )]
        [string] $FilePath,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = "Command" )]
        [string] $Command,

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [string] $SqlUser = $Script:DatabaseUserName,

        [string] $SqlPwd = $Script:DatabaseUserPassword,
        
        [bool] $TrustedConnection = $false,

        [switch] $EnableException,

        [switch] $NoPooling

    )

    if ($PSCmdlet.ParameterSetName -eq "FilePath") {
        if (-not (Test-PathExists -Path $FilePath -Type Leaf)) { return }
    }

    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $Params = @{}

    #Hack to get all variables for the function, regardless of they were assigned from the caller or with default values.
    #The TrustedConnection is the real deal breaker. If $true user and password are ignored in Get-SqlCommand.
    $MyInvocation.MyCommand.Parameters.Keys | Get-Variable -ErrorAction Ignore | ForEach-Object { $Params.Add($_.Name, $_.Value) };
    
    $null = $Params.Remove('FilePath')
    $null = $Params.Remove('Command')
    $null = $Params.Remove('EnableException')
    
    $Params.TrustedConnection = $UseTrustedConnection

    $sqlCommand = Get-SqlCommand @Params

    if ($PSCmdlet.ParameterSetName -eq "FilePath") {
        $sqlCommand.CommandText = (Get-Content "$FilePath") -join [Environment]::NewLine
    }
    if ($PSCmdlet.ParameterSetName -eq "Command") {
        $sqlCommand.CommandText = $Command
    }

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        $messageString = "Something went wrong while <c='em'>executing custom sql script</c> against the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }

    Invoke-TimeSignal -End
}