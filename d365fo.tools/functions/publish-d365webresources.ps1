
<#
    .SYNOPSIS
        Deploy web resources
        
    .DESCRIPTION
        Deploys the Dynamics 365 for Finance and Operations web resources to the AOS service web root path.
        
    .PARAMETER PackageDirectory
        Path to the package directory containing the web resources.
        
    .PARAMETER AosServiceWebRootPath
        Path to the AOS service web root path.
        
    .EXAMPLE
        PS C:\> Publish-D365WebResources
        
        This will deploy the web resources to the AOS service web root path.
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
#>
function Publish-D365WebResources {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [PsfDirectory] $PackageDirectory = $Script:PackageDirectory,

        [Parameter(Mandatory = $false)]
        [PsfDirectory] $AosServiceWebRootPath = $Script:AOSPath
    )
  
    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Initializing web resources deplyoment."

    $webResourceTypes = @("Images", "Scripts", "Styles", "Html")
    
    Write-PSFMessage -Level Debug -Message "Creating web resources directory."
    $resourcesDirectory = Join-Path $AosServiceWebRootPath "Resources"
    Test-PathExists -Path $resourcesDirectory -Type Container -Create | Out-Null

    $params = @{
        ResourceTypes = $webResourceTypes
        PublishingDirectory = $resourcesDirectory
        PackageDirectory = $PackageDirectory
        AosServiceWebRootPath = $AosServiceWebRootPath
    }
    Publish-D365FOResources @params

    Write-PSFMessage -Level Host -Message "Web resources deployment completed."

    Invoke-TimeSignal -End
}