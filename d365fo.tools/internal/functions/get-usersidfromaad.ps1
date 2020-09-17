
<#
    .SYNOPSIS
        Get the SID from an Azure Active Directory (AAD) user
        
    .DESCRIPTION
        Get the generated SID that an Azure Active Directory (AAD) user will get in relation to Dynamics 365 Finance & Operations environment
        
    .PARAMETER SignInName
        The sign in name (email address) for the user that you want the SID from
        
    .PARAMETER Provider
        The provider connected to the sign in name
        
    .EXAMPLE
        PS C:\> Get-UserSIDFromAad -SignInName "Claire@contoso.com" -Provider "ZXY"
        
        This will get the SID for Azure Active Directory user "Claire@contoso.com"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-UserSIDFromAad {
    [CmdletBinding()]
    [OutputType('System.String')]
    param     (
        [string] $SignInName,
        
        [string] $Provider
    )

    try {

        $productDetails = Get-ProductInfoProvider

        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.BusinessPlatform.SharedTypes.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.PerformanceCounters.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"
        Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.AX.Security.SidGenerator.dll"

        if ($([Version]$productDetails.ApplicationVersion) -ge $([Version]"10.0.13")) {
            $SID = [Microsoft.Dynamics.Ax.Security.SidGenerator]::Generate($SignInName, $Provider, [Microsoft.Dynamics.Ax.Security.SidGenerator+SidAlgorithm]::Sha1)
        }
        else {
            $SID = [Microsoft.Dynamics.Ax.Security.SidGenerator]::Generate($SignInName, $Provider)
        }
        
        Write-PSFMessage -Level Verbose -Message "Generated SID: $SID" -Target $SID

        $SID

    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}