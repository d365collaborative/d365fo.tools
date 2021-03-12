---
external help file: d365fo.tools-help.xml
Module Name: d365fo.tools
online version:
schema: 2.0.0
---

# Get-D365AzureDevOpsNuget

## SYNOPSIS
Get Azure DevOps nugets

## SYNTAX

```
Get-D365AzureDevOpsNuget [-Url] <String> [-FeedName] <String> [-PeronalAccessToken] <String> [[-Name] <String>]
 [-Latest] [<CommonParameters>]
```

## DESCRIPTION
Get Azure DevOps nugets from a feed, to list all available details

## EXAMPLES

### EXAMPLE 1
```
Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"
```

This will list all packages / nugets from the Azure DevOps feed.
Foreach packacge, it will list all available versions.
The http request will be going to the Uri "https://dev.azure.com/Contoso/Financials".
The feed is identified by the FeedName "AASBuild365".
The request will authenticate with the PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"

### EXAMPLE 2
```
Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny" -Latest
```

This will list all packages / nugets from the Azure DevOps feed.
Foreach packacge, it will only list the latest version (highest).
The http request will be going to the Uri "https://dev.azure.com/Contoso/Financials".
The feed is identified by the FeedName "AASBuild365".
The request will authenticate with the PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"
The cmdlet will only output the latest version by the Latest switch.

### EXAMPLE 3
```
$currentNugets = Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny" -Latest
```

PS C:\\\> foreach ($item in $currentNugets) {
PS C:\\\>     $lcsNugets = Get-D365LcsAssetFile -FileType NuGetPackage -AssetFilename "$($item.Name)*"
PS C:\\\>     foreach ($itemInner in $lcsNugets) {
PS C:\\\>         if ($itemInner.FileName -Match "\d+\.\d+\.\d+\.\d+") {
PS C:\\\>             if ($(\[Version\]$Matches\[0\]) -gt \[Version\]$item.Version) {
PS C:\\\>                 $itemInner
PS C:\\\>             }
PS C:\\\>         }
PS C:\\\>     }
PS C:\\\> }

This will fetch all latest nugets from the Azure DevOps artifacts feed (nuget).
For each nuget found, it will fetch matching nugets from the LCS Asset Library and return those that have a higher version.

This can be used to automatically download and push the latest nuget from LCS to Azure DevOps.
Needs to be put into work with Invoke-D365AzureDevOpsNugetPush

## PARAMETERS

### -Url
The Azure DevOps url that you want to work against

It needs to be the full url for the organization and project, e.g.
"https://dev.azure.com/Contoso/Financials" - where Contoso is the organization and the Financials is the project.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uri

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FeedName
Name of the feed that you want to work against

The feed name is found under the Artifacts area in Azure DevOps

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

### -PeronalAccessToken
The Personal Access Token that you need to provide for the cmdlet to be able to communicate with the Azure DevOps REST services

The Personal Access Token is configured via the Azure DevOps portal, on your own account

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

### -Name
Name of the package / nuget that you are searching for

Supports wildcard searching e.g.
"*platform*" will output all packages / nugets that matches the search pattern

Default value is "*" which will search for all packages / nugets

```yaml
Type: String
Parameter Sets: (All)
Aliases: PackageName

Required: False
Position: 4
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Latest
Instruct the cmdlet to only fetch the latest package / nuget based on the version (highest)

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
Author: Mötz Jensen (@Splaxi)

## RELATED LINKS
