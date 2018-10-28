
<#
    .SYNOPSIS
        Execute a SQL Script
        
    .DESCRIPTION
        Execute a SQL Script against the D365FO SQL Server database
        
    .PARAMETER FilePath
        Path to the file containing the SQL Script that you want executed
        
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
        
    .PARAMETER TrustedConnection
        Switch to instruct the cmdlet whether the connection should be using Windows Authentication or not
        
    .EXAMPLE
        PS C:\> Invoke-D365SqlScript -FilePath "C:\temp\d365fo.tools\DeleteUser.sql"
        
        This will execute the "C:\temp\d365fo.tools\DeleteUser.sql" against the registered SQL Server on the machine.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
#>
Function Invoke-D365SqlScript {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1 )]
        [string] $FilePath,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $DatabaseServer = $Script:DatabaseServer,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $DatabaseName = $Script:DatabaseName,

        [Parameter(Mandatory = $false, Position = 4 )]
        [string] $SqlUser = $Script:DatabaseUserName,

        [Parameter(Mandatory = $false, Position = 5 )]
        [string] $SqlPwd = $Script:DatabaseUserPassword,
        
        [Parameter(Mandatory = $false, Position = 6)]
        [bool] $TrustedConnection = $false
    )

    if (-not (Test-PathExists -Path $FilePath -Type Leaf)) { return }

    Invoke-TimeSignal -Start

    $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters

    $Params = @{}

    #Hack to get all variables for the function, regardless of they were assigned from the caller or with default values.
    #The TrustedConnection is the real deal breaker. If $true user and password are ignored in Get-SqlCommand.
    $MyInvocation.MyCommand.Parameters.Keys | Get-Variable -ErrorAction Ignore | ForEach-Object { $Params.Add($_.Name, $_.Value) };
    
    $Params.Remove('FilePath')
    $Params.TrustedConnection = $UseTrustedConnection

    $sqlCommand = Get-SqlCommand @Params

    $sqlCommand.CommandText = (Get-Content "$FilePath") -join [Environment]::NewLine

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
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