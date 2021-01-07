<#
# Example:
Register-PSFTeppArgumentCompleter -Command Get-Alcohol -Parameter Type -Name d365fo.tools.alcohol
#>

#File Options
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter FileType -Name d365fo.tools.lcs.options
Register-PSFTeppArgumentCompleter -Command Get-D365LcsAssetFile -Parameter FileType -Name d365fo.tools.lcs.options

#LCS API URLS
Register-PSFTeppArgumentCompleter -Command Get-D365LcsApiToken -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsAssetFile -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsAssetValidationStatus -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsDatabaseBackups -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsDatabaseOperationStatus -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsDeploymentStatus -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls


Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsDatabaseExport -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsDatabaseRefresh -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsDeployment -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsEnvironmentStart -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsEnvironmentStop -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls

Register-PSFTeppArgumentCompleter -Command Set-D365LcsApiConfig -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls

#TimeZones
Register-PSFTeppArgumentCompleter -Command Send-D365BroadcastMessage -Parameter TimeZone -Name d365fo.tools.timezones
Register-PSFTeppArgumentCompleter -Command Add-D365BroadcastMessageConfig -Parameter TimeZone -Name d365fo.tools.timezones

#Event Trace
Register-PSFTeppArgumentCompleter -Command Start-D365EventTrace -Parameter ProviderName -Name d365fo.tools.event.trace.providers
Register-PSFTeppArgumentCompleter -Command Start-D365EventTrace -Parameter OutputFormat -Name d365fo.tools.event.trace.format.options
