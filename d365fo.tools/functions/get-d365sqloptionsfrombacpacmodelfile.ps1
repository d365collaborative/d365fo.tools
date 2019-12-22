
<#
    .SYNOPSIS
        Get the SQL Server options from the bacpac model.xml file
        
    .DESCRIPTION
        Extract the SQL Server options that are listed inside the model.xml file originating from a bacpac file
        
    .PARAMETER Path
        Path to the extracted model.xml file that you want to work against
        
    .EXAMPLE
        PS C:\> Get-D365SqlOptionsFromBacpacModelFile -Path "C:\Temp\model.xml"
        
        This will display all the SQL Server options configured in the bacpac file.
        
    .EXAMPLE
        PS C:\> Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" | Get-D365SqlOptionsFromBacpacModelFile
        
        This will display all the SQL Server options configured in the bacpac file.
        First it will export the model.xml from the "C:\Temp\AxDB.bacpac" file, using the Export-d365ModelFileFromBacpac function.
        The output from Export-d365ModelFileFromBacpac will be piped into the Get-D365SqlOptionsFromBacpacModelFile function.
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365SqlOptionsFromBacpacModelFile {
    [CmdletBinding(DefaultParameterSetName = 'ImportTier1')]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ModelFile')]
        [Alias('File')]
        [string] $Path
    )

    Invoke-TimeSignal -Start

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

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

    Invoke-TimeSignal -End
}