<#
.SYNOPSIS
Switches the 2 databases. The Old wil be renamed _original

.DESCRIPTION
Switches the 2 databases. The Old wil be renamed _original

.PARAMETER DatabaseServer
The databaseserver where the switch should occur

.PARAMETER DatabaseName
The name of the database to be switched

.PARAMETER SqlUser
User with access to alter both databases

.PARAMETER SqlPwd
Password for the SqlUser

.PARAMETER NewDatabaseName
The database that takes the DatabaseName's place

.EXAMPLE
Switch-D365ActiveDatabase -NewDatabaseName "GoldenConfig"

.NOTES
General notes
#>
function Switch-D365ActiveDatabase {
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$DatabaseServer = $Script:DatabaseServer,
        [Parameter(Mandatory = $false, Position = 2)]
        [string]$DatabaseName = $Script:DatabaseName,
        [Parameter(Mandatory = $false, Position = 3)]
        [string]$SqlUser = $Script:DatabaseUserName,
        [Parameter(Mandatory = $false, Position = 4)]
        [string]$SqlPwd = $Script:DatabaseUserPassword,
        [Parameter(Mandatory = $true, Position = 5)]
        [string]$NewDatabaseName
    )

    Write-Host "Make sure to stop all :"
    write-Host "World wide web publishing service (on all AOS computers)"
    Write-Host "Microsoft Dynamics 365 for Finance and Operations Batch Management Service (on non-private AOS computers only)"
    Write-Host "Management Reporter 2012 Process Service (on business intelligence [BI] computers only)"
    


    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SQLCommand $DatabaseServer "Master" $SqlUser $SqlPwd

    $commandText = (Get-Content "$script:PSModuleRoot\internal\sql\switch-database.sql") -join [Environment]::NewLine
   
    $sqlCommand.CommandText = $commandText

    write-verbose $sqlCommand.CommandText
    Write-Verbose "Rename $DatabaseName to $DatabaseName`_original"
    Write-Verbose "Rename $NewDatabaseName to $DatabaseName"
    

    $var = New-Object System.Data.SqlClient.SqlParameter("@OrigName", $DatabaseName)
    $null = $sqlCommand.Parameters.Add($var)
    $var = New-Object System.Data.SqlClient.SqlParameter("@NewName", $NewDatabaseName)
    $null = $sqlCommand.Parameters.Add($var)

    $sqlCommand.Connection.Open()

    $null = $sqlCommand.ExecuteNonQuery()
    $sqlCommand.Dispose()

    "$DatabaseName`_original"

}