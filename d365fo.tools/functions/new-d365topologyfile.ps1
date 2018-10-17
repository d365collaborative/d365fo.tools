
<#
    .SYNOPSIS
        Create a new topology file
        
    .DESCRIPTION
        Build a new topology file based on a template and update the ServiceModelList
        
    .PARAMETER Path
        Path to the template topology file
        
    .PARAMETER Services
        The array with all the service names that you want to fill into the topology file
        
    .PARAMETER NewPath
        Path to where you want to save the new file after it has been created
        
    .EXAMPLE
        PS C:\> New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services "ALMService","AOSService","BIService" -NewPath C:\temp\CurrentTopology.xml
        
        This will read the "DefaultTopologyData.xml" file and fill in "ALMService","AOSService" and "BIService"
        as the services in the ServiceModelList tag. The new file is stored at "C:\temp\CurrentTopology.xml"
        
    .EXAMPLE
        PS C:\> $Services = @(Get-D365InstalledService | ForEach-Object {$_.Servicename})
        PS C:\> New-D365TopologyFile -Path C:\Temp\DefaultTopologyData.xml -Services $Services -NewPath C:\temp\CurrentTopology.xml
        
        This will get all the services already installed on the machine. Afterwards the list is piped
        to New-D365TopologyFile where all services are import into the new topology file that is stored at "C:\temp\CurrentTopology.xml"
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-D365TopologyFile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 2 )]
        [string[]] $Services,

        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 3 )]
        [alias('NewFile')]
        [string] $NewPath
    )
    
    begin {
    }
    
    process {

        if (Test-PathExists -Path $Path -Type Leaf) {
            Remove-Item -Path $NewPath -Force -ErrorAction SilentlyContinue
            
            [xml]$topology = [xml](Get-Content -Path $Path)

            [System.Collections.ArrayList] $ServicesList = New-Object -TypeName "System.Collections.ArrayList"
            
            foreach ($obj in $Services) {
                $null = $ServicesList.Add("<string>$obj</string>")
            }

            $topology.TopologyData.MachineList.Machine.ServiceModelList.InnerXml = (($ServicesList.ToArray()) -join [Environment]::NewLine )
            
            $sw = New-Object System.Io.Stringwriter
            $writer = New-Object System.Xml.XmlTextWriter($sw)
            $writer.Formatting = [System.Xml.Formatting]::Indented
            $writer.Indentation = 4;
            $topology.WriteContentTo($writer)

            $topology.LoadXml($sw.ToString())
            $topology.Save("$NewPath")
        }
        else {
            Write-PSFMessage -Level Critical -Message "The base topology file wasn't found at the specified location. Please check the path and run the cmdlet again."
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    
    end {
    }
}