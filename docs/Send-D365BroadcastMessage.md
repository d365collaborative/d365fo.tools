---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Send-D365BroadcastMessage

## SYNOPSIS
Send broadcast message to online users in D365FO

## SYNTAX

```
Send-D365BroadcastMessage [[-Tenant] <String>] [[-URL] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <String>] [[-TimeZone] <String>] [[-StartTime] <DateTime>] [[-EndingInMinutes] <Int32>]
 [-OnPremise] [<CommonParameters>]
```

## DESCRIPTION
Utilize the same messaging framework available from LCS and send a broadcast message to all online users in the environment

## EXAMPLES

### EXAMPLE 1
```
Send-D365BroadcastMessage
```

This will send a message to all active users that are working on default D365FO environment.

See the RELATED LINKS section for the supporting cmdlets needed to store a default configuration.

### EXAMPLE 2
```
Send-D365BroadcastMessage -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will send a message to all active users that are working on the D365FO environment located at "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
It will authenticate against the Azure Active Directory with the "e674da86-7ee5-40a7-b777-1111111111111" guid.
It will use the ClientId "dea8d7a9-1602-4429-b138-111111111111" and ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" go get access to the environment.
It will use the default value "UTC" Time Zone for converting the different time and dates.
It will use the default start time which is NOW.
It will use the default end time which is 60 minutes.

### EXAMPLE 3
```
Send-D365BroadcastMessage -OnPremise -Tenant "https://adfs.local/adfs" -URL "https://ax-sandbox.d365fo.local" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will send a message to all active users that are working on the D365FO OnPremise environment located at "https://ax-sandbox.d365fo.local".
It will authenticate against Local ADFS with the "https://adfs.local/adfs" path
It will use the ClientId "dea8d7a9-1602-4429-b138-111111111111" and ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" go get access to the environment.
It will use the default value "UTC" Time Zone for converting the different time and dates.
It will use the default start time which is NOW.
It will use the default end time which is 60 minutes.

## PARAMETERS

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to send a message to

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: 2
Default value: $Script:BroadcastTenant
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
URL / URI for the D365FO environment you want to send a message to

```yaml
Type: String
Parameter Sets: (All)
Aliases: URI

Required: False
Position: 3
Default value: $Script:BroadcastUrl
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The ClientId obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:BroadcastClientId
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The ClientSecret obtained from the Azure Portal when you created a Registered Application

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:BroadcastClientSecret
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeZone
Id of the Time Zone your environment is running in

You might experience that the local VM running the D365FO is running another Time Zone than the computer you are running this cmdlet from

All available .NET Time Zones can be traversed with tab for this parameter

The default value is "UTC"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: $Script:BroadcastTimeZone
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
The time and date you want the message to be displayed for the users

Default value is NOW

The specified StartTime will always be based on local Time Zone.
If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndingInMinutes
Specify how many minutes into the future you want this message / maintenance window to last

Default value is 60 minutes

The specified StartTime will always be based on local Time Zone.
If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: $Script:BroadcastEndingInMinutes
Accept pipeline input: False
Accept wildcard characters: False
```

### -OnPremise
Specify if environnement is an D365 OnPremise

Default value is "Not set" (= Cloud Environnement)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: $Script:BroadcastOnPremise
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The specified StartTime will always be based on local Time Zone.
If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.

For OnPremise environnement use -OnPremise flag to added "namespaces/AXSF" path to D365 URL and allow to get token from local ADFS server

Tags: Servicing, Message, Users, Environment

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Add-D365BroadcastMessageConfig]()

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Set-D365ActiveBroadcastMessageConfig]()

