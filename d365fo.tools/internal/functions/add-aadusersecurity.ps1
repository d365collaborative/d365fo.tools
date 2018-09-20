function Add-AadUserSecurity ($sqlCommand,$Id) {
    

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\Set-AadUserSecurityInD365FO.sql") -join [Environment]::NewLine
   
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Id", $Id)

    Write-Verbose "Setting security roles in D365FO database"
       
    $differenceBetweenNewUserAndAdmin = $sqlCommand.ExecuteScalar()
    
    Write-Verbose "Difference between new user and admin security roles $differenceBetweenNewUserAndAdmin"

    $SqlCommand.Parameters.Clear()

    return $differenceBetweenNewUserAndAdmin -eq 0
}