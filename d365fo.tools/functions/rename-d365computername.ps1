
<#
    .SYNOPSIS
        Function for renaming computer.
        Renames Computer and changes the SSRS Configration
        
    .DESCRIPTION
        When doing development on-prem, there is as need for changing the Computername.
        Function both changes Computername and SSRS Configuration
        
    .PARAMETER NewName
        The new name for the computer
        
    .PARAMETER SSRSReportDatabase
        Name of the SSRS reporting database
        
    .EXAMPLE
        PS C:\> Rename-D365ComputerName -NewName "Demo-8.1" -SSRSReportDatabase "ReportServer"
        
        This will rename the local machine to the "Demo-8.1" as the new Windows machine name.
        It will update the registration inside the SQL Server Reporting Services configuration to handle the new name of the machine.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Rename-D365ComputerName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $NewName,

        [Parameter(Mandatory = $false,Position = 2)]
        [string] $SSRSReportDatabase = "DynamicsAxReportServer"
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