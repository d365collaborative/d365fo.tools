
<#
    .SYNOPSIS
        Add a certificate thumbprint to the wif.config.
        
    .DESCRIPTION
        Register a certificate thumbprint in the wif.config file.
        This can be useful for example when configuring RSAT on a local machine and add the used certificate thumbprint to that AOS.s
        
    .PARAMETER CertificateThumbprint
        The thumbprint value of the certificate that you want to register in the wif.config file
        
    .EXAMPLE
        PS C:\> Add-D365RsatWifConfigAuthorityThumbprint -CertificateThumbprint "12312323r424"
        
        This will open the wif.config file and insert the "12312323r424" thumbprint value into the file.
        
    .NOTES
        Tags: RSAT, Certificate, Testing, Regression Suite Automation Test, Regression, Test, Automation
        
        Author: Kenny Saelen (@kennysaelen)
        
        Author: Mötz Jensen (@Splaxi)
#>
function Add-D365RsatWifConfigAuthorityThumbprint {
    [Alias("Add-D365WIFConfigAuthorityThumbprint")]

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$CertificateThumbprint
    )
      

    try
    {
        $wifConfigFile = Join-Path $script:ServiceDrive "\AOSService\webroot\wif.config"

        if($true -eq (Test-Path -Path $wifConfigFile))
        {
            [xml]$wifXml = Get-Content $wifConfigFile

            $authorities = $wifXml.SelectNodes('//system.identityModel//identityConfiguration//securityTokenHandlers//securityTokenHandlerConfiguration//issuerNameRegistry//authority[@name="https://fakeacs.accesscontrol.windows.net/"]')
            
            if($authorities.Count -lt 1)
            {
                Write-PSFMessage -Level Critical -Message "Only one authority should be found with the name https://fakeacs.accesscontrol.windows.net/"
                Stop-PSFFunction -Message  "Stopping because an invalid authority structure was found in the wif.config file."
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
        else
        {
            Write-PSFMessage -Level Critical -Message "The wif.config file would not be located on the system."
            Stop-PSFFunction -Message  "Stopping because the wif.config file could not be located."
            return
        }
    }
    catch
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while configuring the certificates and the Windows Identity Foundation configuration for the AOS" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
        return
    }
}