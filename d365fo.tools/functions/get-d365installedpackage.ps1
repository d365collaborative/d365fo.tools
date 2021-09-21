
<#
    .SYNOPSIS
        Get installed package from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed package from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER Name
        Name of the package that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all packages
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed packages
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage
        
        Shows the entire list of installed packages located in the default location on the machine
        
        A result set example:
        ApplicationFoundationFormAdaptor
        ApplicationPlatformFormAdaptor
        ApplicationSuiteFormAdaptor
        ApplicationWorkspacesFormAdaptor
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage -Name "Application*Adaptor"
        
        Shows the list of installed packages where the name fits the search "Application*Adaptor"
        
        A result set example:
        ApplicationFoundationFormAdaptor
        ApplicationPlatformFormAdaptor
        ApplicationSuiteFormAdaptor
        ApplicationWorkspacesFormAdaptor
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage -PackageDirectory "J:\AOSService\PackagesLocalDirectory"
        
        Shows the entire list of installed packages located in "J:\AOSService\PackagesLocalDirectory" on the machine
        
        A result set example:
        ApplicationFoundationFormAdaptor
        ApplicationPlatformFormAdaptor
        ApplicationSuiteFormAdaptor
        ApplicationWorkspacesFormAdaptor
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Model, Models, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
#>
function Get-D365InstalledPackage {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    Write-PSFMessage -Level Verbose -Message "Package directory is: $PackageDirectory" -Target $PackageDirectory
    Write-PSFMessage -Level Verbose -Message "Name is: $Name" -Target $Name

    $Packages = Get-ChildItem -Path $PackageDirectory -Directory -Exclude bin

    foreach ($obj in $Packages) {
        if ($obj.Name -NotLike $Name) { continue }
        [PSCustomObject]@{
            PackageName      = $obj.Name
            PackageDirectory = $obj.FullName
        }
    }
}