
<#
    .SYNOPSIS
        Add a certificate thumbprint to the wif.config
        
    .DESCRIPTION
        Register a certificate thumbprint in the wif.config file
        
    .PARAMETER CertificateThumbprint
        The thumbprint value of the certificate that you want to register in the wif.config file
        
    .EXAMPLE
        PS C:\> Add-WIFConfigAuthorityThumbprint -CertificateThumbprint "12312323r424"
        
        This will open the wif.config file and insert the "12312323r424" thumbprint value into the file.
        
    .NOTES
        Author: Kenny Saelen (@kennysaelen)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Add-WIFConfigAuthorityThumbprint
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$CertificateThumbprint
    )

    try
    {
        $wifConfigFile = Join-Path $script:ServiceDrive "\AOSService\webroot\wif.config"

        [xml]$wifXml = Get-Content $wifConfigFile

        $authorities = $wifXml.SelectNodes('//system.identityModel//identityConfiguration//securityTokenHandlers//securityTokenHandlerConfiguration//issuerNameRegistry//authority[@name="https://fakeacs.accesscontrol.windows.net/"]')
        
        if($authorities.Count -lt 1)
        {
            Write-PSFMessage -Level Critical -Message "Only one authority should be found with the name https://fakeacs.accesscontrol.windows.net/"
            Stop-PSFFunction -StepsUpward 1
            return
        }
        else
        {
            foreach ($authority in $authorities)
            {
               $addElem = $wifXml.CreateElement("add")
               $addAtt = $wifXml.CreateAttribute("thumbprint")
               $addAtt.Value = $CertificateThumbprint
               $addElem.Attributes.Append($addAtt)
               $authority.FirstChild.AppendChild($addElem)
               $wifXml.Save($wifConfigFile)
            }
        }
    }
    catch
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring the certificates and the Windows Identity Foundation configuration for the AOS" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }
}