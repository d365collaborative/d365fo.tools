
<#
    .SYNOPSIS
        Send broadcast message to online users in D365FO
        
    .DESCRIPTION
        Utilize the same messaging framework available from LCS and send a broadcast message to all online users in the environment
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to send a message to
        
    .PARAMETER URL
        URL / URI for the D365FO environment you want to send a message to
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER TimeZone
        Id of the Time Zone your environment is running in
        
        You might experience that the local VM running the D365FO is running another Time Zone than the computer you are running this cmdlet from
        
        All available .NET Time Zones can be traversed with tab for this parameter
        
        The default value is "UTC"
        
    .PARAMETER StartTime
        The time and date you want the message to be displayed for the users
        
        Default value is NOW
        
        The specified StartTime will always be based on local Time Zone. If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.
        
    .PARAMETER EndingInMinutes
        Specify how many minutes into the future you want this message / maintenance window to last
        
        Default value is 60 minutes
        
        The specified StartTime will always be based on local Time Zone. If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.
        
    .PARAMETER OnPremise
        Specify if environnement is an D365 OnPremise
        
        Default value is "Not set" (= Cloud Environnement)
        
    .EXAMPLE
        PS C:\> Send-D365BroadcastMessage
        
        This will send a message to all active users that are working on default D365FO environment.
        
        See the RELATED LINKS section for the supporting cmdlets needed to store a default configuration.
        
    .EXAMPLE
        PS C:\> Send-D365BroadcastMessage -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will send a message to all active users that are working on the D365FO environment located at "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        It will authenticate against the Azure Active Directory with the "e674da86-7ee5-40a7-b777-1111111111111" guid.
        It will use the ClientId "dea8d7a9-1602-4429-b138-111111111111" and ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" go get access to the environment.
        It will use the default value "UTC" Time Zone for converting the different time and dates.
        It will use the default start time which is NOW.
        It will use the default end time which is 60 minutes.
        
    .EXAMPLE
        PS C:\> Send-D365BroadcastMessage -OnPremise -Tenant "https://adfs.local/adfs" -URL "https://ax-sandbox.d365fo.local" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will send a message to all active users that are working on the D365FO OnPremise environment located at "https://ax-sandbox.d365fo.local".
        It will authenticate against Local ADFS with the "https://adfs.local/adfs" path
        It will use the ClientId "dea8d7a9-1602-4429-b138-111111111111" and ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" go get access to the environment.
        It will use the default value "UTC" Time Zone for converting the different time and dates.
        It will use the default start time which is NOW.
        It will use the default end time which is 60 minutes.
        
    .NOTES
        
        The specified StartTime will always be based on local Time Zone. If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.
        
        For OnPremise environnement use -OnPremise flag to added "namespaces/AXSF" path to D365 URL and allow to get token from local ADFS server
        
        Tags: Servicing, Message, Users, Environment
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Add-D365BroadcastMessageConfig
        
    .LINK
        Clear-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365BroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
        
#>

function Send-D365BroadcastMessage {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [Alias('$AADGuid')]
        [string] $Tenant = $Script:BroadcastTenant,

        [Parameter(Mandatory = $false, Position = 2)]
        [Alias('URI')]
        [string] $URL = $Script:BroadcastUrl,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $ClientId = $Script:BroadcastClientId,

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $ClientSecret = $Script:BroadcastClientSecret,

        [Parameter(Mandatory = $false, Position = 5)]
        [string] $TimeZone = $Script:BroadcastTimeZone,

        [Parameter(Mandatory = $false, Position = 6)]
        [datetime] $StartTime = (Get-Date),

        [Parameter(Mandatory = $false, Position = 7)]
        [int] $EndingInMinutes = $Script:BroadcastEndingInMinutes,

        [Parameter(Mandatory = $false, Position = 8)]
        [switch] $OnPremise = $Script:BroadcastOnPremise
    )

    $URL = $URL -replace "/$", ""

    $bearerParms = @{
        Resource     = $URL
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
    }

    if ($OnPremise) {
        $bearerParms.AuthProviderUri = "$Tenant/oauth2/token"
    }
    else {
        $bearerParms.AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"
    }

    $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

    $headerParms = @{
        URL         = $URL
        BearerToken = $bearer
    }

    $headers = New-AuthorizationHeaderBearerToken @headerParms

    [System.UriBuilder] $messageEndpoint = $URL

    if ($OnPremise) {
        $messageEndpoint.Path = "namespaces/AXSF/api/services/SysBroadcastMessageServices/SysBroadcastMessageService/AddMessage"
    }
    else {
        $messageEndpoint.Path = "api/services/SysBroadcastMessageServices/SysBroadcastMessageService/AddMessage"
    }

    $endTime = $StartTime.AddMinutes($EndingInMinutes)
    
    $timeZoneFound = Get-TimeZone -InputObject $TimeZone

    if (Test-PSFFunctionInterrupt) { return }
    
    $startTimeConverted = [System.TimeZoneInfo]::ConvertTime($startTime, [System.TimeZoneInfo]::Local, $timeZoneFound)
    $endTimeConverted = [System.TimeZoneInfo]::ConvertTime($endTime, [System.TimeZoneInfo]::Local, $timeZoneFound)

    $body = @"
{
    "request": {
        "FromDateTime": "$($startTimeConverted.ToString("s"))",
        "ToDateTime": "$($endTimeConverted.ToString("s"))"
    }
}
"@

    try {
        [PSCustomObject]@{
            MessageId = Invoke-RestMethod -Method Post -Uri $messageEndpoint.Uri.AbsoluteUri -Headers $headers -ContentType 'application/json' -Body $body
        }
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while trying to send a message to the users." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors."
        return
    }
}