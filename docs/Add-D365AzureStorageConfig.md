---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Add-D365AzureStorageConfig

## SYNOPSIS
Save an Azure Storage Account config

## SYNTAX

### AccessToken
```
Add-D365AzureStorageConfig -Name <String> -AccountId <String> -AccessToken <String> -Container <String>
 [-Temporary] [-Force] [<CommonParameters>]
```

### SAS
```
Add-D365AzureStorageConfig -Name <String> -AccountId <String> -SAS <String> -Container <String> [-Temporary]
 [-Force] [<CommonParameters>]
```

## DESCRIPTION
Adds an Azure Storage Account config to the configuration store

## EXAMPLES

### EXAMPLE 1
```
Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Container "testblob"
```

This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", AccessToken "dafdfasdfasdf" and blob container "testblob".

### EXAMPLE 2
```
Add-D365AzureStorageConfig -Name UAT-Exports -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -AccountId "1234" -Container "testblob"
```

This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", SAS "sv=2018-03-28&si=unlisted&sr=c&sig=AUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" and blob container "testblob".
The SAS key enables you to provide explicit access to a given blob container inside an Azure Storage Account.
The SAS key can easily be revoked and that way you have control over the access to the container and its content.

### EXAMPLE 3
```
Add-D365AzureStorageConfig -Name UAT-Exports -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -AccountId "1234" -Container "testblob" -Temporary
```

This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", SAS "sv=2018-03-28&si=unlisted&sr=c&sig=AUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" and blob container "testblob".
The SAS key enables you to provide explicit access to a given blob container inside an Azure Storage Account.
The SAS key can easily be revoked and that way you have control over the access to the container and its content.

The configuration will only last for the rest of this PowerShell console session.

## PARAMETERS

### -Name
The logical name of the Azure Storage Account you are about to registered in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountId
The account id for the Azure Storage Account you want to register in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessToken
The access token for the Azure Storage Account you want to register in the configuration store

```yaml
Type: String
Parameter Sets: AccessToken
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SAS
The SAS key that you have created for the storage account or blob container

```yaml
Type: String
Parameter Sets: SAS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Container
The name of the blob container inside the Azure Storage Account you want to register in the configuration store

```yaml
Type: String
Parameter Sets: (All)
Aliases: Blobname, Blob

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Temporary
Instruct the cmdlet to only temporarily add the azure storage account configuration in the configuration store

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
Switch to instruct the cmdlet to overwrite already registered Azure Storage Account entry

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
Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
