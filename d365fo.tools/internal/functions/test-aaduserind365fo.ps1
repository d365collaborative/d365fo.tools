
<#
    .SYNOPSIS
        Test to see if a given user already exists
        
    .DESCRIPTION
        Test to see if a given user already exists in the Dynamics 365 for Finance & Operations instance
        
    .PARAMETER SqlCommand
        The SQL Command object that should be used when testing the user
        
    .PARAMETER SignInName
        The sign in name (email address) for the user that you want test
        
    .EXAMPLE
        PS C:\> $SqlCommand = Get-SqlCommand -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        PS C:\> Test-AadUserInD365FO -SqlCommand $SqlCommand -SignInName "Claire@contoso.com"
        
        This will get a SqlCommand object that will connect to the localhost server and the AXDB database, with the sql credential "User123".
        It will query the the database for the user with the e-mail address "Claire@contoso.com".
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Test-AadUserInD365FO {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [Parameter(Mandatory = $true)]
        [string] $SignInName
    )

    $sqlCommand.CommandText = (Get-Content "$script:ModuleRoot\internal\sql\test-aaduserind365fo.sql") -join [Environment]::NewLine

    $null = $sqlCommand.Parameters.Add("@Email", $SignInName)

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $NumFound = $sqlCommand.ExecuteScalar()

        Write-PSFMessage -Level Verbose -Message "Number of user rows found in database $NumFound" -Target $NumFound
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }
    finally {
        $SqlCommand.Parameters.Clear()
    }

    $NumFound -ne 0
}