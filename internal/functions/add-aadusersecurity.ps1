function Add-AadUserSecurity ($sqlCommand,$Id) {
    

    $commandText = get-content "$script:PSModuleRoot\internal\sql\Set-AadUserSecurityInD365FO.sql"
   
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Id", $Id)

    Write-Verbose "Setting security roles in D365FO database"
       
    $differenceBetweenNewUserAndAdmin = $sqlCommand.ExecuteScalar()
    
    Write-Verbose "Difference between new user and admin security roles $differenceBetweenNewUserAndAdmin"

    $SqlCommand.Parameters.Clear()

    return $differenceBetweenNewUserAndAdmin -eq 0
}