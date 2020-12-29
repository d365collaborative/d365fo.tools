
<#
    .SYNOPSIS
        Get the SQL Server options from the bacpac model.xml file
        
    .DESCRIPTION
        Extract the SQL Server options that are listed inside the model.xml file originating from a bacpac file
        
    .PARAMETER Path
        Path to the extracted model.xml file that you want to work against
        
    .EXAMPLE
        PS C:\> Get-D365BacpacSqlOptions -Path "c:\temp\d365fo.tools\bacpac.model.xml"
        
        This will display all the SQL Server options configured in the bacpac model file.
        
    .EXAMPLE
        PS C:\> Export-D365BacpacModelFile -Path "c:\Temp\AxDB.bacpac" | Get-D365BacpacSqlOptions
        
        This will display all the SQL Server options configured in the bacpac file.
        First it will export the model.xml from the "c:\Temp\AxDB.bacpac" file, using the Export-D365BacpacModelFile function.
        The output from Export-D365BacpacModelFile will be piped into the Get-D365BacpacSqlOptions function.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365BacpacSqlOptions {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Alias("Get-D365SqlOptionsFromBacpacModelFile")]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [Alias('ModelFile')]
        [Alias('File')]
        [string] $Path
    )

    begin {
        Invoke-TimeSignal -Start
    }

    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }
    
        $reader = [System.Xml.XmlReader]::Create($Path)

        $break = $false
        while ($reader.read() -and -not ($break)) {
            switch ($reader.NodeType) {
                ([System.Xml.XmlNodeType]::Element) {
                    if ($reader.Name -eq "Element") {
                        if ($reader.GetAttribute("Type") -eq "SqlDatabaseOptions") {
                            if ($reader.ReadToDescendant("Property")) {
                                do {
                                    [PSCustomObject]@{OptionName = $reader.GetAttribute("Name")
                                        OptionValue              = $reader.GetAttribute("Value")
                                    }

                                } while ($reader.ReadToNextSibling("Property"))

                            }

                            $break = $true
                            break
                        }
                    }

                    break
                }
            }
        }
    }

    end {
        if ($reader) {
            $reader.Close()
            $reader.Dispose()
        }

        Invoke-TimeSignal -End
    }
}