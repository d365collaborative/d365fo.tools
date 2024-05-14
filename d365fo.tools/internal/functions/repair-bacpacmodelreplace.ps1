<#
."C:\GIT\GITHUB\d365fo.tools.Workspace\d365fo.tools\d365fo.tools\internal\functions\repair-bacpacmodelreplace.ps1"
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Path
Parameter description

.PARAMETER OutputPath
Parameter description

.PARAMETER Search
Parameter description

.PARAMETER Replace
Parameter description

.EXAMPLE
An example

.NOTES
General notes

Repair-BacpacModelReplace -Path "C:\Temp\INOX\Bacpac\Base.xml" -OutputPath "C:\Temp\INOX\Bacpac\Working.xml" -Search '<Property Name="IsArithAbortOn" Value="True" />' -Replace ''
#>
function Repair-BacpacModelReplace {
    [CmdletBinding()]
    param (
        [string] $Path,

        [string] $OutputPath,

        [string] $Search,

        [string] $Replace
    )
    
    [int]$flushCounter = 500000

    $buffer = [System.Collections.Generic.List[string]]::new($flushCounter) #much faster than PS array using +=
    $bufferCounter = 0;
    
    try {
        $stream = [System.IO.StreamReader]::new($Path)

        :LineLoop while ($stream.Peek() -ge 0) {
            $line = $stream.ReadLine()
        
            # Skipping empty lines
            if (-not [string]::IsNullOrEmpty($line)) {
                # Replace on all lines - simpler code
                $buffer.Add($line.Replace($Search, $Replace))
            }
            else {
                $buffer.Add($line)
            }

            $bufferCounter++;
            if ($bufferCounter -ge $flushCounter) {
                $buffer | Add-Content -LiteralPath $OutputPath -Encoding UTF8
                $buffer = [System.Collections.Generic.List[string]]::new($flushCounter);
                $bufferCounter = 0;
            }
        }
    }
    finally {
        # We need to close the stream object, to release the file system lock on the input file
        $stream.Close()
        $stream.Dispose()
    }

    #flush anything still remaining in the buffer
    if ($bufferCounter -gt 0) {
        $buffer | Add-Content -LiteralPath $OutputPath -Encoding UTF8
        $buffer = $null;
        $bufferCounter = 0;
    }
}