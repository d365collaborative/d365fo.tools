
<#
    .SYNOPSIS
        Get log file from a Runbook step
        
    .DESCRIPTION
        Get the log files for a specific Runbook step
        
    .PARAMETER Path
        Path to Software Deployable Package that was run in connection with the runbook
        
    .PARAMETER Step
        Step id for the step that you want to locate the log files for
        
    .PARAMETER Latest
        Instruct the cmdlet to only work with the latest log file
        
        Is based on the last written attribute on the log file
        
    .PARAMETER OpenInEditor
        Instruct the cmdlet to open the log file in the default text editor
        
    .EXAMPLE
        PS C:\> Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34
        
        This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
        The output will list the complete path to the log files.
        
        An output example:
        
        Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
        LastModified : 8/7/2020 12:40:34 PM
        File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
        
        Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-36-22.log
        LastModified : 8/7/2020 12:36:22 PM
        File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-36-22.log
        
        Filename     : AutoUpdateDIXFService.ps1-2020-05-8--19-15-07.log
        LastModified : 8/5/2020 7:15:07 PM
        File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-05-8--19-15-07.log
        
    .EXAMPLE
        PS C:\> Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -Latest
        
        This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
        The output will be limited to the latest log, based on last write time.
        The output will list the complete path to the log file.
        
        An output example:
        
        Filename     : AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
        LastModified : 8/7/2020 12:40:34 PM
        File         : C:\Temp\PU35\RunbookWorkingFolder\Runbook\MININT-F36S5EH\DIXFService\34\Log\AutoUpdateDIXFService.ps1-2020-07-8--12-40-34.log
        
    .EXAMPLE
        PS C:\> Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -OpenInEditor
        
        This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
        The Get-D365RunbookLogFile will open all log files in the default text editor.
        
    .EXAMPLE
        PS C:\> Get-D365RunbookLogFile -Path "C:\Temp\PU35" -Step 34 -Latest -OpenInEditor
        
        This will locate all logfiles that has been outputted from the Step 34 from the PU35 installation.
        The output will be limited to the latest log, based on last write time.
        The Get-D365RunbookLogFile will open the log file in the default text editor.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects | Get-D365RunbookLogFile -Path "C:\Temp\PU35" -OpenInEditor
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
        The Get-D365RunbookLogFile will open all log files for the failed step.
        
    .NOTES
        Tags: Runbook, Servicing, Hotfix, DeployablePackage, Deployable Package, InstallationRecordsDirectory, Installation Records Directory
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365RunbookLogFile {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [Alias('StepId')]
        [string] $Step,

        [switch] $Latest,

        [switch] $OpenInEditor

    )
    
    process {
        if (-not (Test-PathExists -Path $Path -Type Container)) { return }

        $stepPath = Get-ChildItem -Path $Path -Filter $step -Recurse -Directory | Select-Object -First 1

        if ($null -eq $stepPath) {
            $messageString = "Couldn't locate a folder with the specified step id."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        }

        $files = @(Get-ChildItem -Path "$($stepPath.FullName)\Log\*.log" -Recurse | Sort-Object -Descending { $_.LastWriteTime })

        if ($files.Count -lt 1) {
            $messageString = "Couldn't locate any log files in the folder associated with the step."
            Write-PSFMessage -Level Host -Message $messageString
            Stop-PSFFunction -Message "Stopping because of errors." -Exception $([System.Exception]::new($($messageString -replace '<[^>]+>', '')))
        }

        if ($Latest) {
            $files = $files | Select-Object -First 1
        }
        
        foreach ($obj in $files) {
            $obj | Select-PSFObject "Name as Filename", "LastWriteTime as LastModified", "Fullname as File" -TypeName "D365FO.TOOLS.FileObject"
        }

        if($OpenInEditor) {
            foreach ($obj in $files) {
                & "$($obj.Fullname)"
            }
        }
    }
}