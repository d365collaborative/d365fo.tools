<#
.SYNOPSIS
Removes a Database

.DESCRIPTION
Removes a Database

.PARAMETER DatabaseServer
The server the database is on 

.PARAMETER DatabaseName
Name of the database to remove

.PARAMETER SqlUser
The User with rights for dropping the database

.PARAMETER SqlPwd
Password for the SqlUser

.EXAMPLE
Remove-Database -DatabaseName "database_original"

.NOTES
General notes
#>
function Remove-Database
{
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,
        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,
        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,
        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword

    )

    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SQLCommand $DatabaseServer "master" $SqlUser $SqlPwd

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\remove-database.sql") -join [Environment]::NewLine
   
    $commandText = $commandText.Replace('@Database',$DatabaseName)

    $sqlCommand.CommandText = $commandText

    Write-Verbose "Dropping $DatabaseName"

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()

    $sqlCommand.Dispose()

}