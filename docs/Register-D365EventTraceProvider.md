---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version: https://automaly.com/posts/unable-to-trace-error/
schema: 2.0.0
---

# Register-D365EventTraceProvider

## SYNOPSIS
Register D365FO Event Trace Providers

## SYNTAX

```
Register-D365EventTraceProvider [[-Path] <String>] [-EnableException] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Register event manifests from the AOS Monitoring directory to restore missing Event Trace Providers for Dynamics 365 for Finance and Operations.

Existing providers are registered again.
Each manifest uses the first matching resource DLL in this order: .Instrumentation.dll, Resource.dll, .dll.

Run from an elevated PowerShell session on the D365FO server.
Restart the VM after registration before starting a trace.

## EXAMPLES

### EXAMPLE 1
```
Register-D365EventTraceProvider
```

Register the event manifests from the configured AOS Monitoring directory.
Restart the VM afterwards before starting a trace.

### EXAMPLE 2
```
Register-D365EventTraceProvider -Path "K:\AosService\WebRoot\Monitoring" -WhatIf
```

Show which event manifests would be registered from the specified Monitoring directory.
No providers are changed.

## PARAMETERS

### -Path
Path to the Monitoring directory containing the event manifests and resource DLLs.

Defaults to the Monitoring directory below the configured AOS application root.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Join-Path -Path $Script:AOSPath -ChildPath "Monitoring")
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableException
Disable user-friendly warnings and throw exceptions that can be caught by calling scripts.

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

### -WhatIf
Show which event manifests would be registered without changing the installed providers.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompt for confirmation before registering each event manifest.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Tags: ETL, EventTracing, EventTrace, Monitoring

Based on the troubleshooting guidance published by Automaly.

## RELATED LINKS

[https://automaly.com/posts/unable-to-trace-error/](https://automaly.com/posts/unable-to-trace-error/)

