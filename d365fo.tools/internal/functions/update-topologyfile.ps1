
<#
    .SYNOPSIS
        Update the topology file
        
    .DESCRIPTION
        Update the topology file based on the already installed list of services on the machine
        
    .PARAMETER Path
        Path to the folder where the topology XML file that you want to work against is placed
        
        Should only contain a path to a folder, not a file
        
    .EXAMPLE
        PS C:\> Update-TopologyFile -Path "c:\temp\d365fo.tools\DefaultTopologyData.xml"
        
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
        [string]$Path
    )
    
    $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                
    Write-PSFMessage -Level Verbose "Creating topology file: $topologyFile"
                
    [xml]$xml = Get-Content $topologyFile
    $machine = $xml.TopologyData.MachineList.Machine
    $machine.Name = $env:computername
                
    $serviceModelList = $machine.ServiceModelList
    $null = $serviceModelList.RemoveAll()
 
    [System.Collections.ArrayList] $Files2Process = New-Object -TypeName "System.Collections.ArrayList"

    $null = $Files2Process.Add((Join-Path $Path 'Microsoft.Dynamics.AX.AXInstallationInfo.dll'))
    Import-AssemblyFileIntoMemory -Path $($Files2Process.ToArray())
 
    $models = [Microsoft.Dynamics.AX.AXInstallationInfo.AXInstallationInfo]::GetInstalledServiceModel()

    foreach ($name in $models.Name) {
        $element = $xml.CreateElement('string')
        $element.InnerText = $name
        $serviceModelList.AppendChild($element)
    }
    
    $xml.Save($topologyFile)
    
    $true
}