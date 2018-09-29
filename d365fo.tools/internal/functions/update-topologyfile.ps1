# Credit http://dev.goshoom.net/en/2016/11/installing-deployable-packages-with-powershell/
function Update-TopologyFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]    
    param ([string]$Path)
    
    $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                
    Write-PSFMessage -Level Verbose "Creating topology file: $topologyFile"
                
    [xml]$xml = Get-Content $topologyFile
    $machine = $xml.TopologyData.MachineList.Machine
    $machine.Name = $env:computername 
                
    $serviceModelList = $machine.ServiceModelList
    $serviceModelList.RemoveAll()
 
    $instalInfoDll = Join-Path $Path 'Microsoft.Dynamics.AX.AXInstallationInfo.dll'
    [void][System.Reflection.Assembly]::LoadFile($instalInfoDll)
 
    $models = [Microsoft.Dynamics.AX.AXInstallationInfo.AXInstallationInfo]::GetInstalledServiceModel()
    foreach ($name in $models.Name) {
        $element = $xml.CreateElement('string')
        $element.InnerText = $name
        $serviceModelList.AppendChild($element)
    }
    $xml.Save($topologyFile)
    
    return $true
}