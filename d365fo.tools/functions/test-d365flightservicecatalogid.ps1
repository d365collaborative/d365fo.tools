
<#
    .SYNOPSIS
        Test if the FlightingServiceCatalogID is present and filled out
        
    .DESCRIPTION
        Test if the FlightingServiceCatalogID element exists in the web.config file used by D365FO
        
    .PARAMETER AosServiceWebRootPath
        Path to the root folder where to locate the web.config file
        
    .EXAMPLE
        PS C:\> Test-D365FlightServiceCatalogId
        
        This will open the web.config and check if the FlightingServiceCatalogID element is present or not.
        
    .NOTES
        Tags: Flight, Flighting
        
        Author: Mötz Jensen (@Splaxi))
        
        The DataAccess.FlightingServiceCatalogID must already be set in the web.config file.
        https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features
#>

function Test-D365FlightServiceCatalogId {
    [CmdletBinding()]
    param (
        [string]$AosServiceWebRootPath = $Script:AOSPath
    )

    $res = @{}

    try {
        $WebConfigFile = Join-Path -Path $AosServiceWebRootPath -ChildPath $Script:WebConfig
        
        Write-PSFMessage -Level Verbose -Message "Retrieve the FlightingServiceCatalogID" -Target $WebConfigFile

        $FlightServiceNode = Select-Xml -XPath "/configuration/appSettings/add[@key='DataAccess.FlightingServiceCatalogID']/@value" -Path $WebConfigFile
        
        if($null -eq $FlightServiceNode){
            Write-PSFMessage -Level Host -Message "The <c='em'>DataAccess.FlightingServiceCatalogID</c> child element under the <c='em'>AppSettings</c> element is missing. See <c='em'>https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features</c> for details."
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        $res.FlightingServiceCatalogID = $FlightServiceNode.Node.Value
        
        Write-PSFMessage -Level Verbose -Message "FlightingServiceCatalogID: $FlightServiceId" -Target $WebConfigFile
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while reading from the web.config file" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }

    if(-not [System.String]::IsNullOrEmpty($res.FlightingServiceCatalogID)){
        [PsCustomObject]$res
    }
}