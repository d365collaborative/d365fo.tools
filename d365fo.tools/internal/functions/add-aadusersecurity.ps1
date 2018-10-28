
<#
    .SYNOPSIS
        Assign D365 Security configuration
        
    .DESCRIPTION
        Assign the same security configuration as the ADMIN user in the D365FO database
        
    .PARAMETER sqlCommand
        The SQL Command object that should be used when assigning the permissions
        
    .PARAMETER Id
        Id of the user inside the D365FO database
        
    .EXAMPLE
        PS C:\> $SqlParams = @{
        DatabaseServer = "localhost"
        DatabaseName = "AXDB"
        SqlUser = "sqladmin"
        SqlPwd = "Pass@word1"
        TrustedConnection = $false
        }
        
        PS C:\> $SqlCommand = Get-SqlCommand @SqlParams
        PS C:\> Add-AadUserSecurity -SqlCommand $SqlCommand -Id "TestUser"
        
        This will create a new Sql Command object using the Get-SqlCommand cmdlet and the $SqlParams hashtable containing all the needed parameters.
        With the $SqlCommand in place it calls the Add-AadUserSecurity cmdlet and instructs it to update the "TestUser" to have the same security configuration as the ADMIN user.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Add-AadUserSecurity {
    [OutputType('System.Boolean')]
    param (
        [Parameter(Mandatory = $true)]
        [System.Data.SqlClient.SqlCommand] $SqlCommand,

        [Parameter(Mandatory = $true)]
        [string] $Id
    )

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\Set-AadUserSecurityInD365FO.sql") -join [Environment]::NewLine
   
    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@Id", $Id)

    Write-PSFMessage -Level Verbose -Message "Setting security roles in D365FO database"

    Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

    $differenceBetweenNewUserAndAdmin = $sqlCommand.ExecuteScalar()
    
    Write-PSFMessage -Level Verbose -Message "Difference between new user and admin security roles $differenceBetweenNewUserAndAdmin" -Target $differenceBetweenNewUserAndAdmin
    
    $SqlCommand.Parameters.Clear()

    $differenceBetweenNewUserAndAdmin -eq 0
}