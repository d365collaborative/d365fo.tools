<#
.SYNOPSIS
Invoke the AXUpdateInstaller.exe file

.DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process 

.PARAMETER Path
Path to the folder containing all deployable packages that you want installed

The cmdlet only supports already extracted zip files

.PARAMETER Action
The action which you want the AxUpdateInstaller.exe to execute

Valid options are:
DevInstall
QuickInstallAll

.PARAMETER GenerateImportExecute
Switch used to generate, import and execute a deployable package

Normally used for installing binary hotfixes

.PARAMETER RunBookId
The value/name of the desired runbook id you want this execution to work against

Default value is: "DevBox"

.PARAMETER RunBookFile
The name of the runbook file itself you want this execution to work against

Default value is: "DevBox-runbook.xml"

.PARAMETER TopologyFile
The name of the Topology file you want this execution to work against

Default value is: "DefaultTopologyData.xml"

.PARAMETER ServiceModelFile
The name of the ServiceModel file you want this execution to work against

Default value is: "DefaultServiceModelData.xml"

.PARAMETER GenerateOnly
Switch to instruct the cmdlet to only generate the scripts and parameters to screen and not execute them

.EXAMPLE
Invoke-D365AXUpdateInstaller -Path C:\DeployablePackages -GenerateImportExecute

Will execute the AxUpdateInstaller.exe with generate, import and execute
Is normally used for installation of binary hotfixes

It expects folders inside C:\DeployablePackages

.EXAMPLE
Invoke-D365AXUpdateInstaller -Path C:\DeployablePackages -Action DevInstall

Will execute the AxUpdateInstaller.exe with the devinstall parameter
Is normally used for installation of 3. party ISV solutions on development machines

It expects folders inside C:\DeployablePackages

.NOTES
The cmdlet wraps the execution of AXUpdateInstaller.exe and parses the parameters needed
#>
function Invoke-D365AXUpdateInstaller {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $True, ParameterSetName = 'Default', Position = 1 )]
        [Parameter(Mandatory = $True, ParameterSetName = 'GenerateImportExecute', Position = 1 )]
        [string] $Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [ValidateSet('DevInstall', 'QuickInstallAll')]
        [string] $Action = "DevInstall",

        [Parameter(Mandatory = $true, ParameterSetName = 'GenerateImportExecute', Position = 2 )]
        [switch] $GenerateImportExecute,

        [Parameter(Mandatory = $false, ParameterSetName = 'GenerateImportExecute', Position = 3 )]
        [string] $RunBookId = "DexBox",

        [Parameter(Mandatory = $false, ParameterSetName = 'GenerateImportExecute', Position = 4 )]
        [string] $RunBookFile = "DevBox-runbook.xml",

        [Parameter(Mandatory = $false, ParameterSetName = 'GenerateImportExecute', Position = 5 )]
        [string] $TopologyFile = "DefaultTopologyData.xml",

        [Parameter(Mandatory = $false, ParameterSetName = 'GenerateImportExecute', Position = 6 )]
        [string] $ServiceModelFile = "DefaultServiceModelData.xml",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [Parameter(Mandatory = $false, ParameterSetName = 'GenerateImportExecute', Position = 7 )]
        [switch] $GenerateOnly
    )
    
    begin {
    }
    
    process {
        if (Test-Path $Path -PathType Container ) {
            Get-ChildItem -Path $Path -Recurse | Unblock-File

            $Packages = Get-ChildItem -Path $Path -Directory | Sort-Object Name

            foreach ($Package in $Packages) {
                $Path = $Package.FullName
                $AxUpdateInstaller = Join-Path $Path "AXUpdateInstaller.exe"
                
                if ($GenerateImportExecute.IsPresent) {
                    $RunBookFile = Join-Path $Package.FullName $RunBookFile 
                    $TopologyFile = Join-Path $Package.FullName $TopologyFile
                    $ServiceModelFile = Join-Path $Package.FullName $ServiceModelFile

                    $param = "generate -runbookid=`"$RunBookId`" -topologyfile=`"$TopologyFile`" -servicemodelfile=`"$ServiceModelFile`" -runbookfile=`"$RunBookFile`""
                    
                    if ($GenerateOnly.IsPresent) {
                        Write-Host "`r`n$AxUpdateInstaller $param`r`n" -ForegroundColor Green
                    }
                    else {
                        Start-Process -FilePath $AxUpdateInstaller -ArgumentList $param -NoNewWindow -Wait 
                    }

                    $param = "import -runbookfile=`"$RunBookFile`""
                    if ($GenerateOnly.IsPresent) {
                        Write-Host "`r`n$AxUpdateInstaller $param`r`n" -ForegroundColor Green
                    }
                    else {
                        Start-Process -FilePath $AxUpdateInstaller -ArgumentList $param -NoNewWindow -Wait
                    }

                    $param = "execute -runbookid=`"$RunBookId`""
                    if ($GenerateOnly.IsPresent) {
                        Write-Host "`r`n$AxUpdateInstaller $param`r`n" -ForegroundColor Green
                    }
                    else {
                        Start-Process -FilePath $AxUpdateInstaller -ArgumentList $param -NoNewWindow -Wait
                    }
                }
                else {
    
                    switch ($Action.ToLower()) {
                        "devinstall" {
                            $param = "devinstall"
                        }

                        "quickinstallall" { 
                            $param = "quickinstallall"
                        }
                    }

                    if ($GenerateOnly.IsPresent) {
                        Write-Host "`r`n$AxUpdateInstaller $param`r`n" -ForegroundColor Green
                    }
                    else {
                        Start-Process -FilePath $AxUpdateInstaller -ArgumentList $param -NoNewWindow -Wait
                    }
                }
                
            }
        }

    }
    
    end {
    }
}