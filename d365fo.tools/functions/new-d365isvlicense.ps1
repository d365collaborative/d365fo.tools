
<#
    .SYNOPSIS
        Create a license deployable package
        
    .DESCRIPTION
        Create a deployable package with a license file inside
        
    .PARAMETER LicenseFile
        Path to the license file that you want to have inside a deployable package
        
    .PARAMETER Path
        Path to the template zip file for creating a deployable package with a license file
        
        Default path is the same as the aos service "PackagesLocalDirectory\bin\CustomDeployablePackage\ImportISVLicense.zip"
        
    .PARAMETER OutputPath
        Path where you want the generated deployable package stored
        
        Default value is: "C:\temp\d365fo.tools\ISVLicense.zip"
        
    .EXAMPLE
        PS C:\> New-D365ISVLicense -LicenseFile "C:\temp\ISVLicenseFile.txt"
        
        This will take the "C:\temp\ISVLicenseFile.txt" file and locate the "ImportISVLicense.zip" template file under the "PackagesLocalDirectory\bin\CustomDeployablePackage\".
        It will extract the "ImportISVLicense.zip", load the ISVLicenseFile.txt and compress (zip) the files into a deployable package.
        The package will be exported to "C:\temp\d365fo.tools\ISVLicense.zip"
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        Author: Szabolcs Eötvös
        Author: Florian Hopfner (@FH-Inway)
        
#>
function New-D365ISVLicense {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true, Position = 1)]
        [string] $LicenseFile,

        [Alias('Template')]
        [string] $Path = "$Script:BinDirTools\CustomDeployablePackage\ImportISVLicense.zip",

        [string] $OutputPath = "C:\temp\d365fo.tools\ISVLicense.zip"

    )

    begin {
        $oldprogressPreference = $global:progressPreference
        $global:progressPreference = 'silentlyContinue'
    }
    
    process {
        Add-FileToPackage -File $LicenseFile -Archive $Path -Path "AosService\Scripts\License" -OutputPath $OutputPath -ClearPath
    }

    end {
        $global:progressPreference = $oldprogressPreference
    }
}