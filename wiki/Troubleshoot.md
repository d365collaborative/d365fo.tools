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