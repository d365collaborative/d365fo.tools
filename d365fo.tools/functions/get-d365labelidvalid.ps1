<#
    .SYNOPSIS
        Checks if a string is a valid 'Label Id' format
 
    .DESCRIPTION
        This function will validate if a string is a valid 'Label Id' format.

    .PARAMETER LabelId
        LabelId string to validate
 
    .EXAMPLE
        Get-D365LabelIdIsValid -LabelId "ABC123" #True
        Get-D365LabelIdIsValid -LabelId "@ABC123" #True
        Get-D365LabelIdIsValid -LabelId "@ABC123_1" #False
        Get-D365LabelIdIsValid -LabelId "ABC.123" #False
 
    .NOTES
        Author: Alex Kwitny (@AlexOnDAX)

        The intent of this function is to be used with other methods to create valid labels via scripting.
 
#>
function Get-D365LabelIdIsValid {
	[CmdletBinding()]
    [OutputType([bool])]
	param 
	( 
	    [Parameter(Mandatory=$True, Position=0)] 
	    [string]$LabelId
	)
    
    $RegexOptions = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor [System.Text.RegularExpressions.RegexOptions]::Compiled -bor [System.Text.RegularExpressions.RegexOptions]::CultureInvariant

    $Matcher_New_LabelID = New-Object System.Text.RegularExpressions.Regex('(^[a-zA-Z_])([a-zA-Z\d_])*$', $RegexOptions)
    $Matcher_Legacy_LabelID = New-Object System.Text.RegularExpressions.Regex([System.String]::Format([System.IFormatProvider][System.Globalization.CultureInfo]::InvariantCulture, "^{0}{1}{2}$", [System.Object]'@', [System.Object]"[a-zA-Z]\w\w", [System.Object]"\d+"), $RegexOptions)
    $Matcher_New_Label_WithLabelFile = New-Object System.Text.RegularExpressions.Regex("(?<AtSign>\@)(?<LabelFileId>[a-zA-Z]\w*):(?<LabelId>[a-zA-Z]\w*)", $RegexOptions)

    if (!$LabelId)
    {
        return $False
    }

    if (!($Matcher_New_LabelID.IsMatch($LabelId)) -and !($Matcher_Legacy_LabelID.IsMatch($LabelId)))
    {
        return $Matcher_New_Label_WithLabelFile.IsMatch($LabelId)
    }

    return $True
}