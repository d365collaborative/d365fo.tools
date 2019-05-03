
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
        
    .PARAMETER WaitForValidation
        Instruct the cmdlet to wait for the validation process to complete
        
        The cmdlet will sleep for 60 seconds, before requesting the status of the validation process from LCS
        
    .EXAMPLE
        PS C:\> Get-D365LcsAssetValidationStatus -ProjectId 123456789 -BearerToken "sdaflkja21jlkfjfdsa" -AssetId "958ae597-f089-4811-abbd-c1190917eaae" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will check the validation status for the file in the Asset Library with AssetId "958ae597-f089-4811-abbd-c1190917eaae".
        It will test against the Asset Library located under the LCS project 123456789.
        The BearerToken "sdaflkja21jlkfjfdsa" is used to authenticate against the LCS API endpoint.
        
        The file is validated against the NON-EUROPE LCS API.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Get-D365LcsAssetValidationStatus {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [int] $ProjectId = $Script:LcsApiProjectId,
        
        [Parameter(Mandatory = $false, Position = 2)]
        [Alias('Token')]
        [string] $BearerToken = $Script:LcsApiBearerToken,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 3)]
        [string] $AssetId,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $LcsApiUri = $Script:LcsApiLcsApiUri,

        [switch] $WaitForValidation
    )

    if (-not ($BearerToken.StartsWith("Bearer "))) {
        $BearerToken = "Bearer $BearerToken"
    }

    do {
        Write-PSFMessage -Level Verbose -Message "Sleeping before hitting the LCS API for Asset Validation Status"
        Start-Sleep -Seconds 6 #should be 60
        $status = Get-LcsAssetValidationStatus -BearerToken $BearerToken -ProjectId $ProjectId -AssetId $AssetId -LcsApiUri $LcsApiUri
    }
    while (($status.DisplayStatus -eq "Process") -and $WaitForValidation)

    $status | Select-PSFObject "ID as AssetId", "DisplayStatus as Status"
}