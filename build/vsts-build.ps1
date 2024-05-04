<#
This script publishes the module to the gallery.
It expects as input an ApiKey authorized to publish the module.

Insert any build steps you may need to take before publishing it here.
#>
param (
	$ModuleName = 'd365fo.tools',

	$Repository = 'PSGallery',

	$ApiKey,

	[switch]
	$SkipPublish,

	[switch]
	$AutoVersion
)

# Prepare publish folder
Write-PSFMessage -Level Important -Message "Creating and populating publishing directory"
$publishDir = New-Item -Path $env:SYSTEM_DEFAULTWORKINGDIRECTORY -Name publish -ItemType Directory
Copy-Item -Path "$($env:SYSTEM_DEFAULTWORKINGDIRECTORY)\$ModuleName" -Destination $publishDir.FullName -Recurse -Force

# Create commands.ps1
$text = @()
Get-ChildItem -Path "$($publishDir.FullName)\$ModuleName\internal\functions\" -Recurse -File -Filter "*.ps1" | ForEach-Object {
	$text += [System.IO.File]::ReadAllText($_.FullName)
}
Get-ChildItem -Path "$($publishDir.FullName)\$ModuleName\functions\" -Recurse -File -Filter "*.ps1" | ForEach-Object {
	$text += [System.IO.File]::ReadAllText($_.FullName)
}
$text -join "`n`n" | Set-Content -Path "$($publishDir.FullName)\$ModuleName\commands.ps1"

# Create resourcesBefore.ps1
$processed = @()
$text = @()
foreach ($line in (Get-Content "$($PSScriptRoot)\filesBefore.txt" | Where-Object { $_ -notlike "#*" }))
{
	if ([string]::IsNullOrWhiteSpace($line)) { continue }
	
	$basePath = Join-Path "$($publishDir.FullName)\$ModuleName" $line
	foreach ($entry in (Resolve-PSFPath -Path $basePath))
	{
		$item = Get-Item $entry
		if ($item.PSIsContainer) { continue }
		if ($item.FullName -in $processed) { continue }
		$text += [System.IO.File]::ReadAllText($item.FullName)
		$processed += $item.FullName
	}
}
if ($text) { $text -join "`n`n" | Set-Content -Path "$($publishDir.FullName)\$ModuleName\resourcesBefore.ps1" }

# Create resourcesAfter.ps1
$processed = @()
$text = @()
foreach ($line in (Get-Content "$($PSScriptRoot)\filesAfter.txt" | Where-Object { $_ -notlike "#*" }))
{
	if ([string]::IsNullOrWhiteSpace($line)) { continue }
	
	$basePath = Join-Path "$($publishDir.FullName)\$ModuleName" $line
	foreach ($entry in (Resolve-PSFPath -Path $basePath))
	{
		$item = Get-Item $entry
		if ($item.PSIsContainer) { continue }
		if ($item.FullName -in $processed) { continue }
		$text += [System.IO.File]::ReadAllText($item.FullName)
		$processed += $item.FullName
	}
}
if ($text) { $text -join "`n`n" | Set-Content -Path "$($publishDir.FullName)\$ModuleName\resourcesAfter.ps1" }

#region Updating the Module Version
if ($AutoVersion)
{
	Write-PSFMessage -Level Important -Message "Updating module version numbers."
	try { [version]$remoteVersion = (Find-Module $ModuleName -Repository $Repository -ErrorAction Stop).Version }
	catch
	{
		Stop-PSFFunction -Message "Failed to access $Repository" -EnableException $true -ErrorRecord $_
	}
	if (-not $remoteVersion)
	{
		Stop-PSFFunction -Message "Couldn't find $ModuleName on repository $Repository" -EnableException $true
	}
	$newBuildNumber = $remoteVersion.Build + 1
	[version]$localVersion = (Import-PowerShellDataFile -Path "$($publishDir.FullName)\$ModuleName\$ModuleName.psd1").ModuleVersion
	Update-ModuleManifest -Path "$($publishDir.FullName)\$ModuleName\$ModuleName.psd1" -ModuleVersion "$($localVersion.Major).$($localVersion.Minor).$($newBuildNumber)"
}
#endregion Updating the Module Version

# Publish to Gallery
if ($SkipPublish) { return }
Publish-Module -Path "$($publishDir.FullName)\$ModuleName" -NuGetApiKey $ApiKey -Force