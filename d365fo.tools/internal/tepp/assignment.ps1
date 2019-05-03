<#
# Example:
Register-PSFTeppArgumentCompleter -Command Get-Alcohol -Parameter Type -Name d365fo.tools.alcohol
#>

Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter FileType -Name d365fo.tools.lcs.options
Register-PSFTeppArgumentCompleter -Command Start-LcsUpload -Parameter FileType -Name d365fo.tools.lcs.options

Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Set-D365LcsUploadConfig -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsDeployment -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls
Register-PSFTeppArgumentCompleter -Command Get-D365LcsUploadToken -Parameter LcsApiUri -Name d365fo.tools.lcs.api.urls

Register-PSFTeppArgumentCompleter -Command Send-D365BroadcastMessage -Parameter TimeZone -Name d365fo.tools.timezones
Register-PSFTeppArgumentCompleter -Command Add-D365BroadcastMessageConfig -Parameter TimeZone -Name d365fo.tools.timezones
