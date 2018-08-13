function Get-SQLCommand ($DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd, $UseTrustedConnection) {
    Write-PSFMessage -Level Debug -Message "Trusted connection" -Target $UseTrustedConnection
    Write-PSFMessage -Level Debug -Message "Writing the bound parameters" -Target $PsBoundParameters
    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Params.Add("Server=$DatabaseServer;")
    $null = $Params.Add("Database=$DatabaseName;")

    if ($null -eq $UseTrustedConnection -or !$UseTrustedConnection) {
        $null = $Params.Add("User=$SqlUser;")
        $null = $Params.Add("Password=$SqlPwd;")
    }
    else {
        $null = $Params.Add("Integrated Security=SSPI;")        
    }

    $null = $Params.Add("Application Name=d365fo.tools")
    
    Write-PSFMessage -Level Verbose -Message "Building the SQL connection string." -Target $Params
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = ($Params -join "")

    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection

    $sqlCommand
}