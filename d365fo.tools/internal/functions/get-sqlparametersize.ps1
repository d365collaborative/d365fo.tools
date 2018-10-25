
<#
    .SYNOPSIS
        Get the size from the parameter
        
    .DESCRIPTION
        Get the size from the parameter based on its datatype and value
        
    .PARAMETER SqlParameter
        The SqlParameter object that you want to get the size from
        
    .EXAMPLE
        PS C:\> $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        PS C:\> $SqlCmd.Parameters.AddWithValue("@Parm1", "1234")
        PS C:\> Get-SqlParameterSize -SqlParameter $SqlCmd.Parameters[0]
        
        This will extract the size from the first parameter from the SqlCommand object and return it as a formatted string.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-SqlParameterSize {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [System.Data.SqlClient.SqlParameter] $SqlParameter
    )

    $res = ""

    $stringSizeTypes = @(
        [System.Data.SqlDbType]::Char,
        [System.Data.SqlDbType]::NChar,
        [System.Data.SqlDbType]::NText,
        [System.Data.SqlDbType]::NVarChar,
        [System.Data.SqlDbType]::Text,
        [System.Data.SqlDbType]::VarChar
    )

    if ( $stringSizeTypes -contains $SqlParameter.SqlDbType) {
        $res = "($($SqlParameter.Size))"
    }

    $res
}