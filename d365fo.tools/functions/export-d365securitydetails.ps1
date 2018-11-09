
<#
    .SYNOPSIS
        Extract details from a User Interface Security file
        
    .DESCRIPTION
        Extracts and partitions the security details from an User Interface Security file into the same structure as AOT security files
        
    .PARAMETER FilePath
        Path to the User Interface Security XML file you want to work against
        
    .PARAMETER OutputDirectory
        Path to the folder where the cmdlet will output and structure the details from the file.
        The cmdlet will create a sub folder named like the input file.
        
        Default value is: "C:\temp\d365fo.tools\security-extraction"
        
    .EXAMPLE
        PS C:\> Export-D365SecurityDetails -FilePath C:\temp\d365fo.tools\SecurityDatabaseCustomizations.xml
        
        This will grab all the details inside the "C:\temp\d365fo.tools\SecurityDatabaseCustomizations.xml" file and extract that into the default path "C:\temp\d365fo.tools\security-extraction"
        
    .NOTES
        
        Tags: Security, Configuration, Permission, Development
        
        Author: Mötz Jensen (@splaxi)
        
        The work and design of this cmdlet is based on the findings by Alex Meyer (@alexmeyer_ITGuy).
        
        He wrote about his findings on his blog:
        https://alexdmeyer.com/2018/09/26/converting-d365fo-user-interface-security-customizations-export-to-aot-security-xml-files/
        
        He published a github repository:
        
        https://github.com/ameyer505/D365FOSecurityConverter
        
        All credits goes to Alex Meyer
#>
function Export-D365SecurityDetails {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Path')]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [Alias('Output')]
        [string]$OutputDirectory = "C:\temp\d365fo.tools\security-extraction"
    )
    
    begin { }
    
    process {

        if (-not (Test-PathExists -Path $FilePath -Type Leaf)) { return }
        if (-not (Test-PathExists -Path $OutputDirectory -Type Container)) { return }

        [xml] $xdoc = Get-Content $FilePath
        
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        
        $OutputDirectory = Join-Path $OutputDirectory $fileName

        Write-PSFMessage -Level Verbose -Message "Creating the output directory for the extraction" -Target $OutputDirectory
        $null = New-Item -Path $OutputDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue

        Write-PSFMessage -Level Verbose -Message "Getting all the security objects."
        $secObjects = $xdoc.SelectNodes("/*/*/*/*/*[starts-with(name(),'AxSec')]")

        if ($secObjects.Count -gt 0) {

            Write-PSFMessage -Level Verbose -Message "Looping through all the security objects we found"
            foreach ( $secObject in $secObjects) {
                
                $secPath = Join-Path $OutputDirectory $secObject.LocalName
                
                $null = New-Item -Path $secPath -ItemType Directory -Force -ErrorAction SilentlyContinue

                $secObjectName = $secObject.Name
                
                if (-not ([string]::IsNullOrEmpty($secObjectName))) {
                    $filePathOut = Join-Path $secPath $secObjectName
                    $filePathOut += ".xml"

                    Write-PSFMessage -Level Verbose -Message "Generating the output file: $filePathOut" -Target $filePathOut
                    $secObject.OuterXml | Out-File $filePathOut
                }
            }
        }
    }
    
    end {
    }
}