
<#
    .SYNOPSIS
        Convert an object to boolean
        
    .DESCRIPTION
        Convert an object to boolean or default it to the specified boolean value
        
    .PARAMETER Object
        Input object that you want to work against
        
    .PARAMETER Default
        The default boolean value you want returned if the convert / cast fails
        
    .EXAMPLE
        PS C:\> ConvertTo-BooleanOrDefault -Object "1" -Default $true
        
        This will try and convert the "1" value to a boolean value.
        If the convert would fail, it would return the default value $true.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function ConvertTo-BooleanOrDefault {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
        [Object] $Object,

        [Boolean] $Default
    )

    [boolean] $result = $Default;
    $stringTrue = @("yes", "true", "ok", "y")

    $stringFalse = @( "no", "false", "n")

    try {
        if (-not ($null -eq $Object) ) {
            switch ($Object.ToString().ToLower()) {
                {$stringTrue -contains $_} {
                    $result = $true
                    break
                }
                {$stringFalse -contains $_} {
                    $result = $false
                    break
                }
                default {
                    $result = [System.Boolean]::Parser($Object.ToString())
                    break
                }
            }
        }
    }
    catch {
    }

    $result
}