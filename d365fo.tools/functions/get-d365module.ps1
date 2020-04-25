
<#
    .SYNOPSIS
        Get installed package / module from Dynamics 365 Finance & Operations environment
        
    .DESCRIPTION
        Get installed package / module from the machine running the AOS service for Dynamics 365 Finance & Operations
        
    .PARAMETER Name
        Name of the package / module that you are looking for
        
        Accepts wildcards for searching. E.g. -Name "Application*Adaptor"
        
        Default value is "*" which will search for all packages / modules
        
    .PARAMETER ExcludeBinaryModules
        Instruct the cmdlet to exclude binary modules from the output
        
    .PARAMETER BinDir
        The path to the bin directory for the environment
        
        Default path is the same as the AOS service PackagesLocalDirectory\bin
        
        Default value is fetched from the current configuration on the machine
        
    .PARAMETER PackageDirectory
        Path to the directory containing the installed package / module
        
        Normally it is located under the AOSService directory in "PackagesLocalDirectory"
        
        Default value is fetched from the current configuration on the machine
        
    .EXAMPLE
        PS C:\> Get-D365Module
        
        Shows the entire list of installed packages / modules located in the default location on the machine.
        
        A result set example:
        
        ModuleName                               IsBinary Version         References
        ----------                               -------- -------         ----------
        AccountsPayableMobile                    False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
        ApplicationCommon                        False    10.0.8008.26462 {ApplicationFoundation, ApplicationPlatform}
        ApplicationFoundation                    False    7.0.5493.35504  {ApplicationPlatform}
        ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...
        Custom                                   True     10.0.0.0        {ApplicationPlatform}
        
    .EXAMPLE
        PS C:\> Get-D365Module -ExcludeBinaryModules
        
        Outputs the all packages / modules that are NOT binary.
        Will only include modules that is IsBinary = "False".
        
        A result set example:
        
        ModuleName                               IsBinary Version         References
        ----------                               -------- -------         ----------
        AccountsPayableMobile                    False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
        ApplicationCommon                        False    10.0.8008.26462 {ApplicationFoundation, ApplicationPlatform}
        ApplicationFoundation                    False    7.0.5493.35504  {ApplicationPlatform}
        ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...
        
    .EXAMPLE
        PS C:\> Get-D365Module -Name "Application*Adaptor"
        
        Shows the list of installed packages / modules where the name fits the search "Application*Adaptor".
        
        A result set example:
        
        ModuleName                               IsBinary Version         References
        ----------                               -------- -------         ----------
        ApplicationFoundationFormAdaptor         False    7.0.4841.35227  {ApplicationPlatform, ApplicationFoundation, TestE...
        ApplicationPlatformFormAdaptor           False    7.0.4841.35227  {ApplicationPlatform, TestEssentials}
        ApplicationSuiteFormAdaptor              False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
        ApplicationWorkspacesFormAdaptor         False    10.0.9107.14827 {ApplicationFoundation, ApplicationPlatform, Appli...
        
    .NOTES
        Tags: PackagesLocalDirectory, Servicing, Model, Models, Package, Packages
        
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Get-D365Module {
    [CmdletBinding()]
    param (
        [string] $Name = "*",

        [switch] $ExcludeBinaryModules,

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
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }

        Write-PSFMessage -Level Verbose -Message "Intializing RuntimeProvider."

        $runtimeProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.Runtime.RuntimeProviderConfiguration -ArgumentList $Script:PackageDirectory
        $metadataProviderFactoryViaRuntime = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
        $metadataProviderViaRuntime = $metadataProviderFactoryViaRuntime.CreateRuntimeProvider($runtimeProviderConfiguration)

        Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaRuntime

        $modules = $metadataProviderViaRuntime.ModelManifest.ListModules()
        $modules | ForEach-Object {
            $_ | Add-Member -MemberType NoteProperty -Name 'IsBinary' -Value $false
        }

        Write-PSFMessage -Level Verbose -Message "Testing if the cmdlet is running on a OneBox or not." -Target $Script:IsOnebox
    
        if ($Script:IsOnebox) {
            Write-PSFMessage -Level Verbose -Message "Machine is onebox. Initializing DiskProvider too."

            $diskProviderConfiguration = New-Object Microsoft.Dynamics.AX.Metadata.Storage.DiskProvider.DiskProviderConfiguration
            $diskProviderConfiguration.AddMetadataPath($PackageDirectory)
            $metadataProviderFactoryViaDisk = New-Object Microsoft.Dynamics.AX.Metadata.Storage.MetadataProviderFactory
            $metadataProviderViaDisk = $metadataProviderFactoryViaDisk.CreateDiskProvider($diskProviderConfiguration)

            Write-PSFMessage -Level Verbose -Message "MetadataProvider initialized." -Target $metadataProviderViaDisk

            $diskModules = $metadataProviderViaDisk.ModelManifest.ListModules()

            foreach($module in $modules) {
                if ($diskModules.Name -NotContains $module.Name) {
                    $module.IsBinary = $true
                }
            }
        }

        if($ExcludeBinaryModules -eq $true){
            $modules = $modules | Where-Object IsBinary -eq $false
        }

        Write-PSFMessage -Level Verbose -Message "Looping through all modules."

        foreach ($obj in $($modules | Sort-Object Name)) {
            Write-PSFMessage -Level Verbose -Message "Filtering out all modules that doesn't match the model search." -Target $obj
            if ($obj.Name -NotLike $Name) { continue }

            $res = [Ordered]@{
                Module = $obj.Name
                ModuleName = $obj.Name
                IsBinary = $obj.IsBinary
                PSTypeName = 'D365FO.TOOLS.ModuleInfo'
            }

            $modulepath = Join-Path (Join-Path $PackageDirectory $obj.Name) "bin"

            if (Test-Path -Path $modulepath -PathType Container) {
                $fileversion = Get-FileVersion -Path (Get-ChildItem $modulepath -Filter "Dynamics.AX.$($obj.Name).dll").FullName
                $version = $fileversion.FileVersion
                $versionUpdated = $fileversion.FileVersionUpdated
            }
            else {
                $version = ""
                $versionUpdated = ""
            }

            $res.Version = $version
            $res.VersionUpdated = $versionUpdated
            $res.References = $obj.References
            
            [PSCustomObject]$res
        }
    }
}