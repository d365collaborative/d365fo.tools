If you need to make sure that the different cmdlets / functions break execution, you will have to change your console preferences to enable that.

The simplest way is to tell PowerShell to stop when ever it hits a warning.
```
$WarningPreference="Stop"
```

If you want the module to specific throw an exception when executing, you need run the following command.
```
$PSDefaultParameterValues['*:EnableException'] = $true
```


