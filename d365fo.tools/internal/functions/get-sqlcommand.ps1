
<#
    .SYNOPSIS
        Get a SqlCommand object
        
    .DESCRIPTION
        Get a SqlCommand object initialized with the passed parameters
        
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
        Should the connection use a Trusted Connection or not
        
    .PARAMETER NoPooling
        Should the connection use connection pooling or not
        
    .EXAMPLE
        PS C:\> Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -TrustedConnection $true
        
        This will initialize a new SqlCommand object (.NET type) with localhost as the server name, AxDB as the database and the User123 sql credentials.
        
    .EXAMPLE
        PS C:\> Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123" -TrustedConnection $true -NoPooling
        
        This will initialize a new SqlCommand object (.NET type) with localhost as the server name, AxDB as the database and the User123 sql credentials.
        The connection will not use connection pooling.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-SQLCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName,

        [Parameter(Mandatory = $false)]
        [string] $SqlUser,

        [Parameter(Mandatory = $false)]
        [string] $SqlPwd,

        [Parameter(Mandatory = $false)]
        [boolean] $TrustedConnection,

        [switch] $NoPooling
    )

    Write-PSFMessage -Level Debug -Message "Writing the bound parameters" -Target $PsBoundParameters
    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Params.Add("Server='$DatabaseServer';")
    $null = $Params.Add("Database='$DatabaseName';")
    
    # We have learned that closing a connection is not enough to closing the connection.
    if ($NoPooling) { $null = $Params.Add("Pooling=false;") }

    if ($null -eq $TrustedConnection -or (-not $TrustedConnection)) {
        $null = $Params.Add("User='$SqlUser';")
        $null = $Params.Add("Password='$SqlPwd';")
    }
    else {
        $null = $Params.Add("Integrated Security='SSPI';")
    }

    $null = $Params.Add("Application Name='d365fo.tools'")
    
    Write-PSFMessage -Level Verbose -Message "Building the SQL connection string." -Target ($Params -join ",")
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection

    try {
        $sqlConnection.ConnectionString = ($Params -join "")

        $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
        $sqlCommand.Connection = $sqlConnection
        $sqlCommand.CommandTimeout = 0
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working with the sql server connection objects" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    
    $sqlCommand
}