
<#
    .SYNOPSIS
        Convert HashTable into an array
        
    .DESCRIPTION
        Convert HashTable with switches inside into an array of Key:Value
        
    .PARAMETER InputObject
        The HashTable object that you want to work against
        
        Shold only contain Key / Vaule, where value is $true or $false
        
    .PARAMETER KeyPrefix
        The prefix that you want to append to the key of the HashTable
        
        The default value is "-"
        
    .PARAMETER ValuePrefix
        The prefix that you want to append to the value of the HashTable
        
        The default value is ":"
        
    .EXAMPLE
        PS C:\> $params = @{NoPrompt = $true; CreateParents = $false}
        PS C:\> $arguments = Convert-HashToArgStringSwitch -Inputs $params
        
        This will convert the $params into an array of strings, each with the Key:Value.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Convert-HashToArgStringSwitch {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [HashTable] $InputObject,

        [string] $KeyPrefix = "-",

        [string] $ValuePrefix = ":",

        [switch] $KeepCase = $true
    )

    foreach ($key in $InputObject.Keys) {
        $value = "{0}" -f $InputObject.Item($key).ToString()
        if(-not $KeepCase) {$value = $value.ToLower()}
        "$KeyPrefix$($key)$ValuePrefix$($value)"
    }
}