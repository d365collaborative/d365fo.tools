<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Update-User {
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
        [string]$Email

    )

    [System.Data.SqlClient.SqlCommand]$sqlCommand = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd


    $sqlCommand.Connection.Open()

    $sqlCommand.CommandText = get-content "$script:PSModuleRoot\internal\sql\get-user.sql"
    $null = $sqlCommand.Parameters.Add("@Email", $Email)



    [System.Data.SqlClient.SqlCommand]$sqlCommand_Update = Get-SqlCommand $DatabaseServer $DatabaseName $SqlUser $SqlPwd

    $sqlCommand_Update.Connection.Open()

    $sqlCommand_Update.CommandText = get-content  "$script:PSModuleRoot\internal\sql\update-user.sql"


    $reader = $sqlCommand.ExecuteReader()

    while ($reader.Read() -eq $true) {
        $userId = $reader.GetString(0)
        $networkAlias = $reader.GetString(1)
        

        $userAuth = Get-UserAuthenticationDetail $networkAlias

        $null = $sqlCommand_Update.Parameters.Add("@id",$userId)
        $null = $sqlCommand_Update.Parameters.Add("@networkDomain",$userAuth["NetworkDomain"])
        $null = $sqlCommand_Update.Parameters.Add("@sid",$userAuth["SID"])
        $null = $sqlCommand_Update.Parameters.Add("@identityProvider",$userAuth["IdentityProvider"])

        write-verbose "Updating user $userId"
        
        $null = $sqlCommand_Update.ExecuteNonQuery()

        $sqlCommand_Update.Parameters.Clear()


    }
    $sqlCommand_Update.Dispose()
    $sqlCommand.Dispose()
    
}