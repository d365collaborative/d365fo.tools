You may have noticed that the d365fo.tools cmdlets rarely throw exceptions. In fact, most cmdlets are written in such a way that exceptions are caught and a warning message is displayed instead.

While this is the preferred approach when using the d365fo.tools in an interactive way (i.e. a users enters commands one by one in a PowerShell console), it can cause issues in other situations.

If for example you want to write a script that call severals cmdlets, the script should probably stop when one call runs into an issue. But instead, the script just shows a warning and continues executing the other calls.

# How to stop execution of the cmdlets in case of a warning?

The simplest way to change the default behavior is to tell PowerShell that it should stop executing in case of a warning. This can be done by setting the value of a preference variable:
```
$WarningPreference="Stop"
```

This will change the behavior of all PowerShell commands that are executed after this variable has been set for the remainder of the PowerShell session.

If you want to restore the default behavior, run the following command or start a new PowerShell session:
```
$WarningPreference="Continue"
```

To learn more about preference variables, run the following command or visit [about_Preference_Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables).
```
Get-Help About_Preference_Variables
```

# How to throw exceptions?

While stopping in case of warnings will cover many situations, sometimes you might prefer getting a real exception so you can implement your own exception handling. 

To cover those situations, the d365fo.tools provide a cmdlet to activate exceptions: `Enable-D365Exception`

By calling this cmdlet at the start of a PowerShell session (or at the beginning of a script), subsequent calls to other cmdlets of the module will throw an exception in case of an issue.

However, note that only cmdlets with the `-EnableException` parameter support this type of exception handling.

To disable throwing exceptions, call the `Disable-D365Exception` cmdlet.

## What does the -EnableException parameter do?

You may have noticed that some cmdlets provide a `-EnableException` switch parameter that does not seem to change how the cmdlet behaves. This is because this parameter only works in combination with the `Enable-D365Exception` cmdlet. 

You would not add this parameter explicitely to your commands. Rather, you call the `Enable-D365Exception` cmdlet first and then other cmdlet calls will use the `-EnableException` parameter behind the scenes to throw an exception.

# Why are exceptions handled like this?

The d365fo.tools PowerShell module is written to help Dynamics 365 Finance and Operations users complete their "daily" tasks easier and more efficient, in a structured and repeatable manner. While the main users of the module are people with a technical background, we don't assume that they have pre-existing skills with PowerShell.

This is why exceptions by default are hidden from the user so that they don't have errors, exceptions and other messages contaminating the console output. In PowerShell community lingo, this is called the "sea of red", because errors and exceptions are displayed in a red font. For a new user of PowerShell, this can be a scary thing that makes them look for other solutions.

For others that are used to having exceptions to handle issues in their programs, this can be tough to get used to. This is why the options described above are provided so that you can switch the d365fo.tools into a mode that increases exposure of any issues.

## Can this be changed?

We had some discussions in the past on how the module should handle exceptions (take a look at the discussion in issue [#265](https://github.com/d365collaborative/d365fo.tools/issues/265)). While we feel that we are currently in a good place when it comes to exception handling, there is always room for improvements or change. If you want to contribute to that, we encourage you to create an [issue](https://github.com/d365collaborative/d365fo.tools/issues) or [discussion](https://github.com/d365collaborative/d365fo.tools/discussions) or submit a pull request.