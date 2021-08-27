
function Get-D365PackageLabelResourceFiles {
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