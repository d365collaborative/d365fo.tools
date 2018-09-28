function Export-D365SecurityDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Path')]
        [string]$FilePath,

        [Parameter(Mandatory = $false)]
        [Alias('Output')]
        [string]$OutputDirectory = "C:\temp\d365fo.tools\security-extraction"
    )
    
    begin {        
        $ObjectsToScan = @("AxSecurityRole", "AxSecurityDuty", "AxSecurityPrivilege")
    }
    
    process {

        if (-not (Test-PathExists -Path $FilePath -Type Leaf)) { return }
        if (-not (Test-PathExists -Path $OutputDirectory -Type Container)) { return }

        [xml] $xdoc = Get-Content $FilePath    
        
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
        
        $OutputDirectory = Join-Path $OutputDirectory $fileName

        Write-PSFMessage -Level Verbose -Message "Creating the output directory for the extraction" -Target $OutputDirectory
        New-Item -Path $OutputDirectory -ItemType Directory -Force -ErrorAction SilentlyContinue

        Write-PSFMessage -Level Verbose -Message "Looping through all the security objects we want to know about" -Target $OutputDirectory
        foreach ($item in $ObjectsToScan) {
            
            $secObjects = $xdoc.SelectNodes("//$item")
        
            if ($secObjects.Count -gt 0) {
                $secPath = Join-Path $OutputDirectory $item
                
                New-Item -Path $secPath -ItemType Directory -Force -ErrorAction SilentlyContinue

                foreach ( $secObject in $secObjects) {
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
    }
    
    end {
    }
}