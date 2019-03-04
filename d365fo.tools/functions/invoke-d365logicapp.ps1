
<#
    .SYNOPSIS
        Invoke a http request for a Logic App
        
    .DESCRIPTION
        Invoke a Logic App using a http request and pass a json object with details about the calling function
        
    .PARAMETER Url
        The URL for the http endpoint that you want to invoke
        
    .PARAMETER Payload
        The data content you want to send to the LogicApp
        
    .EXAMPLE
        PS C:\> Invoke-D365SyncDB | Invoke-D365LogicApp
        
        This will execute the sync process and when it is done it will invoke a Azure Logic App with the default parameters that have been configured for the system.
        
    .NOTES
        Tags: LogicApp, Logic App, Configuration, Url, Notification
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365LogicApp {
    param (
        [string] $Url = (Get-D365LogicAppConfig).Url,

        [Parameter(Mandatory = $false)]
        [string] $Payload = "{}"
    )

    Invoke-PSNHttpEndpoint -Url $URL -Payload $Payload
}