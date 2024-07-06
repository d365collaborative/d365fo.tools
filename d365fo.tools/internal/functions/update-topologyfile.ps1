﻿
<#
    .SYNOPSIS
        Update the topology file
        
    .DESCRIPTION
        Update the topology file based on the already installed list of services on the machine
        
    .PARAMETER Path
        Path to the folder where the Microsoft.Dynamics.AX.AXInstallationInfo.dll assembly is located
        
        Should only contain a path to a folder, not a file
        
    .PARAMETER TopologyFile
        Path to the topology file to update
        
        If not specified, the default topology file will be used
        
    .EXAMPLE
        PS C:\> Update-TopologyFile -Path "c:\temp\UpdatePackageFolder" -TopologyFile "c:\temp\d365fo.tools\DefaultTopologyData.xml"
        
        This will update the "c:\temp\d365fo.tools\DefaultTopologyData.xml" file with all the installed services on the machine.
        
    .NOTES
        # Credit http://dev.goshoom.net/en/2016/11/installing-deployable-packages-with-powershell/
        
        Author: Tommy Skaue (@Skaue)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Update-TopologyFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [string]$TopologyFile
    )
    
    if (-not $TopologyFile) {
        $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
    }
                
    Write-PSFMessage -Level Verbose "Updating topology file: $topologyFile"
                
    [xml]$xml = Get-Content $topologyFile
    $machine = $xml.TopologyData.MachineList.Machine
    $machine.Name = $env:computername
                
    $serviceModelList = $xml.SelectSingleNode("//ServiceModelList")
    $null = $serviceModelList.RemoveAll()
 
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Files2Process.Add((Join-Path $Path 'Microsoft.Dynamics.AX.AXInstallationInfo.dll'))
    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())
 
    $models = [Microsoft.Dynamics.AX.AXInstallationInfo.AXInstallationInfo]::GetInstalledServiceModel()

    if ($null -eq $models -or $models.Count -eq 0) {
        Write-PSFMessage -Level Warning "No installed service models found."
        Write-PSFMessage -Level Output "Using fallback list of known service model names."
        $serviceModelNames = $Script:FallbackInstallationServiceModelNames
        $models = $serviceModelNames | ForEach-Object {
            [PSCustomObject]@{
                Name = $_
            }
        }

    }

    foreach ($name in $models.Name) {
        $element = $xml.CreateElement('string')
        $element.InnerText = $name
        $serviceModelList.AppendChild($element)
    }
    
    $xml.Save($topologyFile)
    
    $true
}