# Script to generate the comment based markdown help files.
# based on https://gist.github.com/Splaxi/8934e13cb35918d13af6e3a21c208b0e
# See also https://github.com/d365collaborative/d365fo.tools/wiki/Building-tools
$path = "$PSScriptRoot\.."

Import-Module "$path\d365fo.tools" -Force

Remove-Item -Path "$path\docs\*.md"
$null = New-MarkdownHelp -Module $moduleName -OutputFolder "$path\docs" -Force

Get-ChildItem -Path "$path\docs" -Recurse -File | Set-PSMDEncoding