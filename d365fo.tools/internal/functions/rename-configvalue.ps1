
<#
    .SYNOPSIS
        Rename the value in the web.config file
        
    .DESCRIPTION
        Replace the old value with the new value inside a web.config file
        
    .PARAMETER File
        Path to the file that you want to update/rename/replace
        
    .PARAMETER NewValue
        The new value that replaces the old value
        
    .PARAMETER OldValue
        The old value that needs to be replaced
        
    .EXAMPLE
        PS C:\> Rename-ConfigValue -File "C:\temp\d365fo.tools\web.config" -NewValue "Demo-8.1" -OldValue "usnconeboxax1aos"
        
        This will open the "C:\temp\d365fo.tools\web.config" file and replace all "usnconeboxax1aos" entries with "Demo-8.1"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Rename-ConfigValue {
    param (
        [string] $File,
        [string] $NewValue,
        [string] $OldValue
    )

    Write-PSFMessage -Level Verbose -Message "Replace content from $File. Old value is $OldValue. New value is $NewValue." -Target (@($File, $OldValue, $NewValue))
    
    (Get-Content $File).replace($OldValue, $NewValue) | Set-Content $File
}