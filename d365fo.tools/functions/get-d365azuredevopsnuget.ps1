
<#
    .SYNOPSIS
        Get Azure DevOps nugets
        
    .DESCRIPTION
        Get Azure DevOps nugets from a feed, to list all available details
        
    .PARAMETER Url
        The Azure DevOps url that you want to work against
        
        It needs to be the full url for the organization and project, e.g. "https://dev.azure.com/Contoso/Financials" - where Contoso is the organization and the Financials is the project.
        
    .PARAMETER FeedName
        Name of the feed that you want to work against
        
        The feed name is found under the Artifacts area in Azure DevOps
        
    .PARAMETER PeronalAccessToken
        The Personal Access Token that you need to provide for the cmdlet to be able to communicate with the Azure DevOps REST services
        
        The Personal Access Token is configured via the Azure DevOps portal, on your own account
        
    .PARAMETER Name
        Name of the package / nuget that you are searching for
        
        Supports wildcard searching e.g. "*platform*" will output all packages / nugets that matches the search pattern
        
        Default value is "*" which will search for all packages / nugets
        
    .PARAMETER Latest
        Instruct the cmdlet to only fetch the latest package / nuget based on the version (highest)
        
    .EXAMPLE
        PS C:\> Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"
        
        This will list all packages / nugets from the Azure DevOps feed. Foreach packacge, it will list all available versions.
        The http request will be going to the Uri "https://dev.azure.com/Contoso/Financials".
        The feed is identified by the FeedName "AASBuild365".
        The request will authenticate with the PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"
        
    .EXAMPLE
        PS C:\> Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny" -Latest
        
        This will list all packages / nugets from the Azure DevOps feed. Foreach packacge, it will only list the latest version (highest).
        The http request will be going to the Uri "https://dev.azure.com/Contoso/Financials".
        The feed is identified by the FeedName "AASBuild365".
        The request will authenticate with the PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny"
        The cmdlet will only output the latest version by the Latest switch.
        
    .EXAMPLE
        PS C:\> $currentNugets = Get-D365AzureDevOpsNuget -Uri "https://dev.azure.com/Contoso/Financials" -FeedName "AASBuild365" -PeronalAccessToken "m9o7jfuch0huJ0YP2W46tTB90TQrMv0rcoZNaueBs3TLy68vF4Ny" -Latest
        PS C:\> foreach ($item in $currentNugets) {
        PS C:\>     $lcsNugets = Get-D365LcsAssetFile -FileType NuGetPackage -AssetFilename "$($item.Name)*"
        PS C:\>     foreach ($itemInner in $lcsNugets) {
        PS C:\>         if ($itemInner.FileName -Match "\d+\.\d+\.\d+\.\d+") {
        PS C:\>             if ($([Version]$Matches[0]) -gt [Version]$item.Version) {
        PS C:\>                 $itemInner
        PS C:\>             }
        PS C:\>         }
        PS C:\>     }
        PS C:\> }
        
        This will fetch all latest nugets from the Azure DevOps artifacts feed (nuget).
        For each nuget found, it will fetch matching nugets from the LCS Asset Library and return those that have a higher version.
        
        This can be used to automatically download and push the latest nuget from LCS to Azure DevOps.
        Needs to be put into work with Invoke-D365AzureDevOpsNugetPush
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Get-D365AzureDevOpsNuget {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('Uri')]
        [string] $Url,

        [Parameter(Mandatory = $true)]
        [string] $FeedName,

        [Parameter(Mandatory = $true)]
        [string] $PeronalAccessToken,

        [Alias('PackageName')]
        [string] $Name = "*",

        [switch] $Latest
    )
    
    begin {
        if ($Url -notlike "https://dev.azure.com/*/*") {
            $messageString = "The supplied uri is not in a valid format. Please enter the project uri like <c='em'>https://dev.azure.com/[ORGANIZATION]]/[PROJECT]</c>."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because the uri is wrongly formatted." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
            return
        }
        else {
            $uriPackages = $Url.Replace("https://dev.azure.com", "https://feeds.dev.azure.com") + "/_apis/packaging/Feeds/{0}/packages?api-version=6.0-preview.1&includeAllVersions=true"

            if ($Name -NotMatch '\*') {
                $uriPackages += "&packageNameQuery={1}"
            }

            $uriFeeds = $Url.Replace("https://dev.azure.com", "https://feeds.dev.azure.com") + "/_apis/packaging/Feeds?api-version=6.0-preview.1"
        }

        $header = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PeronalAccessToken)")) }

    }
    
    process {
        if (Test-PSFFunctionInterrupt) { return }

        $feedsRaw = Invoke-RestMethod -Method Get -Uri $uriFeeds -Headers $header

        $feeds = @($feedsRaw | Select-Object -ExpandProperty Value)

        $feed = $feeds | Where-Object Name -like $FeedName | Select-Object -First 1

        if (-not $feed) {
            $messageString = "No feed found that matched the provided feedname <c='em'>$feedname</c>."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because the feed couldn't be located." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
            return
        }

        $uriPackages = $uriPackages -f $($feed.Id), $Name

        $packagesRaw = Invoke-RestMethod -Method Get -Uri $uriPackages -Headers $header

        $packages = @($packagesRaw | Select-Object -ExpandProperty value)

        foreach ($item in $packages) {
            if ($item.Name -NotLike $Name) { continue }

            foreach ($itemInner in $item.versions) {
                if ($Latest) {
                    if (-not $itemInner.IsLatest) { continue }
                }

                [PSCustomObject][ordered]@{
                    Name       = $item.Name
                    Version    = [Version]$itemInner.Version
                    VersionId  = $itemInner.Id
                    IsLatest   = $itemInner.IsLatest
                    PackageId  = $item.Id
                    PackageUrl = $item.Url

                }
            }
        }
    }
    
    end {
        
    }
}