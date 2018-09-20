function Test-AadUserIdInD365FO ($SqlCommand, $Id) {


    $commandText =(Get-Content "$script:ModuleRoot\internal\sql\test-aaduseridind365fo.sql") -join [Environment]::NewLine
  
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Id", $Id)
      
    $NumFound = $sqlCommand.ExecuteScalar()

    Write-Verbose "Number of user rows found in database $NumFound"

    $SqlCommand.Parameters.Clear()

    return $NumFound -ne 0

}