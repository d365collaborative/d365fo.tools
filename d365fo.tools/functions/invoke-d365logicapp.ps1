
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
        
    .PARAMETER AsJob
        Switch to instruct the cmdlet to run the invocation as a job (async)
        
    .EXAMPLE
        PS C:\> Invoke-D365SyncDB | Invoke-D365LogicApp
        
        This will execute the sync process and when it is done it will invoke a Azure Logic App with the default parameters that have been configured for the system.
        
    .EXAMPLE
        PS C:\> Invoke-D365SyncDB | Invoke-D365LogicApp -Email administrator@contoso.com -Subject "Work is done" -Url https://prod-35.westeurope.logic.azure.com:443/
        
        This will execute the sync process and when it is done it will invoke a Azure Logic App with the email, subject and URL parameters that are needed to invoke an Azure Logic App.
        
    .NOTES
        Tags: LogicApp, Logic App, Configuration, Url, Email, Notification, Message, Email
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365LogicApp {
    param (
        [string] $Url = (Get-D365LogicAppConfig).Url,

        [string] $Email = (Get-D365LogicAppConfig).Email,

        [string] $Subject = (Get-D365LogicAppConfig).Subject,

        [switch] $IncludeAll,
        
        [switch] $AsJob

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

        if ($IncludeAll) {
            $strMessage = $arrList -Join ", "
        }
        else {
            $strMessage = $arrList[$MyInvocation.PipelinePosition - 2]
        }

        $strMessage = "The following list of cmdlets has executed: $strMessage"
        
        Invoke-PSNMessage -Url $URL -ReceiverEmail $Email -Subject $Subject -Message $strMessage -AsJob:$AsJob
    }
    
    end {
    }
}