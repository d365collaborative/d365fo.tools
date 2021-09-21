**Work with packages, label files, language and labels**

```
Get-D365InstalledPackage
```
*Gets all installed packages on the system/machine*

```
Get-D365InstalledPackage -Name "ApplicationSuite"
```
*Gets the "ApplicationSuite" package*

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US"
```
*Gets all the "en-US" resource / label files from the ApplicationSuite package*

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" -Name "PRO"
```
*Gets the PRO resource / label file from the "ApplicationSuite" package with the language "EN-US"*

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" -Name "PRO" | Get-D365Label
```
*Gets all label details from the PRO resource / label file from the "ApplicationSuite" package with the language "EN-US"*

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "*" -Name "PRO" | Get-D365Label -Name "@PRO505"
```
*Gets the "@PRO505" label details from the "PRO" resource / label file from the "ApplicationSuite" package, **across all languages***

```
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile -Language "en-US" | Get-D365Label -Value "*qty*" -IncludePath
```

*Gets all "en-US" labels where the value contains "*qty*" from the "ApplicationSuite" package, **across all resource / label files***

```
Get-D365InstalledPackage | Out-GridView -PassThru | Get-D365PackageLabelFile -Language "da" | Out-GridView -PassThru | Get-D365Label -IncludePath | Out-GridView 
```

*You don't quite know what you are looking for and the powershell cmdlets does not feel comfortable. Use the above command to display a GridView with filtering options available. First you will have to select what package you want to work against - you can select multiple. Next GridView will make you select the specific resource / label files you want to work against, across the selected packages - you can select multiple. The last GridView will show you the results from the earlier selections and make it possible for you to filter what ever you want.*

```
Get-D365InstalledPackage | Get-D365PackageLabelFile -Language "da" | Get-D365Label -Value "*antal*" -IncludePath | Out-GridView
```

*Shows all labels that contains the "antal" text value, across all packages, across all resource / label files, with the language "da" and shows it in GridView where you can filter the entire result further for you convenience* 