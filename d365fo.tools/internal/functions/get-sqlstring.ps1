
<#
    .SYNOPSIS
        Get an executable string from a SqlCommand object
        
    .DESCRIPTION
        Get an formatted and valid string from a SqlCommand object that contains all variables
        
    .PARAMETER SqlCommand
        The SqlCommand object that you want to retrieve the string from
        
    .EXAMPLE
        PS C:\> $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        PS C:\> $SqlCmd.CommandText = "SELECT * FROM Table WHERE Column = @Parm1"
        PS C:\> $SqlCmd.Parameters.AddWithValue("@Parm1", "1234")
        PS C:\> Get-SqlString -SqlCommand $SqlCmd
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-SqlString {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [System.Data.SqlClient.SqlCommand] $SqlCommand
    )

	$sbDeclare = [System.Text.StringBuilder]::new()
	$sbAssignment = [System.Text.StringBuilder]::new()
	$sbRes = [System.Text.StringBuilder]::new()

    if ($SqlCommand.CommandType -eq [System.Data.CommandType]::Text) {
        if (-not ($null -eq $SqlCommand.Connection)) {
            $null = $sbDeclare.Append("USE [").Append($SqlCommand.Connection.Database).AppendLine("]")
        }

        foreach ($parameter in $SqlCommand.Parameters) {
            if ($parameter.Direction -eq [System.Data.ParameterDirection]::Input) {
                $null = $sbDeclare.Append("DECLARE ").Append($parameter.ParameterName).Append("`t")
                $null = $sbDeclare.Append($parameter.SqlDbType.ToString().ToUpper())
                $null = $sbDeclare.AppendLine((Get-SqlParameterSize -SqlParameter $parameter))

                $null = $sbAssignment.Append("SET ").Append($parameter.ParameterName).Append(" = ").AppendLine((Get-SqlParameterValue -SqlParameter $parameter))
			}
        }
        
        $null = $sbRes.AppendLine($sbDeclare.ToString())
        $null = $sbRes.AppendLine($sbAssignment.ToString())
        $null = $sbRes.AppendLine($SqlCommand.CommandText)
	}

	$sbRes.ToString()
}