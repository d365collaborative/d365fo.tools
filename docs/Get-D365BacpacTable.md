---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365BacpacTable

## SYNOPSIS
Get tables from the bacpac file

## SYNTAX

### Default (Default)
```
Get-D365BacpacTable -Path <String> [-Table <String[]>] [-Top <Int32>] [<CommonParameters>]
```

### SortSizeAsc
```
Get-D365BacpacTable -Path <String> [-Table <String[]>] [-Top <Int32>] [-SortSizeAsc] [<CommonParameters>]
```

### SortSizeDesc
```
Get-D365BacpacTable -Path <String> [-Table <String[]>] [-Top <Int32>] [-SortSizeDesc] [<CommonParameters>]
```

## DESCRIPTION
Get tables and their metadata from the bacpac file

Metadata as in original size and compressed size, which are what size the bulk files are and will only indicate what you can expect of the table size

## EXAMPLES

### EXAMPLE 1
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac"
```

This will return all tables from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "*" as the Table parameter, to output all tables.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the default sort, which is by name acsending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
ax.DBVERSION                                                                   62 B           52 B         1
crt.RETAILUPGRADEHISTORY                                                   13,49 MB       13,41 MB         3
dbo.__AOSMESSAGEREGISTRATION                                                1,80 KB          540 B         2
dbo.__AOSSTARTUPVERSION                                                         4 B            6 B         1
dbo.ACCOUNTINGDISTRIBUTION                                                 48,60 MB        4,50 MB        95
dbo.ACCOUNTINGEVENT                                                        11,16 MB        1,51 MB       128
dbo.AGREEMENTPARAMETERS_RU                                                    366 B          113 B         1
dbo.AIFSQLCDCENABLEDTABLES                                                 13,63 KB        2,19 KB         1
dbo.AIFSQLCHANGETRACKINGENABLEDTABLES                                       9,89 KB        1,42 KB         1
dbo.AIFSQLCTTRIGGERS                                                       44,75 KB        6,29 KB         1

### EXAMPLE 2
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -SortSizeAsc
```

This will return all tables from inside the bacpac file, sorted by the original size, ascending.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "*" as the Table parameter, to output all tables.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the SortSizeAsc parameter, which is by original size acsending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.__AOSSTARTUPVERSION                                                         4 B            6 B         1
dbo.SYSSORTORDER                                                               20 B           20 B         1
dbo.SECURITYDATABASESETTINGS                                                   20 B           12 B         1
dbo.SYSPOLICYSEQUENCEGROUP                                                     24 B           10 B         1
dbo.SYSFILESTOREPARAMETERS                                                     26 B           10 B         1
dbo.SYSHELPCPSSETUP                                                            28 B           15 B         1
dbo.DATABASELOGPARAMETERS                                                      28 B           10 B         1
dbo.FEATUREMANAGEMENTPARAMETERS                                                28 B           10 B         1
dbo.AIFSQLCTVERSION                                                            28 B           24 B         1
dbo.SYSHELPSETUP                                                               28 B           15 B         1

### EXAMPLE 3
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -SortSizeDesc
```

This will return all tables from inside the bacpac file, sorted by the original size, descending.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "*" as the Table parameter, to output all tables.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the SortSizeDesc parameter, which is by original size descending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.TSTIMESHEETLINESTAGING                                                 35,31 GB        2,44 GB      9077
dbo.RESROLLUP                                                              13,30 GB      367,19 MB      3450
dbo.PROJECTSTAGING                                                         11,31 GB      508,70 MB      2929
dbo.TSTIMESHEETTABLESTAGING                                                 5,93 GB      246,65 MB      1564
dbo.BATCHHISTORY                                                            5,80 GB      234,99 MB      1529
dbo.HCMPOSITIONHIERARCHYSTAGING                                             5,16 GB      222,18 MB      1358
dbo.ERLCSFILEASSETTABLE                                                     3,15 GB      217,68 MB       302
dbo.EVENTINBOX                                                              2,92 GB      105,63 MB       747
dbo.HCMPOSITIONV2STAGING                                                    2,79 GB      200,27 MB       755
dbo.HCMEMPLOYEESTAGING                                                      2,49 GB      218,69 MB       677

### EXAMPLE 4
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -SortSizeDesc -Top 5
```

This will return all tables from inside the bacpac file, sorted by the original size, descending.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "*" as the Table parameter, to output all tables.
It uses the value 5 as the Top parameter, to output only 5 tables, based on the sorting selected.
It uses the SortSizeDesc parameter, which is by original size descending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.TSTIMESHEETLINESTAGING                                                 35,31 GB        2,44 GB      9077
dbo.RESROLLUP                                                              13,30 GB      367,19 MB      3450
dbo.PROJECTSTAGING                                                         11,31 GB      508,70 MB      2929
dbo.TSTIMESHEETTABLESTAGING                                                 5,93 GB      246,65 MB      1564
dbo.BATCHHISTORY                                                            5,80 GB      234,99 MB      1529

### EXAMPLE 5
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -Table "Sales*"
```

This will return all tables which matches the "Sales*" wildcard search from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "Sales*" as the Table parameter, to output all tables that matches the wildcard pattern.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the default sort, which is by name acsending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.SALESPARAMETERS                                                         4,29 KB          310 B         1
dbo.SALESPARMUPDATE                                                       273,48 KB       24,21 KB         1
dbo.SALESQUOTATIONTOLINEPARAMETERS                                          4,18 KB          596 B         1
dbo.SALESSUMMARYPARAMETERS                                                  2,95 KB          425 B         1
dbo.SALESTABLE                                                              1,20 KB          313 B         1
dbo.SALESTABLE_W                                                              224 B           60 B         1
dbo.SALESTABLE2LINEPARAMETERS                                               4,46 KB          637 B         1

### EXAMPLE 6
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -Table "Sales*","CUSTINVOICE*"
```

This will return all tables which matches the "Sales*" and "CUSTINVOICE*" wildcard searches from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "Sales*" and "CUSTINVOICE*" as the Table parameter, to output all tables that matches the wildcard pattern.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the default sort, which is by name acsending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.CUSTINVOICEJOUR                                                         2,01 MB      118,87 KB         1
dbo.CUSTINVOICELINE                                                        14,64 MB      975,30 KB         4
dbo.CUSTINVOICELINEINTERPROJ                                                6,58 MB      477,97 KB         2
dbo.CUSTINVOICETABLE                                                        1,06 MB       56,56 KB         1
dbo.CUSTINVOICETRANS                                                       32,34 MB        1,51 MB        54
dbo.SALESPARAMETERS                                                         4,29 KB          310 B         1
dbo.SALESPARMUPDATE                                                       273,48 KB       24,21 KB         1
dbo.SALESQUOTATIONTOLINEPARAMETERS                                          4,18 KB          596 B         1
dbo.SALESSUMMARYPARAMETERS                                                  2,95 KB          425 B         1
dbo.SALESTABLE                                                              1,20 KB          313 B         1
dbo.SALESTABLE_W                                                              224 B           60 B         1
dbo.SALESTABLE2LINEPARAMETERS                                               4,46 KB          637 B         1

### EXAMPLE 7
```
Get-D365BacpacTable -Path "c:\Temp\AxDB.bacpac" -Table "SalesTable","CustTable"
```

This will return the tables "dbo.SalesTable" and "dbo.CustTable" from inside the bacpac file.

It uses "c:\Temp\AxDB.bacpac" as the Path for the bacpac file.
It uses the default value "SalesTable" and "CustTable" as the Table parameter, to output the tables that matches the names.
It uses the default value "\[int\]::max" as the Top parameter, to output all tables.
It uses the default sort, which is by name acsending.

A result set example:

Name                                                                   OriginalSize CompressedSize BulkFiles
----                                                                   ------------ -------------- ---------
dbo.CUSTTABLE                                                             154,91 KB        8,26 KB         1
dbo.SALESTABLE                                                              1,20 KB          313 B         1

## PARAMETERS

### -Path
Path to the bacpac file that you want to work against

It can also be a zip file

```yaml
Type: String
Parameter Sets: (All)
Aliases: BacpacFile, File

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Table
Name of the table that you want to delete the data for

Supports an array of table names

If a schema name isn't supplied as part of the table name, the cmdlet will prefix it with "dbo."

Supports wildcard searching e.g.
"Sales*" will locate all "dbo.Sales*" tables in the bacpac file

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Instruct the cmdlet with how many tables you want returned

Default is \[int\]::max, which translates into all tables present inside the bapcac file

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 2147483647
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortSizeAsc
Instruct the cmdlet to sort the output by size (original) ascending

```yaml
Type: SwitchParameter
Parameter Sets: SortSizeAsc
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SortSizeDesc
Instruct the cmdlet to sort the output by size (original) descending

```yaml
Type: SwitchParameter
Parameter Sets: SortSizeDesc
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
Tags: Bacpac, Servicing, Data, SqlPackage, Table, Size, Troubleshooting

Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
