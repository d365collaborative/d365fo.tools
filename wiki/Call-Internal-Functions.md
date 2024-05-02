# Call internal functions

d365fo.tools has a number of internal functions that are used by the cmdlets. These functions are not intended to be used directly by the user and as such cannot be called directly. However, for troubleshooting purposes or when developing cmdlets, it can be useful to call these functions directly.

> ⚠️ **Warning** If you follow these instructions to call internal functions, we assume you know what you are doing and have taken precautions against an internal function call going wrong.

## Dot source the internal function

To call an internal function, you need to [dot source](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-5.1#script-scope-and-dot-sourcing) the function. This is done by using the `.` operator followed by the path to the function. 

The path to the function consists of 3 parts:
1. **The path to the module**: If you have installed the module, you can use the following PowerShell command to get the path to the module:
    ```powershell
    Split-Path $(Get-Module d365fo.tools -ListAvailable | Select-Object -First 1).Path
    ```
    This will return the path to the module, which is typically something like `C:\Program Files\WindowsPowerShell\Modules\d365fo.tools\` followed by a version number.
2. **The path to the function**: Within the module, the internal functions are located in the `internal\functions` folder.
3. **The file name of the function**: The file name of the function is the name of the function you want to call, followed by `.ps1`.

For example, to dot source the internal function `Invoke-Process` you would use a command similar to the following:
```
. 'C:\Program Files\WindowsPowerShell\Modules\d365fo.tools\0.7.9\internal\functions\Invoke-Process.ps1'
```

## Call the internal function

Once you have dot sourced the internal function, you can call it as you would any other function. For example, to call the `Invoke-Process` function, you would use a command similar to the following:

```powershell
Invoke-Process -Path 'C:\Temp\Program.exe' -Params '/help'
```

## Dependencies

Internal functions may have dependencies on other internal functions, cmdlets or settings. If you are calling an internal function that has dependencies, you will need to dot source and initialize the dependencies as well.

This may require calling the function multiple times. Each time, the error messages should help you identify which dependencies are missing.

For example, the `Invoke-Process` function has the following dependencies:
- internal function `Invoke-TimeSignal`
- internal function `Test-PathExists`
- setting `$Script:TimeSignals`

So to fully load the `Invoke-Process` function, you would use the following script:

```powershell
. 'C:\Program Files\WindowsPowerShell\Modules\d365fo.tools\0.7.9\internal\functions\Invoke-TimeSignal.ps1'
. 'C:\Program Files\WindowsPowerShell\Modules\d365fo.tools\0.7.9\internal\functions\Test-PathExists.ps1'
. 'C:\Program Files\WindowsPowerShell\Modules\d365fo.tools\0.7.9\internal\functions\Invoke-Process.ps1'
$Script:TimeSignals = @{}
```

> ℹ️ **Note** The dependencies of an internal function may have dependencies of their own.