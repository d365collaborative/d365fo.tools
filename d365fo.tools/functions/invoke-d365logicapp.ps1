<#
.SYNOPSIS
Invoke a http request for a Logic App

.DESCRIPTION
Invoke a Logic App using a http request and pass a json object with details about the calling function

.PARAMETER Url
The URL for the http endpoint that you want to invoke

.PARAMETER Email
The email address of the receiver of the message that the cmdlet will send

.PARAMETER Subject
Subject string to apply to the email and to the IM message

.PARAMETER IncludeAll
Switch to instruct the cmdlet to include all cmdlets (names only) from the pipeline

.EXAMPLE
Invoke-D365SyncDB | Invoke-D365LogicApp

This will execute the sync process and when it is done it will invoke a Azure Logic App with the default parameters that have been configured for the system.

.EXAMPLE
Invoke-D365SyncDB | Invoke-D365LogicApp -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/

This will execute the sync process and when it is done it will invoke a Azure Logic App with the email, subject and URL parameters that are needed to invoke an Azure Logic App.

.NOTES
Author: Mötz Jensen (@Splaxi)

#>
function Invoke-D365LogicApp {
    param (
        [string] $Url = $logicApp.Url,

        [string] $Email = $logicApp.Email,

        [string] $Subject = $logicApp.Subject,

        [switch] $IncludeAll
    )

    begin {
    }
    
    process {
        $pipes = $MyInvocation.Line.Split("|")
         
        $arrList = New-Object -TypeName "System.Collections.ArrayList"
        foreach ($item in $pipes.Trim()) {
            $null = $arrList.Add( $item.Split(" ")[0])
        }

        $strMessage = "";

        if ($IncludeAll.IsPresent) {
            $strMessage = $arrList -Join ", "
        }
        else {
            $strMessage = $arrList[$MyInvocation.PipelinePosition - 2]
        }

        $strMessage = "The following list of cmdlets has executed: $strMessage"
        $RequestData = "{`"email`":`"$Email`", `"message`":`"$strMessage`", `"subject`":`"$Subject`"}"

        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
        $RequestUrl = $Url
        $request = [System.Net.WebRequest]::Create($RequestUrl)
        $request.Method = "POST"
        $request.ContentType = "application/json";

        $stream = new-object System.IO.StreamWriter ($request.GetRequestStream())
        $stream.write($RequestData)
        $stream.Flush()
        $stream.Close()

        $response = $request.GetResponse()

        $requestStream = $response.GetResponseStream()
        $readStream = New-Object System.IO.StreamReader $requestStream
        $data = $readStream.ReadToEnd()
        $data
    }
    
    end {
    }
}
