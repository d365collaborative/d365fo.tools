Many d365fo.tools cmdlets use default values for their parameters. This makes the cmdlets easier to use, since the user only has to care about the parameters that need to be specified for their use case. But you may wonder what the default values are and how the module determines them.

# An example

For example, the [Get-D365Module](https://github.com/d365collaborative/d365fo.tools/blob/master/d365fo.tools/functions/get-d365module.ps1) cmdlet has a `-PackageDirectory` parameter. The documentation for the parameter says *Normally it is located under AOSService directory in "PackagesLocalDirectory" - Default value is fetched from the current configuration on the machine*. Looking at the code of the cmdlet, it specifies the parameter like this: `[string] $PackageDirectory = $Script:PackageDirectory`.

We will come back to this example in the following sections to explain how the default value is determined.

# The script scope

You may have noticed that the default value for the `-PackageDirectory` parameter is `$Script:PackageDirectory`. The `$Script:` part is a scope specifier. Scopes are a common concept in many programming languages to define the visibility of variables. For PowerShell, scopes are documented in the [about_Scopes](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scopes) help topic.

For the purpose of the d365fo.tools module, the script scope lets us define variables that are available to all cmdlets in the module. This is useful for variables that are used by many cmdlets, like the `-PackageDirectory` variable. Note that variables with this scope are not available to the user of the module, only to the cmdlets in the module. So unfortunately, there is no easy way for users to tell what the default value of parameters like `-PackageDirectory` is, because they cannot access the script scope.

# Setting the default values

The values of the variables in the script scope are set in several internal scripts that get executed when the module is imported. You can see this in the [postimport.ps1](https://github.com/d365collaborative/d365fo.tools/blob/master/d365fo.tools/internal/scripts/postimport.ps1) script, where the [variables.ps1](https://github.com/d365collaborative/d365fo.tools/blob/master/d365fo.tools/internal/scripts/variables.ps1) script is called. This script sets the default values for many variables in the module. 

## It depends

You will note that some variables get assigned a fixed value (like `$Script:WebConfig = "web.config"` for the variable that stores the name of the web.config file). Others get their value assigned by other means, which means there is no one way to determine the default value of a variable. But the variables.ps1 script is a good place to start looking.

For the `-PackageDirectory` variable, it uses `$Script:PackageDirectory = $environment.Aos.PackageDirectory`. So for this particular variable, there is another layer of indirection before its value can be determined. The `$environment` variable is set by a call to `Get-ApplicationEnvironment`, which is an internal function not available outside of the module. However, that internal function is used by the `Get-D365EnvironmentSettings` cmdlet, which is available to the user. So the user can determine the value of the `-PackageDirectory` variable by calling `Get-D365EnvironmentSettings` and looking at the `Aos.PackageDirectory` property of the returned object.

```powershell	
$environmentSettings = Get-D365EnvironmentSettings
$environmentSettings.Aos.PackageDirectory
```

This of course requires advanced knowledge of the inner workings of the module and is not intended for regular use. But it serves as an example of how the default values of the variables in the module are determined.

# Configurable default values

You may have noticed that there are several calls to internal functions in the variables.ps1 script. The ones discussed here start with `Update-` and end with `Variables`, like `Update-ModuleVariables`. These functions do the same as the variables.ps1 script, but have outsourced some of the variable value initialization to these functions. You can tell from the name of the function that they cover certain functional areas of the module. For example, `Update-AzureStorageVariables` sets the default values for variables related to Azure Storage.

The common theme for these variables is that they are based on configuration values. The variables discussed so far are usually static and without a need by a user to change them. But there are also variables that are based on configuration values that the user can set. With the exception of `Update-ModuleVariables`, those configuration value are defined by cmdlets of the module. For example, the `Update-AzureStorageVariables` function uses the values set by the `Add-D365AzureStorageConfig` and `Set-D365ActiveAzureStorageConfig` cmdlets.

Another important thing to note is that the configuration values are persisted between sessions. This means that the user only has to set the configuration values once, and they will be used as default values for the variables in all future sessions of the module.

This also applies to the `Update-ModuleVariables` function, but the configuration values are not set by the user, but by the module itself. The configuration values are specified in the [configuration.ps1](https://github.com/d365collaborative/d365fo.tools/blob/master/d365fo.tools/internal/configurations/configuration.ps1) script. To understand how those configurations work, we first need to learn about the PSFramework module.

## PSFramework

A lot of the general structure and functionality of d365fo.tools is provided by the PSFramework module. This module provides a lot of functionality for building advanced PowerShell modules, and one of the features it provides is the ability to define a configuration for a module. This is part of the configuration system of PSFramework. You can learn more about it here: [The Configuration System](https://psframework.org/documentation/documents/psframework/configuration.html).

You can see in the `configurations.ps1` script how the `Set-PSConfig` cmdlet of PSFramework is used to define the configuration for the d365fo.tools module. The configuration is then used by the `Update-ModuleVariables` function to set the default values for several variables in the script scope.

However, not all configurations values are exposed as variables in the script scope. Some are also taken directly from the PSFramework configuration with the `Get-PSFConfig` cmdlet.