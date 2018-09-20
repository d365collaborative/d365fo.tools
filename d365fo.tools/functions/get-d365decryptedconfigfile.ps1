<#
.SYNOPSIS
Decrypts the AOS config file

.DESCRIPTION
Function used for decrypting the config file used by the D365 Finance & Operations AOS service

.PARAMETER DropPath
Place where the decrypted files should be placed

.PARAMETER AosServiceWebRootPath
Location of the D365 webroot folder

.EXAMPLE
Get-D365DecryptedConfigFile -DropPath 'C:\Temp'

.NOTES
Used for getting the Password for the database and other service accounts used in environment
#>

function Get-D365DecryptedConfigFile {
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [Alias('ExtractFolder')]
        [string]$DropPath = "C:\temp\d365fo.tools\ConfigFile_Decrypted",

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$AosServiceWebRootPath = $Script:AOSPath
    )

    $WebConfigFile = Join-Path $AosServiceWebRootPath $Script:WebConfig

    if (!(Test-PathExists -Path $WebConfigFile, $Util -Type Leaf)) {return}
    if (!(Test-PathExists -Path $DropPath -Type Container -Create)) {return}

    Write-PSFMessage -Level Verbose -Message "Starting the decryption logic"
    New-DecryptedFile $WebConfigFile $DropPath 
}