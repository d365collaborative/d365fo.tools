
<#
    .SYNOPSIS
        Get the validation status from LCS
        
    .DESCRIPTION
        Get the validation status for a given file in the Asset Library in LCS
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER AssetId
        The unique id of the asset / file that you are trying to deploy from LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        Depending on whether your LCS project is located in europe or not, there is 2 valid URI's / URL's
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        
    .EXAMPLE
        PS C:\> Get-LcsAssetValidationStatus -ProjectId 123456789 -BearerToken "JldjfafLJdfjlfsalfd..." -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the file with the AssetId "958ae597-f089-4811-abbd-c1190917eaae" in validated or not.
        It will test against the Asset Library located under the LCS project 123456789.
        The BearerToken "JldjfafLJdfjlfsalfd..." is used to authenticate against the LCS API endpoint.
        The file will be named "ReadyForTesting" inside the Asset Library in LCS.
        The file is validated against the NON-EUROPE LCS API.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>

function Get-LcsAssetValidationStatusV2 {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true)]
        [int] $ProjectId,
        
        [Parameter(Mandatory = $true)]
        [Alias('Token')]
        [string] $BearerToken,

        [Parameter(Mandatory = $true)]
        [string] $AssetId,

        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "GET"
        $parms.Uri = "$LcsApiUri/box/fileasset/GetFileAssetValidationStatus/$($ProjectId)?assetId=$AssetId"
        $parms.Headers = $headers
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RestMethod @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for listing files from the asset library of LCS. $($_.exception.response.StatusDescription)." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the LCS API." -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors" -StepsUpward 1
            return
        }

        Invoke-TimeSignal -End
    }
}