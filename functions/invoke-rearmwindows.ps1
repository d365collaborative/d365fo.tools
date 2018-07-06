##############################
#.SYNOPSIS
#Invokes the Rearm of Windows license
#
#.DESCRIPTION
#Function used for invoking the rearm functionality inside Windows
#
#.PARAMETER DropPath
#Place where the decrypted files should be placed
#
#.PARAMETER AosServiceWebRootPath
#Location of the D365 webroot folder
#
#.EXAMPLE
#Get-DecrypteConfigFile -DropPath 'C:\Temp'
#
#.NOTES
# Used for getting the Password for the database and other service accounts used in environment
##############################
function Invoke-ReArmWindows {
    param(
        [Parameter(Mandatory = $false, Position = 1)]        
        [switch]$Restart
    )

    Write-Verbose "Invoking the rearm process."

    (Get-WmiObject -Class SoftwareLicensingService -Namespace root/cimv2 -ComputerName .).ReArmWindows()
  
    if ($Restart) {
        Restart-Computer -Force
    }
}