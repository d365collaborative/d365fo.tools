
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