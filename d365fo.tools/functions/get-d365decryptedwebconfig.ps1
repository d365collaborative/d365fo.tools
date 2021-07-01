
<#
    .SYNOPSIS
        Decrypts the AOS config file
        
    .DESCRIPTION
        Function used for decrypting the config file used by the D365 Finance & Operations AOS service
        
    .PARAMETER OutputPath
        Place where the decrypted files should be placed
        
        Default value is: "c:\temp\d365fo.tools\WebConfigDecrypted"
        
    .PARAMETER AosServiceWebRootPath
        Location of the D365 webroot folder
        
    .EXAMPLE
        PS C:\> Get-D365DecryptedWebConfig
        
        This will get the config file from the instance, decrypt it and save it.
        IT will save the decrypted web.config file in the default location: "c:\temp\d365fo.tools\WebConfigDecrypted".
        
        A result set example:
        
        Filename   LastModified        File
        --------   ------------        ----
        web.config 7/1/2021 9:01:31 PM C:\temp\d365fo.tools\WebConfigDecrypted\web.config
        
    .EXAMPLE
        PS C:\> Get-D365DecryptedWebConfig -OutputPath "c:\temp\d365fo.tools"
        
        This will get the config file from the instance, decrypt it and save it to "c:\temp\d365fo.tools"
        
        A result set example:
        
        Filename   LastModified        File
        --------   ------------        ----
        web.config 7/1/2021 9:07:36 PM C:\temp\d365fo.tools\web.config
        
    .NOTES
        Tags: Configuration, Service Account, Sql, SqlUser, SqlPwd, WebConfig, Web.Config, Decryption
        
        Author : Rasmus Andersen (@ITRasmus)
        Author : Mötz Jensen (@splaxi)
        
        Used for getting the Password for the database and other service accounts used in environment
#>
function Get-D365DecryptedWebConfig {
    [Alias("Get-D365DecryptedConfigFile")]
    param(
        [string] $OutputPath = "c:\temp\d365fo.tools\WebConfigDecrypted",

        [string] $AosServiceWebRootPath = $Script:AOSPath
    )

    $WebConfigFile = Join-Path $AosServiceWebRootPath $Script:WebConfig

    if (!(Test-PathExists -Path $WebConfigFile -Type Leaf)) { return }
    if (!(Test-PathExists -Path $OutputPath -Type Container -Create)) { return }

    Write-PSFMessage -Level Verbose -Message "Starting the decryption logic"
    New-DecryptedFile $WebConfigFile $OutputPath

    $file = Get-Item -Path "$OutputPath\web.config" -ErrorAction SilentlyContinue

    if ($null -eq $file) {
        $messageString = "There was an error while decrypting the <c='em'>web.config</c> file."
        Write-PSFMessage -Level Host -Message $messageString
        Stop-PSFFunction -Message "Stopping because the web.config file wasn't decrypted." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        return
    }
    
    $file | Select-PSFObject "Name as Filename", "LastWriteTime as LastModified", "Fullname as File"
}