<#
# Example:
Register-PSFTeppArgumentCompleter -Command Get-Alcohol -Parameter Type -Name d365fo.tools.alcohol
#>

Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter FileType -Name d365fo.tools.lcs.upload.options
Register-PSFTeppArgumentCompleter -Command Invoke-D365LcsUpload -Parameter LcsApiUri -Name d365fo.tools.lcs.upload.api.urls

Register-PSFTeppArgumentCompleter -Command Start-LcsUpload -Parameter FileType -Name d365fo.tools.lcs.upload.options

Register-PSFTeppArgumentCompleter -Command Set-D365LcsUploadConfig -Parameter LcsApiUri -Name d365fo.tools.lcs.upload.api.urls
Register-PSFTeppArgumentCompleter -Command Send-D365BroadcastMessage -Parameter TimeZone -Name d365fo.tools.timezones
Register-PSFTeppArgumentCompleter -Command Add-D365BroadcastMessageConfig -Parameter TimeZone -Name d365fo.tools.timezones
