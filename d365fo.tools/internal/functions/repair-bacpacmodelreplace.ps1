<#
.SYNOPSIS
Repair a bacpac model file - using replace logic

.DESCRIPTION
Will use a search value, to replace an text value from the model file

.PARAMETER Path
Path to the bacpac model file that you want to work against

.PARAMETER OutputPath
Path to where the repaired model file should be placed

.PARAMETER Search
Search pattern that is used to replace the value

Works directly on the value entered, not wildcard or regex is supported at all

E.g. "<Property Name=\"AutoDrop\" Value=\"True\" />"

.PARAMETER Replace
Replace value that you want to substitute your search value with

.EXAMPLE
PS C:\> Repair-BacpacModelReplace -Path c:\temp\model.xml -OutputPath c:\temp\repaired_model.xml -Search "<Property Name=\"AutoDrop\" Value=\"True\" />" -Replace ""

This will replace the below section from the model file

<Property Name="AutoDrop" Value="True" />

.NOTES
Author: Mötz Jensen (@Splaxi)

Json files has to be an array directly in the root of the file. All " (double quotes) has to be escaped with \" - otherwise it will not work as intended.

This cmdlet is inspired by the work of "Brad Bateman" (github: @batetech)
        
        His github profile can be found here:
        https://github.com/batetech

Florian Hopfner did a gist implementation, and did all the inital work in terms of finding the fastest way to work against the model file

The original gist is: https://gist.github.com/FH-Inway/f485c720b43b72bffaca5fb6c094707e

His github profile can be found here:
        https://github.com/FH-Inway
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