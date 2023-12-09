<#
  .SYNOPSIS
  Enable Microsoft Entra ID integrations. Run the script on a CHE server.
  https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#set-up-a-new-application-and-certificate-registration

  .DESCRIPTION
  The CHEauth.ps1 script generates a selfsigned certificate, installs it to certstore "LocalMachine", grants NetworkService READ permission to it and exports the certificate for Azure application ID to Desktop
  and updates the web.config with application ID together with thumbprint of certificate.
  Create an Azure application with API permissions: Dynamics ERP – This permission is required to access finance and operations environments, Microsoft Graph (User.Read.All and Group.Read.All permissions of the Application type)
  Add Env FO URL to RedirectURI in Authentication in the Azure Application.
  
  .PARAMETER appID
  Specifies the Azure application ID. This is hardcoded and not checked in Microsoft Entra!

  .PARAMETER certName
  Specifies the name for the certificate.
  By default, it's named "CHEAuth"

  .PARAMETER certExpire
  Specifies the expiration date for the certificate.
  By default it's 2 years

  .OUTPUTS
  A certificate to Desktop of the current user that must be uploaded to the Application ID

  .EXAMPLE
  PS> .\CHEauth.ps1
  Creates a selfsigned certificate named "CHEAuth" and expires after 2 years. It will ask for appID.

  .EXAMPLE
  PS> .\CHEauth.ps1 -appid 3485734867345786736 -certname "Selfsignedcert"
  Creates a selfsigned certificate with name "Selfsignedcert" that expires after default 2 years

  .EXAMPLE
  PS> .\CHEauth.ps1 -appid 3485734867345786736 -certname "Selfsignedcert" -certexpire 1
  Creates a selfsigned certificate with name "Selfsignedcert" that expires after 1 year
#>
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#"No Administrative rights, it will display a popup window asking user for Admin rights"
$arguments = "& '" + $myinvocation.mycommand.definition + "'";Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments;break
}

#Create and Install cert in Localmachine certstore
 param (
        [Parameter(Mandatory=$true)][string]$appID,
        [Parameter(Mandatory = $true)]${certName[CHEauth]},
        [Parameter(Mandatory = $true)]${certExpire[2]}
    )
    $certName = if (${certName[CHEauth]}) { ${certName[CHEauth]} }
    else {
        "CHEauth"
    }
    $certExpire = if (${certExpire[2]}) {  ${certExpire[2]}   }
    else {
        2
    }

#----Region variables----
$certFilepath = "$env:USERPROFILE\Desktop" ## Specify your preferred location. Desktop is default.
$certStorelocation = "Cert:\LocalMachine\My"
#----End Region variables----

#BEGIN
CLS
write-host "Using variables: " -ForegroundColor CYAN
write-host '$certName: ' $($certName) -ForegroundColor Magenta
write-host '$certExpire: ' $($certExpire) -ForegroundColor Magenta
write-host '$certFilepath: ' $($certFilepath) -ForegroundColor Magenta
write-host '$certStorelocation: ' $($certStorelocation) -ForegroundColor Magenta
write-host '$appID: ' $($appID) -ForegroundColor Magenta
write-host ""
write-host "Check if the variables is ok." -ForegroundColor Green


if ($appID -eq ""){
write-host 'Please provide Azure application ID in variable $appID and rerun the script' -ForegroundColor Red
write-host 'The application need access to:' -ForegroundColor yellow
write-host "Dynamics ERP – This permission is required to access finance and operations environments." -ForegroundColor yellow
write-host "Microsoft Graph (User.Read.All and Group.Read.All permissions of the Application type)" -ForegroundColor yellow
pause;exit
}

#Check for existsting cert
$existingcert = Get-ChildItem -Path $certStorelocation -ea 0 | Where-Object {$_.Subject -Match "$certname"} # | Select-Object Thumbprint, FriendlyName
if ($existingcert){
write-host "A certificate with name $($certName) already exists in $($certStorelocation) with expiredate $($existingcert.notafter). Delete and re-create? " -ForegroundColor yellow;$certDel = read-host
    if ($certDel -eq 'y'){
        $existingcert| Remove-Item
    }
    else {write-host "Existing cert found in certstore. Cannot continue. Exiting.";pause;exit }
}#end if check existing cert

if (test-path "$certFilepath\$certname.cer"){
    write-host "Certfile already exists. Delete?" -ForegroundColor yellow;$certDelFile = read-host
    if ($certDelFile -eq 'y'){
        remove-item  "$certFilepath\$certname.cer" -force
    }
    else {write-host "Existing certfile found. Cannot continue. Exiting.";pause;exit }
}#end if check existing certfile

#Create cert
Write-host "Create, install and export cert $($certName) for Azure application ID $($appid) ?" -ForegroundColor CYAN ;$certAns = read-host
if ($certAns -eq "y"){
    write-host "Creating selfsigned cert $($certname) with $($certExpire) years expiration date..." -foregroundcolor yellow
    $cert = New-SelfSignedCertificate -Subject "CN=$certname" -CertStoreLocation $certStorelocation -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048 -KeyAlgorithm RSA -HashAlgorithm SHA256 -NotAfter (get-date).AddYears($certExpire)
    write-host "Exporting cert $($certname)" -foregroundcolor yellow
    Export-Certificate -Cert $cert -FilePath "$certFilepath\$certname.cer"   
    $certthumbprint = $cert.Thumbprint
    write-host "Thumprint: " $certthumbprint
    write-host ""
    
    #Set ACL rights
    $certobj = Get-ChildItem Cert:\LocalMachine\My | Where-Object Thumbprint -eq $certthumbprint
    $privatekey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($CertObj)
    $containerName = ""
    if ($privateKey.GetType().Name -ieq "RSACng") {
        $containerName = $privateKey.Key.UniqueName
    }
    else {
        $containerName = $privateKey.CspKeyContainerInfo.UniqueKeyContainerName
    }

    $keyFullPath =  $env:ProgramData + "\Microsoft\Crypto\RSA\MachineKeys\" + $containerName;
    if (-Not (Test-Path -Path $keyFullPath -PathType Leaf)) {
        throw "Unable to get the privatekey container to set permissions."
    }

    #Grant NetworkService account access to cert
    $networkServiceSID = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::NetworkServiceSid, $null)
    $permissions = (Get-Item $keyFullPath).GetAccessControl()
    $newruleset = 0
    $identnetwork = $permissions.access | where-object {$_.identityreference -eq "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)"} | select
    if($identnetwork.IdentityReference -ne "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)"){
        $rule1 = new-object security.accesscontrol.filesystemaccessrule($networkServiceSID, 'FullControl', 'None', 'None', 'Allow')
        $permissions.AddAccessRule($rule1)
        $newruleset = 1
        write-host "Added NetworkService with FULLCONTROL access to cert" -ForegroundColor Yellow
    }
    else {
    if ($identnetwork.FileSystemRights -ne 'FullControl'){
        $rule1 = new-object security.accesscontrol.filesystemaccessrule($networkServiceSID, 'FullControl', 'None', 'None', 'Allow')
        $permissions.AddAccessRule($rule1)
        $newruleset = 1
        write-host "Gave NetworkService FULLCONTROL access to cert" -ForegroundColor Yellow
    }    
    }

    #set permissions rules if updated
    if ($newruleset -eq 1){
        Set-Acl -Path $keyFullPath -AclObject $permissions
    }
    
    write-host ""
    write-host "Selfsigned cert installed. Upload the cert $($certName) to Azure Application id $($appid)" -ForegroundColor green
    write-host "In the Microsoft Entra admin center, in App registrations, select your application $($appID)." -ForegroundColor Yellow
    write-host "Select Certificates & secrets > Certificates > Upload certificate." -ForegroundColor Yellow
    write-host "Select the file you want to upload. It must be one of the following file types: .cer, .pem, .crt." -ForegroundColor Yellow
    write-host "Select Add." -ForegroundColor Yellow
    write-host ""

    #update web.config
    write-host "Enabling certauth in D365..." -ForegroundColor Yellow
    if (test-path "$env:servicedrive\AOSService\Webroot\web.config"){
        write-host 'Creating a backup of "$($env:servicedrive\AOSService\Webroot\web.config)' -ForegroundColor yellow
        copy-item "$env:servicedrive\AOSService\Webroot\web.config" -destination "$env:servicedrive\AOSService\Webroot\web.config_$((Get-Date).tostring("dd-MMM-yyyy"))"
        [xml]$xml = Get-Content "$env:servicedrive\AOSService\Webroot\web.config"
        if ($xml.SelectNodes('//add[@key="Aad.Realm"]/@value') -ne "spn:$appID"){
            $nodes = ($xml.configuration.appSettings).ChildNodes
            $clientid = $nodes | Where-object -Property Key -eq "Aad.Realm"
            $clientid.value = "spn:$appID"
            $InfraThumb = $nodes | Where-object -Property Key -eq "Infrastructure.S2SCertThumbprint"
            $InfraThumb.value = $certthumbprint
            $GraphThumb = $nodes | Where-object -Property Key -eq "GraphApi.GraphAPIServicePrincipalCert"
            $GraphThumb.value = $certthumbprint
            $xml.Save("$env:servicedrive\AOSService\Webroot\web.config")
            write-host "Aad.Realm set. Import of users should now be enabled." -ForegroundColor green
        }#xml select nodes
    }#end if test-path xml file
    else {write-host 'AOSService drive not found! Are you running the script on a CHE environment ?' -ForegroundColor red}


}#end if $certAns
else {write-host "Skipped creating cert." -ForegroundColor green}

start-sleep -s 20