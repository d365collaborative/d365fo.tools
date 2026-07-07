$scriptBlock = { Get-D365UdeDatabaseCredential | Sort-Object Id | Select-Object -ExpandProperty Id }

Register-PSFTeppScriptblock -Name "d365fo.tools.ude.credentials" -ScriptBlock $scriptBlock -Mode Simple
