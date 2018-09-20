function Test-AadUserInD365FO ($SqlCommand, $SignInName) {


    $commandText =(Get-Content "$script:PSModuleRoot\internal\sql\test-aaduserind365fo.sql") -join [Environment]::NewLine
  
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Email", $SignInName)
      
    $NumFound = $sqlCommand.ExecuteScalar()

    Write-Verbose "Number of user rows found in database $NumFound"

    $SqlCommand.Parameters.Clear()

    return $NumFound -ne 0

}