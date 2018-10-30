
<#
    .SYNOPSIS
        Test to see if a given user ID exists
        
    .DESCRIPTION
        Test to see if a given user ID exists in the Dynamics 365 for Finance & Operations instance
        
    .PARAMETER SqlCommand
        The SQL Command object that should be used when testing the user ID
        
    .PARAMETER Id
        Id of the user that you want to test exists or not
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> Test-AadUserIdInD365FO -SqlCommand $SqlCommand -Id "TestUser"
        
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        It will query the the database for any user with the Id "TestUser".
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>

function Test-AadUserIdInD365FO {

    param (
        [System.Data.SqlClient.SqlCommand] $SqlCommand,
        [string] $Id
    )

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\test-aaduseridind365fo.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Id", $Id)

    Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

    $NumFound = $sqlCommand.ExecuteScalar()

    Write-PSFMessage -Level Verbose -Message  "Number of user rows found in database $NumFound" -Target $NumFound
    $SqlCommand.Parameters.Clear()

    $NumFound -ne 0
}