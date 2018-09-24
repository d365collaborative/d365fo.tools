function Get-SQLCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName, 

        [Parameter(Mandatory = $false)]
        [string] $SqlUser, 

        [Parameter(Mandatory = $false)]
        [string] $SqlPwd,

        [Parameter(Mandatory = $false)]
        [bool] $TrustedConnection
    )

    Write-PSFMessage -Level Debug -Message "Writing the bound parameters" -Target $PsBoundParameters
    [System.Collections.ArrayList]$Params = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Params.Add("Server='$DatabaseServer';")
    $null = $Params.Add("Database='$DatabaseName';")

    if ($null -eq $TrustedConnection -or !$TrustedConnection) {
        $null = $Params.Add("User='$SqlUser';")
        $null = $Params.Add("Password='$SqlPwd';")
    }
    else {
        $null = $Params.Add("Integrated Security='SSPI';")        
    }

    $null = $Params.Add("Application Name='d365fo.tools'")
    
    Write-PSFMessage -Level Verbose -Message "Building the SQL connection string." -Target $Params
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection

    try {
        $sqlConnection.ConnectionString = ($Params -join "")

        $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
        $sqlCommand.Connection = $sqlConnection
        $sqlCommand.CommandTimeout = 0    
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working with the sql server connection objects" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return        
    }
    
    $sqlCommand
}
