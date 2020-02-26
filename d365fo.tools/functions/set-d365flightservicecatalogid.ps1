
<#
    .SYNOPSIS
        Set the FlightingServiceCatalogID
        
    .DESCRIPTION
        Set the FlightingServiceCatalogID element in the web.config file used by D365FO
        
    .PARAMETER AosServiceWebRootPath
        Path to the root folder where to locate the web.config file
        
    .PARAMETER FlightServiceCatalogId
        Flighting catalog ID to be set
        
    .EXAMPLE
        PS C:\> Set-D365FlightServiceCatalogId
        
        This will set the FlightingServiceCatalogID element the web.config to the default value "12719367".
        
    .NOTES
        Tags: Flight, Flighting
        
        Author: Frank Hüther(@FrankHuether))
        
        The DataAccess.FlightingServiceCatalogID element must already exist in the web.config file, which is expected to be the case in newer environments.
        https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features
#>

function Set-D365FlightServiceCatalogId {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string]$FlightServiceCatalogId = "12719367",
        
        [string]$AosServiceWebRootPath = $Script:AOSPath
    )

    try {
        $WebConfigFile = Join-Path -Path $AosServiceWebRootPath -ChildPath $Script:WebConfig
        
        Write-PSFMessage -Level Verbose -Message "Retrieve the FlightingServiceCatalogID" -Target $WebConfigFile

        [xml]$WebConfigContents = Get-Content $WebConfigFile
        $FlightServiceNode = $WebConfigContents.SelectSingleNode("/configuration/appSettings/add[@key='DataAccess.FlightingServiceCatalogID']/@value")
        
        if($null -eq $FlightServiceNode){
            Write-PSFMessage -Level Host -Message "The <c='em'>DataAccess.FlightingServiceCatalogID</c> child element under the <c='em'>AppSettings</c> element is missing. See <c='em'>https://docs.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages#features-flighted-in-data-management-and-enabling-flighted-features</c> for details."
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }

        $FlightServiceNode.Value = $FlightServiceCatalogId

        Write-PSFMessage -Level Verbose -Message "Write the FlightingServiceCatalogID" -Target $WebConfigFile
        $WebConfigContents.Save($WebConfigFile)
        
        Write-PSFMessage -Level Verbose -Message "New FlightingServiceCatalogID: $($FlightServiceNode.Value)" -Target $WebConfigFile
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while updating the web.config file" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}