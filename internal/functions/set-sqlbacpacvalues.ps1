function Set-SqlBacpacValues {
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
        [bool] $TrustedConnection
    )
    
    $sqlCommand = Get-SqlCommand -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd -TrustedConnection $TrustedConnection

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\set-bacpacvaluessql.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@DATABASENAME', $DatabaseName)

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level Verbose "Execution sql statement against database" -Target $sqlCommand.CommandText
        $sqlCommand.Connection.Open()
        $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        Write-PSFMessage -Level Critical -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
}