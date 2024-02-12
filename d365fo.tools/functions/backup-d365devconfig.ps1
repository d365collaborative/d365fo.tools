
<#
    .SYNOPSIS
        Backup the DynamicsDevConfig.xml file
        
    .DESCRIPTION
        Will backup the DynamicsDevConfig.xml file located in the PackagesLocalDirectory\Bin folder
        
    .PARAMETER OutputPath
        Path to the folder where you want the DynamicsDevConfig.xml file to be persisted
        
        Default is: "C:\Temp\d365fo.tools\DevConfigBackup"
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Backup-D365DevConfig
        
        Will locate the DynamicsDevConfig.xml file, and back it up.
        It will look for the file in the PackagesLocalDirectory\Bin folder. E.g. K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml.
        It will save the file to the default location: "C:\Temp\d365fo.tools\DevConfigBackup".
        
        A result set example:
        
        Filename              LastModified         File
        --------              ------------         ----
        DynamicsDevConfig.xml 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\DevConfigBackup\DynamicsDevConfig.xml
        
    .EXAMPLE
        PS C:\> Backup-D365DevConfig -Force
        
        Will locate the DynamicsDevConfig.xml file, back it up, and overwrite if a previous backup file exists.
        It will look for the file in the PackagesLocalDirectory\Bin folder. E.g. K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml.
        It will save the file to the default location: "C:\Temp\d365fo.tools\DevConfigBackup".
        It will overwrite any file named DynamicsDevConfig.xml in the destination folder.
        
        A result set example:
        
        Filename              LastModified         File
        --------              ------------         ----
        DynamicsDevConfig.xml 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\DevConfigBackup\DynamicsDevConfig.xml
        
    .NOTES
        Tags: Web Server, IIS, IIS Express, Development
        
        Author: Sander Holvoet (@smholvoet)
        
#>
function Backup-D365DevConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $OutputPath = $(Join-Path $Script:DefaultTempPath "DevConfigBackup"),

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

        $File = $(Join-Path -Path (Join-Path -Path $Script:PackageDirectory -ChildPath "bin") -ChildPath $Script:DevConfig)
    }
    
    process {

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        Backup-File -File $File -DestinationPath $OutputPath -Force:$Force
    }
}