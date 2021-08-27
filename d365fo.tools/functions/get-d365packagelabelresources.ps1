
function Get-D365PackageLabelResources {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
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