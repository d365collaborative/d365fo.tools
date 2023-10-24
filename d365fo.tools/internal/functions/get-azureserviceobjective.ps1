
<#
    .SYNOPSIS
        Get the Azure Service Objectives
        
    .DESCRIPTION
        Get the current tiering details from the Azure SQL Database instance
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-AzureServiceObjective -DatabaseServer dbserver1.database.windows.net -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        
        This will get the Azure service objective details from the Azure SQL Database instance located at "dbserver1.database.windows.net"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-AzureServiceObjective {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $DatabaseServer,

        [Parameter(Mandatory = $true)]
        [string] $DatabaseName,

        [Parameter(Mandatory = $true)]
        [string] $SqlUser,

        [Parameter(Mandatory = $true)]
        [string] $SqlPwd,

        [switch] $EnableException
    )
    
    $Params = Get-DeepClone $PSBoundParameters
    if($Params.ContainsKey("EnableException")){$null = $Params.Remove("EnableException")}

    $sqlCommand = Get-SqlCommand @Params -TrustedConnection $false

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\get-azureserviceobjective.sql") -join [Environment]::NewLine

    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

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
            $messageString = "The query to detect <c='em'>edition</c> and <c='em'>service objectives</c> from the Azure DB instance <c='em'>failed</c>."
            Write-PSFMessage -Level Host -Message $messageString -Target (Get-SqlString $SqlCommand)
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>','')))
            return
        }
    }
    catch {
        $messageString = "Something went wrong while working against the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_
        return
    }
}