
<#
    .SYNOPSIS
        Repair a bacpac model file - using simple remove AND replace logic
        
    .DESCRIPTION
        Will use a search pattern, and end pattern, to remove an element from the model file
        
        Will use a search pattern, with the replacement value, to replace the string within the model file
        
    .PARAMETER Path
        Path to the bacpac model file that you want to work against
        
    .PARAMETER OutputPath
        Path to where the repaired model file should be placed
        
    .PARAMETER RemoveInstructions
        Search pattern that is used to start the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*<Element Type=\"SqlPermissionStatement\"*ms_db_configreader*"
        
        End pattern that is used to conclude the removable of the element
        
        Supports wildcard - as it utilizes the -Like operation that is available directly in powershell
        
        E.g. "*</Element>*"
        
    .PARAMETER ReplaceInstructions
        Search pattern that is used to replace the value
        
        Works directly on the value entered, no wildcard or regex is supported at all
        
        E.g. "<Property Name=\"AutoDrop\" Value=\"True\" />"
        
        Replace value that you want to substitute your search value with
        
        E.g. ""
        
    .EXAMPLE
        PS C:\> $removeIns1 = [pscustomobject][ordered]@{Search = '*<Element Type="SqlPermissionStatement"*ms_db_configreader*';End = '*</Element>*'}
        PS C:\> $replace1 = [pscustomobject][ordered]@{Search = '<Property Name="AutoDrop" Value="True" />';Replace = ''}
        PS C:\> Repair-BacpacModelSimpleAndReplace -Path c:\temp\model.xml -OutputPath c:\temp\repaired_model.xml -RemoveInstructions @($removeIns1) -ReplaceInstructions @($replace1)
        
        This will remove the below section from the model file, based on the RemoveInstructions:
        
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
        
        This will remove the below section from the model file, based on the ReplaceInstructions:
        
        <Property Name="AutoDrop" Value="True" />
        
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
        
        https://devblog.pekspro.com/posts/multiple-find-and-replace-with-powershell
#>
function Repair-BacpacModelSimpleAndReplace {
    [CmdletBinding()]
    param (
        [string] $Path,

        [string] $OutputPath,

        [Object[]] $RemoveInstructions,

        [Object[]] $ReplaceInstructions
    )
    Invoke-TimeSignal -Start
    
    Write-PSFMessage -Level Verbose -Message "RemoveInstructions count is: $($RemoveInstructions.Count)" -Target $RemoveInstructions
    Write-PSFMessage -Level Verbose -Message "ReplaceInstructions count is: $($ReplaceInstructions.Count)" -Target $ReplaceInstructions
    
    [int]$flushCounter = 500000

    $buffer = [System.Collections.Generic.List[string]]::new($flushCounter) #much faster than PS array using +=
    $bufferCounter = 0;
    
    try {
        $stream = [System.IO.StreamReader]::new($Path)

        :LineLoop while ($stream.Peek() -ge 0) {
            $line = $stream.ReadLine()
        
            # Skipping empty lines
            if (-not [string]::IsNullOrEmpty($line)) {

                # Implement Replace Logic directly here - so we only handle replace once, if the line contains data..
                foreach ($ReplaceIns in $ReplaceInstructions) {
                    $line = $line.Replace($ReplaceIns.Search, $ReplaceIns.Replace)
                }

                foreach ($remove in $RemoveInstructions) {
                    
                    if ($line -like $remove.Search) {
                        # We found the search pattern - next is just removing lines, until we find the end pattern

                        while ($stream.Peek() -ge 0) {
                            $line = $stream.ReadLine();

                            if ($line -like $remove.End) {
                                # We found the end tag, so we need to start the line loop again.
                                continue LineLoop
                            }
                        }
                    }
                }
            
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
        $stream.Close()
        $stream.Dispose()
    }

    # Flush anything still remaining in the buffer
    if ($bufferCounter -gt 0) {
        $buffer | Add-Content -LiteralPath $OutputPath -Encoding UTF8
        $buffer = $null;
        $bufferCounter = 0;
    }

    Invoke-TimeSignal -End
}