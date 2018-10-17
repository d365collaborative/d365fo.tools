
<#
    .SYNOPSIS
        Sets the offline administrator e-mail
        
    .DESCRIPTION
        Sets the registered offline administrator in the "DynamicsDevConfig.xml" file located in the default Package Directory
        
    .PARAMETER Email
        The desired email address of the to be offline administrator
        
    .EXAMPLE
        PS C:\> Set-D365OfflineAuthenticationAdminEmail -Email "admin@contoso.com"
        
        Will update the Offline Administrator E-mail address in the DynamicsDevConfig.xml file with "admin@contoso.com"
        
    .NOTES
        This cmdlet is inspired by the work of "Sheikh Sohail Hussain" (twitter: @SSohailHussain)
        
        His blog can be found here:
        http://d365technext.blogspot.com
        
        The specific blog post that we based this cmdlet on can be found here:
        http://d365technext.blogspot.com/2018/07/offline-authentication-admin-email.html
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365OfflineAuthenticationAdminEmail {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [string] $Email
    )

    if (-not ($script:IsAdminRuntime)) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    $filePath = Join-Path (Join-Path $Script:PackageDirectory "bin") "DynamicsDevConfig.xml"

    if (-not (Test-PathExists -Path $filePath -Type Leaf)) {return}

    $namespace = @{ns="http://schemas.microsoft.com/dynamics/2012/03/development/configuration"}
    $xmlDoc = [xml] (Get-Content -Path $filePath)
    $OfflineAuthAdminEmail = Select-Xml -Xml $xmlDoc -XPath "/ns:DynamicsDevConfig/ns:OfflineAuthenticationAdminEmail"  -Namespace $namespace

    $oldValue = $OfflineAuthAdminEmail.Node.InnerText
    
    Write-PSFMessage -Level Verbose -Message "Old value found in the file was: $oldValue" -Target $oldValue

    $OfflineAuthAdminEmail.Node.InnerText = $Email
    $xmlDoc.Save($filePath)
}