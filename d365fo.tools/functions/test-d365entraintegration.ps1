
<#
    .SYNOPSIS
        Test the Entra Id integration
        
    .DESCRIPTION
        Validates the configuration of the web.config file and the certificate for the environment
        
        If any of the configuration is missing or in someway incorrect, it will prompt and stating corrective actions needed
        
    .EXAMPLE
        PS C:\> Test-D365EntraIntegration
        
        This will validate the settings inside the web.config file.
        It will search for Aad.Realm, Infrastructure.S2SCertThumbprint, GraphApi.GraphAPIServicePrincipalCert
        It will search for the certificate that matches the thumbprint.
        
        A result set example:
        
        EntraAppId                           Thumbprint                               Subject    Expiration
        ----------                           ----------                               -------    ----------
        e068e004-8bec-48c3-a36f-2ab4982ee738 0768175DF3DFDEA3FA78925ADC1E588707649335 CN=CHEAuth 2/5/2026 8:09:28 AM
        
    .NOTES
        Based on: https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/dev-tools/secure-developer-vm#external-integrations
        
        Author: Mötz Jensen (@Splaxi)
#>
function Test-D365EntraIntegration {
    param (
    )

    if (-not ($Script:IsAdminRuntime)) {
        Write-PSFMessage -Level Critical -Message "It seems that you ran this cmdlet <c='em'>non-elevated</c>. Testing the Entra integration requires you to run this cmdlet from an elevated console. Please exit the current console and start a new with `"Run As Administrator`""
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    # Check web.config
    $webConfigFile = Join-Path -Path $Script:AOSPath $Script:WebConfig
    
    if (-not (Test-PathExists -Path $webConfigFile -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
        Write-PSFMessage -Level Host -Message "Unable to find the web.config file."
        Stop-PSFFunction -Message "Stopping because the web.config file could not be found"
    }
    
    $config = @{}

    [xml]$xml = Get-Content $webConfigFile
    $nodes = ($xml.configuration.appSettings).ChildNodes

    $config.AadRealm = $nodes | Where-Object -Property Key -eq "Aad.Realm" | Select-Object -First 1 -ExpandProperty value
    $config.S2SCertThumbprint = $nodes | Where-Object -Property Key -eq "Infrastructure.S2SCertThumbprint" | Select-Object -First 1 -ExpandProperty value
    $config.GraphAPIServicePrincipalCert = $nodes | Where-Object -Property Key -eq "GraphApi.GraphAPIServicePrincipalCert" | Select-Object -First 1 -ExpandProperty value
    
    if ([System.String]::IsNullOrWhiteSpace($config.AadRealm)) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'Aad.Realm'</c> value is empty. This indicates that you need to run the <c='em'>'New-D365EntraIntegration'</c> cmdlet."
        Stop-PSFFunction -Message "Stopping because the 'Aad.Realm' value is empty"
    }
    
    if ([System.String]::IsNullOrWhiteSpace($config.S2SCertThumbprint)) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'Infrastructure.S2SCertThumbprint'</c> value is empty. This indicates that you need to run the <c='em'>'New-D365EntraIntegration'</c> cmdlet."
        Stop-PSFFunction -Message "Stopping because the 'Infrastructure.S2SCertThumbprint' value is empty"
    }

    if ([System.String]::IsNullOrWhiteSpace($config.GraphAPIServicePrincipalCert)) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'GraphApi.GraphAPIServicePrincipalCert'</c> value is empty. This indicates that you need to run the <c='em'>'New-D365EntraIntegration'</c> cmdlet."
        Stop-PSFFunction -Message "Stopping because the 'GraphApi.GraphAPIServicePrincipalCert' value is empty"
    }

    if ((-not [System.String]::IsNullOrWhiteSpace($config.S2SCertThumbprint)) -and $config.S2SCertThumbprint -ne $config.GraphAPIServicePrincipalCert) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'Infrastructure.S2SCertThumbprint'</c> and the <c='em'>'GraphApi.GraphAPIServicePrincipalCert'</c> value do not match each other. This indicates that you have a <c='em'>corrupted</c> configuration. Running the <c='em'>'New-D365EntraIntegration'</c> cmdlet could assist with fixing the configuration."
        Stop-PSFFunction -Message "Stopping because the 'Infrastructure.S2SCertThumbprint' and 'GraphApi.GraphAPIServicePrincipalCert' values do not match"
    }

    if (Test-PSFFunctionInterrupt) { return }

    # Check wif.config
    $wifConfigFile = Join-Path -Path $Script:AOSPath $Script:WifConfig
    
    if (-not (Test-PathExists -Path $wifConfigFile -Type Leaf -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)) {
        Write-PSFMessage -Level Host -Message "Unable to find the wif.config file."
        Stop-PSFFunction -Message "Stopping because the wif.config file could not be found"
    }
    
    [xml]$xml = Get-Content $wifConfigFile
    $nodes = ($xml.'system.identityModel'.identityConfiguration.securityTokenHandlers.securityTokenHandlerConfiguration.audienceUris).ChildNodes
    $config.AudienceUri = $nodes | Where-Object { $_.value -like "*$($config.AadRealm)*" } | Select-Object -First 1 -ExpandProperty value

    if ([System.String]::IsNullOrWhiteSpace($config.AudienceUri)) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'AudienceUri'</c> value is empty.  This indicates that you have a <c='em'>corrupted</c> configuration. Try running the <c='em'>'New-D365EntraIntegration'</c> cmdlet to fix the configuration."
        Stop-PSFFunction -Message "Stopping because the 'AudienceUri' value is empty"
    }
    elseif ($config.AadRealm -ne $config.AudienceUri) {
        Write-PSFMessage -Level Host -Message "The <c='em'>'Aad.Realm'</c> and the <c='em'>'AudienceUri'</c> value do not match each other. This indicates that you have a <c='em'>corrupted</c> configuration. Try running the <c='em'>'New-D365EntraIntegration'</c> cmdlet to fix the configuration."
        Stop-PSFFunction -Message "Stopping because the 'Aad.Realm' and 'AudienceUri' values do not match"
    }

    if (Test-PSFFunctionInterrupt) { return }

    # Check certificate
    $certStoreLocation = "Cert:\LocalMachine\My"
    
    $certEntra = Get-ChildItem -Path $certStoreLocation -ErrorAction SilentlyContinue | Where-Object { $_.Thumbprint -eq $config.S2SCertThumbprint } | Select-Object -First 1
    
    if ($null -eq $certEntra) {
        Write-PSFMessage -Level Host -Message "Unable to find any certificate in the certificate store <c='em'>'$certStoreLocation'</c> that matches the thumbprint <c='em'>'$($config.S2SCertThumbprint)'</c>."
        Stop-PSFFunction -Message "Stopping because no certificate matching the thumbprint was found"
        return
    }

    [PSCustomObject][ordered]@{
        EntraAppId = $config.AadRealm.replace("spn:", "")
        Thumbprint = $config.S2SCertThumbprint
        Subject    = $certEntra.Subject
        Expiration = $certEntra.NotAfter
    }
}