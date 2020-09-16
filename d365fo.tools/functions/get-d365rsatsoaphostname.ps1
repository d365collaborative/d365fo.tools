
<#
    .SYNOPSIS
        Get the SOAP hostname for the D365FO environment
        
    .DESCRIPTION
        Get the SOAP hostname from the IIS configuration, to be used during the Rsat configuration
        
    .EXAMPLE
        PS C:\> Get-D365RsatSoapHostname
        
        This will get the SOAP hostname from IIS.
        It will display the SOAP URL / URI correctly formatted, to be used during the configuration of Rsat.
        
    .NOTES
        Tags: RSAT, Testing, Regression Suite Automation Test, Regression, Test, Automation, SOAP
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365RsatSoapHostname {
    [CmdletBinding()]
    [OutputType()]
    param ()

    [PSCustomObject]@{
        SoapHostname = (Get-WebBinding | Where-Object bindingInformation -like *soap*).bindingInformation.Replace("*:443:", "")
    }
}