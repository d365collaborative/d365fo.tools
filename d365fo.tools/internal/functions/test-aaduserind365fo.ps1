function Test-AadUserInD365FO {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [Parameter(Mandatory = $true)]
        [string] $SignInName
    )
        
    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\test-aaduserind365fo.sql") -join [Environment]::NewLine
  
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Email", $SignInName)
    
    try {
        $NumFound = $sqlCommand.ExecuteScalar()

        Write-PSFMessage -Level Verbose -Message "Number of user rows found in database $NumFound" -Target $NumFound
    }
    catch {
        
    }
    finally {
        $SqlCommand.Parameters.Clear()
    }

    $NumFound -ne 0
}