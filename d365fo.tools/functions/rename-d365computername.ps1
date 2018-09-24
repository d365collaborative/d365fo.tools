<#
.SYNOPSIS
Function for renaming computer.
Renames Computer and changes the SSRS Configration

.DESCRIPTION
When doing development on-prem, there is as need for changing the Computername.
Function both changes Computername and SSRS Configuration

.PARAMETER NewName
The new name for the computer

.EXAMPLE
Rename-D365ComputerName

.NOTES

Author : Rasmus Andersen (ITRasmus)
#>
function Rename-D365ComputerName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$NewName,
        [Parameter(Mandatory = $false,Position = 2)]
        [string]$SSRSReportDatabase = "DynamicsAxReportServer"

    
    )

    Write-PSFMessage -Level Verbose -Message "Testing for elevated runtime"
    
    if (!$script:IsAdminRuntime) {
        Write-PSFMessage -Level Host -Message "The cmdlet needs <c='em'>administrator permission</c> (Run As Administrator) to be able to update the configuration. Please start an <c='em'>elevated</c> session and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because the function is not run elevated"
        return
    }

    Write-PSFMessage -Level Verbose -Message "Renaming computer to $NewName"

    Rename-Computer -NewName $NewName -Force       


    Write-PSFMessage -Level Verbose -Message "Setting SSRS Reporting server database server to localhost"

    $rsconfig = "$Script:SQLTools\rsconfig.exe"
    $arguments = "-s localhost -a Windows -c -d `"$SSRSReportDatabase`""

    Start-Process -Wait -NoNewWindow -FilePath $rsconfig -ArgumentList $arguments -Verbose



}


    


 
