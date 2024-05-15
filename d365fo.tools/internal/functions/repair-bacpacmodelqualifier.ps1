
<#
    .SYNOPSIS
        Repair a bacpac model file - using qualification logic
        
    .DESCRIPTION
        Will use a search pattern, qualification and end pattern, to remove an element from the model file
        
    .PARAMETER Path
        Path to the bacpac model file that you want to work against
        
    .PARAMETER OutputPath
        Path to where the repaired model file should be placed
        
    .PARAMETER Search
        Search pattern that is used to start the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*<Element Type=\"SqlRoleMembership\">*"
        
    .PARAMETER Qualifier
        Qualifier pattern that is used to qualify the element, based on a nested line value
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*<References Name=*ms_db_configwriter*"
        
    .PARAMETER End
        End pattern that is used to conclude the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*</Element>*"
        
    .EXAMPLE
        PS C:\> Repair-BacpacModelQualifier -Path c:\temp\model.xml -OutputPath c:\temp\repaired_model.xml -Search "*<Element Type=\"SqlRoleMembership\">*" -Qualifier "*<References Name=*ms_db_configwriter*" -End "*</Element>*"
        
        This will remove the below section from the model file
        
        <Element Type="SqlRoleMembership">
            <Relationship Name="Member">
            <Entry>
                <References Name="[ms_db_configwriter]" />
            </Entry>
            </Relationship>
            <Relationship Name="Role">
                <Entry>
                    <References ExternalSource="BuiltIns" Name="[db_ddladmin]" />
                </Entry>
            </Relationship>
        </Element>
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        Json files has to be an array directly in the root of the file. All " (double quotes) has to be escaped with \" - otherwise it will not work as intended.
        
        This cmdlet is inspired by the work of "Brad Bateman" (github: @batetech)
        
        His github profile can be found here:
        https://github.com/batetech
        
        Florian Hopfner did a gist implementation, which has been used as the foundation for this implementation
        
        The original gist is: https://gist.github.com/FH-Inway/f485c720b43b72bffaca5fb6c094707e
        
        His github profile can be found here:
        https://github.com/FH-Inway
#>
function Repair-BacpacModelQualifier {
    [CmdletBinding()]
    param (
        [string] $Path,

        [string] $OutputPath,

        [string] $Search,

        [string] $Qualifier,

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
                    # Will buffer all lines going forward, in case we need to keep them in the output file

                    $bufTemp = [System.Collections.Generic.List[string]]::new(20)
                    $bufTemp.Add($line)
                    $foundQualifier = $false

                    while ($stream.Peek() -ge 0) {
                        $line = $stream.ReadLine();
                        
                        $bufTemp.Add($line)
                    
                        if ($line -like $Qualifier) {
                            $foundQualifier = $true
                        }

                        if ($line -like $End) {
                            if (-not $foundQualifier) {
                                # This tells us to keep all the lines that we buffered
                                $buffer.AddRange($bufTemp.ToArray())
                            }

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