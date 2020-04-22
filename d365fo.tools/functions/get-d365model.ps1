
<#
    .SYNOPSIS
        Get available model from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get available model from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER Name
        Name of the model that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all models
        
    .PARAMETER Module
        Name of the module that you want to list models from
        
        Accepts wildcards for searchinf. E.g. -Module "Application*Adaptor"
        
        Default value is "*" which will search across all modules
        
    .PARAMETER CustomizableOnly
        Instructs the cmdlet to filter out all models that cannot be customized
        
    .PARAMETER ExcludeMicrosoftModels
        Instructs the cmdlet to filter out all models that has Microsoft as the publisher

    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Default path is the same as the AOS service "PackagesLocalDirectory" directory
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Model
        
        Shows the entire list of installed models located in the default location on the machine.
        
        A result set example:
        
        ModelName                        Module                              Customization        Id Publisher
        ---------                        ------                              -------------        -- ---------
        AccountsPayableMobile            AccountsPayableMobile               DoNotAllow    895571380 Microsoft Corporation
        ApplicationCommon                ApplicationCommon                   DoNotAllow      8956718 Microsoft
        ApplicationFoundation            ApplicationFoundation               Allow               450 Microsoft Corporation
        ApplicationFoundationFormAdaptor ApplicationFoundationFormAdaptor    DoNotAllow       855029 Microsoft Corporation
        ApplicationPlatform              ApplicationPlatform                 Allow               400 Microsoft Corporation
        
    .EXAMPLE
        PS C:\> Get-D365Model -CustomizableOnly
        
        Shows only the models that are marked as customizable.
        Will only include models that is Customization = "Allow".
        
        A result set example:
        
        ModelName                        Module                              Customization        Id Publisher
        ---------                        ------                              -------------        -- ---------
        ApplicationFoundation            ApplicationFoundation               Allow               450 Microsoft Corporation
        ApplicationPlatform              ApplicationPlatform                 Allow               400 Microsoft Corporation
        ApplicationPlatformFormAdaptor   ApplicationPlatformFormAdaptor      Allow            855030 Microsoft Corporation
        AtlCostAccounting                AtlCostAccounting                   Allow         895972481 Microsoft
        AtlMaterialhandling              AtlMaterialhandling                 Allow         895972595 Microsoft Corporation
        
    .EXAMPLE
        PS C:\> Get-D365Model -Name "Application*Adaptor"
        
        Shows the list of models where the name fits the search "Application*Adaptor".
        
        A result set example:
        
        ModelName                        Module                           Customization     Id Publisher
        ---------                        ------                           -------------     -- ---------
        ApplicationFoundationFormAdaptor ApplicationFoundationFormAdaptor DoNotAllow    855029 Microsoft Corporation
        ApplicationPlatformFormAdaptor   ApplicationPlatformFormAdaptor   Allow         855030 Microsoft Corporation
        ApplicationSuiteFormAdaptor      ApplicationSuiteFormAdaptor      DoNotAllow    855028 Microsoft Corporation
        ApplicationWorkspacesFormAdaptor ApplicationWorkspacesFormAdaptor DoNotAllow    855066 Microsoft Corporation
        
    .EXAMPLE
        PS C:\> Get-D365Model -Module ApplicationSuite
        
        Shows only the models that are inside the ApplicationSuite module.
        
        A result set example:
        
        ModelName                                          Module           Customization        Id Publisher
        ---------                                          ------           -------------        -- ---------
        Electronic Reporting Application Suite Integration ApplicationSuite DoNotAllow       855009 Microsoft Corporation
        Foundation                                         ApplicationSuite DoNotAllow           17 Microsoft Corporation
        SCMControls                                        ApplicationSuite DoNotAllow       855891 Microsoft Corporation
        Tax Books Application Suite Integration            ApplicationSuite DoNotAllow    895570102 Microsoft Corporation
        Tax Engine Application Suite Integration           ApplicationSuite DoNotAllow      8957001 Microsoft Corporation
        
    .EXAMPLE
        PS C:\> Get-D365Model -Name "*Application*" -Module "*Suite*"
        
        Shows the list of models where the name fits the search "*Application*" and the module name fits the search "*Suite*".
        
        A result set example:
        
        ModelName                                          Module                      Customization        Id Publisher
        ---------                                          ------                      -------------        -- ---------
        ApplicationSuiteFormAdaptor                        ApplicationSuiteFormAdaptor DoNotAllow       855028 Microsoft Cor...
        AtlApplicationSuite                                AtlApplicationSuite         DoNotAllow    895972466 Microsoft Cor...
        Electronic Reporting Application Suite Integration ApplicationSuite            DoNotAllow       855009 Microsoft Cor...
        Tax Books Application Suite Integration            ApplicationSuite            DoNotAllow    895570102 Microsoft Cor...
        Tax Engine Application Suite Integration           ApplicationSuite            DoNotAllow      8957001 Microsoft Cor...
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Model, Models, Module, Modules
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365Model {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $Module = "*",

        [switch] $CustomizableOnly,
        
        [switch] $ExcludeMicrosoftModels,

        [string] $BinDir = "$Script:BinDir\bin",

        [string] $PackageDirectory = $Script:PackageDirectory
    )

    begin {
        [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"
        
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Delta.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Diff.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Merge.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Management.Core.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Core.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.AX.Metadata.Storage.dll"))
        $null = $Files2Process.Add((Join-Path $BinDir "Microsoft.Dynamics.ApplicationPlatform.XppServices.Instrumentation.dll"))

        Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())

        Write-PSFMessage -Level Verbose -Message "Intializing RuntimeProvider."

        $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $Script:PackageDirectory
        $metadataProviderFactoryViaRuntime = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProviderViaRuntime = $metadataProviderFactoryViaRuntime.CreateRuntimeProvider($runtimeProviderConfiguration)

        Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaRuntime

        $models = $metadataProviderViaRuntime.ModelManifest.ListModelInfos()

        Write-PSFMessage -Level Verbose -Message "Testing if the cmdlet is running on a OneBox or not." -Target $Script:IsOnebox
    
        if ($Script:IsOnebox) {
            Write-PSFMessage -Level Verbose -Message "Machine is onebox. Initializing DiskProvider too."

            $diskProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
            $diskProviderConfiguration.AddMetadataPath($PackageDirectory)
            $metadataProviderFactoryViaDisk = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProviderViaDisk = $metadataProviderFactoryViaDisk.CreateDiskProvider($diskProviderConfiguration)

            Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaDisk

            $diskModels = $metadataProviderViaDisk.ModelManifest.ListModelInfos()

            foreach ($model in $diskModels) {
                if ($models.Name -NotContains $model.Name) {
                    $models += $model
                }
            }
        }

        if($CustomizableOnly){
            $models = $models | Where-Object Customization -eq "Allow"
        }
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        $modelsLocal = $models
        
        $modelsLocal = $modelsLocal | Where-Object Module -like $Module

        Write-PSFMessage -Level Verbose -Message "Looping through all modules."

        foreach ($obj in $($modelsLocal | Sort-Object Name, Module)) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj.Name -NotLike $Name) { continue }

            if($ExcludeMicrosoftModels -and $obj.Publisher -like "Microsoft*"){ continue }
            
            $obj | Select-PSFObject "Name as ModelName",* -ExcludeProperty Name -TypeName "D365FO.TOOLS.ModelInfo"
        }
    }
}