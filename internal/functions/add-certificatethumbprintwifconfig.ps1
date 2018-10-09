function Add-WIFConfigAuthorityThumbprint 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$CertificateThumbprint
    )

    try 
    {
        $wifConfigFile = Join-Path ([System.Environment]::ExpandEnvironmentVariables("%ServiceDrive%")) "\AOSService\webroot\wif.config"
        
        [xml]$wifXml = Get-Content $wifConfigFile

        $authorities = $wifXml.SelectNodes('//system.identityModel//identityConfiguration//securityTokenHandlers//securityTokenHandlerConfiguration//issuerNameRegistry//authority[@name="https://fakeacs.accesscontrol.windows.net/"]');
        
        if($authorities.Count -lt 1)
        {
            throw "Only one authority should be found with the name https://fakeacs.accesscontrol.windows.net/"
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
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}