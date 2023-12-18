
<#
    .SYNOPSIS
        Set a new bookmark in the browser
        
    .DESCRIPTION
        Add a new bookmark to the favorite bar in the browser
        
        Edge and Chrome behaves the same
        
    .PARAMETER PathBrowser
        Path to the root folder of the profile in the browser
        
        Only default is tested / handled
        
    .PARAMETER Uri
        Uri of the system that you want to add as a bookmark
        
    .PARAMETER Name
        Name of the bookmark entry
        
    .EXAMPLE
        PS C:\> Set-BrowserBookmark -PathBrowser 'C:\Users\Admin....\AppData\Local\Microsoft\Edge\User Data\Default' -Uri 'https://devdevaos.axcloud.dynamics.com/?cmp=DAT&mi=DefaultDashboard' -Name "D365FO"
        
        This will work against the Edge browser.
        The bookmark will be for the 'https://devdevaos.axcloud.dynamics.com/?cmp=DAT&mi=DefaultDashboard' system.
        The name will be "D365FO".
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
#>
function Set-BrowserBookmark {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [string] $PathBrowser,

        [string] $Uri,

        [string] $Name
    )

    $pathBase = "$PathBrowser"

    if ((Test-PathExists -Path $pathBase -Type Container)) {
        $prefRaw = Get-Content -Path "$pathBase\Preferences" -Raw
        $prefObj = $prefRaw | ConvertFrom-Json

        if ($null -eq $prefObj.bookmark_bar) {
            # Sometimes the needed settings is missing
            $prefRaw.Replace(',"browser":', ',"bookmark_bar":{"show_on_all_tabs": true,"show_only_on_ntp":false},"browser":') | Out-File -FilePath "$pathBase\Preferences" -Encoding utf8 -Force
        }
        else {
            $prefObj.bookmark_bar.show_on_all_tabs = $true
            $($prefObj | ConvertTo-Json -Depth 10).Replace("`r`n", "") | Out-File -FilePath "$pathBase\Preferences" -Encoding utf8 -Force > $null
        }

        if (-not (Test-PathExists -Path "$pathBase\Bookmarks" -Type Leaf)) {
            # We might be handling bookmarks / favorites for the first time
            Copy-Item -Path "$script:ModuleRoot\internal\misc\Bookmarks" -Destination "$pathBase\Bookmarks" -Force > $null
        }

        $favRaw = Get-Content -Path "$pathBase\Bookmarks" -Raw
        $favObj = $favRaw | ConvertFrom-Json
    
        # If any bookmarks already exists - we need to up the counter / id
        $id = [int]$($favObj.roots.bookmark_bar.children.id | Sort-Object -Descending | Select-Object -First 1)
        $id++

        $bookMark = [PsCustomObject][Ordered]@{
            guid = [System.Guid]::NewGuid().Guid
            id   = $id
            name = $name
            type = "url"
            url  = $URL
        }

        # The children property is an array - which is a fixed size
        $children = [System.Collections.Generic.List[System.Object]]::new($favObj.roots.bookmark_bar.children)
        
        $children.Add($bookMark)
        $favObj.roots.bookmark_bar.children = $children.ToArray()
        $($favObj | ConvertTo-Json -Depth 10) | Out-File -FilePath "$pathBase\Bookmarks" -Encoding utf8 -Force > $null
    }
}