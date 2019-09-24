
<#
    .SYNOPSIS
        Provision an user to be the administrator of a Dynamics 365 for Finance & Operations environment
        
    .DESCRIPTION
        Provision an user to be the administrator by using the supplied tools from Microsoft (AdminUserProvisioning.exe)
        
    .PARAMETER SignInName
        The sign in name (email address) for the user that you want to be the administrator
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER SqlUser
        The login name for the SQL Server instance
        
    .PARAMETER SqlPwd
        The password for the SQL Server user
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Set-AdminUser -SignInName "Claire@contoso.com" -DatabaseServer localhost -DatabaseName AxDB -SqlUser User123 -SqlPwd "Password123"
        
        This will provision the user with the e-mail "Claire@contoso.com" to be the administrator of the D365 for Finance & Operations instance.
        It will handle if the tenant is switching also, and update the necessary details.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        Author: Mark Furrer (@devax_mf)
        
#>
function Set-AdminUser {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    Param (
        [string] $SignInName,

        [string] $DatabaseServer,

        [string] $DatabaseName,

        [string] $SqlUser,

        [string] $SqlPwd,

        [switch] $EnableException
    )

    $WebConfigFile = Join-Path $Script:AOSPath $Script:WebConfig

    $MetaDataNode = Select-Xml -XPath "/configuration/appSettings/add[@key='Aos.MetadataDirectory']/@value" -Path $WebConfigFile

    $MetaDataNodeDirectory = $MetaDataNode.Node.Value
    
    Write-PSFMessage -Level Verbose -Message "MetaDataDirectory: $MetaDataNodeDirectory" -Target $MetaDataNodeDirectory

    $AdminFileLocationPu29AndUp  = "$MetaDataNodeDirectory\Bin\Microsoft.Dynamics.AdminUserProvisioningLib.dll"
    $AdminFileLocationBeforePu29 = "$MetaDataNodeDirectory\Bin\AdminUserProvisioning.exe"
    if ( Test-Path -Path $AdminFileLocationPu29AndUp -PathType Leaf ) {
        $AdminFile = $AdminFileLocationPu29AndUp
        $AdminLibNameSpace = "Microsoft.Dynamics.AdminUserProvisioningLib"
    } else {
        $AdminFile = $AdminFileLocationBeforePu29
        $AdminLibNameSpace = "Microsoft.Dynamics.AdminUserProvisioning"
    }
    Write-PSFMessage -Level Verbose -Message "Path to AdminFile: $AdminFile"

    $TempFileName = New-TemporaryFile
    $TempFileName = $TempFileName.BaseName

    $AdminDll = "$env:TEMP\$TempFileName.dll"

    copy-item -Path $AdminFile -Destination $AdminDll

    $adminAssembly = [System.Reflection.Assembly]::LoadFile($AdminDll)

    $AdminUserUpdater = $adminAssembly.GetType("$AdminLibNameSpace.AdminUserUpdater")

    $PublicBinding = [System.Reflection.BindingFlags]::Public
    $StaticBinding = [System.Reflection.BindingFlags]::Static
    $CombinedBinding = $PublicBinding -bor $StaticBinding

    $UpdateAdminUser = $AdminUserUpdater.GetMethod("UpdateAdminUser", $CombinedBinding)
    
    Write-PSFMessage -Level Verbose -Message "Adjusting parameter set to the PU that is in use in this environment."
    if((($UpdateAdminUser.GetParameters()).Name) -contains "hostUrl") {
        Write-PSFMessage -Level Verbose -Message "PU29 or higher found. Will adjust parameters."
        $params = $SignInName, "AAD-Global", $null, $null, $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd, "$Script:AOSPath\", $Script:Url
    }
    elseif((($UpdateAdminUser.GetParameters()).Name) -contains "providerName") {
        Write-PSFMessage -Level Verbose -Message "PU26/27/28 found. Will adjust parameters."
        $params = $SignInName, "AAD-Global", $null, $null, $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd
    }
    else {
        Write-PSFMessage -Level Verbose -Message "PU below PU26 found. Will adjust parameters."
        $params = $SignInName, $null, $null, $DatabaseServer, $DatabaseName, $SqlUser, $SqlPwd
    }

    try {
	    $paramsString = $params -join ", "
        Write-PSFMessage -Level Verbose -Message "Updating Admin using the values $paramsString"
        $UpdateAdminUser.Invoke($null, $params)
    }
    catch {
        $messageString = "Something went wrong while <c='em'>provisioning</c> the environment to the new administrator: $SignInName."
        Write-PSFMessage -Level Host -Message $messageString -Exception $PSItem.Exception -Target $SignInName
        Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', ''))) -ErrorRecord $_ -StepsUpward 1
        return
    }
}