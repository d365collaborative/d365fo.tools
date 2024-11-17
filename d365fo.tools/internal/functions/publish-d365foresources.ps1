
<#
    .SYNOPSIS
        Publish resources
        
    .DESCRIPTION
        Publishes Dynamics 365 for Finance and Operations resources to the publishing directory.
        
    .PARAMETER ResourceTypes
        The types of resources to publish.
        
    .PARAMETER PublishingDirectory
        The directory to publish the resources to. Each resource type will be published to a subdirectory.
        
    .PARAMETER PackageDirectory
        The directory containing the resources.
        
    .PARAMETER AosServiceWebRootPath
        The path to the AOS service web root containing the metadata assemblies to access the resources.
        
    .EXAMPLE
        PS C:\> Publish-D365FOResources -ResourceTypes Images,Scripts,Styles,Html -PublishingDirectory C:\temp\resources
        
        This will publish the resources of the types Images, Scripts, Styles, and Html to the directory C:\temp\resources.
        
    .NOTES
        Author: Florian Hopfner (@FH-Inway)
#>
function Publish-D365FOResources {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]] $ResourceTypes,

        [Parameter(Mandatory = $true)]
        [PsfDirectory] $PublishingDirectory,

        [Parameter(Mandatory = $false)]
        [PsfDirectory] $PackageDirectory = $Script:PackageDirectory,

        [Parameter(Mandatory = $false)]
        [PsfDirectory] $AosServiceWebRootPath = $Script:AOSPath
    )

    Invoke-TimeSignal -Start

    Write-PSFMessage -Level Verbose -Message "Initializing resources publishing."
  
    $resourcesDirectory = $PublishingDirectory
    foreach ($resourceType in $ResourceTypes) {
        $resourceTypeDirectory = Join-Path $resourcesDirectory $resourceType
        Test-PathExists -Path $resourceTypeDirectory -Type Container -Create | Out-Null
    }

    Import-Assemblies -AosServiceWebRootPath $AosServiceWebRootPath
    # For unknown reasons, the provider cannot be initialized in a separate function.
    # If this is done, $metadataProviderViaRuntime.Resources is null.
    Write-PSFMessage -Level Debug -Message "Initializing metadata runtime provider."
    $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $PackageDirectory
    $metadataProviderFactoryViaRuntime = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
    $metadataProviderViaRuntime = $metadataProviderFactoryViaRuntime.CreateRuntimeProvider($runtimeProviderConfiguration)
    
    Write-PSFMessage -Level Verbose -Message "Starting resources publishing"
    $resources = $metadataProviderViaRuntime.Resources.GetPrimaryKeys()
    foreach ($resourceItem in $resources) {
        $params = @{
            ResourceItem = $resourceItem
            MetadataProviderViaRuntime = $metadataProviderViaRuntime
            ResourceTypes = $ResourceTypes
            ResourcesDirectory = $resourcesDirectory
        }
        Publish-Resource @params
    }
    Write-PSFMessage -Level Host -Message "Resources publishing completed."

    Invoke-TimeSignal -End
}

function Import-Assemblies {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PsfDirectory] $AosServiceWebRootPath
    )

    Write-PSFMessage -Level Debug -Message "Importing required assemblies."
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
    $binDir = Join-Path $AosServiceWebRootPath "bin"
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Core.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Storage.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.Performance.Instrumentation.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll))
    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())
}

function Publish-Resource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [object] $ResourceItem,

        [Parameter(Mandatory = $true)]
        [object] $MetadataProviderViaRuntime,

        [Parameter(Mandatory = $true)]
        [string[]] $ResourceTypes,

        [Parameter(Mandatory = $true)]
        [string] $ResourcesDirectory
    )

    $resourceName = [System.String]$ResourceItem
    Write-PSFMessage -Level Debug -Message "Processing resource '$resourceName'."
    $resourceHeader = New-Object -TypeName Microsoft.Dynamics.AX.Metadata.MetaModel.MetaReadHeader
    $resource = $MetadataProviderViaRuntime.Resources.Read($resourceName, [ref]$resourceHeader)
    $resourceTimestamp = $MetadataProviderViaRuntime.Resources.GetContentTimestampUtc($resource, $resourceHeader)
    $resourceType = $resource.TypeOfResource

    $resourcePath = Join-Path $ResourcesDirectory $resourceType
    $resourceFilePath = Join-Path $resourcePath $resource.FileName
    
    Write-PSFMessage -Level Debug -Message "Checking resource '$resourceName' of type '$resourceType' for publishing."
    $resourceData = @{
        ResourceType = $resourceType
        ResourceName = $resourceName
        ResourceTimestamp = $resourceTimestamp
    }
    $params = @{
        ResourceData = $resourceData
        AllowedResourceTypes = $ResourceTypes
        ResourceFilePath = $resourceFilePath
    }
    $shouldPublishResource = Test-PublishResource @params
    if (-not $shouldPublishResource) {
        Write-PSFMessage -Level Debug -Message "Resource '$resourceName' is not being published."
        continue
    }

    Write-PSFMessage -Level Debug -Message "Publishing resource '$resourceName' to '$resourceFilePath'."
    $sourceStream = $MetadataProviderViaRuntime.Resources.GetContent($resource, $resourceHeader)
    if ($sourceStream) {
        $argumentList = @(
            $resourceFilePath,
            [System.IO.FileMode]::Create,
            [System.IO.FileAccess]::Write
        )
        $targetStream = New-Object -TypeName System.IO.FileStream -ArgumentList $argumentList
        $sourceStream.CopyTo($targetStream)

        $sourceStream.Close()
        $targetStream.Close()
        Write-PSFMessage -Level Debug -Message "Resource '$resourceName' published successfully."
    }
}

function Test-PublishResource {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [hashtable] $ResourceData,
    
        [Parameter(Mandatory = $true)]
        [string[]] $AllowedResourceTypes,

        [Parameter(Mandatory = $true)]
        [string] $ResourceFilePath
    )

    $resourceType = $ResourceData.ResourceType
    $resourceName = $ResourceData.ResourceName
    $resourceTimestamp = $ResourceData.ResourceTimestamp

    $isAResourceTypeToPublish = $AllowedResourceTypes -contains $resourceType
    if (-not $isAResourceTypeToPublish) { 
        Write-PSFMessage -Level Debug -Message "Resource '$resourceName' of type '$resourceType' is not a resource type to publish. Skipping."
        return $false 
    }

    if (-not (Test-PathExists -Path $ResourceFilePath -Type Leaf -WarningAction SilentlyContinue -ErrorAction SilentlyContinue)) {
        Write-PSFMessage -Level Debug -Message "Resource '$resourceName' does not exist. Will be published."
        return $true
    }

    $existingFileTimestamp = (Get-ItemProperty $resourceFilePath).LastWriteTimeUtc
    if ($existingFileTimestamp -ne $ResourceTimestamp) {
        Write-PSFMessage -Level Debug -Message "Resource '$ResourceName' is outdated (resource time stamp: $ResouceTimestamp, existing file time stamp: $existingFileTimestamp). Will be published."
        return $true
    }

    Write-PSFMessage -Level Debug -Message "Resource '$ResourceName' is up to date."
    return $false
}