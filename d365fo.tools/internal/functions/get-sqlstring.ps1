function Get-SqlString {
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlCommand] $SqlCommand
    )

	$sbDeclare = [System.Text.StringBuilder]::new()
	$sbAssignment = [System.Text.StringBuilder]::new()
	$sbRes = [System.Text.StringBuilder]::new()

    if ($SqlCommand.CommandType -eq [System.Data.CommandType]::Text) {
        foreach ($parameter in $SqlCommand.Parameters) {
            if ($parameter.Direction = [System.Data.ParameterDirection]::Input) {
                $null = $sbDeclare.Append("DECLARE ").Append($parameter.ParameterName).Append("\t")
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