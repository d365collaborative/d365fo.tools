
<#
    .SYNOPSIS
        Get information for all assets of a type from the shared asset library of LCS
        
    .DESCRIPTION
        Get the information for the available file assets of a certain type from the shared asset library of LCS
        
    .PARAMETER FileType
        Type of file you want to get information for
        
        Valid options:
        "Model"
        "Process Data Package"
        "Software Deployable Package"
        "GER Configuration"
        "Data Package"
        "PowerBI Report Model"
        "E-Commerce Package"
        "NuGet Package"
        "Retail Self-Service Package"
        "Commerce Cloud Scale Unit Extension"
        
    .PARAMETER BearerToken
        The token you want to use when working against the LCS api
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on which LCS shared asset library you want to query. There are multiple valid URI's / URL's.
        Not that not all file types may be available in all URIs.
        
        Valid options:
        "https://lcsapi.lcs.dynamics.com"
        "https://lcsapi.eu.lcs.dynamics.com"
        "https://lcsapi.fr.lcs.dynamics.com"
        "https://lcsapi.sa.lcs.dynamics.com"
        "https://lcsapi.uae.lcs.dynamics.com"
        "https://lcsapi.ch.lcs.dynamics.com"
        "https://lcsapi.no.lcs.dynamics.com"
        "https://lcsapi.lcs.dynamics.cn"
        "https://lcsapi.gov.lcs.microsoftdynamics.us"
        
    .PARAMETER RetryTimeout
        The retry timeout, before the cmdlet should quit retrying based on the 429 status code
        
        Needs to be provided in the timspan notation:
        "hh:mm:ss"
        
        hh is the number of hours, numerical notation only
        mm is the number of minutes
        ss is the numbers of seconds
        
        Each section of the timeout has to valid, e.g.
        hh can maximum be 23
        mm can maximum be 59
        ss can maximum be 59
        
        Not setting this parameter will result in the cmdlet to try for ever to handle the 429 push back from the endpoint
        
    .PARAMETER EnableException
        This parameters disables user-friendly warnings and enables the throwing of exceptions
        This is less user friendly, but allows catching exceptions in calling scripts
        Usually this parameter is not used directly, but via the Enable-D365Exception cmdlet
        See https://github.com/d365collaborative/d365fo.tools/wiki/Exception-handling#what-does-the--enableexception-parameter-do for further information
        
    .EXAMPLE
        PS C:\> Get-LcsSharedAssetFile -FileType SoftwareDeployablePackage -BearerToken "JldjfafLJdfjlfsalfd..." -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will get all software deployable packages from the shared asset library of LCS.
        The FileType is Software Deployable Packages, with the FileType parameter.
        The request will authenticate with the BearerToken "JldjfafLJdfjlfsalfd...".
        The http request will be going to the LcsApiUri "https://lcsapi.lcs.dynamics.com" (NON-EUROPE).
        
    .NOTES
        Tags: Environment, LCS, Api, AAD, Token, Asset, File, Files
        
        Author: Florian Hopfner (@FH-Inway)
#>

function Get-LcsSharedAssetFile {
    [Cmdletbinding()]
    param(
        [LcsAssetFileType] $FileType,

        [Alias('Token')]
        [string] $BearerToken,
        
        [Parameter(Mandatory = $true)]
        [string] $LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $fileTypeValue = [int]$FileType
        
        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "GET"
        $parms.Uri = "$LcsApiUri/box/fileasset/GetSharedAssets?fileType=$($fileTypeValue)"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
    }

    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in request for listing files from the shared asset library of LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception
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