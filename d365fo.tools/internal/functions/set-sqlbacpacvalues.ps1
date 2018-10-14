<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER DatabaseServer
Parameter description

.PARAMETER DatabaseName
Parameter description

.PARAMETER SqlUser
Parameter description

.PARAMETER SqlPwd
Parameter description

.PARAMETER TrustedConnection
Parameter description

.PARAMETER TenantId
Parameter description

.PARAMETER PlanId
Parameter description

.PARAMETER PlanCapability
Parameter description

.EXAMPLE
PS C:\> Set-SqlBacpacValues

This will work

.NOTES
Author: Rasmus Andersen (@ITRasmus)
Author: Mötz Jensen (@Splaxi)

#>
function Set-SqlBacpacValues {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
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
        [boolean] $TrustedConnection,

        [Parameter(Mandatory = $true)]
        [string]$TenantId,

        [Parameter(Mandatory = $true)]
        [string]$PlanId,
        
        [Parameter(Mandatory = $true)]
        [string]$PlanCapability
    )
    
    $sqlCommand = Get-SQLCommand -DatabaseServer $DatabaseServer -DatabaseName $DatabaseName -SqlUser $SqlUser -SqlPwd $SqlPwd -TrustedConnection $TrustedConnection

    $commandText = (Get-Content "$script:ModuleRoot\internal\sql\set-bacpacvaluessql.sql") -join [Environment]::NewLine
    $commandText = $commandText.Replace('@DATABASENAME', $DatabaseName)

    $sqlCommand.CommandText = $commandText

    $null = $sqlCommand.Parameters.Add("@TenantId", $TenantId)
    $null = $sqlCommand.Parameters.Add("@PlanId", $PlanId)
    $null = $sqlCommand.Parameters.Add("@PlanCapability ", $PlanCapability)

    try {
        Write-PSFMessage -Level Verbose "Execution sql statement against database" -Target $sqlCommand.CommandText
        $sqlCommand.Connection.Open()
        $sqlCommand.ExecuteNonQuery()

        $true
    }
    catch {
        Write-PSFMessage -Level Critical -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally {
        $sqlCommand.Connection.Close()
        $sqlCommand.Dispose()
    }
}