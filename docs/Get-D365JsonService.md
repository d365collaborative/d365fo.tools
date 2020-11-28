---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365JsonService

## SYNOPSIS
Get Json based service

## SYNTAX

```
Get-D365JsonService [[-Name] <String>] [-Url] <String> [-Tenant] <String> [-ClientId] <String>
 [-ClientSecret] <String> [-RawOutput] [-OutputAsJson] [<CommonParameters>]
```

## DESCRIPTION
Get Json based services that are available from a Dynamics 365 Finance & Operations environment

## EXAMPLES

### EXAMPLE 1
```
Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will get all available service groups for the D365FO instance.
It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

### EXAMPLE 2
```
Get-D365JsonService -Name "*TS*" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
```

This will get all available service groups for the D365FO instance, which matches the "*TS*" as a name.
It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
It will limit the output to only those matching the specified Name parameter: "*TS*"

### EXAMPLE 3
```
Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -RawOutput
```

This will get all available service groups for the D365FO instance with the outer most hierarchy.
It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

### EXAMPLE 4
```
Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -OutputAsJson
```

This will get all available service groups for the D365FO instance and display the result as json.
It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".

## PARAMETERS

### -Name
The name of the json service that you are looking for

Default value is "*" to display all json services

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
URL / URI for the D365FO environment you want to access

If you are working against a D365FO instance, it will be the URL / URI for the instance itself

If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tenant
Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

Required: True
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

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
Instructs the cmdlet to include the outer structure of the response received from the endpoint

The output will still be a PSCustomObject

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

### -OutputAsJson
Instructs the cmdlet to convert the output to a Json string

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

### System.String
## NOTES
Tags: DMF, OData, RestApi, Data Management Framework

Author: Mötz Jensen (@Splaxi)

Idea taken from http://www.ksaelen.be/wordpresses/dynamicsaxblog/2016/01/dynamics-ax-7-tip-what-services-are-exposed/

## RELATED LINKS
