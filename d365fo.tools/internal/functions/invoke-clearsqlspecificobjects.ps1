Function Invoke-ClearSqlSpecificObjects {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns')]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
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
    
    $sqlCommand = Get-SQLCommand @PsBoundParameters

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\clear-sqlbacpacdatabase.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    try {
        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()    
    }
}
