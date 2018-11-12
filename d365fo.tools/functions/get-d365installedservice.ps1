
<#
    .SYNOPSIS
        Get installed D365 services
        
    .DESCRIPTION
        Get installed Dynamics 365 for Finance & Operations services that are installed on the machine
        
    .PARAMETER Path
        Path to the folder that contains the "InstallationRecords" folder
        
    .EXAMPLE
        PS C:\> Get-D365InstalledService
        
        This will get all installed services on the machine.
        
    .NOTES
        Tags: Services, Servicing, Topology
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365InstalledService {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 1 )]
        [string] $Path = $Script:InstallationRecordsDir
    )
    
    begin {
    }
    
    process {
        $servicePath = Join-Path $Path "ServiceModelInstallationRecords"

        Write-PSFMessage -Level Verbose -Message "Service installation log path is: $servicePath" -Target $servicePath
        $ServiceFiles = Get-ChildItem -Path $servicePath -Filter "*_current.xml" -Recurse

        foreach ($obj in $ServiceFiles) {
            [PSCustomObject]@{
                ServiceName = ($obj.Name.Split("_")[0])
                Version     = (Select-Xml -XPath "/ServiceModelInstallationInfo/Version" -Path $obj.fullname).Node."#Text"
            }
        }
    }
    
    end {
    }
}