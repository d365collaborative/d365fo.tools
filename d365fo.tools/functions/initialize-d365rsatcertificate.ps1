
<#
    .SYNOPSIS
        Create and configure test automation certificate
        
    .DESCRIPTION
        Creates a new self signed certificate for automated testing and reconfigures the AOS Windows Identity Foundation configuration to trust the certificate
        
    .PARAMETER CertificateFileName
        Filename to be used when exporting the cer file
        
    .PARAMETER PrivateKeyFileName
        Filename to be used when exporting the pfx file
        
    .PARAMETER Password
        The password that you want to use to protect your certificate with
        
    .PARAMETER CertificateOnly
        Switch specifying if only the certificate needs to be created.
        If specified, then only the certificate is created and the thumbprint is not added to the wif.config on the AOS side.
        If not specified (default) then the certificate is created and installed and the corresponding thumbprint is added to the wif.config on the local machine.
        
    .EXAMPLE
        PS C:\> Initialize-D365RsatCertificate
        
        This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates and modify the wif.config of the AOS to include the thumbprint and trust the certificate.
        initialize-d365rsatcertificate
    .EXAMPLE
        PS C:\> Initialize-D365RsatCertificate -CertificateOnly
        
        This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates.
        No actions will be taken regarding modifying the AOS wif.config file.
        Use this when installing RSAT on a machine different from the AOS where RSAT is pointing to.
        
    .NOTES
        Tags: Automated Test, Test, Regression, Certificate, Thumbprint
        
        Author: Kenny Saelen (@kennysaelen)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Initialize-D365RsatCertificate {
    [Alias("Initialize-D365TestAutomationCertificate")]

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingCmdletAliases", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string] $CertificateFileName = (Join-Path $env:TEMP "TestAuthCert.cer"),

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $PrivateKeyFileName = (Join-Path $env:TEMP "TestAuthCert.pfx"),

        [Parameter(Mandatory = $false, Position = 3)]
        [Security.SecureString] $Password = (ConvertTo-SecureString -String "Password1" -Force -AsPlainText),

        [Parameter(Mandatory = $false, Position = 4)]
        [switch] $CertificateOnly
    )

    if (-not $Script:IsAdminRuntime) {
        Write-PSFMessage -Level Critical -Message "The cmdlet needs administrator permission (Run As Administrator) to be able to update the configuration. Please start an elevated session and run the cmdlet again."
        Stop-PSFFunction -Message "Elevated permissions needed. Please start an elevated session and run the cmdlet again."
        return
    }

    try {
        # Create the certificate and place it in the right stores
        $X509Certificate = New-D365SelfSignedCertificate -CertificateFileName $CertificateFileName -PrivateKeyFileName $PrivateKeyFileName -Password $Password

        if (Test-PSFFunctionInterrupt) {
            Write-PSFMessage -Level Critical -Message "The self signed certificate creation was interrupted."
            Stop-PSFFunction -Message "Stopping because of errors."
            return
        }

        if($false -eq $CertificateOnly)
        {
            # Modify the wif.config of the AOS to have this thumbprint added to the https://fakeacs.accesscontrol.windows.net/ authority
            Add-D365RsatWifConfigAuthorityThumbprint -CertificateThumbprint $X509Certificate.Thumbprint
        }

        Write-PSFMessage -Level Host -Message "Generated certificate: $X509Certificate"
    }

    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring the certificates and the Windows Identity Foundation configuration for the AOS" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}