
<#
    .SYNOPSIS
        Backup the wif.config file
        
    .DESCRIPTION
        Will backup the wif.config file located in the AOS / IIS folder
        
    .PARAMETER OutputPath
        Path to the folder where you want the web.config file to be persisted
        
        Default is: "C:\Temp\d365fo.tools\WifConfigBackup"
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Backup-D365WifConfig
        
        Will locate the wif.config file, and back it up.
        It will look for the file in the AOS / IIS folder. E.g. K:\AosService\WebRoot\wif.config.
        It will save the file to the default location: "C:\Temp\d365fo.tools\WifConfigBackup".
        
        A result set example:
        
        Filename   LastModified         File
        --------   ------------         ----
        wif.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WifConfigBackup\wif.config
        
    .EXAMPLE
        PS C:\> Backup-D365WifConfig -Force
        
        Will locate the wif.config file, back it up, and overwrite if a previous backup file exists.
        It will look for the file in the AOS / IIS folder. E.g. K:\AosService\WebRoot\wif.config.
        It will save the file to the default location: "C:\Temp\d365fo.tools\WifConfigBackup".
        It will overwrite any file named wif.config in the destination folder.
        
        A result set example:
        
        Filename   LastModified         File
        --------   ------------         ----
        wif.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WifConfigBackup\wif.config
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
        
#>
function Backup-D365WifConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $OutputPath = $(Join-Path $Script:DefaultTempPath "WifConfigBackup"),

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

        $File = $(Join-Path -Path $Script:AOSPath -ChildPath $Script:WifConfig)
    }
    
    process {

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }
        
        if (Test-PSFFunctionInterrupt) { return }
        
        Backup-File -File $File -DestinationPath $OutputPath -Force:$Force

    }
}