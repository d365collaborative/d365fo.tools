
<#
    .SYNOPSIS
        Update the "model.xml" from the bacpac file to a single table
        
    .DESCRIPTION
        Update the "model.xml" file from inside the bacpac file to only handle a single table
        
        This can be used to restore a single table as fast as possible to a new data

        The table will be created like ordinary bacpac restore, expect it will only have the raw table definition and indexes, all other objects are dropped
        
        The output can be used directly with the Import-D365Bacpac cmdlet and its ModelFile parameter, see the example sections for more details

    .PARAMETER Path
        Path to the bacpac file that you want to work against
        
        It can also be a zip file
        
    .PARAMETER Table
        Name of the table that you want to be kept inside the model file when the update is done

    .PARAMETER Schema
        Schema where the table that you want to work against exists

        The default value is "dbo"

    .PARAMETER OutputPath
        Path to where you want the updated bacpac model file to be saved
        
    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite the bacpac model file specified in the OutputPath
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Import, Table, Troubleshooting
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Update-D365BacpacModelFileSingleTable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('ModelFile')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [string] $Table,

        [string] $Schema = "dbo",

        [string] $OutputPath = $Script:DefaultTempPath,

        [switch] $Force
    )
    
    begin {
        Invoke-TimeSignal -Start

        if ([System.IO.File]::GetAttributes($OutputPath).HasFlag([System.IO.FileAttributes]::Directory)) {
            $OutputPath = Join-Path -Path $OutputPath -ChildPath "$Schema.$Table.model.xml"
        }
        
        if (-not $Force) {
            if ((-not (Test-PathExists -Path $OutputPath -Type Leaf -ShouldNotExist -ErrorAction SilentlyContinue -WarningAction SilentlyContinue))) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$OutputPath</c> already exists. Consider changing the <c='em'>OutputPath</c> path or set the <c='em'>Force</c> parameter to overwrite the file."
                return
            }
        }

        if (Test-PSFFunctionInterrupt) { return }

        if ($Schema -NotLike "[*]") {
            $Schema = "[$Schema]"
        }
        
        if ($Table -NotLike "[*]") {
            $Table = "[$Table]"
        }
    }

    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }
        
        $xmlFile = [System.Xml.XmlReader]::Create($Path)

        $settings = [System.Xml.XmlWriterSettings]::new()
        $settings.Indent = $true
        $settings.Encoding = [System.Text.UTF8Encoding]::new($false)
        $outFile = [System.Xml.XmlWriter]::Create($OutputPath, $settings)

        while ($xmlFile.Read()) {

            if ($xmlFile.NodeType -in "XmlDeclaration", "ProcessingInstruction") {
                $outFile.WriteProcessingInstruction($xmlFile.Name, $xmlFile.Value)
            }
            elseif ($xmlFile.NodeType -eq "Element" -and $xmlFile.Name -eq "DataSchemaModel") {
                $outFile.WriteStartElement($xmlFile.name, "http://schemas.microsoft.com/sqlserver/dac/Serialization/2012/02")
                if ($xmlFile.HasAttributes) {
                    while ($xmlFile.MoveToNextAttribute()) {
                        if ($xmlFile.name -ne "xmlns") {
                            $outFile.WriteAttributeString($xmlFile.Name, $xmlFile.Value)
                        }
                    }
                }
            }
            elseif ($xmlFile.NodeType -eq "Element" -and $xmlFile.Name -eq "Model") {
                $outFile.WriteStartElement($xmlFile.name)
            }
            elseif ($xmlFile.NodeType -eq "Element" -and $xmlFile.Depth -eq 2) {
                $rawElement = $($xmlFile.ReadOuterXml() -replace 'xmlns=".*"', '')
                if (-not $rawElement -match 'Type="(?<Type>.*?)".*?>') {
                    continue
                }
        
                if ($Matches.Type -NotIn "SqlSchema", "SqlTable", "SqlDatabaseOptions", "SqlGenericDatabaseScopedConfigurationOptions", "SqlIndex") {
                    continue
                }
        
                if ($Matches.Type -eq "SqlSchema") {
                    if (-not $rawElement -match 'Name="(?<Name>.*?)".*?>') {
                        continue
                    }
        
                    if ($Matches.Name -ne $Schema) {
                        continue
                    }
                }
                elseif ($Matches.Type -eq "SqlTable") {
                    if (-not $rawElement -match 'Name="(?<Name>.*?)".*?>') {
                        continue
                    }
                    
                    if ($Matches.Name -ne "$Schema.$Table") {
                        continue
                    }
        
                    $rawElement = $rawElement -replace "\s*.*<AttachedAnnotation Disambiguator=`".*`".*/>", ""
                }
                elseif ($Matches.Type -eq "SqlIndex") {
                    if (-not $rawElement -match 'Name="(?<Name>.*?)".*?>') {
                        continue
                    }
                    
                    if (-not $Matches.Name.StartsWith("$Schema.$Table", [System.StringComparison]::InvariantCultureIgnoreCase)) {
                        continue
                    }
                }
                $outFile.WriteRaw($rawElement)
            }
            else {
                if ($xmlFile.NodeType -eq "EndElement" -and $xmlFile.Name -in "Model", "DataSchemaModel") {
                    $outFile.WriteEndElement()
                }
            }
        }

        [PSCustomObject]@{
            File     = $OutputPath
            Filename = $(Split-Path -Path $OutputPath -Leaf)
        }
    }
    
    end {
        if ($outFile) {

            $outFile.Flush()
            $outFile.Close()
            $outFile.Dispose()
        }

        if ($xmlFile) {
            $xmlFile.Close()
            $xmlFile.Dispose()
        }

        Invoke-TimeSignal -End
    }
}