@{

    # Script module or binary module file associated with this manifest.
    RootModule             = 'd365fo.tools.psm1'

    # Version number of this module.
    ModuleVersion          = '0.3.77'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID                   = '7c7b26d4-f764-4cb0-a692-459a0a689dbb'

    # Author of this module
    Author                 = 'Motz Jensen & Rasmus Andersen'

    # Company or vendor of this module
    CompanyName            = 'Essence Solutions'

    # Copyright statement for this module
    Copyright              = '(c) 2018 Motz Jensen & Rasmus Andersen. All rights reserved.'

    # Description of the functionality provided by this module
    Description            = 'A set of tools that will assist you when working with Dynamics 365 Finance & Operations development / demo machines.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '3.0'

    # Name of the Windows PowerShell host required by this module
    PowerShellHostName     = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion  = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion             = ''

    # Processor architecture (None, X86, Amd64) required by this module
    ProcessorArchitecture  = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules        = @(
        @{ ModuleName = 'PSFramework'; ModuleVersion = '0.9.24.85' },
        @{ ModuleName = 'Azure.Storage'; ModuleVersion = '4.4.0' } #4.3.1
        @{ ModuleName = 'MSOnline'; ModuleVersion = '1.1.183.17' } #4.3.1
        
    )

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies     = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess       = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess         = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules          = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport      = @(
                                'Add-D365AzureStorageConfig',
                                'Add-D365EnvironmentConfig',

                                'Disable-D365MaintenanceMode'

                                'Enable-D365MaintenanceMode',
                                'Enable-D365User',
                                
                                'Get-D365ActiveAzureStorageConfig',
                                'Get-D365ActiveEnvironmentConfig',
                                'Get-D365AzureStorageConfig',
                                'Get-D365AzureStorageFile',
                                'Get-D365DatabaseAccess',
                                'Get-D365DecryptedConfigFile',
                                'Get-D365DotNetClass',
                                'Get-D365DotNetMethod',
                                'Get-D365Environment',
                                'Get-D365EnvironmentConfig',
                                'Get-D365EnvironmentSettings',
                                'Get-D365InstalledHotfix',
                                'Get-D365InstalledPackage',
                                'Get-D365InstalledService',
                                'Get-D365InstanceName',
                                'Get-D365Label',
                                'Get-D365OfflineAuthenticationAdminEmail',
                                'Get-D365PackageLabelFile',
                                'Get-D365ProductInformation',
                                'Get-D365Table',
                                'Get-D365TableField',
                                'Get-D365Url',
                                'Get-D365User',
                                'Get-D365UserAuthenticationDetail',
                                'Get-D365WindowsActivationStatus',

                                'Import-D365AadUser',
                                'Import-D365Bacpac',
                                'Import-D365BacpacOldVersion',

                                'Initialize-D365Config',

                                'Invoke-D365AzureStorageDownload',
                                'Invoke-D365AzureStorageUpload',
                                'Invoke-D365AXUpdateInstaller',
                                'Invoke-D365DBSync',
                                'Invoke-D365ModelUtil',
                                'Invoke-D365ReArmWindows',
                                'Invoke-D365SCDPBundleInstall',
                                'Invoke-D365SpHelp',
                                'Invoke-D365SysFlushAodCache',
                                'Invoke-D365SysRunnerClass',
                                'Invoke-D365TableBrowser',

                                'New-D365Bacpac',
                                'New-D365BacpacOldVersion',
                                'New-D365TopologyFile',
                                
                                'Remove-D365Database',
                                'Remove-D365User',

                                'Rename-D365Instance',

                                'Set-D365ActiveAzureStorageConfig',
                                'Set-D365ActiveEnvironmentConfig',
                                'Set-D365Admin',
                                'Set-D365OfflineAuthenticationAdminEmail',
                                'Set-D365StartPage',
                                'Set-D365SysAdmin',
                                'Set-D365WorkstationMode',

                                'Start-D365Environment',

                                'Stop-D365Environment',

                                'Switch-D365ActiveDatabase',

                                'Update-D365User',
                                'Get-ExposedService'
                            )

                            # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport        = @()

    # Variables to export from this module
    VariablesToExport      = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport        = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    ModuleList             = @()

    # List of all files packaged with this module
    FileList               = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData            = @{
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

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}