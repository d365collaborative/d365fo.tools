<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DatabaseServer
Parameter description

.PARAMETER DatabaseName
Parameter description

.PARAMETER SqlUser
Parameter description

.PARAMETER SqlPwd
Parameter description

.PARAMETER TrustedConnection
Parameter description

.PARAMETER FilePath
Parameter description

.EXAMPLE
PS C:\> Invoke-CustomSqlScript

This will work.

.NOTES
General notes
#>

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
        [boolean] $TrustedConnection,

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
