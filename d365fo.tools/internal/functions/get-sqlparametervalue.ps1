function Get-SqlParameterValue {
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlParameter] $SqlParameter
    )

    $stringEscaped = @(
        [System.Data.SqlDbType]::Char,
        [System.Data.SqlDbType]::DateTime,
        [System.Data.SqlDbType]::NChar,
        [System.Data.SqlDbType]::NText,
        [System.Data.SqlDbType]::NVarChar,
        [System.Data.SqlDbType]::Text,
        [System.Data.SqlDbType]::VarChar,
        [System.Data.SqlDbType]::Xml,
        [System.Data.SqlDbType]::Date,
        [System.Data.SqlDbType]::Time,
         [System.Data.SqlDbType]::DateTime2,
         [System.Data.SqlDbType]::DateTimeOffset
         )
    
    switch ($SqlParameter.SqlDbType) {
        { $stringEscaped -contains $_ } {

        }
        [System.Data.SqlDbType]Bit {
            sp.Value.ToBooleanOrDefault(false) ? "1" : "0";
        }
		

        Default {}
    }
    
    # string empty = string.Empty;
	# switch (sp.SqlDbType)
	# {
	# case SqlDbType.Char:
	# case SqlDbType.DateTime:
	# case SqlDbType.NChar:
	# case SqlDbType.NText:
	# case SqlDbType.NVarChar:
	# case SqlDbType.Text:
	# case SqlDbType.VarChar:
	# case SqlDbType.Xml:
	# case SqlDbType.Date:
	# case SqlDbType.Time:
	# case SqlDbType.DateTime2:
	# case SqlDbType.DateTimeOffset:
	# 	return "'" + sp.Value.ToString().Replace("'", "''") + "'";
	# case SqlDbType.Bit:
	# 	return sp.Value.ToBooleanOrDefault(false) ? "1" : "0";
	# case SqlDbType.Structured:
	# {
	# 	StringBuilder stringBuilder = new StringBuilder();
	# 	DataTable dataTable = (DataTable)sp.Value;
	# 	stringBuilder.Append("declare ").Append(sp.ParameterName).Append(" ")
	# 		.AppendLine(sp.TypeName);
	# 	foreach (DataRow row in dataTable.Rows)
	# 	{
	# 		stringBuilder.Append("insert ").Append(sp.ParameterName).Append(" values (");
	# 		for (int i = 0; i < dataTable.Columns.Count; i++)
	# 		{
	# 			switch (Type.GetTypeCode(row[i].GetType()))
	# 			{
	# 			case TypeCode.Boolean:
	# 				stringBuilder.Append(Convert.ToInt32(row[i]));
	# 				break;
	# 			case TypeCode.String:
	# 				stringBuilder.Append("'").Append(row[i]).Append("'");
	# 				break;
	# 			case TypeCode.DateTime:
	# 				stringBuilder.Append("'").Append(Convert.ToDateTime(row[i]).ToString("yyyy-MM-dd HH:mm")).Append("'");
	# 				break;
	# 			default:
	# 				stringBuilder.Append(row[i]);
	# 				break;
	# 			}
	# 			stringBuilder.Append(", ");
	# 		}
	# 		stringBuilder.Length -= 2;
	# 		stringBuilder.AppendLine(")");
	# 	}
	# 	return stringBuilder.ToString();
	# }
	# case SqlDbType.Decimal:
	# case SqlDbType.Float:
	# 	return ((double)sp.Value).ToString(CultureInfo.InvariantCulture).Replace("'", "''");
	# default:
	# 	return sp.Value.ToString().Replace("'", "''");
	# }
}