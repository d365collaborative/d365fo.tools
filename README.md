# **d365fo.tools**

A PowerShell module to handle different management tasks related to Microsoft Dynamics 365 Finance & Operations (D365FO).
Read more about D365FO on [docs.microsoft.com](https://docs.microsoft.com/en-us/dynamics365/unified-operations/fin-and-ops/index).

Available on PowerShell Gallery:
[d365fo.tools](https://www.powershellgallery.com/packages/d365fo.tools).

## Table of contents
* [Getting started](#getting-started)
* [Getting help](#getting-help)
* [Contributing](#contributing)
* [Dependencies](#dependencies)

## Getting started
### Install the latest module
```PowerShell
Install-Module -Name d365fo.tools
```

### Install without administrator privileges
```PowerShell
Install-Module -Name d365fo.tools -Scope CurrentUser
```
### List all available commands / functions

```PowerShell
Get-Command -Module d365fo.tools
```

### Update the module

```PowerShell
Update-Module -name d365fo.tools
```

### Update the module - force

```PowerShell
Update-Module -name d365fo.tools -Force
```
## Getting help

[The wiki](https://github.com/d365collaborative/d365fo.tools/wiki) contains more details about installation and also guides to help you with some common tasks. It also contains documentation for all the module's commands. Expand the wiki's `Pages` control at the top of the content sidebar to view and search the list of command documentation pages.

Another way to learn about the different cmdlets available is to install the tools onto your D365FO developer box.
You can also visit the **'docs'** folder in this repository (look at the top). Click this link [**docs**](https://github.com/d365collaborative/d365fo.tools/tree/master/docs) to jump straight inside.

Since the project started we have adopted and extended the comment based help inside each cmdlet / function. This means that every single command contains at least one fully working example on how to run it and what to expect from the cmdlet.

If you are just starting out with the module (and maybe with PowerShell as well), consider setting the [`$ConfirmPreference`](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables#confirmpreference) to `Medium` or `Low`. This will increase the number of prompts you will receive to confirm executing a command. It will help to avoid accidentally running a command that you didn't intend to run.

**Getting help inside the PowerShell console**

Getting help is as easy as writing **Get-Help CommandName**

```PowerShell
Get-Help New-D365Bacpac
```

*This will display the available default help.*

Getting the entire help is as easy as writing **Get-Help CommandName -Full**

```PowerShell
Get-Help New-D365Bacpac -Full
```

*This will display all available help content there is for the cmdlet / function*

Getting all the available examples for a given command is as easy as writing **Get-Help CommandName -Examples**

```PowerShell
Get-Help New-D365Bacpac -Examples
```

*This will display all the available **examples** for the cmdlet / function.*

We know that when you are learning about new stuff and just want to share your findings with your peers, working with help inside a PowerShell session isn't that great.

### Web based help and examples
We have implemented **platyPS** (https://github.com/PowerShell/platyPS) to generate markdown files for each cmdlet / function available in the module. These files are hosted here on github for you to consume in your web browser and the give you the look and feel of other documentation sites.

The generated help markdown files are located inside the **'docs'** folder in this repository. Click this [link](https://github.com/d365collaborative/d365fo.tools/tree/master/docs) to jump straight inside.

They are also available in the [wiki](https://github.com/d365collaborative/d365fo.tools/wiki) in the list of pages.

For sake of the sanity and just trying to help people out, we copy & pasted **all** the old examples previously available in the readme into the wiki. The page is located [here](https://github.com/d365collaborative/d365fo.tools/wiki/Old-readme-examples). We **don't** plan on keep the **"Old readme examples"** wiki up-to-date going forward. If you believe we are missing some examples that should be part of the comment based help, please create an issue.

## Contributing

Want to contribute to the project? We'd love to have you! Visit our [contributing.md](https://github.com/d365collaborative/d365fo.tools/blob/master/contributing.md) for a jump start.

## Dependencies

This module depends on other modules. The dependencies are documented in the [dependency graph](https://github.com/d365collaborative/d365fo.tools/network/dependencies) and the Dependencies section of the Package Details of the [package listing](https://www.powershellgallery.com/packages/d365fo.tools) in the PowerShell Gallery.
