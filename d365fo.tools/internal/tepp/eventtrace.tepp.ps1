$scriptBlock = { (Get-NetEventProvider -ShowInstalled | Where-Object name -like "Microsoft-Dynamics*" | Sort-Object Name).Name }

Register-PSFTeppScriptblock -Name "d365fo.tools.event.trace.providers" -ScriptBlock $scriptBlock -Mode Simple

Register-PSFTeppScriptblock -Name "d365fo.tools.event.trace.format.options" -ScriptBlock { 'bin', 'bincirc', 'csv', 'sql', 'tsv' }

