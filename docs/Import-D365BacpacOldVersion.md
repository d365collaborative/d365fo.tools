---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Import-D365BacpacOldVersion

## SYNOPSIS
Import a bacpac file

## SYNTAX

### Default (Default)
```
Import-D365BacpacOldVersion [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-BacpacFile] <String> [-NewDatabaseName] <String> [-AxDeployExtUserPwd] <String>
 [-AxDbAdminPwd] <String> [-AxRuntimeUserPwd] <String> [-AxMrRuntimeUserPwd] <String>
 [-AxRetailRuntimeUserPwd] <String> [-AxRetailDataSyncUserPwd] <String> [<CommonParameters>]
```

### UpdateOnly
```
Import-D365BacpacOldVersion [[-DatabaseServer] <String>] [[-SqlUser] <String>] [[-SqlPwd] <String>]
 [[-NewDatabaseName] <String>] [[-AxDeployExtUserPwd] <String>] [[-AxDbAdminPwd] <String>]
 [[-AxRuntimeUserPwd] <String>] [[-AxMrRuntimeUserPwd] <String>] [[-AxRetailRuntimeUserPwd] <String>]
 [[-AxRetailDataSyncUserPwd] <String>] [-UpdateOnly] [<CommonParameters>]
```

### ImportOnly
```
Import-D365BacpacOldVersion [[-DatabaseServer] <String>] [[-DatabaseName] <String>] [[-SqlUser] <String>]
 [[-SqlPwd] <String>] [-BacpacFile] <String> [-NewDatabaseName] <String> [-ImportOnly] [<CommonParameters>]
```

## DESCRIPTION
Function used for importing a bacpac file into a Tier 2 environment

## EXAMPLES

### EXAMPLE 1
```
Import-D365BacpacOldVersion -SqlUser "sqladmin" -SqlPwd "XxXx" -BacpacFile "C:\temp\uat.bacpac" -AxDeployExtUserPwd "XxXx" -AxDbAdminPwd "XxXx" -AxRuntimeUserPwd "XxXx" -AxMrRuntimeUserPwd "XxXx" -AxRetailRuntimeUserPwd "XxXx" -AxRetailDataSyncUserPwd "XxXx" -NewDatabaseName "ImportedDatabase" -verbose
```

## PARAMETERS

### -DatabaseServer
The complete server name

```yaml
Type: String
Parameter Sets: (All)
Aliases: AzureDB

Required: False
Position: 2
Default value: $Script:DatabaseServer
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatabaseName
The original databaseName

```yaml
Type: String
Parameter Sets: Default, ImportOnly
Aliases:

Required: False
Position: 3
Default value: $Script:DatabaseName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlUser
Sql server with access to create a new Database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: $Script:DatabaseUserName
Accept pipeline input: False
Accept wildcard characters: False
```

### -SqlPwd
Password for the SqlUser

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: $Script:DatabaseUserPassword
Accept pipeline input: False
Accept wildcard characters: False
```

### -BacpacFile
Location of the Bacpac file

```yaml
Type: String
Parameter Sets: Default, ImportOnly
Aliases: File

Required: True
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -NewDatabaseName
Name for the imported database

```yaml
Type: String
Parameter Sets: Default, ImportOnly
Aliases:

Required: True
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxDeployExtUserPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxDbAdminPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRuntimeUserPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxMrRuntimeUserPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRetailRuntimeUserPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AxRetailDataSyncUserPwd
Password for the user

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportOnly
{{Fill ImportOnly Description}}

```yaml
Type: SwitchParameter
Parameter Sets: ImportOnly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UpdateOnly
{{Fill UpdateOnly Description}}

```yaml
Type: SwitchParameter
Parameter Sets: UpdateOnly
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
