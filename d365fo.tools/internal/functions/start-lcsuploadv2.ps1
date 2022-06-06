
<#
    .SYNOPSIS
        Start the upload process to LCS
        
    .DESCRIPTION
        Start the flow of actions to upload a file to LCS
        
    .PARAMETER Token
        The token to be used for the http request against the LCS API
        
    .PARAMETER ProjectId
        The project id for the Dynamics 365 for Finance & Operations project inside LCS
        
    .PARAMETER FileType
        Type of file you want to upload
        
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
        
    .PARAMETER Name
        Name to be assigned / shown on LCS
        
    .PARAMETER Filename
        Filename to be assigned / shown on LCS
        
        Often will it require an extension for it to be accepted
        
    .PARAMETER Description
        Description to be assigned / shown on LCS
        
    .PARAMETER LcsApiUri
        URI / URL to the LCS API you want to use
        
        The value depends on where your LCS project is located. There are multiple valid URI's / URL's
        
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
        
    .EXAMPLE
        PS C:\> Start-LcsUploadV2 -Token "Bearer JldjfafLJdfjlfsalfd..." -ProjectId 123456789 -FileType "SoftwareDeployablePackage" -Name "ReadyForTesting" -Filename "ReadyForTesting.zip" -Description "Latest release that fixes it all" -LcsApiUri "https://lcsapi.lcs.dynamics.com"
        
        This will contact the NON-EUROPE LCS API and instruct it that we want to upload a new file to the Asset Library.
        The token "Bearer JldjfafLJdfjlfsalfd..." is used to the authorize against the LCS API.
        The ProjectId is 123456789 and FileType is "SoftwareDeployablePackage".
        The file will be named "ReadyForTesting" and the Description will be "Latest release that fixes it all".
        
    .NOTES
        Tags: Url, LCS, Upload, Api, Token
        
        Author: Mötz Jensen (@Splaxi)
        
#>

function Start-LcsUploadV2 {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Token,

        [Parameter(Mandatory = $true)]
        [int] $ProjectId,

        [Parameter(Mandatory = $true)]
        [LcsAssetFileType] $FileType,

        [string] $Name,

        [string] $Filename,

        [string] $Description,

        [string] $LcsApiUri,

        [Timespan] $RetryTimeout = "00:00:00",

        [switch] $EnableException
    )

    begin {
        Invoke-TimeSignal -Start
        
        $fileTypeValue = [int]$FileType
        $jsonPayload = @{
            Name            = $Name
            FileName        = $Filename
            FileDescription = $jsonDescription
            SizeByte        = 0
            FileType        = $fileTypeValue
        } | ConvertTo-Json

        $headers = @{
            "Authorization" = "$BearerToken"
        }

        $parms = @{}
        $parms.Method = "POST"
        $parms.Uri = "$LcsApiUri/box/fileasset/CreateFileAsset/$ProjectId"
        $parms.Headers = $headers
        $parms.RetryTimeout = $RetryTimeout
        $parms.Payload = $jsonPayload
        $parms.ContentType = "application/json"
    }
    
    process {
        try {
            Write-PSFMessage -Level Verbose -Message "Invoke LCS request."
            Invoke-RequestHandler @parms
        }
        catch [System.Net.WebException] {
            Write-PSFMessage -Level Host -Message "Error status code <c='em'>$($_.exception.response.statuscode)</c> in starting a new deployment in LCS. <c='em'>$($_.exception.response.StatusDescription)</c>." -Exception $PSItem.Exception -Target $_
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