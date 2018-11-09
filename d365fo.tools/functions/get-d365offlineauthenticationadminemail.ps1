
<#
    .SYNOPSIS
        Gets the registered offline administrator e-mail configured
        
    .DESCRIPTION
        Get the registered offline administrator from the "DynamicsDevConfig.xml" file located in the default Package Directory
        
    .EXAMPLE
        PS C:\> Get-D365OfflineAuthenticationAdminEmail
        
        Will read the DynamicsDevConfig.xml and display the registered Offline Administrator E-mail address.
        
    .NOTES
        Tags: Development, Email, DynamicsDevConfig, Offline, Authentication
        
        This cmdlet is inspired by the work of "Sheikh Sohail Hussain" (twitter: @SSohailHussain)
        
        His blog can be found here:
        http://d365technext.blogspot.com
        
        The specific blog post that we based this cmdlet on can be found here:
        http://d365technext.blogspot.com/2018/07/offline-authentication-admin-email.html
#>
function Get-D365OfflineAuthenticationAdminEmail {
    [CmdletBinding()]
    param ()

    $filePath = Join-Path (Join-Path $Script:PackageDirectory "bin") "DynamicsDevConfig.xml"

    if(-not (Test-PathExists -Path $filePath -Type Leaf)) {return}

    $namespace = @{ns="http://schemas.microsoft.com/dynamics/2012/03/development/configuration"}
    $OfflineAuthAdminEmail = Select-Xml -XPath "/ns:DynamicsDevConfig/ns:OfflineAuthenticationAdminEmail" -Path $filePath -Namespace $namespace

    $AdminEmail = $OfflineAuthAdminEmail.Node.InnerText
    [PSCustomObject] @{Email = $AdminEmail}
}