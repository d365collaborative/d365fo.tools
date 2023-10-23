
<#
    .SYNOPSIS
        Clear Azure SQL Database specific objects
        
    .DESCRIPTION
        Clears all the objects that can only exists inside an Azure SQL Database instance or disable things that will require rebuilding on the receiving system
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN)
        
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
        PS C:\> Invoke-ClearAzureSpecificObjects -DatabaseServer TestServer.database.windows.net -DatabaseName ExportClone -SqlUser User123 -SqlPwd "Password123"
        
        This will execute all necessary scripts against the "ExportClone" database that exists in the "TestServer.database.windows.net" Azure SQL Database instance.
        It uses the SQL credential "User123" to preform the needed actions.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
Function Invoke-ClearAzureSpecificObjects {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
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

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\clear-azurebacpacdatabase.sql") -join [Environment]::NewLine

    $commandText = $commandText.Replace("@NewDatabase", $DatabaseName)
    
    $sqlCommand.CommandText = $commandText

    try {
        Write-PSFMessage -Level InternalComment -Message "Executing a script against the database." -Target (Get-SqlString $SqlCommand)

        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        $messageString = "Something went wrong while <c='em'>clearing</c> the <c='em'>Azure</c> specific objects in the database."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target (Get-SqlString $SqlCommand)
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
    finally {
        if ($sqlCommand.Connection.State -ne [System.Data.ConnectionState]::Closed) {
            $sqlCommand.Connection.Close()
        }

        $sqlCommand.Dispose()
    }
}