
<#
    .SYNOPSIS
        Checks if a string is a valid 'Label Id' format
        
    .DESCRIPTION
        This function will validate if a string is a valid 'Label Id' format.
        
    .PARAMETER LabelId
        The LabelId string thay you want to validate
        
    .EXAMPLE
        PS C:> Test-D365LabelIdIsValid -LabelId "ABC123"
        
        This will test the if the LabelId is valid.
        It will use the "ABC123" as the LabelId parameter.
        
        The expected result is $true
        
    .EXAMPLE
        PS C:> Test-D365LabelIdIsValid -LabelId "@ABC123"
        
        This will test the if the LabelId is valid.
        It will use the "@ABC123" as the LabelId parameter.
        
        The expected result is $true
        
    .EXAMPLE
        PS C:> Test-D365LabelIdIsValid -LabelId "@ABC123_1"
        
        This will test the if the LabelId is valid.
        It will use the "@ABC123_1" as the LabelId parameter.
        
        The expected result is $false
        
    .EXAMPLE
        PS C:> Test-D365LabelIdIsValid -LabelId "ABC.123" #False
        
        This will test the if the LabelId is valid.
        It will use the "ABC.123" as the LabelId parameter.
        
        The expected result is $false
        
    .NOTES
        Author: Alex Kwitny (@AlexOnDAX)
        
        The intent of this function is to be used with other methods to create valid labels via scripting.
        
#>
function Test-D365LabelIdIsValid {
    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory = $True)]
        [string] $LabelId
    )
    
    $RegexOptions = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Compiled -bor [System.Text.RegularExpressions.RegexOptions]::CultureInvariant

    $Matcher_New_LabelID = New-Object System.Text.RegularExpressions.Regex('(^[a-zA-Z_])([a-zA-Z\d_])*$', $RegexOptions)
    $Matcher_Legacy_LabelID = New-Object System.Text.RegularExpressions.Regex([System.String]::Format([System.IFormatProvider][System.Globalization.CultureInfo]::InvariantCulture, "^{0}{1}{2}$", [System.Object]'@', [System.Object]"[a-zA-Z]\w\w", [System.Object]"\d+"), $RegexOptions)
    $Matcher_New_Label_WithLabelFile = New-Object System.Text.RegularExpressions.Regex("(?<AtSign>\@)(?<LabelFileId>[a-zA-Z]\w*):(?<LabelId>[a-zA-Z]\w*)", $RegexOptions)

    if (!$LabelId) {
        $false
        return
    }

    if (!($Matcher_New_LabelID.IsMatch($LabelId)) -and !($Matcher_Legacy_LabelID.IsMatch($LabelId))) {
        $Matcher_New_Label_WithLabelFile.IsMatch($LabelId)
        return
    }

    $true
}