
<#
    .SYNOPSIS
        Get the value from the parameter
        
    .DESCRIPTION
        Get the value that is assigned to the SqlParameter object
        
    .PARAMETER SqlParameter
        The SqlParameter object that you want to work against
        
    .EXAMPLE
        PS C:\> $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        PS C:\> $SqlCmd.Parameters.AddWithValue("@Parm1", "1234")
        PS C:\> Get-SqlParameterValue -SqlParameter $SqlCmd.Parameters[0]
        
        This will extract the value from the first parameter from the SqlCommand object.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-SqlParameterValue {
    [CmdletBinding()]
    [OutputType('System.String')]
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
            $result = "'{0}'" -f $SqlParameter.Value.ToString().Replace("'", "''")
            break
        }

        { [System.Data.SqlDbType]::Bit } {
            if ((ConvertTo-BooleanOrDefault -Object $SqlParameter.Value.ToString() -Default $true)) {
                $result = '1'
            }
            else {
                $result = '0'
            }
                        
            break
        }
		
        { $stringNumbers -contains $_ } {
            $SqlParameter.Value
            $result = ([System.Double]$SqlParameter.Value).ToString([System.Globalization.CultureInfo]::InvariantCulture).Replace("'", "''")
            break
        }

        default {
            $result = $SqlParameter.Value.ToString().Replace("'", "''")
            break
        }
    }

    $result
}