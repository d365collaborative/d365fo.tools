---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365LcsAssetFile

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
Get-D365LcsAssetFile [[-ProjectId] <Int32>] [[-FileType] <LcsAssetFileType>] [[-AssetName] <String>]
 [[-AssetVersion] <String>] [[-BearerToken] <String>] [[-LcsApiUri] <String>] [-Latest] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AssetName
{{ Fill AssetName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetVersion
{{ Fill AssetVersion Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BearerToken
{{ Fill BearerToken Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: Token

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FileType
{{ Fill FileType Description }}

```yaml
Type: LcsAssetFileType
Parameter Sets: (All)
Aliases:
Accepted values: Model, ProcessDataPackage, SoftwareDeployablePackage, GERConfiguration, DataPackage, PowerBIReportModel

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
{{ Fill Latest Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: GetLatest

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LcsApiUri
{{ Fill LcsApiUri Description }}

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

### -ProjectId
{{ Fill ProjectId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
