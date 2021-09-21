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

Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value @{} -Initialize -Description "Object that stores different Azure Storage Account and their details."
Set-PSFConfig -FullName "d365fo.tools.active.azure.storage.account" -Value @{} -Initialize -Description "Object that stores the Azure Storage Account details that should be used during the module."
Set-PSFConfig -FullName "d365fo.tools.active.logic.app" -Value @{} -Initialize -Description "Object that stores the Azure Logic App details that should be used during the module."

Set-PSFConfig -FullName "d365fo.tools.lcs.projectid" -Value "" -Initialize -Description "Project number for the specific LCS project that you want to upload to."
Set-PSFConfig -FullName "d365fo.tools.lcs.clientid" -Value "" -Initialize -Description "Client Id of the Azure Registered App that you configured to be able to use the API of LCS."
Set-PSFConfig -FullName "d365fo.tools.lcs.lcsapiuri" -Value "" -Initialize -Description "URI / URL for the LCS API."
Set-PSFConfig -FullName "d365fo.tools.lcs.activetokenexpireson" -Value "" -Initialize -Description "The time when the currently stored bearer token will expire. Measured in seconds from 1970-01-01 (UnixTime)."
Set-PSFConfig -FullName "d365fo.tools.lcs.bearertoken" -Value "" -Initialize -Description "The bearer token used to authenticate / authorize against LCS when you want to upload files."
Set-PSFConfig -FullName "d365fo.tools.lcs.refreshtoken" -Value "" -Initialize -Description "The refresh token, that can be used to obtain a new bearer token from Azure Active Directory."

Set-PSFConfig -FullName "d365fo.tools.active.broadcast.message.config.name" -Value "" -Initialize -Description "Name of the broadcast message configuration that should be the default / active configuration for the module."

Set-PSFConfig -FullName "d365fo.tools.path.sqlpackage" -Value "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" -Initialize -Description "Path to the default location where SqlPackage.exe is located."

Set-PSFConfig -FullName "d365fo.tools.azure.common.oauth.token" -Value "https://login.microsoftonline.com/common/oauth2/token" -Initialize -Description "URI / URL for the Azure Active Directory OAuth 2.0 endpoint for tokens"

Set-PSFConfig -FullName "d365fo.tools.path.rsat" -Value "C:\Program Files (x86)\Regression Suite Automation Tool" -Initialize -Description "Path to the default location where RSAT is located."

Set-PSFConfig -FullName "d365fo.tools.path.rsatplayback" -Value "C:\Users\$($env:UserName)\AppData\Roaming\regressionTool\playback" -Initialize -Description "Path to the playback output location where RSAT is writing all the output values."

Set-PSFConfig -FullName "d365fo.tools.path.azcopy" -Value "C:\temp\d365fo.tools\AzCopy\AzCopy.exe" -Initialize -Description "Path to the default location where AzCopy.exe is located."

Set-PSFConfig -FullName "d365fo.tools.path.nuget" -Value "C:\temp\d365fo.tools\nuget\nuget.exe" -Initialize -Description "Path to the default location where nuget.exe is located."
