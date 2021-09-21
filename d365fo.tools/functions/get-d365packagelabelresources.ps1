
<#
    .SYNOPSIS
        Get label from the resource file
        
    .DESCRIPTION
        Get label details from the resource file for a Dynamics 365 Finance & Operations environment
        
    .PARAMETER FilePath
        The path to resource file that you want to get label details from
        
    .PARAMETER Name
        Name of the label you are looking for
        
        Accepts wildcards for searching. E.g. -Name "@PRO*"
        
        Default value is "*" which will search for all labels in the resource file
        
    .PARAMETER Value
        Value of the label you are looking for
        
        Accepts wildcards for searching. E.g. -Name "*Qty*"
        
        Default value is "*" which will search for all values in the resource file
        
    .PARAMETER IncludePath
        Switch to indicate whether you want the result set to include the path to the resource file or not
        
        Default is OFF - path details will not be part of the output
        
    .EXAMPLE
        PS C:\> Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll"
        
        Will get all labels from the "PRO.resouce.dll" file
        
        The language is determined by the path to the resource file and nothing else
        
    .EXAMPLE
        PS C:\> Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll" -Name "@PRO505"
        
        Will get the label with the name "@PRO505" from the "PRO.resouce.dll" file
        
        The language is determined by the path to the resource file and nothing else
        
    .EXAMPLE
        PS C:\> Get-D365PackageLabelResources -Path "C:\AOSService\PackagesLocalDirectory\ApplicationSuite\Resources\en-US\PRO.resources.dll" -Value "*qty*"
        
        Will get all the labels where the value fits the search "*qty*" from the "PRO.resouce.dll" file
        
        The language is determined by the path to the resource file and nothing else
        
    .EXAMPLE
        PS C:\> Get-D365InstalledPackage -Name "ApplicationSuite" | Get-D365PackageLabelResourceFile -Language "da" | Get-D365PackageLabelResources -value "*batch*" -IncludePath
        
        Will get all the labels, across all label files, for the "ApplicationSuite", where the language is "da" and where the label value fits the search "*batch*".
        
        The path to the label file is included in the output.
        
    .NOTES
        Tags: PackagesLocalDirectory, Label, Labels, Language, Development, Servicing, Resource, Resources
        
        Author: Mötz Jensen (@Splaxi)
        
        There are several advanced scenarios for this cmdlet. See more on github and the wiki pages.
#>
function Get-D365PackageLabelResources {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true)]
        [Parameter(Mandatory = $true, ParameterSetName = 'Specific')]
        [Alias('Path')]
        [string] $FilePath,

        [string] $Name = "*",

        [string] $Value = "*",

        [switch] $IncludePath
    )

    BEGIN {}

    PROCESS {
        $assembly = [Reflection.Assembly]::LoadFile($FilePath)

        $resNames = $assembly.GetManifestResourceNames()
        $resname = $resNames[0].Replace(".resources", "")
        $resLanguage = $resname.Split(".")[1]

        $resMan = New-Object -TypeName System.Resources.ResourceManager -ArgumentList $resname, $assembly

        $language = New-Object System.Globalization.CultureInfo -ArgumentList "en-US"
        $resources = $resMan.GetResourceSet($language, $true, $true)

        foreach ($obj in $resources) {
            if ($obj.Name -NotLike $Name) { continue }
            if ($obj.Value -NotLike $Value) { continue }
            $res = [PSCustomObject]@{
                Name     = $obj.Name
                Language = $resLanguage
                Value    = $obj.Value
            }

            if ($IncludePath.IsPresent) {
                $res | Add-Member -MemberType NoteProperty -Name 'Path' -Value $FilePath
            }

            $res
        }
    }

    END {}
}