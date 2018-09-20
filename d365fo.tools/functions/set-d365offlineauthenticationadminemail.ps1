<#
.SYNOPSIS
Sets the offline administrator e-mail

.DESCRIPTION
Sets the registered offline administrator in the "DynamicsDevConfig.xml" file located in the default Package Directory

.PARAMETER Email
The desired email address of the to be offline administrator

.EXAMPLE
Set-D365OfflineAuthenticationAdminEmail -Email "admin@contoso.com"

Will update the Offline Administrator E-mail address in the DynamicsDevConfig.xml file with "admin@contoso.com"

.NOTES
This cmdlet is inspired by the work of "Sheikh Sohail Hussain" (twitter: @SSohailHussain)

His blog can be found here:
http://d365technext.blogspot.com

The specific blog post that we based this cmdlet on can be found here:
http://d365technext.blogspot.com/2018/07/offline-authentication-admin-email.html
#>
function Set-D365OfflineAuthenticationAdminEmail {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [string] $Email
    )

    if(!$Script:IsAdminRuntime){
        Write-Host "The cmdlet needs administrator permission (Run As Administrator) to be able to update the configuration. Please start an elevated session and run the cmdlet again." -ForegroundColor Yellow
        Write-Error "Elevated permissions needed. Please start an elevated session and run the cmdlet again." -ErrorAction Stop
    }


    $filePath = Join-Path (Join-Path $Script:PackageDirectory "bin") "DynamicsDevConfig.xml"

    if ([System.IO.File]::Exists($filePath) -ne $True) {
        Write-Host "The DynamicsDevConfig.xml is not present on the system. Please make sure that the following path exists and you have enough permissions: `r`n$filePath " -ForegroundColor Yellow
        Write-Error "The DynamicsDevConfig.xml is missing on the system." -ErrorAction Stop
    }

    $namespace = @{ns="http://schemas.microsoft.com/dynamics/2012/03/development/configuration"}
    $xmlDoc = [xml] (Get-Content -Path $filePath)
    $OfflineAuthAdminEmail = Select-Xml -Xml $xmlDoc -XPath "/ns:DynamicsDevConfig/ns:OfflineAuthenticationAdminEmail"  -Namespace $namespace

    $oldValue = $OfflineAuthAdminEmail.Node.InnerText
    Write-Verbose "Old value found in the file was: $oldValue"

    $OfflineAuthAdminEmail.Node.InnerText = $Email
    $xmlDoc.Save($filePath)
}