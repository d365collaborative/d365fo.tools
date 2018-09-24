Function Invoke-CustomSqlScript {
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
        [bool] $TrustedConnection,

        [Parameter(Mandatory = $false)]
        [string] $FilePath
    )

    Invoke-TimeSignal -Start

    $Params = Get-DeepClone $PsBoundParameters
    $Params.Remove('FilePath')
    $sqlCommand = Get-SQLCommand @Params

    $commandText = (Get-Content "$FilePath") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText
    try {
        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()
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

    Invoke-TimeSignal -End
}
