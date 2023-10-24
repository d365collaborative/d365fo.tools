@{
	# Script module or binary module file associated with this manifest
	RootModule        = 'd365fo.tools.psm1'

	# Version number of this module.
	ModuleVersion     = '0.7.4'

	# ID used to uniquely identify this module
	GUID              = '7c7b26d4-f764-4cb0-a692-459a0a689dbb'

	# Author of this module
	Author            = 'Mötz Jensen & Rasmus Andersen'

	# Company or vendor of this module
	CompanyName       = 'Essence Solutions'

	# Copyright statement for this module
	Copyright         = '(c) 2018 Mötz Jensen & Rasmus Andersen. All rights reserved.'

	# Description of the functionality provided by this module
	Description       = 'A set of tools that will assist you when working with Dynamics 365 Finance & Operations development / demo machines.'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'
	
	# Modules that must be imported into the global environment prior to importing
	# this module.
	# To enable the GitHub dependency graph, changes should be synchronized with
	# https://github.com/d365collaborative/d365fo.tools/blob/master/.github/workflows/dependencies.yml
    RequiredModules   = @(
		  @{ ModuleName = 'PSFramework'; ModuleVersion = '1.0.12' }
		, @{ ModuleName = 'Az.Storage'; ModuleVersion = '1.11.0' }
		, @{ ModuleName = 'AzureAd'; ModuleVersion = '2.0.1.16' }
		, @{ ModuleName = 'PSOAuthHelper'; ModuleVersion = '0.3.0' }
		, @{ ModuleName = 'ImportExcel'; ModuleVersion = '7.1.0' }
	)
	

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\d365fo.tools.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\d365fo.tools.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess  = @('xml\d365fo.tools.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport = @(
		'Add-D365AzureStorageConfig',
		'Add-D365BroadcastMessageConfig',
		'Add-D365ModuleToRemove',
		'Add-D365RsatWifConfigAuthorityThumbprint',
		'Add-D365WindowsDefenderRules',

		'Backup-D365DevConfig',
		'Backup-D365MetaDataDir',
		'Backup-D365Runbook',
		'Backup-D365WebConfig',

		'Clear-D365ActiveBroadcastMessageConfig',
		'Clear-D365BacpacObject',
		'Clear-D365BacpacTableData',
		'Clear-D365MonitorData',
		'Clear-D365TempDbTables',
		'ConvertTo-D365Dacpac',

		'Publish-D365SsrsReport',

		'Disable-D365MaintenanceMode'
		'Disable-D365SqlChangeTracking',
		'Disable-D365User',
		'Disable-D365Flight',
		'Disable-D365Exception',

		'Enable-D365Exception',
		'Enable-D365MaintenanceMode',
		'Enable-D365SqlChangeTracking',
		'Enable-D365User',
		'Enable-D365Flight',

		'Export-D365BacpacModelFile',
		'Export-D365Model',
		'Export-D365SecurityDetails',

		'Find-D365Command',

		'Get-D365ActiveAzureStorageConfig',
		'Get-D365ActiveBroadcastMessageConfig',

		'Get-D365AOTObject',

		'Get-D365AzureDevOpsNuget',

		'Get-D365AzureStorageConfig',
		'Get-D365AzureStorageFile',
		'Get-D365AzureStorageUrl',
		'Get-D365BacpacSqlOptions',
		'Get-D365BacpacTable',
		'Get-D365BroadcastMessage',
		'Get-D365BroadcastMessageConfig',

		'Get-D365ClickOnceTrustPrompt',
		'Get-D365CompilerResult',

		'Get-D365Database',
		'Get-D365DatabaseAccess',
		'Get-D365DecryptedWebConfig',
		'Get-D365DefaultModelForNewProjects',
		'Get-D365DotNetClass',
		'Get-D365DotNetMethod',

		'Get-D365Environment',
		'Get-D365EnvironmentSettings',
		'Get-D365EventTraceProvider',
		'Get-D365ExternalIP',

		'Get-D365JsonService',

		'Get-D365InstalledHotfix',
		'Get-D365InstalledPackage',
		'Get-D365InstalledService',
		'Get-D365InstanceName',

		'Get-D365Label',
		'Get-D365Language',
		'Get-D365LabelFile',
						
		'Get-D365LcsApiConfig',
		'Get-D365LcsApiToken',
		'Get-D365LcsAssetFile',
		'Get-D365LcsSharedAssetFile',
		'Get-D365LcsAssetValidationStatus',
		'Get-D365LcsDatabaseBackups',
		'Get-D365LcsDatabaseOperationStatus',
		'Get-D365LcsDeploymentStatus',
		'Get-D365LcsEnvironmentHistory',
		'Get-D365LcsEnvironmentMetadata',

		'Get-D365MaintenanceMode',
		'Get-D365Model',
		'Get-D365Module',
		'Get-D365OfflineAuthenticationAdminEmail',

		'Get-D365PackageBundleDetail',
		'Get-D365PackageLabelResourceFile',
		'Get-D365PackageLabelResources',
		'Get-D365ProductInformation',

		'Get-D365RsatCertificateThumbprint',
		'Get-D365RsatPlaybackFile',
		'Get-D365RsatSoapHostname',

		'Get-D365Runbook',
		'Get-D365RunbookId',
		'Get-D365RunbookLogFile',

		'Get-D365SDPCleanUp',

		'Get-D365Table',
		'Get-D365TableField',
		'Get-D365TableSequence',
		'Get-D365TablesInChangedTracking',
		'Get-D365TfsUri',
		'Get-D365TfsWorkspace',

		'Get-D365Url',
		'Get-D365User',
		'Get-D365UserAuthenticationDetail',

		'Get-D365VisualStudioCompilerResult',
		'Get-D365WebServerType',
		'Get-D365WindowsActivationStatus',

		'Import-D365AadUser',
		'Import-D365AadApplication',
		'Import-D365Bacpac',
		'Import-D365Dacpac',
		'Import-D365Model',
		'Import-D365ExternalUser',
		'Import-D365RsatSelfServiceCertificates',
						
		'Initialize-D365RsatCertificate',
		
		'Install-D365SupportingSoftware',

		'Invoke-D365AzCopyTransfer',
						
		'Invoke-D365AzureDevOpsNugetPush',
						
		'Invoke-D365AzureStorageDownload',
		'Invoke-D365AzureStorageUpload',

		'Invoke-D365CompilerResultAnalyzer',
						
		'Invoke-D365DataFlush',
		'Invoke-D365DbSync',
		'Invoke-D365DbSyncPartial',
		'Invoke-D365DbSyncModule',
						
		'Invoke-D365GenerateReportAggregateDataEntity',
		'Invoke-D365GenerateReportAggregateMeasure',
		'Invoke-D365GenerateReportConfigKey',
		'Invoke-D365GenerateReportConfigKeyGroup',
		'Invoke-D365GenerateReportDataEntity',
		'Invoke-D365GenerateReportDataEntityField',
		'Invoke-D365GenerateReportKpi',
		'Invoke-D365GenerateReportLicenseCode',
		'Invoke-D365GenerateReportMenuItem',
		'Invoke-D365GenerateReports',
		'Invoke-D365GenerateReportSsrs',
		'Invoke-D365GenerateReportTable',
		'Invoke-D365GenerateReportWorkflowType'
						
		'Invoke-D365InstallAzCopy',
		'Invoke-D365InstallLicense',
		'Invoke-D365InstallNuget',
		'Invoke-D365InstallSqlPackage',
						
		'Invoke-D365LcsApiRefreshToken',
		'Invoke-D365LcsDatabaseExport',
		'Invoke-D365LcsDatabaseRefresh',
		'Invoke-D365LcsDeployment',
		'Invoke-D365LcsEnvironmentStart',
		'Invoke-D365LcsEnvironmentStop',
		'Invoke-D365LcsUpload',

		'Invoke-D365ModuleCompile',
		'Invoke-D365ModuleLabelGeneration',
		'Invoke-D365ModuleReportsCompile',
		'Invoke-D365ModuleFullCompile',

		'Invoke-D365ProcessModule'

		'Invoke-D365ReArmWindows',
		'Invoke-D365RunbookAnalyzer',

		'Invoke-D365SDPInstall',
		'Invoke-D365SCDPBundleInstall',
		'Invoke-D365SeleniumDownload',
		'Invoke-D365SysFlushAodCache',
		'Invoke-D365SysRunnerClass',
		'Invoke-D365SqlScript',

		'Invoke-D365VisualStudioCompilerResultAnalyzer',
		'Invoke-D365WinRmCertificateRotation',
						
		'Invoke-D365TableBrowser',

		'Invoke-D365BestPractice',

		'New-D365Bacpac',
		'New-D365CAReport',
		'New-D365ISVLicense',
		'New-D365ModuleToRemove',
		'New-D365TopologyFile',

		'Register-D365AzureStorageConfig',
		
		'Remove-D365LcsAssetFile',
		'Remove-D365BroadcastMessageConfig',
		'Remove-D365Database',
		'Remove-D365Model',
		'Remove-D365User',

		'Rename-D365Instance',
		'Rename-D365ComputerName',

		'Restart-D365Environment',

		'Restore-D365DevConfig',
		'Restore-D365WebConfig',

		'Send-D365BroadcastMessage',

		'Set-D365ActiveAzureStorageConfig',
		'Set-D365ActiveBroadcastMessageConfig',

		'Set-D365Admin',

		'Set-D365AzCopyPath',

		'Set-D365ClickOnceTrustPrompt',

		'Set-D365DefaultModelForNewProjects',

		'Set-D365FavoriteBookmark',
		'Set-D365LcsApiConfig',
						
		'Set-D365NugetPath',

		'Set-D365OfflineAuthenticationAdminEmail',
						
		'Set-D365RsatTier2Crypto',
		'Set-D365RsatConfiguration',
						
		'Set-D365SDPCleanUp',
		'Set-D365StartPage',
		'Set-D365SqlPackagePath',
		'Set-D365SysAdmin',

		'Set-D365WebConfigDatabase',
		'Set-D365WebServerType',

		'Set-D365TraceParserFileSize',

		'Set-D365WorkstationMode',

		'Set-D365FlightServiceCatalogId',

		'Start-D365Environment',
		'Start-D365EnvironmentV2',
		'Start-D365EventTrace',

		'Stop-D365Environment',
		'Stop-D365EventTrace',

		'Switch-D365ActiveDatabase',

		'Test-D365Command',
		'Test-D365FlightServiceCatalogId',
		'Test-D365LabelIdIsValid',
						
		'Update-D365BacpacModelFileSingleTable',
		'Update-D365User'
	)

	# Cmdlets to export from this module
	CmdletsToExport   = ''

	# Variables to export from this module
	VariablesToExport = ''

	# Aliases to export from this module
	AliasesToExport   = @(
		'Initialize-D365TestAutomationCertificate'
		, 'Add-D365WIFConfigAuthorityThumbprint'
		, 'Invoke-D365SqlCmd'
		, 'Get-D365ModelFileFromBacpac'
		, 'Get-D365SqlOptionsFromBacpacModelFile'
		, 'Clear-D365TableDataFromBacpac'
	)

	# List of all modules packaged with this module
	ModuleList        = @()

	# List of all files packaged with this module
	FileList          = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData       = @{

		#Support for PowerShellGet galleries.
		PSData = @{
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags                       = @('d365fo', 'Dynamics365', 'D365', 'Finance&Operations', 'FinanceOperations', 'FinanceAndOperations', 'Dynamics365FO')

			# A URL to the license for this module.
			LicenseUri                 = "https://opensource.org/licenses/MIT"

			# A URL to the main website for this project.
			ProjectUri                 = 'https://github.com/d365collaborative/d365fo.tools'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			# ReleaseNotes = ''

			# Indicates this is a pre-release/testing version of the module.
			IsPrerelease               = 'True'

			ExternalModuleDependencies = @('PSDiagnostics')

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}
