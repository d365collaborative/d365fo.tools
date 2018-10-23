function Get-SqlParameterValue {
    [CmdletBinding()]
    param (
        [System.Data.SqlClient.SqlParameter] $SqlParameter
    )

    $result = $null

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
	
    $stringNumbers = @([System.Data.SqlDbType]::Float, [System.Data.SqlDbType]::Decimal)
	
    switch ($SqlParameter.SqlDbType) {
        { $stringEscaped -contains $_ } {
            $result = $SqlParameter.Value.ToString().Replace("'", "''")
            break
        }
        [System.Data.SqlDbType]::Bit {
            $result = ConvertTo-BooleanOrDefault -Object $SqlParameter.Value.ToString() -Default $true
            break
        }
		
        {$stringNumbers -contains $_} {
            $SqlParameter.Value
            $result = ([System.Double]$SqlParameter.Value).ToString([System.Globalization.CultureInfo]::InvariantCulture).Replace("'", "''")
            break
        }
        default {
            $result = $SqlParameter.Value.ToString().Replace("'", "''")
            break
        }
    }
}