@{
    # Script module or binary module file associated with this manifest
    RootModule   = 'd365fo.tools.psm1'

    # Version number of this module.
    ModuleVersion     = '0.4.95'

    # ID used to uniquely identify this module
    GUID              = '7c7b26d4-f764-4cb0-a692-459a0a689dbb'

    # Author of this module
    Author            = 'Motz Jensen & Rasmus Andersen'

    # Company or vendor of this module
    CompanyName       = 'Essence Solutions'

    # Copyright statement for this module
    Copyright         = '(c) 2018 Motz Jensen & Rasmus Andersen. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'A set of tools that will assist you when working with Dynamics 365 Finance & Operations development / demo machines.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Modules that must be imported into the global environment prior to importing
    # this module
    RequiredModules   = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '0.10.30.165' },
        @{ ModuleName = 'Azure.Storage'; ModuleVersion = '4.4.0' }, #4.3.1
		@{ ModuleName = 'AzureAd'; ModuleVersion = '2.0.1.16' },
		@{ ModuleName = 'PSNotification'; ModuleVersion = '0.5.3' }
    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @('bin\d365fo.tools.dll')

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @('xml\d365fo.tools.Types.ps1xml')

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @('xml\d365fo.tools.Format.ps1xml')

    # Functions to export from this module
    FunctionsToExport = @(
						'Add-D365AzureStorageConfig',
						'Add-D365EnvironmentConfig',

						'Backup-D365MetaDataDir',

						'Clear-D365MonitorData',

						'Disable-D365MaintenanceMode'
						'Disable-D365User',

						'Enable-D365MaintenanceMode',
						'Enable-D365User',
						'Export-D365SecurityDetails',

						'Find-D365Command',

						'Get-D365ActiveAzureStorageConfig',
						'Get-D365ActiveEnvironmentConfig',

						'Get-D365AOTObject',

						'Get-D365AzureStorageConfig',
						'Get-D365AzureStorageFile',
						'Get-D365ClickOnceTrustPrompt',

						'Get-D365DatabaseAccess',
						'Get-D365DecryptedConfigFile',
						'Get-D365DotNetClass',
						'Get-D365DotNetMethod',

						'Get-D365Environment',
						'Get-D365EnvironmentConfig',
						'Get-D365EnvironmentSettings',
						'Get-D365ExposedService',

						'Get-D365InstalledHotfix',
						'Get-D365InstalledPackage',
						'Get-D365InstalledService',
						'Get-D365InstanceName',

						'Get-D365Label',
						'Get-D365LogicAppConfig',
						'Get-D365OfflineAuthenticationAdminEmail',

						'Get-D365PackageBundleDetail',
						'Get-D365PackageLabelFile',
						'Get-D365ProductInformation',

						'Get-D365Runbook',

						'Get-D365SDPCleanUp',
						'Get-D365Table',
						'Get-D365TableField',
						'Get-D365TableSequence',
						'Get-D365Tier2Params',
						'Get-D365TfsUri',
						'Get-D365TfsWorkspace',

						'Get-D365Url',
						'Get-D365User',
						'Get-D365UserAuthenticationDetail',
						'Get-D365WindowsActivationStatus',

						'Import-D365AadUser',
						'Import-D365Bacpac',

						'Initialize-D365TestAutomationCertificate',

						'Invoke-D365AzureStorageDownload',
						'Invoke-D365AzureStorageUpload',

						'Invoke-D365DataFlush',
						'Invoke-D365DBSync',
						'Invoke-D365InstallLicense',
						'Invoke-D365LogicApp',

						'Invoke-D365ModelUtil',
						'Invoke-D365ReArmWindows',
						'Invoke-D365RunbookAnalyzer',

						'Invoke-D365SDPInstall',
						'Invoke-D365SCDPBundleInstall',
						'Invoke-D365SeleniumDownload',
						'Invoke-D365SysFlushAodCache',
						'Invoke-D365SysRunnerClass',
						'Invoke-D365SqlScript',

						'Invoke-D365TableBrowser',

						'New-D365Bacpac',
						'New-D365CAReport',
						'New-D365ISVLicense',
						'New-D365TopologyFile',

						'Remove-D365Database',
						'Remove-D365User',

						'Rename-D365Instance',
						'Rename-D365ComputerName',

						'Set-D365ActiveAzureStorageConfig',
						'Set-D365ActiveEnvironmentConfig',
						'Set-D365Admin',

						'Set-D365ClickOnceTrustPrompt',

						'Set-D365FavoriteBookmark',
						'Set-D365LogicAppConfig',
						'Set-D365OfflineAuthenticationAdminEmail',
						
						'Set-D365SDPCleanUp',
						'Set-D365StartPage',
						'Set-D365SysAdmin',

						'Set-D365Tier2Params',

						'Set-D365WorkstationMode',

						'Start-D365Environment',

						'Stop-D365Environment',

						'Switch-D365ActiveDatabase',

						'Test-D365Command',
						
						'Update-D365User'
						)

    # Cmdlets to export from this module
	CmdletsToExport   = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport   = ''

    # List of all modules packaged with this module
    ModuleList        = @()

    # List of all files packaged with this module
    FileList          = @()

    # Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        #Support for PowerShellGet galleries.
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('d365fo', 'Dynamics365', 'D365', 'Finance&Operations', 'FinanceOperations', 'FinanceAndOperations', 'Dynamics365FO')

            # A URL to the license for this module.
            LicenseUri   = "https://opensource.org/licenses/MIT"

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/d365collaborative/d365fo.tools'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Indicates this is a pre-release/testing version of the module.
            IsPrerelease = 'True'

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}