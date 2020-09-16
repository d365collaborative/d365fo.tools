# List of forbidden commands
$global:BannedCommands = @(
	'Write-Host',
	'Write-Verbose',
	'Write-Warning',
	'Write-Error',
	'Write-Output',
	'Write-Information',
	'Write-Debug'
)

<#
	Contains list of exceptions for banned cmdlets.
	Insert the file names of files that may contain them.
	
	Example:
	"Write-Host"  = @('Write-PSFHostColor.ps1','Write-PSFMessage.ps1')
#>
$global:MayContainCommand = @{
	"Write-Host"  = @()
	"Write-Verbose" = @('invoke-d365dbsync.ps1','invoke-d365dbsyncpartial.ps1')
	"Write-Warning" = @()
	"Write-Error"  = @()
	"Write-Output" = @('convertto-hashtable.ps1')
	"Write-Information" = @()
	"Write-Debug" = @()
}

$global:MayContainAlias = @(
	'Initialize-D365RsatCertificate'
	, 'Add-D365RsatWifConfigAuthorityThumbprint'
)

