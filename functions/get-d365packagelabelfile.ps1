<#
.SYNOPSIS
Get label file from a package

.DESCRIPTION
Get label file (resource file) from the package directory

.PARAMETER PackageDirectory
Path to the package that you want to get a label file from

.PARAMETER Name
Name of the label file you are looking for

Accepts wildcards for searching. E.g. -Name "Fixed*Accounting"

Default value is "*" which will search for all label files

.PARAMETER Language
The language of the label file you are looking for

Accepts wildcards for searching. E.g. -Language "en*"

Default value is "en-US" which will search for en-US language files

.EXAMPLE
Get-D365PackageLabelFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite"

Shows all the label files for ApplicationSuite package

.EXAMPLE
Get-D365PackageLabelFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite" -Name "Fixed*Accounting"

Shows the label files for ApplicationSuite package where the name fits the search "Fixed*Accounting"

.EXAMPLE
Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelFile

Shows all label files (en-US) for the ApplicationSuite package

.NOTES
The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.

#>
function Get-D365PackageLabelFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [Parameter(Mandatory = $true, ParameterSetName = 'Specific', Position = 1 )]
        [Alias('Path')]
        [string] $PackageDirectory,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 2 )]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'Specific', Position = 3 )]
        [string] $Language = "en-US"
    )

    BEGIN {}

    PROCESS {
        $Path = $PackageDirectory

        $files = Get-ChildItem -Path ("$Path\Resources\$Language\*.resources.dll")

        foreach ($obj in $files) {
            if ($obj.Name.Replace(".resources.dll", "") -NotLike $Name) { continue }
            [PSCustomObject]@{
                LabelName    = ($obj.Name).Replace(".resources.dll", "")
                LanguageName = (Get-Command $obj.FullName).FileVersionInfo.Language
                Language     = $obj.directory.basename
                FilePath     = $obj.FullName
            }
        }
    }

    END {}
}