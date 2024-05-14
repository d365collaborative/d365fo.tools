<#
."C:\GIT\GITHUB\d365fo.tools.Workspace\d365fo.tools\d365fo.tools\internal\functions\repair-bacpacmodelsimpleremove.ps1"
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

.PARAMETER End
Parameter description

.EXAMPLE
An example

.NOTES
General notes

Repair-BacpacModelSimpleRemove -Path "C:\Temp\INOX\Bacpac\Base.xml" -OutputPath "C:\Temp\INOX\Bacpac\Working.xml" -Search '*<Element Type="SqlPermissionStatement"*ms_db_configreader*' -End '*</Element>*'
Repair-BacpacModelSimpleRemove -Path "C:\Temp\INOX\Bacpac\Base.xml" -OutputPath "C:\Temp\INOX\Bacpac\Working.xml" -Search '*<Element Type="SqlPermissionStatement"*ms_db_configwriter*' -End '*</Element>*'

#>
function Repair-BacpacModelSimpleRemove {
    [CmdletBinding()]
    param (
        [string] $Path,

        [string] $OutputPath,

        [string] $Search,

        [string] $End
        
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

                if ($line -like $Search) {
                    # We hit search pattern, will read lines until hitting the end pattern.
                    # AKA - simply remove lines until finding it.
                    
                    while ($stream.Peek() -ge 0) {
                        $line = $stream.ReadLine();
                        
                        if ($line -like $End) {
                            continue LineLoop
                        }
                    }
                }
            
                # Persisting all lines that didn't meet the search pattern
                $buffer.Add($line)
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