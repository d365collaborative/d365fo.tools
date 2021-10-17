When we release a new version of the module all functions are compiled into one big **commands.ps1** file. This is because we want the module to load as fast as possible.

It has some drawbacks in relation to troubleshooting and tinkering with the module after you have installed it from www.powershellgallery.com

If you need to change any on the functions on the machine where you installed the module, you can adjust the loading logic, before loading the module and have it load every single function from its source file instead of the compiled commands.ps1.

### **Note**
**Exit** you current powershell console and start a entirely fresh powershell console, **without** loading the module.

```
Set-PSFConfig d365fo.tools.Import.IndividualFiles -Value $true
Set-PSFConfig d365fo.tools.Import.DoDotSource -Value $true 
Import-Module d365fo.tools -Force -Passthru
```