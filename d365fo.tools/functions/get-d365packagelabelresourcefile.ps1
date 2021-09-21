
<#
    .SYNOPSIS
        Get label / resource file from a package
        
    .DESCRIPTION
        Get label (resource) file from the package directory of a Dynamics 365 Finance & Operations environment
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed packages
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER Name
        Name of the label (resource) file you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Fixed*Accounting"
        
        Default value is "*" which will search for all label files
        
    .PARAMETER Language
        The language of the label file you are looking for
        
        Accepts wildcards for searching. E.g. -Language "en*"
        
        Default value is "en-US" which will search for en-US language files
        
    .EXAMPLE
        PS C:\> Get-D365PackageLabelResourceFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite"
        
        Shows all the label files for ApplicationSuite package
        
    .EXAMPLE
        PS C:\> Get-D365PackageLabelResourceFile -PackageDirectory "C:\AOSService\PackagesLocalDirectory\ApplicationSuite" -Name "Fixed*Accounting"
        
        Shows the label files for ApplicationSuite package where the name fits the search "Fixed*Accounting"
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelResourceFile
        
        Shows all label files (en-US) for the ApplicationSuite package
        
    .NOTES
        Tags: PackagesLocalDirectory, Label, Labels, Language, Development, Servicing, Module, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
#>
function Get-D365PackageLabelResourceFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Specific')]
        [Alias('Path')]
        [string] $PackageDirectory,

        [string] $Name = "*",

        [string] $Language = "en-US"
    )

    BEGIN {}

    PROCESS {
        $Path = $PackageDirectory

        if (Test-Path "$Path\Resources\$Language") {
        
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
        else {
            Write-PSFMessage -Level Verbose -Message "Skipping `"$("$Path\Resources\$Language")`" because it doesn't exist."
        }
    }

    END {}
}