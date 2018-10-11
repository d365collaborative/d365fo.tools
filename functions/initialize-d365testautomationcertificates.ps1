  <#
  .SYNOPSIS
  Create and configure test automation certificates
  
  .DESCRIPTION
  Creates a new self signed certificate for automated testing and reconfigures the AOS Windows Identity Foundation configuration to trust the certificate
  
  .PARAMETER CertificateFileName
  Filename to be used when exporting the cer file
  
  .PARAMETER PrivateKeyFileName
  Filename to be used when exporting the pfx file

  .EXAMPLE
  Initialize-D365TestAutomationCertificate 

  This will generate a certificate for issuer 127.0.0.1 and install it in the trusted root certificates and modify the wif.config of the AOS to include the thumbprint and trust the certificate

  .NOTES
  Author = Kenny Saelen @kennysaelen
  #>
  function Initialize-D365TestAutomationCertificate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$CertificateFileName = (Join-Path $env:TEMP "TestAuthCert.cer"),

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$PrivateKeyFileName = (Join-Path $env:TEMP "TestAuthCert.pfx"),

        [Parameter(Mandatory = $false, Position = 3)]
        [Security.SecureString]$Password = (ConvertTo-SecureString -String "Password1" -Force -AsPlainText),

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$MakeCertExecutable = "C:\Program Files (x86)\Windows Kits\10\bin\x64\MakeCert.exe"
    )

    if (!$Script:IsAdminRuntime) 
    {
        Write-PSFMessage -Level Critical -Message "The cmdlet needs administrator permission (Run As Administrator) to be able to update the configuration. Please start an elevated session and run the cmdlet again." -ForegroundColor Yellow
        Stop-PSFFunction "Elevated permissions needed. Please start an elevated session and run the cmdlet again."
    }

    try 
    {
        # Create the certificate and place it in the right stores
        $X509Certificate = New-D365SelfSignedCertificate -CertificateFileName $CertificateFileName -PrivateKeyFileName $PrivateKeyFileName -Password $Password -MakeCertExecutable $MakeCertExecutable
        
        if (Test-PSFFunctionInterrupt) 
        { 
            Write-PSFMessage -Level Critical -Message "The self signed certificate creation was interrupted"
            Stop-PSFFunction -StepsUpward 1
        }

        # Modify the wif.config of the AOS to have this thumbprint added to the https://fakeacs.accesscontrol.windows.net/ authority
        Add-WIFConfigAuthorityThumbprint -CertificateThumbprint $X509Certificate.Thumbprint
    }
    catch 
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring the certificates and the Windows Identity Foundation configuration for the AOS" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}

