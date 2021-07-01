
<#
    .SYNOPSIS
        Restore the web.config file
        
    .DESCRIPTION
        Will restore the web.config file located back into the AOS / IIS folder
        
    .PARAMETER Path
        Path to the folder where you the desired web.config file that you want restored is located
        
        Default is: "C:\Temp\d365fo.tools\WebConfigBackup"
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Restore-D365WebConfig -Force
        
        Will restore the web.config file, and overwrite the current web.config file in the AOS / IIS folder.
        It will use the default path "C:\Temp\d365fo.tools\WebConfigBackup" as the source directory.
        It will overwrite the current web.config file.
        
        A result set example:
        
        Filename   LastModified         File
        --------   ------------         ----
        web.config 6/29/2021 7:31:04 PM K:\AosService\WebRoot\web.config
        
    .NOTES
        Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Restore-D365WebConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Path = $(Join-Path $Script:DefaultTempPath "WebConfigBackup"),

        [switch] $Force
    )

    begin {
        if ($Path -like "*web.config") {
            $sourceFile = $Path
        }
        else {
            $sourceFile = $(Join-Path -Path $Path -ChildPath $Script:WebConfig)
        }
    }
    
    process {

        if (-not (Test-PathExists -Path $sourceFile -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }
    
        $destinationFile = $(Join-Path -Path $Script:AOSPath -ChildPath $Script:WebConfig)

        if (-not $Force) {
            if ((-not (Test-PathExists -Path $destinationFile -Type Leaf -ShouldNotExist -ErrorAction SilentlyContinue -WarningAction SilentlyContinue))) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$destinationFile</c> already exists. Consider changing the <c='em'>destination</c> path or set the <c='em'>Force</c> parameter to overwrite the file."
                return
            }
        }

        Write-PSFMessage -Level Verbose -Message "Copying from: $sourceFile" -Target $item
        Copy-Item -Path $sourceFile -Destination $destinationFile -Force:$Force -PassThru | Select-PSFObject "Name as Filename", "LastWriteTime as LastModified", "Fullname as File"
    }
}