
<#
    .SYNOPSIS
        Create a new self signed certificate
        
    .DESCRIPTION
        Create a new self signed certificate and have it password protected
        
    .PARAMETER CertificateFileName
        Path to the location where you want to store the CER file for the certificate
        
    .PARAMETER PrivateKeyFileName
        Path to the location where you want to store the PFX file for the certificate
        
    .PARAMETER Password
        The password that you want to use to protect your different certificates with
        
    .EXAMPLE
        PS C:\> New-D365SelfSignedCertificate -CertificateFileName "C:\temp\d365fo.tools\TestAuth.cer" -PrivateKeyFileName "C:\temp\d365fo.tools\TestAuth.pfx" -Password (ConvertTo-SecureString -String "pass@word1" -Force -AsPlainText)
        
        This will generate a new CER certificate that is stored at "C:\temp\d365fo.tools\TestAuth.cer".
        This will generate a new PFX certificate that is stored at "C:\temp\d365fo.tools\TestAuth.pfx".
        Both certificates will be password protected with "pass@word1".
        
    .NOTES
        Author: Kenny Saelen (@kennysaelen)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-D365SelfSignedCertificate {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $CertificateFileName = (Join-Path $env:TEMP "TestAuthCert.cer"),

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $PrivateKeyFileName = (Join-Path $env:TEMP "TestAuthCert.pfx"),

        [Parameter(Mandatory = $false, Position = 3)]
        [Security.SecureString] $Password = (ConvertTo-SecureString -String "Password1" -Force -AsPlainText)
    )

    try {
        # First generate a self-signed certificate and place it in the local store on the machine
        $certificate = New-SelfSignedCertificate -dnsname 127.0.0.1 -CertStoreLocation cert:\LocalMachine\My -FriendlyName "D365 Automated testing certificate" -Provider "Microsoft Strong Cryptographic Provider"
        $certificatePath = 'cert:\localMachine\my\' + $certificate.Thumbprint

        # Export the private key
        Export-PfxCertificate -cert $certificatePath -FilePath $PrivateKeyFileName -Password $Password

        # Import the certificate into the local machine's trusted root certificates store
        $importedCertificate = Import-PfxCertificate -FilePath $PrivateKeyFileName -CertStoreLocation Cert:\LocalMachine\Root -Password $Password
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while generating the self-signed certificate and installing it into the local machine's trusted root certificates store." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }

    return $importedCertificate
}