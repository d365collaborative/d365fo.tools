We appreciate you taking the time to read up on how to troubleshoot issues with the d365fo.tools. Ideally, this will enable you to get to a solution for your issue on your own. If not, it will still help you gather the information needed to get help from others.

> **IMPORTANT** Note that some of the information gathered may contain sensitive information. Make sure to remove any sensitive information before sharing the information with others.

# General Powershell troubleshooting

## Check the versions

### d365fo.tools

Check whether the latest version of d365fo.tools is being used. This can be done with the `Get-Module d365fo.tools` cmdlet. If the cmdlet shows no output, add the `-ListAvailable` switch to see all versions installed on the machine. Usually the latest version will be used unless a different version is specified when loading the module. Compare the version with the latest version on [PowerShell Gallery](https://www.powershellgallery.com/packages/d365fo.tools/).

> *Why is this important?* If an older version is used, a first step in troubleshooting is to update to the latest version. If the issue is already fixed in the latest version, there is no need to troubleshoot further. On the other hand, if the module needs to be on a specific older version, this is important information to know.

### PowerShell

Check which version of PowerShell is being used. This can be done with the `$PSVersionTable` variable. 

> *Why is this important?* The module is primarily developed and tested on Windows Server environments with Windows PowerShell (i.e. PowerShell 5.1). If you are using PowerShell Core (i.e. PowerShell 6 or 7) or an older version of Windows PowerShell, there may be issues. 

### Other components

Some cmdlets of the module rely on other components, for example SQLPackage.exe for importing and creating bacpac and dacpac files. If you know the components used by the cmdlet, check the version of those components as well.

> *Why is this important?* Sometimes the issue is not with the d365fo.tools, but the component it relies on. If the component is not up to date, it may contain a bug that is already fixed in a newer version.

## Use common parameters

Powershell provides some common parameters that can be used with any cmdlet, see [about common parameters](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters). Often used parameters for troubleshooting are `-Verbose` and `-Debug`. Support for common parameters varies per cmdlet, but these two are supported by most. 

> *Why is this important?* The `-Verbose` parameter will provide additional information about what the cmdlet is doing. The `-Debug` parameter will provide even more information, including the values of variables used in the cmdlet. This can be very useful to see what is going on and where the issue is.

## Additional error details

Even with `-Verbose` and `-Debug`, the output of a cmdlet may not contain all the available information about an error that ocurred. To get more information, use the [automatic variable](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables) `$Error`. This variable contains an array of all errors that have occurred in the current session. The most recent error is `$Error[0]`, the second most recent is `$Error[1]`, etc. To get more information about an error, use the `| Format-List` cmdlet. For example, `$Error[0] | Format-List` will show the error message, the stack trace, and more.

> *Why is this important?* The error message may not contain all the information needed to troubleshoot an issue. The stack trace may contain more information about where the issue occurred.

## **Record a PowerShell session**
```PS
Start-Transcript -Path "C:\Temp\PowerShellSession.log" -Append
```

## **Gathering logs**
```PS
Get-PSFMessage -Errors | Format-List
Get-PSFMessage -Errors | Format-List | Out-file c:\temp\errors.txt

Get-PSFMessage -Level InternalComment | Format-List
Get-PSFMessage -Level InternalComment | Format-List | out-file C:\temp\sqlcommands.txt
```

## **Locate the folder where the module is installed**
```PS
explorer.exe (Split-Path $(Get-Module d365fo.tools -ListAvailable | Select-Object -First 1).Path -Parent)
```

## **Unsplat a hashtable to a string with parameters**
```PS
($HashArray.Keys | ForEach-Object {"-$($_) `"$($HashArray.Item($_))`""}) -Join " "
```

## **Debug**
For general PowerShell debug information, see [How to debug scripts in Windows PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/how-to-debug-scripts-in-windows-powershell-ise).

To debug a cmdlet, first make sure the module is [loaded with the individual files](Load-individual-files-or-dot-source-the-files). Then open the .ps1 file of the cmdlet in PowerShell ISE and set a breakpoint. Finally, call the cmdlet.