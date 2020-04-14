
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
        
        The default value is: "Password1"
        
    .PARAMETER CertificateOnly
        Switch specifying if only the certificate needs to be created
        
        If specified, then only the certificate is created and the thumbprint is not added to the wif.config on the AOS side
        If not specified (default) then the certificate is created and installed and the corresponding thumbprint is added to the wif.config on the local machine
        
    .PARAMETER KeepCertificateFile
        Instruct the cmdlet to copy the certificate file from the working directory into the desired location specified with OutputPath parameter
        
    .PARAMETER OutputPath
        Path to where you want the certificate file exported to, when using the KeepCertificateFile parameter switch
        
        Default value is: "c:\temp\d365fo.tools"
        
    .EXAMPLE
        PS C:\> Initialize-D365RsatCertificate
        
        This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates and modify the wif.config of the AOS to include the thumbprint and trust the certificate.
        
    .EXAMPLE
        PS C:\> Initialize-D365RsatCertificate -CertificateOnly
        
        This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates.
        No actions will be taken regarding modifying the AOS wif.config file.
        
        Use this when installing RSAT on a machine different from the AOS where RSAT is pointing to.
        
    .EXAMPLE
        PS C:\> Initialize-D365RsatCertificate -CertificateOnly -KeepCertificateFile
        
        This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates.
        No actions will be taken regarding modifying the AOS wif.config file.
        The pfx will be copied into the default "c:\temp\d365fo.tools" folder after creation.
        
        Use this when installing RSAT on a machine different from the AOS where RSAT is pointing to.
        
        The pfx file enables you to import the same certificate across your entire network, instead of creating one per machine.
        
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
        [string] $CertificateFileName = (Join-Path $env:TEMP "TestAuthCert.cer"),

        [string] $PrivateKeyFileName = (Join-Path $env:TEMP "TestAuthCert.pfx"),

        [Security.SecureString] $Password = (ConvertTo-SecureString -String "Password1" -Force -AsPlainText),

        [switch] $CertificateOnly,

        [Parameter(ParameterSetName = "KeepCertificateFile")]
        [switch] $KeepCertificateFile,

        [Parameter(ParameterSetName = "KeepCertificateFile")]
        [string] $OutputPath = $Script:DefaultTempPath
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

        # Write-PSFMessage -Level Host -Message "Generated certificate: $X509Certificate"

        if($KeepCertificateFile){
            $PrivateKeyFileName = ($PrivateKeyFileName | Copy-Item -Destination $OutputPath -PassThru).FullName
        }

        [PSCustomObject]@{
            File = $PrivateKeyFileName
            Filename = $(Split-Path -Path $PrivateKeyFileName -Leaf)
        }

        $X509Certificate | Format-Table Thumbprint, Subject, FriendlyName, NotAfter
    }

    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring the certificates and the Windows Identity Foundation configuration for the AOS" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}