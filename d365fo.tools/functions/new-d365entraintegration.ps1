
<#
    .SYNOPSIS
        Enable the Microsoft Entra ID integration on a cloud hosted environment (CHE).
        
    .DESCRIPTION
        Enable the Microsoft Entra ID integration by executing some of the steps described in https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations.
        The integration can either be enabled with an existing certificate or a new self-signed certificate can be created.
        If a new certificate is created and the integration is also to be enabled on other environments with the same certificate, a certificate password must be specified in order to create a certificate private key file.
        
        The steps executed are:
        
        1. Create a self-signed certificate and save it to Desktop or use a provided certificate.
        2. Install the certificate to the "LocalMachine" certificate store.
        3. Grant NetworkService READ permission to the certificate (only on cloud-hosted environments).
        4. Update the web.config with the application ID and the thumbprint of the certificate.
        
        To execute the steps, the id of an Azure application must be provided. The application must have the following API permissions:
        
        a. Dynamics ERP - This permission is required to access finance and operations environments.
        b. Microsoft Graph (User.Read.All and Group.Read.All permissions of the Application type).
        
        The URL of the finance and operations environment must also be added to the RedirectURI in the Authentication section of the Azure application.
        Finally, after running the cmdlet, if a new certificate was created, it must be uploaded to the Azure application.
        
    .PARAMETER ClientId
        The Azure Registered Application Id / Client Id obtained while creating a Registered App inside the Azure Portal.
        It is assumed that an application with this id already exists in Azure.
        
    .Parameter ExistingCertificateFile
        The path to a certificate file. If this parameter is provided, the cmdlet will not create a new certificate.
        
    .Parameter ExistingCertificatePrivateKeyFile
        The path to a certificate private key file.
        If this parameter is not provided, the certificate can be installed to the certificate store, but the NetworkService cannot be granted READ permission.
        
    .PARAMETER CertificateName
        The name for the certificate. By default, it is named "CHEAuth".
        
    .PARAMETER CertificateExpirationYears
        The number of years the certificate is valid. By default, it is valid for 2 years.
        
    .PARAMETER NewCertificateFile
        The path to the certificate file that will be created. By default, it is created on the Desktop of the current user.
        
    .PARAMETER NewCertificatePrivateKeyFile
        The path to the certificate private key file that will be created. By default, it is created on the Desktop of the current user.
        
    .PARAMETER CertificatePassword
        The password for the certificate private key file.
        If not provided when creating a new certificate, no private key file will be created.
        If not provided when using an existing certificate, the private key file cannot be installed.
        
    .PARAMETER Force
        Forces the execution of some of the steps. For example, if a certificate with the same name already exists, it will be deleted and recreated.
        
    .Parameter WhatIf
        Executes the cmdlet until the first operation that would change the state of the system, without executing that operation.
        Subsequent operations are likely to fail.
        This is currently not fully implemented and should not be used.
        
    .Parameter Confirm
        Prompts for confirmation before each operation of the cmdlet that changes the state of the system.
        
    .OUTPUTS
        If a new certificate is created, the certificate file is placed on the Desktop of the current user.
        It must be uploaded to the Azure Application.
        
    .EXAMPLE
        PS C:\> New-D365EntraIntegration -ClientId e70cac82-6a7c-4f9e-a8b9-e707b961e986
        
        Enables the Entra ID integration with a new self-signed certificate named "CHEAuth" which expires after 2 years.
        
    .EXAMPLE
        PS c:\> New-D365EntraIntegration -ClientId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificateName "SelfsignedCert"
        
        Enables the Entra ID integration with a new self-signed certificate with the name "Selfsignedcert" that expires after 2 years.
        
    .EXAMPLE
        PS C:\> New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificateName "SelfsignedCert" -CertificateExpirationYears 1
        
        Enables the Entra ID integration with a new self-signed certificate with the name "SelfsignedCert" that expires after 1 year.
        
    .EXAMPLE
        PS C:\> $securePassword = Read-Host -AsSecureString -Prompt "Enter the certificate password"
        PS C:\> New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -CertificatePassword $securePassword
        
        Enables the Entra ID integration with a new self-signed certificate with the name "CHEAuth" that expires after 2 years, using the provided password to generate the private key of the certificate.
        The certificate file and the private key file are saved to the Desktop of the current user.
        
    .EXAMPLE
        PS C:\> $securePassword = Read-Host -AsSecureString -Prompt "Enter the certificate password"
        PS C:\> New-D365EntraIntegration -AppId e70cac82-6a7c-4f9e-a8b9-e707b961e986 -ExistingCertificateFile "C:\Temp\SelfsignedCert.cer" -ExistingCertificatePrivateKeyFile "C:\Temp\SelfsignedCert.pfx" -CertificatePassword $securePassword
        
        Enables the Entra ID integration with the certificate file "C:\Temp\SelfsignedCert.cer", the private key file "C:\Temp\SelfsignedCert.pfx" and the provided password to install it.
        
    .NOTES
        Author: Øystein Brenna (@oysbre)
        Author: Florian Hopfner (@FH-Inway)
#>

function New-D365EntraIntegration {
    [CmdletBinding(
        DefaultParameterSetName = "NewCertificate",
        SupportsShouldProcess)]
    param (
        
        [Parameter(Mandatory = $true)]
        [Alias("AppId")]
        [string] $ClientId,

        [Parameter(Mandatory = $true, ParameterSetName = "ExistingCertificate")]
        [string] $ExistingCertificateFile,
    
        [Parameter(ParameterSetName = "ExistingCertificate")]
        [string] $ExistingCertificatePrivateKeyFile,

        [Parameter(ParameterSetName = "NewCertificate")]
        [string]$CertificateName = "CHEAuth",

        [Parameter(ParameterSetName = "NewCertificate")]
        [int]$CertificateExpirationYears = 2,

        [Parameter(ParameterSetName = "NewCertificate")]
        [string] $NewCertificateFile = "$env:USERPROFILE\Desktop\$CertificateName.cer",

        [Parameter(ParameterSetName = "NewCertificate")]
        [string] $NewCertificatePrivateKeyFile = "$env:USERPROFILE\Desktop\$CertificateName.pfx",

        [Security.SecureString] $CertificatePassword,

        [switch] $Force
    )

    if (-not ($Script:IsAdminRuntime)) {
        Write-PSFMessage -Level Critical -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c>. Enabling the Entra integration requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    $certificateStoreLocation = "Cert:\LocalMachine\My"
    $certificateThumbprint = ""

    # Steps 1 and 2: Create or use existing certificate and install it to the certificate store

    # Check and install provided certificate file
    if ($PSCmdlet.ParameterSetName -eq "ExistingCertificate") {
        Write-PSFMessage -Level Verbose -Message "Steps 1+2: Starting installation of existing certificate"
        if (-not (Test-PathExists -Path $ExistingCertificateFile -Type Leaf)) {
            Write-PSFMessage -Level Host -Message "The provided certificate file <c='em'>$ExistingCertificateFile</c> does not exist."
            Stop-PSFFunction -Message "Stopping because the provided certificate file does not exist"
            return
        }

        if ($CertificatePassword -and -not (Test-PathExists -Path $ExistingCertificatePrivateKeyFile -Type Leaf)) {
            Write-PSFMessage -Level Host -Message "The provided certificate private key file <c='em'>$ExistingCertificatePrivateKeyFile</c> does not exist."
            Stop-PSFFunction -Message "Stopping because the provided certificate private key file does not exist"
            return
        }

        $certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($ExistingCertificateFile)
        # Check for existing certificate that has the same thumbprint as the provided certificate
        $existingCertificate = Get-ChildItem -Path $certificateStoreLocation -ErrorAction SilentlyContinue | Where-Object {$_.Thumbprint -eq $certificate.Thumbprint}
        if ($existingCertificate) {
            Write-PSFMessage -Level Warning -Message "A certificate with the same thumbprint as the provided certificate <c='em'>$ExistingCertificateFile</c> already exists in <c='em'>$certificateStoreLocation</c>."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate with the same thumbprint as the provided certificate already exists"
                return
                
            }
            Write-PSFMessage -Level Host -Message "Deleting and installing the provided certificate."
            $existingCertificate | Remove-Item
        }
        # Install certificate
        if ($CertificatePassword) {
            $null = Import-PfxCertificate -FilePath $ExistingCertificatePrivateKeyFile -CertStoreLocation $certificateStoreLocation -Password $CertificatePassword
        }
        $certificate = Import-Certificate -FilePath $ExistingCertificateFile -CertStoreLocation $certificateStoreLocation
        $certificateThumbprint = $certificate.Thumbprint
        Write-PSFMessage -Level Host -Message "Certificate <c='em'>$ExistingCertificateFile</c> installed to <c='em'>$certificateStoreLocation</c>."
    }

    # Create and install certificate
    if ($PSCmdlet.ParameterSetName -eq "NewCertificate") {
        Write-PSFMessage -Level Verbose -Message "Steps 1+2: Starting creation of new certificate"
        #Check for existing certificate
        $existingCertificate = Get-ChildItem -Path $certificateStoreLocation -ErrorAction SilentlyContinue | Where-Object {$_.Subject -Match "$CertificateName"}
        if ($existingCertificate) {
            Write-PSFMessage -Level Warning -Message "A certificate with name <c='em'>$CertificateName</c> already exists in <c='em'>$certificateStoreLocation</c> with expiration date <c='em'>$($existingCertificate.NotAfter)</c>."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate with the same name already exists"
                return
            }
            Write-PSFMessage -Level Host -Message "Deleting and re-creating the certificate."
            $existingCertificate | Remove-Item
        }

        # Check for existing certificate file
        if (Test-PathExists -Path $NewCertificateFile -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
            Write-PSFMessage -Level Warning -Message "A certificate file with the same name as the new certificate file <c='em'>$NewCertificateFile</c> already exists."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate file with the same name already exists"
                return
            }
            Write-PSFMessage -Level Host -Message "The existing certificate file will be overwritten."
        }
        if ($CertificatePassword -and (Test-PathExists -Path $NewCertificatePrivateKeyFile -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
            Write-PSFMessage -Level Warning -Message "A certificate private key file with the same name as the new certificate private key file <c='em'>$NewCertificatePrivateKeyFile</c> already exists."
            if (-not $Force) {
                Stop-PSFFunction -Message "Stopping because a certificate private key file with the same name already exists"
                return
            }
            Write-PSFMessage -Level Host -Message "The existing certificate private key file will be overwritten."
        }

        # Create certificate
        $certificateParams = @{
            Subject = "CN=$CertificateName"
            CertStoreLocation = $certificateStoreLocation
            KeyExportPolicy = 'Exportable'
            KeySpec = 'Signature'
            KeyLength = 2048
            KeyAlgorithm = 'RSA'
            HashAlgorithm = 'SHA256'
            NotAfter = (Get-Date).AddYears($CertificateExpirationYears)
        }
        $certificate = New-SelfSignedCertificate @certificateParams
        $certificateThumbprint = $certificate.Thumbprint
        $null = Export-Certificate -Cert $certificate -FilePath $NewCertificateFile -Force:$Force
        Write-PSFMessage -Level Host -Message "Certificate <c='em'>$CertificateName</c> created and saved to <c='em'>$NewCertificateFile</c>."
        if ($CertificatePassword) {
            $null = Export-PfxCertificate -Cert $certificate -FilePath $NewCertificatePrivateKeyFile -Password $CertificatePassword -Force:$Force
            Write-PSFMessage -Level Host -Message "Certificate private key file <c='em'>$NewCertificatePrivateKeyFile</c> created."
        }
    }

    # Sanity checks before next steps
    if (-not $certificateThumbprint) {
        Write-PSFMessage -Level Host -Message "Unable to get the certificate thumbprint."
        Stop-PSFFunction -Message "Stopping because the certificate thumbprint could not be retrieved"
        return
    }
    $certificateObject = Get-ChildItem Cert:\LocalMachine\My | Where-Object Thumbprint -eq $certificateThumbprint
    if (-not $certificateObject) {
        Write-PSFMessage -Level Host -Message "Unable to get the certificate object."
        Stop-PSFFunction -Message "Stopping because the certificate object could not be retrieved"
        return
    }

    # Step 3: Grant NetworkService READ permission to the certificate by setting ACL rights
    # Check if on cloud-hosted environment
    if ($Script:EnvironmentType -eq [EnvironmentType]::AzureHostedTier1) {
        Write-PSFMessage -Level Verbose -Message "Step 3: Starting granting NetworkService READ permission to the certificate"
        # Get private key container name
        $privatekey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($certificateObject)
        $containerName = ""
        if ($privateKey.GetType().Name -ieq "RSACng") {
            $containerName = $privateKey.Key.UniqueName
        }
        else {
            $containerName = $privateKey.CspKeyContainerInfo.UniqueKeyContainerName
        }
        $keyFullPath = $env:ProgramData + "\Microsoft\Crypto\RSA\MachineKeys\" + $containerName;
        if (-not (Test-PathExists -Path $keyFullPath -Type Leaf)) {
            Write-PSFMessage -Level Host -Message "Unable to get the private key container to set read permission for NetworkService."
            Stop-PSFFunction -Message "Stopping because the private key container to set read permission for NetworkService could not be retrieved"
        }
        # Grant NetworkService account access to certificate if it does not already have it
        $networkServiceSidType = [System.Security.Principal.WellKnownSidType]::NetworkServiceSid
        $readFileSystemRight = [System.Security.AccessControl.FileSystemRights]::Read
        $allowAccessControlType = [System.Security.AccessControl.AccessControlType]::Allow
        $networkServiceSID = New-Object System.Security.Principal.SecurityIdentifier($networkServiceSidType, $null)
        $permissions = (Get-Item $keyFullPath).GetAccessControl()
        $newRuleSet = 0
        $identityNetwork = $permissions.access `
            | Where-Object {$_.identityreference -eq "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)"} `
            | Select-Object
        if ($identityNetwork.IdentityReference -ne "$($networkServiceSID.Translate([System.Security.Principal.NTAccount]).value)") {
            $rule1 = New-Object Security.AccessControl.FileSystemAccessRule($networkServiceSID, $readFileSystemRight, $allowAccessControlType)
            $permissions.AddAccessRule($rule1)
            $newRuleSet = 1
            Write-PSFMessage -Level Verbose -Message "Added NetworkService with READ access to certificate"
        }
        elseif ($identityNetwork.FileSystemRights -ne $readFileSystemRight) {
            $rule1 = New-Object Security.AccessControl.FileSystemAccessRule($networkServiceSID, $readFileSystemRight, $allowAccessControlType)
            $permissions.AddAccessRule($rule1)
            $newRuleSet = 1
            Write-PSFMessage -Level Verbose -Message "Gave NetworkService READ access to certificate"
        }
        if ($newRuleSet -eq 1){
            Set-Acl -Path $keyFullPath -AclObject $permissions
            Write-PSFMessage -Level Host -Message "NetworkService was granted READ permission to the certificate."
        }
    }

    # Step 4: Update web.config
    Write-PSFMessage -Level Verbose -Message "Step 4: Starting updating web.config"
    $webConfigBackup = Join-Path $Script:DefaultTempPath "WebConfigBackup"
    $webConfigFileBackup = Join-Path $webConfigBackup $Script:WebConfig
    if (Test-PathExists -Path $webConfigFileBackup -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) {
        Write-PSFMessage -Level Warning -Message "Backup of web.config already exists."
        if (-not $Force) {
            Stop-PSFFunction -Message "Stopping because a backup of web.config already exists"
            return
        }
        Write-PSFMessage -Level Host -Message "Backup of web.config will be overwritten."
    }
    $null = Backup-D365WebConfig -Force:$Force
    $webConfigFile = Join-Path -Path $Script:AOSPath $Script:WebConfig
    if (-not (Test-PathExists -Path $webConfigFile -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
        Write-PSFMessage -Level Host -Message "Unable to find the web.config file."
        Stop-PSFFunction -Message "Stopping because the web.config file could not be found"
    }
    [xml]$xml = Get-Content $webConfigFile
    $nodes = ($xml.configuration.appSettings).ChildNodes
    $aadRealm = $nodes | Where-Object -Property Key -eq "Aad.Realm"
    $aadRealm.value = "spn:$ClientId"
    $infraThumb = $nodes | Where-Object -Property Key -eq "Infrastructure.S2SCertThumbprint"
    $infraThumb.value = $certificateThumbprint
    $graphThumb = $nodes | Where-Object -Property Key -eq "GraphApi.GraphAPIServicePrincipalCert"
    $graphThumb.value = $certificateThumbprint
    $xml.Save($webConfigFile)
    Write-PSFMessage -Level Host -Message "web.config was updated with the application ID and the thumbprint of the certificate."

    if ($PSCmdlet.ParameterSetName -eq "NewCertificate") {
        Write-PSFMessage -Level Host -Message "The certificate file <c='em'>$NewCertificateFile</c> must be uploaded to the Azure application, see https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app#add-a-certificate."
    }
}