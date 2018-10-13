<#
.SYNOPSIS
Create a license deployable package

.DESCRIPTION
Create a license deployable package based on a template

.PARAMETER Path
Path to the zip file that contains the template needed to build your own license deployable package

Default path is the same as the aos service PackagesLocalDirectory\bin\CustomDeployablePackage\ImportISVLicense.zip

.PARAMETER LicenseFile
Path to the license file (txt) file that you want to slipstream into your deployable package

.PARAMETER OutputPath
Path to where the output from the creation process should be saved.

Default value is "C:\temp\d365fo.tools\ISVLicense.zip"

.EXAMPLE
New-D365ISVLicense -LicenseFile c:\temp\SuperISVSolution.txt

This will use the default zip file stored under PackagesLocalDirectory\bin\CustomDeployablePackage containing the template for ISV license deployable packages.
It will copy the "c:\temp\SuperISVSolution.txt" into the new deployable package.
When done, it will save the new deployable package into the default output path "C:\temp\d365fo.tools\ISVLicense.zip".

.NOTES
Author: Mötz Jensen (@Splaxi)

#>
function New-D365ISVLicense {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    
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

        $Path, $LicenseFile | Unblock-File  

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