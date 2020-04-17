
<#
    .SYNOPSIS
        Get the thumbprint from the RSAT certificate
        
    .DESCRIPTION
        Locate the thumbprint for the certificate created during the RSAT installation
        
    .EXAMPLE
        PS C:\> Get-D365RsatCertificateThumbprint
        
        This will locate any certificates that has 127.0.0.1 in its name.
        It will show the subject and the thumbprint values.
        
    .NOTES
        Tags: RSAT, Certificate, Testing, Regression Suite Automation Test, Regression, Test, Automation.
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365RsatCertificateThumbprint {
    [CmdletBinding()]
    [OutputType()]
    param ( )
    
    Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object Subject -like "*127.0.0.1*" | Format-Table Thumbprint, Subject, FriendlyName, NotAfter
}