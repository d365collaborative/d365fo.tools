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