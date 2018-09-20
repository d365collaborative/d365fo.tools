function New-D365ISVLicense {
    [CmdletBinding()]
    param (
        [Alias('Template')]
        [string] $Path = "$Script:BinDirTools\CustomDeployablePackage\ImportISVLicense.zip",

        [Parameter(Mandatory = $true)]        
        [string] $LicenseFile,

        [string] $OutputPath = "C:\temp\d365fo.tools\ISVLicense.zip"

    )

    begin {
        $oldprogressPreference = $global:progressPreference
        $global:progressPreference = 'silentlyContinue'
    }
    
    process {
        #if (-not (Test-PathExists -Path $Path, $LicenseFile -Type "Leaf")) {return}
        #if ((Test-PathExists -Path $OutputPath -Type "Leaf")){
        #     Write-PSFMessage -Level Host -Message "The output file already. Please delete the file or change the desired output path."
        #     Stop-PSFFunction -Message "Stopping because of errors"

        #     $global:progressPreference = $oldprogressPreference
        #     return
        # }

        $Path,$LicenseFile | Unblock-File  

        $ExtractionPath = [System.IO.Path]::GetTempPath()

        $packageTemp = Join-Path $ExtractionPath ((Get-Random -Maximum 99999).ToString())

        Write-PSFMessage -Level Verbose -Message "Extracting the zip file to $packageTemp" -Target $packageTemp
        Expand-Archive -Path $Path -DestinationPath $packageTemp
        $packageTemp

        $licenseMergePath = Join-Path $packageTemp "AosService\Scripts\License"

        $licenseMergePath

        Get-ChildItem -Path $licenseMergePath | Remove-Item -Force -ErrorAction SilentlyContinue

        Copy-Item -Path $LicenseFile -Destination $licenseMergePath

        Compress-Archive -Path "$packageTemp\*" -DestinationPath $OutputPath
    }

    end {
        $global:progressPreference = $oldprogressPreference
    }
}