function Set-AdminUser($SignInName, $DatabaseServerName, $DatabaseName, $SqlUser, $SqlPwd) {

    $WebConfigFile = Join-Path $Script:AOSPath $Script:WebConfig

    $MetaDataNode = Select-Xml -XPath "/configuration/appSettings/add[@key='Aos.MetadataDirectory']/@value" -Path $WebConfigFile

    $MetaDataNodeDirectory = $MetaDataNode.Node.Value

    Write-Verbose "MetaDataDirectory: $MetaDataNodeDirectory"

    $AdminFile = "$MetaDataNodeDirectory\Bin\AdminUserProvisioning.exe"

    $TempFileName = New-TemporaryFile
    $TempFileName = $TempFileName.BaseName

    $AdminDll = "$env:TEMP\$TempFileName.dll"

    copy-item -Path $AdminFile -Destination $AdminDll

    $adminAssembly = [System.Reflection.Assembly]::LoadFile($AdminDll)

    $AdminUserUpdater = $adminAssembly.GetType("Microsoft.Dynamics.AdminUserProvisioning.AdminUserUpdater")

    $PublicBinding = [System.Reflection.BindingFlags]::Public
    $StaticBinding = [System.Reflection.BindingFlags]::Static
    $CombinedBinding = $PublicBinding -bor $StaticBinding

    $UpdateAdminUser = $AdminUserUpdater.GetMethod("UpdateAdminUser", $CombinedBinding)

    Write-Verbose "Updating Admin using the values $SignInName, $DatabaseServerName, $DatabaseName, $SqlUser, $SqlPwd"

    $params = $SignInName, $null, $null, $DatabaseServerName, $DatabaseName, $SqlUser, $SqlPwd

    $UpdateAdminUser.Invoke($null, $params)
}