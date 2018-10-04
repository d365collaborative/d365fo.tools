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
        [string] $SqlPwd
    )
        
    $sqlCommand = Get-SQLCommand @PsBoundParameters -TrustedConnection $false

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\clear-azurebacpacdatabase.sql") -join [Environment]::NewLine

    $commandText = $commandText.Replace("@NewDatabase", $DatabaseName)
    
    $sqlCommand.CommandText = $commandText

    try {
        $sqlCommand.Connection.Open()

        $null = $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while clearing the Azure specific objects from the Azure DB" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
}
