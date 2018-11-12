
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
        PS C:\> Get-D365DecryptedConfigFile -DropPath "c:\temp\d365fo.tools"
        
        This will get the config file from the instance, decrypt it and save it to "c:\temp\d365fo.tools"
        
    .NOTES
        Tags: Configuration, Service Account, Sql, SqlUser, SqlPwd, WebConfig, Web.Config, Decryption
        
        Author : Rasmus Andersen (@ITRasmus)
        Author : Mötz Jensen (@splaxi)
        
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

    if (!(Test-PathExists -Path $WebConfigFile -Type Leaf)) {return}
    if (!(Test-PathExists -Path $DropPath -Type Container -Create)) {return}

    Write-PSFMessage -Level Verbose -Message "Starting the decryption logic"
    New-DecryptedFile $WebConfigFile $DropPath
}