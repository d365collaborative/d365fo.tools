##############################
#.SYNOPSIS
#Decrypts the AOS configfile
#
#.DESCRIPTION
#Function used for decrypting the config file used by the D365 Finance & Operations AOS service
#
#.PARAMETER DropPath
#Place where the decrypted files should be placed
#
#.PARAMETER AosServiceWebRootPath
#Location of the D365 webroot folder
#
#.EXAMPLE
#Get-DecrypteConfigFile -DropPath 'C:\Temp'
#
#.NOTES
# Used for getting the Password for the database and other service accounts used in environment
##############################
function Get-DecryptedConfigFile {
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [Alias('ExtractFolder')]
        [string]$DropPath = "C:\temp\D365FO-Tool\ConfigFile_Decrypted",
        [Parameter(Mandatory = $false, Position = 2)]
        [string]$AosServiceWebRootPath = $Script:AOSPath
    )

    Write-Verbose $Script:AOSPath

    $WebConfigFile = Join-Path $AosServiceWebRootPath $Script:WebConfig
  
    Write-Verbose "Checking if the extract folder exists"
    if ( -not (Test-Path $DropPath.Trim())) {
        Write-Verbose "Creating $DropPath"
        $null = New-Item -Path $DropPath -ItemType directory -Force -ErrorAction Stop
    }
    Write-Verbose "Decrypting"
    Write-Verbose "File $WebConfigFile - To $DropPath"
    New-DecryptedFile $WebConfigFile $DropPath
 
}