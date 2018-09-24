function New-D365FOUser ($SqlCommand, $SignInName, $Name, $Id, $SID, $StartUpCompany, $IdentityProvider, $NetworkDomain, $ObjectId) {

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\Add-AadUserIntoD365FO.sql") -join [Environment]::NewLine
   
    $sqlCommand.CommandText = $commandText

    Write-Verbose "Adding User : $SignInName,$Name,$Id,$SID,$StartUpCompany,$IdentityProvider,$NetworkDomain"

    $null = $sqlCommand.Parameters.Add("@SignInName", $SignInName)
    $null = $sqlCommand.Parameters.Add("@Name", $Name)
    $null = $sqlCommand.Parameters.Add("@SID", $SID)

    
    [System.Data.SqlClient.SqlParameter]$parm = $sqlCommand.Parameters.Add("@StartUpCompany", $StartUpCompany)
    $parm.Size = 5
    
    $null = $sqlCommand.Parameters.Add("@NetworkDomain", $NetworkDomain)
    $null = $sqlCommand.Parameters.Add("@IdentityProvider", $IdentityProvider)
    $null = $sqlCommand.Parameters.Add("@Id", $Id)
    $null = $sqlCommand.Parameters.Add("@ObjectId", $ObjectId)


    Write-Verbose "Creating the user in database"
    
    $rowsCreated = $sqlCommand.ExecuteScalar()
    
    Write-Verbose "Rows inserted  $rowsCreated for user $SignInName"
    $SqlCommand.Parameters.Clear()

    return $rowsCreated -eq 1
}