function New-D365SelfSignedCertificate 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$CertificateFileName = "TestAuthCert.cer",

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$PrivateKeyFileName = "TestAuthCert.pfx",

        [Parameter(Mandatory = $false, Position = 3)]
        [Security.SecureString]$Password = (ConvertTo-SecureString -String "Password1" -Force -AsPlainText),

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$WindowsKitFolder = "C:\Program Files (x86)\Windows Kits\10\bin\x64"
    )

    try 
    {
        # First generate a self-signed certificate and place it in the local store on the machine
        $certificate = New-SelfSignedCertificate -dnsname 127.0.0.1 -CertStoreLocation cert:\LocalMachine\My -FriendlyName "D365 Automated testing certificate"
        $certificatePath = 'cert:\localMachine\my\' + $certificate.thumbprint 

        # Export the private key
        $privateKeyFilePath = Join-Path $env:TEMP $PrivateKeyFileName
        Export-PfxCertificate -cert $certificatePath -FilePath $privateKeyFilePath -Password $Password

        # Import the certificate into the local machine's trusted root certificates store
        $importedCertificate = Import-PfxCertificate -FilePath $privateKeyFilePath -CertStoreLocation Cert:\LocalMachine\Root -Password $Password    
    }
    catch 
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while generating the self-signed certificate and installing it into the local machine's trusted root certificates store." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    return $importedCertificate
}