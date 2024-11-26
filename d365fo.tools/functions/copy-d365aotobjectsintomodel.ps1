<#
    .SYNOPSIS
    Import objects from a model into a designated model in Dynamics 365 Finance and Operations

    Import a model into Dynamics 365 for Finance & Operations

    .DESCRIPTION
    Import objects from a model into a designated model in Dynamics 365 Finance and Operations environment

    Import a model into a Dynamics 365 for Finance & Operations environment

    .PARAMETER Path
    Path to the axmodel file that you want to import

    .PARAMETER Name
    Name of the model that you want to work against

    .PARAMETER PackageDirectory
    The path to the package directory for the environment
        
    Default path is the same as the AOS service PackagesLocalDirectory
    
    Default value is fetched from the current configuration on the machine

    .PARAMETER Force
    Instruct the cmdlet to overwrite the extracted files

    .EXAMPLE
    PS C:\> Copy-D365AotObjectsIntoModel -Path "c:\temp\d365fo.tools\CustomModel.axmodel" -Name TestModel

    This will extract the files in the model into the PackageLocalDirectory location

    .EXAMPLE
    PS C:\> Copy-D365AotObjectsIntoModel -Path "c:\temp\d365fo.tools\CustomModel.axmodel" -Name TestModel -PackageDirectory "C:\AosService\PackagesLocalDirectory"

    This will extract the files in the model into the PackageLocalDirectory location

    .NOTES
    
    Author: Morten Knudsen
#>
function Copy-D365AotObjectsIntoModel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $True)]
        [Alias("Model")]
        [string] $Name,

        [string] $PackageDirectory = $Script:PackageDirectory,

        [switch] $Force
    )

    begin {
        if (-not (Test-PathExists -Path "$PackageDirectory\$Name\$Name" -Type Container)) { return }

        if (Test-PSFFunctionInterrupt) { return }
    }

    process {

        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $file = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open)
        $zipArch = [System.IO.Compression.ZipArchive]::new($file, [System.IO.Compression.ZipArchiveMode]::Read)

        $files = $zipArch.Entries | Where-Object { $_.name -ne "PackageManifest.xml" -and $_.FullName -notlike "*Descriptor*" }
    
        $collPaths = New-Object System.Collections.Generic.List[System.Object]

        foreach ($item in $files) {
            Write-PSFMessage -Level Verbose -Message "Working on: $($item.Name)"

            $filepathToObjectFolderRelative = $($item.FullName.split("/") | Select-Object -Skip 3) -join "\"
        
            $filePath = "$PackageDirectory\$Name\$Name\$filepathToObjectFolderRelative"

            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($filePath)) > $null

            if ($Force) {
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($item, $filePath, $True) > $null
            }
            else {
                if (-not (Test-PathExists -Path $filePath -Type Leaf -ShouldNotExist)) {
                    Write-PSFMessage -Level Host -Message "The <c='em'>$filePath</c> already exists. Consider changing the <c='em'>destination</c> path or set the <c='em'>Force</c> parameter to overwrite the file."
                    return
                }

                $collPaths.Add(@{Entry = $item; Path = $filePath })
            }
        }

        foreach ($item in $collPaths) {
            [System.IO.Compression.ZipFileExtensions]::ExtractToFile($item.Entry, $item.Path, $True) > $null
        }
    }

    end {
        Write-PSFMessage -Level Verbose -Message "Extraction completed."

        if ($zipArch) {
            Write-PSFMessage -Level Verbose -Message "Closing and saving the file."
            $zipArch.Dispose()
        }

        if ($file) {
            $file.Close()
            $file.Dispose()
        }
    }
}