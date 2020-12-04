
<#
    .SYNOPSIS
        Import certificates for RSAT
        
    .DESCRIPTION
        Import the certificates for RSAT into the correct stores and display the thumbprint
        
        When working with self-service environments you need to download a zip file from LCS. The zip file needs to be unblocked and then extracted into a folder, with only the .cer and the .pxf files inside
        
    .PARAMETER Path
        Path to the folder where the .cer and .pxf files are located
        
        The files needs to be extracted from the zip archive
        
    .PARAMETER Password
        Password for the .pxf file
        
        Working with self-service environments, the password will be displayed during the download of the zip archive
        
    .EXAMPLE
        PS C:\> Import-D365RsatSelfServiceCertificates -Path "C:\Temp\UAT" -Password "123456789"
        
        This will import the .cer and .pxf files into the correct stored, bases on the files located in "C:\Temp\UAT".
        After import it will display the thumbprint for both certificates.
        
        Sample output:
        [23:43:05][Import-D365RsatSelfServiceCertificates] Pfx Thumbprint:  B4D6921321434235463463414312343253523A05
        [23:43:05][Import-D365RsatSelfServiceCertificates] Cert Thumbprint: B4D6921321434235463463414312343253523A05
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Import-D365RsatSelfServiceCertificates {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Path,

        [Parameter(Mandatory = $true)]
        $Password
    )
    
    begin {
        [Security.SecureString] $PasswordSecure = (ConvertTo-SecureString -String $Password -Force -AsPlainText)

        if (-not (Test-PathExists -Path $Path -Type Container)) { return }
    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }

        $pathCertFile = (Get-ChildItem -Path "$Path\*.cer" | Select-Object -First 1).FullName
        $pathPfxFile = (Get-ChildItem -Path "$Path\*.pfx" | Select-Object -First 1).FullName

        if (-not $pathCertFile -or -not $pathPfxFile) {
            $messageString = "One of the certificate files are <c='em'>missing</c>. Make sure that the path you supplied contains a set of <c='em'>.cer</c> and <c='em'>.pxf</c> certificate files."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because an generic error message." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
            return
        }

        $pxfCert = Import-PfxCertificate -FilePath $pathPfxFile -CertStoreLocation "Cert:\LocalMachine\Root" -Password $PasswordSecure
        Import-PfxCertificate -FilePath $pathPfxFile -CertStoreLocation "Cert:\LocalMachine\My" -Password $PasswordSecure > $null
        $cert = Import-Certificate -FilePath $pathCertFile -CertStoreLocation "Cert:\LocalMachine\Root"
        Import-Certificate -FilePath $pathCertFile -CertStoreLocation "Cert:\LocalMachine\My" > $null

        Write-PSFMessage -Level Host -Message "Pfx Thumbprint: <c='em'>$($pxfCert.Thumbprint)</c>"
        Write-PSFMessage -Level Host -Message "Cert Thumbprint: <c='em'>$($cert.Thumbprint)</c>"

    }
    
    end {
        
    }
}