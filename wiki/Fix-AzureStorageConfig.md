Got hit by our breaking change with the names of the parameters for the Add-AzureStorageConfig, Get-AzureStorageConfig

```
$configs = Get-D365AzureStorageConfig
$configs | ForEach-Object {Add-D365AzureStorageConfig -Name $_.Name -AccountId $_.AccountId -SAS $_.SAS -Container $_.Blobname -Force}
``` 