
<#
    .SYNOPSIS
        Restore the DynamicsDevConfig.xml file
        
    .DESCRIPTION
        Will restore the DynamicsDevConfig.xml file located in the PackagesLocalDirectory\Bin folder
        
    .PARAMETER Path
        Path to the folder where you the desired DynamicsDevConfig.xml file that you want restored is located
        
        Default is: "C:\Temp\d365fo.tools\DevConfigBackup"
        
    .PARAMETER Force
        Instructs the cmdlet to overwrite the destination file if it already exists
        
    .EXAMPLE
        PS C:\> Restore-D365DevConfig -Force
        
        Will restore the DynamicsDevConfig.xml file, and overwrite the current DynamicsDevConfig.xml file in the PackagesLocalDirectory\Bin folder.
        It will use the default path "C:\Temp\d365fo.tools\DevConfigBackup" as the source directory.
        It will overwrite the current DynamicsDevConfig.xml file.
        
        A result set example:
        
        Filename              LastModified         File
        --------              ------------         ----
        DynamicsDevConfig.xml 6/29/2021 7:31:04 PM K:\AosService\PackagesLocalDirectory\Bin\DynamicsDevConfig.xml
        
    .NOTES
        Tags: Web Server, IIS, IIS Express, Development
        
        Author: Sander Holvoet (@smholvoet)
        
#>
function Restore-D365DevConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [string] $Path = $(Join-Path $Script:DefaultTempPath "DevConfigBackup"),

        [switch] $Force
    )

    begin {
        if ($Path -like "*$($Script:DevConfig)") {
            $sourceFile = $Path
        }
        else {
            $sourceFile = $(Join-Path -Path $Path -ChildPath $Script:DevConfig)
        }
    }
    
    process {

        if (-not (Test-PathExists -Path $sourceFile -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }
    
        $destinationFile = $(Join-Path -Path (Join-Path -Path $Script:PackageDirectory -ChildPath "bin") -ChildPath $Script:DevConfig)

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