
<#
    .SYNOPSIS
        Search for AOT object
        
    .DESCRIPTION
        Enables you to search for different AOT objects
        
    .PARAMETER Path
        Path to the package that you want to work against
        
    .PARAMETER ObjectType
        The type of AOT object you're searching for
        
    .PARAMETER Name
        Name of the object that you're looking for
        
        Accepts wildcards for searching. E.g. -Name "Work*status"
        
        Default value is "*" which will search for all objects
        
    .PARAMETER SearchInPackages
        Switch to instruct the cmdlet to search in packages directly instead
        of searching in the XppMetaData directory under a given package
        
    .PARAMETER IncludePath
        Switch to instruct the cmdlet to include the path for the object found
        
    .EXAMPLE
        PS C:\> Get-D365AOTObject -Name *flush* -ObjectType AxClass -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
        
        This will search inside the ApplicationFoundation package for all AxClasses that matches the search *flush*.
        
    .EXAMPLE
        PS C:\> Get-D365AOTObject -Name *flush* -ObjectType AxClass -IncludePath -Path "C:\AOSService\PackagesLocalDirectory\ApplicationFoundation"
        
        This will search inside the ApplicationFoundation package for all AxClasses that matches the search *flush* and include the full path to the files.
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage -Name Application* | Get-D365AOTObject -Name *flush* -ObjectType AxClass
        
        This searches for all packages that matches Application* and pipes them into Get-D365AOTObject which will search for all AxClasses that matches the search *flush*.
        
    .EXAMPLE
        This is an advanced example and shouldn't be something you resolve to every time.
        
        PS C:\> Get-D365AOTObject -Path "C:\AOSService\PackagesLocalDirectory\*" -Name *flush* -ObjectType AxClass -SearchInPackages
        
        This will search across all packages and will look for the all AxClasses that matches the search *flush*.
        It will NOT search in the XppMetaData directory for each package.
        
        This can stress your system.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365AOTObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
        [Alias('PackageDirectory')]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateSet('AxAggregateDataEntity', 'AxClass', 'AxCompositeDataEntityView',
            'AxDataEntityView', 'AxForm', 'AxMap', 'AxQuery', 'AxTable', 'AxView')]
        [Alias('Type')]
        [string[]] $ObjectType = @("AxClass"),

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, Position = 4)]
        [switch] $SearchInPackages,

        [Parameter(Mandatory = $false, Position = 5)]
        [switch] $IncludePath
    )
    
    begin {
        
    }
    
    process {
        $SearchList = New-Object -TypeName "System.Collections.ArrayList"

        foreach ($item in $ObjectType) {
            if ($SearchInPackages.IsPresent) {
                $SearchParent = Split-Path $Path -Leaf

                $null = $SearchList.Add((Join-Path "$Path" "\$SearchParent\$item\*.xml"))
                $SearchParent = $item #* Hack to make the logic when selecting the output work as expected
            }
            else {
                $SearchParent = "XppMetadata"

                $null = $SearchList.Add((Join-Path "$Path" "\$SearchParent\*\$item\*.xml"))
            }
        }
        
        #* We are searching files - so the last character has to be a *
        if($Name.Substring($Name.Length -1, 1) -ne "*") {$Name = "$Name*"}

        $Files = Get-ChildItem -Path ($SearchList.ToArray()) -Filter $Name

        if($IncludePath.IsPresent) {
            $Files | Select-PSFObject -TypeName "D365FO.TOOLS.AotObject" "BaseName as Name",
            @{Name = "AotType"; Expression = {Split-Path(Split-Path -Path $_.Fullname -Parent) -leaf }},
            @{Name = "Model"; Expression = {Split-Path(($_.Fullname -Split $SearchParent)[0] ) -leaf }},
            "Fullname as Path"
        }
        else {
            $Files | Select-PSFObject -TypeName "D365FO.TOOLS.AotObject" "BaseName as Name",
            @{Name = "AotType"; Expression = {Split-Path(Split-Path -Path $_.Fullname -Parent) -leaf }},
            @{Name = "Model"; Expression = {Split-Path(($_.Fullname -Split $SearchParent)[0] ) -leaf }}
        }
    }
    
    end {
    }
}