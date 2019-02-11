function Import-D365Model {
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [switch] $Replace
    )

    Invoke-TimeSignal -Start
    
    if($Replace) {
        Invoke-ModelUtil -Command "Replace" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir
    }
    else {
        Invoke-ModelUtil -Command "Import" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir
    }

    Invoke-TimeSignal -End
}