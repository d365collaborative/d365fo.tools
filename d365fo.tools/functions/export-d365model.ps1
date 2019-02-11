function Export-D365Model {
    # [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidDefaultValueSwitchParameter", "")]
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $True, Position = 2 )]
        [string] $Model,

        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, Position = 4 )]
        [string] $MetaDataDir = "$Script:MetaDataDir"
    )

    Invoke-TimeSignal -Start
    
    Invoke-ModelUtil -Command "Export" -Path $Path -BinDir $BinDir -MetaDataDir $MetaDataDir -Model $Model
    
    Invoke-TimeSignal -End
}