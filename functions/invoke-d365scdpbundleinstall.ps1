<#
.SYNOPSIS
Invoke the SCDPBundleInstall.exe file

.DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process 

.PARAMETER Path
Path to the update package that you want to install into the environment

The cmdlet only supports an already extracted ".axscdppkg" file

.PARAMETER MetaDataDir
The path to the meta data directory for the environment 

Default path is the same as the aos service packageslocaldirectory 

.PARAMETER InstallOnly
Switch to instruct the cmdlet to only run the Install option and ignore any TFS / VSTS folders
and source control in general

Use it when testing an update on a local development machine (VM) / onebox

.EXAMPLE
Invoke-D365SCDPBundleInstall -Path "c:\temp\HotfixPackageBundle.axscdppkg"

This will install the "HotfixPackageBundle.axscdppkg" into the default 
PackagesLocalDirectory location on the machine

.NOTES
General notes
#>
function Invoke-D365SCDPBundleInstall {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $True, ParameterSetName = 'Default', Position = 1 )]
        [Alias('Hotfix')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [switch] $InstallOnly = [switch]::Present

    )
    
    begin {
    }
    
    process {
        $Setup = Join-Path $Script:BinDir "\bin\SCDPBundleInstall.exe"

        if($InstallOnly.IsPresent) {
            $param = "-install -packagepath=$Path -metadatastorepath=$MetaDataDir"
        }

        Start-Process -FilePath $Setup -ArgumentList  $param  -NoNewWindow -Wait
    }
    
    end {
    }
}