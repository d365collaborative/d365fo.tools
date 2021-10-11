
<#
    .SYNOPSIS
        Backup the web.config file
        
    .DESCRIPTION
        Will backup the web.config file located in the AOS / IIS folder
        
    .PARAMETER OutputPath
        Path to the folder where you want the web.config file to be persisted
        
        Default is: "C:\Temp\d365fo.tools\WebConfigBackup"
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Backup-D365WebConfig
        
        Will locate the web.config file, and back it up.
        It will look for the file in the AOS / IIS folder. E.g. K:\AosService\WebRoot\web.config.
        It will save the file to the default location: "C:\Temp\d365fo.tools\WebConfigBackup".
        
        A result set example:
        
        Filename   LastModified         File
        --------   ------------         ----
        web.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WebConfigBackup\web.config
        
    .EXAMPLE
        PS C:\> Backup-D365WebConfig -Force
        
        Will locate the web.config file, back it up, and overwrite if a previous backup file exists.
        It will look for the file in the AOS / IIS folder. E.g. K:\AosService\WebRoot\web.config.
        It will save the file to the default location: "C:\Temp\d365fo.tools\WebConfigBackup".
        It will overwrite any file named web.config in the destination folder.
        
        A result set example:
        
        Filename   LastModified         File
        --------   ------------         ----
        web.config 6/29/2021 7:31:04 PM C:\temp\d365fo.tools\WebConfigBackup\web.config
        
    .NOTES
        Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Backup-D365WebConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $OutputPath = $(Join-Path $Script:DefaultTempPath "WebConfigBackup"),

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

        $File = $(Join-Path -Path $Script:AOSPath -ChildPath $Script:WebConfig)
    }
    
    process {

        if (-not (Test-PathExists -Path $File -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }
    
        $fileName = Split-Path -Path $File -Leaf
        $destinationFile = $(Join-Path -Path $OutputPath -ChildPath $fileName)

        if (-not $Force) {
            if ((-not (Test-PathExists -Path $destinationFile -Type Leaf -ShouldNotExist -ErrorAction SilentlyContinue -WarningAction SilentlyContinue))) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$destinationFile</c> already exists. Consider changing the <c='em'>destination</c> path or set the <c='em'>Force</c> parameter to overwrite the file."
                return
            }
        }

        Write-PSFMessage -Level Verbose -Message "Copying from: $File" -Target $item
        Copy-Item -Path $File -Destination $destinationFile -Force:$Force -PassThru | Select-PSFObject "Name as Filename", "LastWriteTime as LastModified", "Fullname as File"
    }
}