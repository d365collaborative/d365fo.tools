<#
    .SYNOPSIS
        Enable the Microsoft Entra ID integration on a cloud hosted environment (CHE).

    .DESCRIPTION
        Enable the Microsoft Entra ID integration by executing some of the steps described in https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations.
        The steps executed are:
            1. Create a self-signed certificate and save it to Desktop or use a provided certificate.
            2. Install the certificate to the "LocalMachine" certificate store.
            3. Grant NetworkService READ permission to the certificate (only on cloud-hosted environments).
            4. Update the web.config with the application ID and the thumbprint of the certificate.
        To execute the steps, the id of an Azure application must be provided. The application must have the following API permissions:
            a. Dynamics ERP – This permission is required to access finance and operations environments.
            b. Microsoft Graph (User.Read.All and Group.Read.All permissions of the Application type).
        The URL of the finance and operations environment must also be added to the RedirectURI in the Authentication section of the Azure application.
        Finally, after running the cmdlet, if a new certificate was created, it must be uploaded to the Azure application.

    .Parameter ExistingCertificateFile
        The path to a certificate file. If this parameter is provided, the cmdlet will not create a new certificate.
    
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal.
        It is assumed that an application with this id already exists in Azure.

    .PARAMETER CertificateName
        The name for the certificate. By default, it is named "CHEAuth".

    .PARAMETER CertificateExpirationYears
        The number of years the certificate is valid. By default, it is valid for 2 years.

    .PARAMETER NewCertificateFile
        The path to the certificate file that will be created. By default, it is created on the Desktop of the current user.

    .PARAMETER Force
        Forces the execution of some of the steps. For example, if a certificate with the same name already exists, it will be deleted and recreated.

    .OUTPUTS
    A certificate to the Desktop of the current user that must be uploaded to the Application ID.

    .EXAMPLE
        PS C:\> New-D365EntraIntegration

        Creates a self-signed certificate named "CHEAuth" which expires after 2 years. 
        It will ask for a ClientId/AppId.

    .EXAMPLE
        PS c:\> New-D365EntraIntegration -ClientId 3485734867345786736 -CertificateName "SelfsignedCert"

        Creates a self-signed certificate with the name "Selfsignedcert" that expires after 2 years.

    .EXAMPLE
        PS C:\> New-D365EntraIntegration -AppId 3485734867345786736 -CertificateName "SelfsignedCert" -CertificateExpirationYears 1

        Creates a self-signed certificate with the name "SelfsignedCert" that expires after 1 year.

    .NOTES
        Author: Øystein Brenna (@oysbre)
        Author: Florian Hopfner (@FH-Inway)
#>

function New-D365EntraIntegration {
    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory = $true, Position = 0)]
        [Parameter(ParameterSetName = "ExistingCertificate")]
        [string] $ExistingCertificateFile,
    
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = "ExistingCertificate")]
        [Parameter(ParameterSetName = "NewCertificate")]
        [Alias("AppId")]
        [string] $ClientId,

        [Parameter(Mandatory = $false)]
        [Parameter(ParameterSetName = "NewCertificate")]
        [string]$CertificateName = "CHEAuth",

        [Parameter(Mandatory = $false)]
        [Parameter(ParameterSetName = "NewCertificate")]
        [int]$CertificateExpirationYears = 2,

        [Parameter(Mandatory = $false)]
        [Parameter(ParameterSetName = "NewCertificate")]
        [string] $NewCertificateFile = "$env:USERPROFILE\Desktop\$CertificateName.cer",

        [Parameter(Mandatory = $false)]
        [switch] $Force
    )

    if (-not ($Script:IsAdminRuntime)) {
        Write-PSFMessage -Level Critical -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c>. Enabling the Entra integration requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    $certStorelocation = "Cert:\LocalMachine\My"
    $certThumbprint = ""

    # Steps 1 and 2: Create or use existing certificate and install it to the certificate store

    # Check and install provided certificate file
    if ($PSCmdlet.ParameterSetName -eq "ExistingCertificate") {
        if (-not (Test-PathExists -Path $ExistingCertificateFile -Type Leaf)) {
            Write-PSFMessage -Level Host -Message "The provided certificate file <c='em'>$ExistingCertificateFile</c> does not exist."
            Stop-PSFFunction -Message "Stopping because the provided certificate file does not exist"
            return
        }

        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($ExistingCertificateFile)
        # Check for existing certificate that has the same thumbprint as the provided certificate
        $existingcert = Get-ChildItem -Path $certStorelocation -ErrorAction SilentlyContinue | Where-Object {$_.Thumbprint -eq $cert.Thumbprint}
        if ($existingcert) {
            Write-PSFMessage -Level Warning -Message "A certificate with the same thumbprint as the provided certificate <c='em'>$ExistingCertificateFile</c> already exists in <c='em'>$certStorelocation</c>."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate with the same thumbprint as the provided certificate already exists"
                return
                
            }
            Write-PSFMessage -Level Host -Message "Deleting and installing the provided certificate."
            $existingcert | Remove-Item
        }
        # Install certificate
        $certStore = New-Object System.Security.Cryptography.X509Certificates.X509Store($certStorelocation, "CurrentUser")
        $certStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $certStore.Add($cert)
        $certStore.Close()
        $certThumbprint = $cert.Thumbprint
        Write-PSFMessage -Level Host -Message "Certificate <c='em'>$ExistingCertificateFile</c> installed to <c='em'>$certStorelocation</c>."
    }

    # Create and install certificate
    if ($PSCmdlet.ParameterSetName -eq "NewCertificate") {
        #Check for existing certificate
        $existingcert = Get-ChildItem -Path $certStorelocation -ErrorAction SilentlyContinue | Where-Object {$_.Subject -Match "$CertificateName"}
        if ($existingcert) {
            Write-PSFMessage -Level Warning -Message "A certificate with name <c='em'>$CertificateName</c> already exists in <c='em'>$certStorelocation</c> with expiredate <c='em'>$($existingcert.NotAfter)</c>."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate with the same name already exists"
                return
            }
            Write-PSFMessage -Level Host -Message "Deleting and re-creating the certificate."
            $existingcert | Remove-Item
        }

        # Check for existing certificate file
        if (Test-PathExists -Path $NewCertificateFile -Type Leaf) {
            Write-PSFMessage -Level Warning -Message "A certificate file with the same name as the new certificate file <c='em'>$NewCertificateFile</c> already exists."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate file with the same name already exists"
                return
            }
            Write-PSFMessage -Level Host -Message "The existing certificate file will be overwritten."
        }

        # Create certificate
        $certParams = @{
            Subject = "CN=$certname"
            CertStoreLocation = $certStorelocation
            KeyExportPolicy = 'Exportable'
            KeySpec = 'Signature'
            KeyLength = 2048
            KeyAlgorithm = 'RSA'
            HashAlgorithm = 'SHA256'
            NotAfter = (Get-Date).AddYears($certExpire)
        }
        $cert = New-SelfSignedCertificate @certParams
        $certThumbprint = $cert.Thumbprint
        Export-Certificate -Cert $cert -FilePath $NewCertificateFile -Force:$Force
        Write-PSFMessage -Level Host -Message "Certificate <c='em'>$CertificateName</c> created and saved to <c='em'>$NewCertificateFile</c>."
    }

    # Sanity checks before next steps
    if (-not $certThumbprint) {
        Write-PSFMessage -Level Critical -Message "Unable to get the certificate thumbprint."
        Stop-PSFFunction -Message "Stopping because the certificate thumbprint could not be retrieved"
        return
    }
    $certobj = Get-ChildItem Cert:\LocalMachine\My | Where-Object Thumbprint -eq $certThumbprint
    if (-not $certobj) {
        Write-PSFMessage -Level Host -Message "Unable to get the certificate object."
        Stop-PSFFunction -Message "Stopping because the certificate object could not be retrieved"
        return
    }

    # Step 3: Grant NetworkService READ permission to the certificate by setting ACL rights
    # Check if on cloud-hosted environment
    if ($Script:EnvironmentType -eq [EnvironmentType]::AzureHostedTier1) {
        # Get private key container name
        $privatekey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($CertObj)
        $containerName = ""
        if ($privateKey.GetType().Name -ieq "RSACng") {
            $containerName = $privateKey.Key.UniqueName
        }
        else {
            $containerName = $privateKey.CspKeyContainerInfo.UniqueKeyContainerName
        }
        $keyFullPath = $env:ProgramData + "\Microsoft\Crypto\RSA\MachineKeys\" + $containerName;
        if (-not (Test-PathExists -Path $keyFullPath -PathType Leaf)) {
            Write-PSFMessage -Level Host -Message "Unable to get the private key container to set read permission for NetworkService."
            Stop-PSFFunction -Message "Stopping because the private key container to set read permission for NetworkService could not be retrieved"
        }
        # Grant NetworkService account access to certificate if it does not already have it
        $networkServiceSID = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::NetworkServiceSid, $null)
        $permissions = (Get-Item $keyFullPath).GetAccessControl()
        $newRuleSet = 0
        $identityNetwork = $permissions.access `
            | Where-Object {$_.identityreference -eq "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)"} `
            | Select-Object
        if ($identityNetwork.IdentityReference -ne "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)") {
            $rule1 = New-Object Security.AccessControl.FileSystemAccessRule($networkServiceSID, 'FullControl', 'None', 'None', 'Allow')
            $permissions.AddAccessRule($rule1)
            $newRuleSet = 1
            Write-PSFMessage -Level Host -Message "Added NetworkService with FULLCONTROL access to certificate"
        }
        elseif ($identityNetwork.FileSystemRights -ne 'FullControl') {
            $rule1 = New-Object Security.AccessControl.FileSystemAccessRule($networkServiceSID, 'FullControl', 'None', 'None', 'Allow')
            $permissions.AddAccessRule($rule1)
            $newRuleSet = 1
            Write-PSFMessage -Level Host -Message "Gave NetworkService FULLCONTROL access to certificate"
        }
        if ($newRuleSet -eq 1){
            Set-Acl -Path $keyFullPath -AclObject $permissions
        }
    }

    # Step 4: Update web.config
    $webConfigFile = Join-Path -path $Script:AOSPath $Script:WebConfig
    Backup-D365WebConfig
    if (-not (Test-PathExists -Path $webConfigFile -PathType Leaf)) {
        Write-PSFMessage -Level Host -Message "Unable to find the web.config file."
        Stop-PSFFunction -Message "Stopping because the web.config file could not be found"
    }
    [xml]$xml = Get-Content $webConfigFile
    $nodes = ($xml.configuration.appSettings).ChildNodes
    $aadRealm = $nodes | Where-Object -Property Key -eq "Aad.Realm"
    $aadRealm.value = "spn:$ClientId"
    $infraThumb = $nodes | Where-Object -Property Key -eq "Infrastructure.S2ScertThumbprint"
    $infraThumb.value = $certThumbprint
    $graphThumb = $nodes | Where-Object -Property Key -eq "GraphApi.GraphAPIServicePrincipalCert"
    $graphThumb.value = $certThumbprint
    $xml.Save($webConfigFile)
    Write-PSFMessage -Level Host -Message "web.config was updated with the application ID and the thumbprint of the certificate."
}