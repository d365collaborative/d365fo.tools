function Get-AzureServiceObjectives {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName, 

        [Parameter(Mandatory = $true)]
        [string] $SqlUser, 

        [Parameter(Mandatory = $true)]
        [string] $SqlPwd
    )
        
    $sqlCommand = Get-SQLCommand @PsBoundParameters -TrustedConnection $false

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-azureserviceobjective.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    try {
        $sqlCommand.Connection.Open()

        Write-PSFMessage -Level Verbose "Execute the statement against the Azure DB instance" -Target $sqlCommand
        $reader = $sqlCommand.ExecuteReader()
        
        if ($reader.Read() -eq $true) {
            Write-PSFMessage -Level Verbose "Extracting details from the result retrieved from the Azure DB instance"

            $edition = $reader.GetString(1)
            $serviceObjective = $reader.GetString(2)

            $reader.close()
            
            $sqlCommand.Connection.Close()
            $sqlCommand.Dispose()
            
            [PSCustomObject]@{
                DatabaseEdition          = $edition
                DatabaseServiceObjective = $serviceObjective
            }
        }
        else {
            Write-PSFMessage -Level Host -Message "The query to detect <c='em'>edition</c> and <c='em'>service objectives</c> from the Azure DB instance <c='em'>failed</c>."
            Stop-PSFFunction -Message "Stopping because of missing parameters"
            return
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}