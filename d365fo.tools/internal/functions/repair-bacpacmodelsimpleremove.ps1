
<#
    .SYNOPSIS
        Repair a bacpac model file - using simple logic
        
    .DESCRIPTION
        Will use a search pattern, and end pattern, to remove an element from the model file
        
    .PARAMETER Path
        Path to the bacpac model file that you want to work against
        
    .PARAMETER OutputPath
        Path to where the repaired model file should be placed
        
    .PARAMETER Search
        Search pattern that is used to start the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*"
        
    .PARAMETER End
        End pattern that is used to conclude the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*</Element>*"
        
    .EXAMPLE
        PS C:\> Repair-BacpacModelSimpleRemove -Path c:\temp\model.xml -OutputPath c:\temp\repaired_model.xml -Search "*<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*" -End "*</Element>*"
        
        This will remove the below section from the model file
        
        <Element Type="SqlPermissionStatement" Name="[Grant.Delete.Object].[ms_db_configreader].[dbo].[dbo].[AutotuneBase]">
        <Property Name="Permission" Value="4" />
        <Relationship Name="Grantee">
        <Entry>
        <References Name="[ms_db_configreader]" />
        </Entry>
        </Relationship>
        <Relationship Name="Grantor">
        <Entry>
        <References ExternalSource="BuiltIns" Name="[dbo]" />
        </Entry>
        </Relationship>
        <Relationship Name="SecuredObject">
        <Entry>
        <References Name="[dbo].[AutotuneBase]" />
        </Entry>
        </Relationship>
        </Element>
        
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