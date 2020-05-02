
<#
    .SYNOPSIS
        Enable the favorite bar and add an URL
        
    .DESCRIPTION
        Enable the favorite bar in internet explorer and put in the URL as a favorite
        
    .PARAMETER URL
        The URL of the shortcut you want to add to the favorite bar
        
    .PARAMETER D365FO
        Instruct the cmdlet that you want the populate the D365FO favorite entry based on the URL provided
        
    .PARAMETER AzureDevOps
        Instruct the cmdlet that you want the populate the AzureDevOps favorite entry based on the URL provided
        
    .EXAMPLE
        PS C:\> Set-D365FavoriteBookmark -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com"
        
        This will add the "https://usnconeboxax1aos.cloud.onebox.dynamics.com" to the favorite bar, enable the favorite bar and lock it.
        This will be interpreted as the using the -D365FO parameter also, because that is the expected behavior.
        
    .EXAMPLE
        PS C:\> Set-D365FavoriteBookmark -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -D365FO
        
        This will add the "https://usnconeboxax1aos.cloud.onebox.dynamics.com" to the favorite bar, enable the favorite bar and lock it.
        The bookmark will be mapped as the one for the Dynamics 365 Finance & Operations instance.
        
    .EXAMPLE
        PS C:\> Set-D365FavoriteBookmark -Url "https://CUSTOMERNAME.visualstudio.com/" -AzureDevOps
        
        This will add the "https://CUSTOMERNAME.visualstudio.com/" to the favorite bar, enable the favorite bar and lock it.
        The bookmark will be mapped as the one for the Azure DevOps instance.
        
    .EXAMPLE
        PS C:\> Get-D365Url | Set-D365FavoriteBookmark
        
        This will get the URL from the environment and add that to the favorite bar, enable the favorite bar and lock it.
        This will be interpreted as the using the -D365FO parameter also, because that is the expected behavior.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365FavoriteBookmark {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName="D365FO")]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $URL,

        [Parameter(Mandatory = $false, ParameterSetName = "D365FO")]
        [switch] $D365FO,

        [Parameter(Mandatory = $false, ParameterSetName = "AzureDevOps")]
        [switch] $AzureDevOps
    )
    
    begin {
    }
    
    process {
        if ($PSCmdlet.ParameterSetName -eq "D365FO") {
            $fileName = "D365FO.url"
        }
        else{
            $fileName = "AzureDevOps.url"
        }
        
        $filePath = Join-Path (Join-Path $Home "Favorites\Links") $fileName

        $pathShowBar = 'HKCU:\Software\Microsoft\Internet Explorer\MINIE\'
        $propShowBar = 'LinksBandEnabled'
        
        $pathLockBar = 'HKCU:\Software\Microsoft\Internet Explorer\Toolbar\'
        $propLockBar = 'Locked'

        $value = "00000001"
    
        Write-PSFMessage -Level Verbose -Message "Setting the show bar and lock bar registry values."
        Set-ItemProperty -Path $pathShowBar -Name $propShowBar -Value $value -Type "DWord"
        Set-ItemProperty -Path $pathLockBar -Name $propLockBar -Value $value -Type "DWord"

        $null = New-Item -Path $filePath -Force -ErrorAction SilentlyContinue

        $LinkContent = (Get-Content "$script:ModuleRoot\internal\misc\$fileName") -Join [Environment]::NewLine
        $LinkContent.Replace("##URL##", $URL) | Out-File $filePath -Force
    }
    
    end {
    }
}