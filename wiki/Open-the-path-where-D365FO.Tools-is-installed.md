Execute below command in powershell and an explorer window will open in the correct path

```
explorer.exe (Split-Path (Get-Module d365fo.tools).Path -Parent)
```