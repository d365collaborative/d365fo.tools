---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Invoke-D365SysRunnerClass

## SYNOPSIS
Start a browser session that executes SysRunnerClass

## SYNTAX

```
Invoke-D365SysRunnerClass [-ClassName] <String> [[-Company] <String>] [[-Url] <String>] [<CommonParameters>]
```

## DESCRIPTION
Makes it possible to call any runnable class directly from the browser, without worrying about the details

## EXAMPLES

### EXAMPLE 1
```
Invoke-D365SysRunnerClass -ClassName SysFlushAOD
```

Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "DAT" (default value) company

### EXAMPLE 2
```
Invoke-D365SysRunnerClass -ClassName SysFlushAOD -Company "USMF"
```

Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "USMF" company

### EXAMPLE 3
```
Invoke-D365SysRunnerClass -ClassName SysFlushAOD -Url https://Test.cloud.onebox.dynamics.com
```

Will execute the SysRunnerClass and have it execute the SysFlushAOD class and will run it against the "DAT" company, on the https://Test.cloud.onebox.dynamics.com URL

## PARAMETERS

### -ClassName
The name of the class you want to execute

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

### -Company
The company for which you want to execute the class against

Default value is: "DAT"

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $Script:Company
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
The URL you want to execute against

Default value is the Fully Qualified Domain Name registered on the machine

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:Url
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
