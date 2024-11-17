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
    
    Write-PSFMessage -Level Debug -Message "Creating web resource directories."
    $resourcesDirectory = Join-Path $AosServiceWebRootPath "Resources"
    Test-PathExists -Path $resourcesDirectory -Type Container -Create | Out-Null

    $webResourceTypes | ForEach-Object {
        $resourceTypeDirectory = Join-Path $resourcesDirectory $_
        Test-PathExists -Path $resourceTypeDirectory -Type Container -Create | Out-Null
    }

    Write-PSFMessage -Level Debug -Message "Importing required assemblies."
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
    $binDir = Join-Path $AosServiceWebRootPath "bin"
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Core.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.AX.Metadata.Storage.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.Performance.Instrumentation.dll))
    $null = $Files2Process.Add((Join-Path $binDir Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll))
    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())

    Write-PSFMessage -Level Debug -Message "Initializing metadata runtime provider."
    $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $PackageDirectory
    $metadataProviderFactoryViaRuntime = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
    $metadataProviderViaRuntime = $metadataProviderFactoryViaRuntime.CreateRuntimeProvider($runtimeProviderConfiguration)

    Write-PSFMessage -Level Verbose -Message "Starting web resources deployment"
    $resources = $metadataProviderViaRuntime.Resources.GetPrimaryKeys()
    foreach ($resourceItem in $resources) {
        $resourceName = [System.String]$resourceItem
        Write-PSFMessage -Level Debug -Message "Processing resource '$resourceName'."
        $resourceHeader = New-Object -TypeName Microsoft.Dynamics.AX.Metadata.MetaModel.MetaReadHeader
        $resource = $metadataProviderViaRuntime.Resources.Read($resourceName, [ref]$resourceHeader)
        $resourceTimestamp = $metadataProviderViaRuntime.Resources.GetContentTimestampUtc($resource, $resourceHeader)
        $resourceType = $resource.TypeOfResource

        $isAWebResource = $webResourceTypes -contains $resourceType
        if (-not $isAWebResource) { 
            Write-PSFMessage -Level Debug -Message "Resource '$resourceName' is not a web resource. Skipping."
            continue 
        }

        Write-PSFMessage -Level Debug -Message "Checking web resource '$resourceName' of type '$resourceType' for deployment."
        $resourcePath = Join-Path $resourcesDirectory $resourceType
        $resourceFilePath = Join-Path $resourcePath $resource.FileName

        $copyFile = $false
        if (-not (Test-PathExists -Path $resourceFilePath -Type Leaf -WarningAction SilentlyContinue -ErrorAction SilentlyContinue)) {
            Write-PSFMessage -Level Debug -Message "Web resource '$resourceName' does not exist. Will be deployed."
            $copyFile = $true
        }
        else {
            $existingFileTimestamp = (Get-ItemProperty $resourceFilePath).LastWriteTimeUtc
            if ($existingFileTimestamp -ne $resourceTimestamp) {
                Write-PSFMessage -Level Debug -Message "Web resource '$resourceName' is outdated (resource time stamp: $resouceTimestamp, existing file time stamp: $existingFileTimestamp). Will be deployed."
                $copyFile = $true
            }
        }

        if (-not $copyFile) {
            Write-PSFMessage -Level Debug -Message "Web resource '$resourceName' is up to date."
            continue
        }

        Write-PSFMessage -Level Debug -Message "Deploying web resource '$resourceName' to '$resourceFilePath'."
        $sourceStream = $metadataProviderViaRuntime.Resources.GetContent($resource, $resourceHeader)
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
            Write-PSFMessage -Level Debug -Message "Web resource '$resourceName' deployed successfully."
        }
    }
    Write-PSFMessage -Level Host -Message "Web resources deployment completed."

    Invoke-TimeSignal -End

}