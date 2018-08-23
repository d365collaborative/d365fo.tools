# Credit http://dev.goshoom.net/en/2016/11/installing-deployable-packages-with-powershell/
function Update-TopologyFile([string]$Path)
{
    $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                
    Write-PSFMessage -Level Verbose "Creating topology file: $topologyFile"
    
    if (!(Test-Path $topologyFile -PathType Leaf))
    {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>$topologyFile</c> file. Please make sure that the file exists and you have enough permissions."
        Stop-PSFFunction -Message "Unable to locate the topology topology file XML."
        return $false
    }
                
    [xml]$xml = Get-Content $topologyFile
    $machine = $xml.TopologyData.MachineList.Machine
    $machine.Name = $env:computername 
                
    $serviceModelList = $machine.ServiceModelList
    $serviceModelList.RemoveAll()
 
    $instalInfoDll = Join-Path $Path 'Microsoft.Dynamics.AX.AXInstallationInfo.dll'
    [void][System.Reflection.Assembly]::LoadFile($instalInfoDll)
 
    $models = [Microsoft.Dynamics.AX.AXInstallationInfo.AXInstallationInfo]::GetInstalledServiceModel()
    foreach ($name in $models.Name)
    {
        $element = $xml.CreateElement('string')
        $element.InnerText = $name
        $serviceModelList.AppendChild($element)
    }
    $xml.Save($topologyFile)
    
    return $true
}