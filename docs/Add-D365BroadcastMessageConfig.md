---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365BroadcastMessageConfig

## SYNOPSIS
Save a broadcast message config

## SYNTAX

```
Add-D365BroadcastMessageConfig [-Name] <String> [[-Tenant] <String>] [[-URL] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <String>] [[-TimeZone] <String>] [[-EndingInMinutes] <Int32>] [-OnPremise] [-Temporary]
 [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds a broadcast message config to the configuration store

## EXAMPLES

### EXAMPLE 1
```
Add-D365BroadcastMessageConfig -Name "UAT" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will create a new broadcast message configuration with the name "UAT".
It will save "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
It will save "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the D365FO environment.
It will save "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will save "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
It will use the default value "UTC" Time Zone for converting the different time and dates.
It will use the default end time which is 60 minutes.

### EXAMPLE 2
```
Add-D365BroadcastMessageConfig -Name "UAT" -OnPremise -Tenant "https://adfs.local/adfs" -URL "https://ax-sandbox.d365fo.local" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will create a new broadcast message configuration with the name "UAT".
It will target an OnPremise environment.
It will save "https://adfs.local/adfs" as the OAuth Tenant Provider.
It will save "https://ax-sandbox.d365fo.local" as the D365FO environment.
It will save "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
It will save "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
It will use the default value "UTC" Time Zone for converting the different time and dates.
It will use the default end time which is 60 minutes.

## PARAMETERS

### -Name
The logical name of the broadcast configuration you are about to register in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to send a message to

```yaml
Type: String
Parameter Sets: (All)
Aliases: $AADGuid

Required: False
Position: 2
Default value: None
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
Default value: None
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
Default value: None
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
Default value: None
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
Default value: UTC
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
Position: 7
Default value: 60
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
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temporary
Instruct the cmdlet to only temporarily add the broadcast message configuration in the configuration store

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Instruct the cmdlet to overwrite the broadcast message configuration with the same name

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS

[Clear-D365ActiveBroadcastMessageConfig]()

[Get-D365ActiveBroadcastMessageConfig]()

[Get-D365BroadcastMessageConfig]()

[Remove-D365BroadcastMessageConfig]()

[Send-D365BroadcastMessage]()

[Set-D365ActiveBroadcastMessageConfig]()

