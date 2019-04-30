<#
# Example:
Register-PSFTeppScriptblock -Name "d365fo.tools.alcohol" -ScriptBlock { 'Beer','Mead','Whiskey','Wine','Vodka','Rum (3y)', 'Rum (5y)', 'Rum (7y)' }
#>

# Register-PSFTeppScriptblock -Name "d365fo.tools.timezones" -ScriptBlock { [System.TimeZoneInfo]::GetSystemTimeZones().Id }


Register-PSFTeppScriptblock -Name "d365fo.tools.timezones" -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
	
    [System.TimeZoneInfo]::GetSystemTimeZones() | Where-Object {$PSItem.DisplayName -match $wordToComplete} | ForEach-Object {
        $CompletionText = '"{0} - [{1}]"' -f $PSItem.DisplayName, $PSItem.StandardName
	
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList @($CompletionText)
    }
}