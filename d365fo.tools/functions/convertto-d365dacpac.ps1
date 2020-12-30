
<#
    .SYNOPSIS
        Convert bacpac file to dacpac
        
    .DESCRIPTION
        Convert bacpac file to dacpac
        
        It will extract the origin.xml file from the file, and set the <ContainsExportedData>false</ContainsExportedData> for the file to be valid to be used as a dacpac file
        
    .PARAMETER Path
        Path to the bacpac file that you want to work against
        
        It can also be a zip file
        
    .NOTES
        Tags: Bacpac, Servicing, Data, SqlPackage, Dacpac, Table
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function ConvertTo-D365Dacpac {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path
    )
    
    begin {
    }

    process {
    }
    
    end {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        if (Test-PSFFunctionInterrupt) { return }

        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($Path)

        $OutputPath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath "Origin.xml"

        if (Test-PSFFunctionInterrupt) { return }

        $file = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open)

        $zipArch = [System.IO.Compression.ZipArchive]::new($file, [System.IO.Compression.ZipArchiveMode]::Update)
        
        $originEntry = $zipArch.GetEntry("Origin.xml")

        if (-not $originEntry) {
            $messageString = "Unable to find the <c='em'>Origin.xml</c> file inside the archive. It would indicate the <c='em'>$Path</c> isn't a valid bacpac or dacpac."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because Origin.xml wasn't found." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        }
        
        if (Test-PSFFunctionInterrupt) { return }

        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($originEntry, $OutputPath, $true)
        
        $originEntry.delete()
        
        $content = Get-Content -Path $OutputPath -Raw

        $content = $content -replace "<ContainsExportedData>true</ContainsExportedData>", "<ContainsExportedData>false</ContainsExportedData>"

        $content | Out-File -FilePath $OutputPath -Encoding utf8 -Force

        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zipArch, $OutputPath, "Origin.xml") > $null
            
        if ($zipArch) {
            $zipArch.Dispose()
        }

        if ($file) {
            $file.Close()
            $file.Dispose()
        }

        Rename-Item -Path $Path -NewName "$($fileName).dacpac"

        [PSCustomObject]@{
            File     = $Path.Replace("bacpac", "dacpac")
            Filename = "$($fileName).dacpac"
        }
    }
}