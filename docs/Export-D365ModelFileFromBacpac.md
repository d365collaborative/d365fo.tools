---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Export-D365ModelFileFromBacpac

## SYNOPSIS
Extract the "model.xml" from the bacpac file

## SYNTAX

```
Export-D365ModelFileFromBacpac [-Path] <String> [-OutputPath] <String> [[-ExtractionPath] <String>] [-Force]
 [-KeepFiles] [<CommonParameters>]
```

## DESCRIPTION
Extract the "model.xml" file from inside the bacpac file

This can be used to update SQL Server options for how the SqlPackage.exe should import the bacpac file into your SQL Server / Azure SQL DB

## EXAMPLES

### EXAMPLE 1
```
Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml"
```

This will extract the "model.xml" file from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will delete the extracted files after extracting the "model.xml" file.

### EXAMPLE 2
```
Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" -Force
```

This will extract the "model.xml" file from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will override the "C:\Temp\model.xml" if already present.

It will delete the extracted files after extracting the "model.xml" file.

### EXAMPLE 3
```
Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" -KeepFiles
```

This will extract the "model.xml" file from inside the bacpac file.

It uses "C:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses "C:\Temp\model.xml" as the OutputPath to where it will store the extracted "model.xml" file.
It uses the default ExtractionPath folder "C:\Temp\d365fo.tools\BacpacExtractions".

It will NOT delete the extracted files after extracting the "model.xml" file.

### EXAMPLE 4
```
Export-d365ModelFileFromBacpac -Path "C:\Temp\AxDB.bacpac" -OutputPath "C:\Temp\model.xml" | Get-D365SqlOptionsFromBacpacModelFile
```

This will display all the SQL Server options configured in the bacpac file.
First it will export the model.xml from the "C:\Temp\AxDB.bacpac" file, using the Export-d365ModelFileFromBacpac function.
The output from Export-d365ModelFileFromBacpac will be piped into the Get-D365SqlOptionsFromBacpacModelFile function.

## PARAMETERS

### -Path
Path to the bacpac file that you want to work against

It can also be a zip file

```yaml
Type: String
Parameter Sets: (All)
Aliases: BacpacFile, File

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath
Path to where you want the updated bacpac file to be saved

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

### -ExtractionPath
Path to where you want the cmdlet to extract the files from the bacpac file while it deletes data

The default value is "c:\temp\d365fo.tools\BacpacExtractions"

When working the cmdlet will create a sub-folder named like the bacpac file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(Join-Path $Script:DefaultTempPath "BacpacExtractions")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Switch to instruct the cmdlet to overwrite the "model.xml" specified in the OutputPath

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

### -KeepFiles
Switch to instruct the cmdlet to keep the extracted files and folders

This will leave the files in place, after the extraction of the "model.xml" file

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
Tags: Bacpac, Servicing, Data, SqlPackage, Sql Server Options, Collation

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
