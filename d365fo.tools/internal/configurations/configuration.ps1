<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'd365fo.tools' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'd365fo.tools' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'd365fo.tools' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."

Set-PSFConfig -FullName "d365fo.tools.workstation.mode" -Value $false -Initialize -Description "Setting to assist the module to grab the URL from configuration rather from the non existing dll files."
Set-PSFConfig -FullName "d365fo.tools.active.environment" -Value @{} -Initialize -Description "Object that stores the environment details that should be used during the module."
Set-PSFConfig -FullName "d365fo.tools.environments" -Value @{} -Initialize -Description "Object that stores different environments and their details."
Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value @{} -Initialize -Description "Object that stores different Azure Storage Account and their details."
Set-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" -Value @{} -Initialize -Description "Object that stores the Azure Storage Account details that should be used during the module."
Set-PSFConfig -FullName "d365fo.tools.active.logic.app" -Value @{} -Initialize -Description "Object that stores the Azure Logic App details that should be used during the module."

Set-PSFConfig -FullName "d365fo.tools.tier2.bacpac.params" -Value "" -Initialize -Description "Object that stores json string from a hashtable with details for the Import-D365Bacpac cmdlet."