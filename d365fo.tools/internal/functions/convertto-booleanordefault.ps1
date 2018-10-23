function ConvertTo-BooleanOrDefault {
    [CmdletBinding()]
    param (
        [Object] $Object,

        [Boolean] $Default
    )

    [boolean] $result = $Default;
    $stringTrue = @("yes"    , "true"     , "ok"    , "y")

    $stringFalse = @( "no", "false", "n"    )

    try {
        if (-not ($null -eq $Object) ) {
            switch ($Object.ToString().ToLower()) {
                {$stringTrue -contains $_} {
                    $result = $true
                    break
                }
                {$stringFalse-contains $_} {
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