
<#
    .SYNOPSIS
        Get a backup name for the file
        
    .DESCRIPTION
        Generate a backup name for the file parsed
        
    .PARAMETER File
        Path to the file that you want a backup name for
        
    .PARAMETER Suffix
        The name that you want to put into the new backup file name
        
    .EXAMPLE
        PS C:\> Get-BackupName -File "C:\temp\d365do.tools\Test.txt" -Suffix "Original"
        
        The function will return "C:\temp\d365do.tools\Test_Original.txt"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-BackupName {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [string] $File,

        [Parameter(Mandatory = $true)]
        [string] $Suffix
    )

    Write-PSFMessage -Level Verbose -Message "Getting backup name for file: $File" -Tag $File

    $FileInfo = [System.IO.FileInfo]::new($File)

    $BackupName = "{0}{1}_{2}{3}" -f $FileInfo.Directory, $FileInfo.BaseName, $Suffix, $FileInfo.Extension
    
    Write-PSFMessage -Level Verbose -Message "Backup name for the file will be $BackupName" -Tag $BackupName
    
    $BackupName
}