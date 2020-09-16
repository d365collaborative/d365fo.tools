
<#
    .SYNOPSIS
        Rotate the certificate used for WinRM
        
    .DESCRIPTION
        There is a scenario where you might need to update the certificate that is being used for WinRM on your Tier1 environment
        
        1 year after you deploy your Tier1 environment, the original WinRM certificate expires and then LCS will be unable to communicate with your Tier1 environment
        
    .PARAMETER MachineName
        The DNS / Netbios name of the machine
        
        The default value is: "$env:COMPUTERNAME" which translates into the current name of the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365WinRmCertificateRotation
        
        This will update the certificate that is being used by WinRM.
        A new certificate is created with the current computer name.
        The new certificate and its thumbprint will be configured for WinRM to use that going forward.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        We recommend that you do a full restart of the Tier1 environment when done.
        
#>
function Invoke-D365WinRmCertificateRotation {
    [CmdletBinding()]
    [OutputType()]
    param(
        [string] $MachineName = $env:COMPUTERNAME
    )

    Write-PSFMessage -Level Verbose "Creating a new certificate."

    $CertStore = "Cert:\LocalMachine\My"
    $Thumbprint = (New-SelfSignedCertificate -DnsName $MachineName -CertStoreLocation $CertStore).Thumbprint

    $executable = "C:\Windows\System32\cmd.exe"

    $params = @("/C", "winrm", "set",
        "winrm/config/Listener?Address=*+Transport=HTTPS",
        "@{Hostname=""$DNSName""; CertificateThumbprint=""$Thumbprint""}"
    )

    Write-PSFMessage -Level Verbose "Configure WinRM to use the newly created certificate."

    Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$true
}