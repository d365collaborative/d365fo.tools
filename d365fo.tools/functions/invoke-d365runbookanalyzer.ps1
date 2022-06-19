
<#
    .SYNOPSIS
        Analyze the runbook
        
    .DESCRIPTION
        Get all the important details from a failed runbook
        
    .PARAMETER Path
        Path to the runbook file that you work against
        
    .PARAMETER FailedOnly
        Instruct the cmdlet to only output failed steps
        
    .PARAMETER FailedOnlyAsObjects
        Instruct the cmdlet to only output failed steps as objects
        
    .EXAMPLE
        PS C:\> Invoke-D365RunbookAnalyzer -Path "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook.xml"
        
        This will analyze the Runbook.xml and output all the details about failed steps, the connected error logs and all the unprocessed steps.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnly
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
        The output will be formatted as PSCustomObjects, to be used as variables or piping.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer -FailedOnlyAsObjects | Get-D365RunbookLogFile -Path "C:\Temp\PU35" -OpenInEditor
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output from Invoke-D365RunbookAnalyzer will only contain failed steps.
        The Get-D365RunbookLogFile will open all log files for the failed step.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer | Out-File "C:\Temp\d365fo.tools\runbook-analyze-results.xml"
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output will be saved into the "C:\Temp\d365fo.tools\runbook-analyze-results.xml" file.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Backup-D365Runbook -Force | Invoke-D365RunbookAnalyzer
        
        This will get the latest runbook from the default location.
        This will backup the file onto the default "c:\temp\d365fo.tools\runbookbackups\".
        This will start the Runbook Analyzer on the backup file.
        
    .NOTES
        Tags: Runbook, Servicing, Hotfix, DeployablePackage, Deployable Package, InstallationRecordsDirectory, Installation Records Directory
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365RunbookAnalyzer {
    [CmdletBinding(DefaultParameterSetName="Default")]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, ParameterSetName = "Default")]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, ParameterSetName = "FailedOnly")]
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, ParameterSetName = "FailedOnlyAsObjects")]
        [Alias('File')]
        [string] $Path,

        [Parameter(ParameterSetName = "FailedOnly")]
        [switch] $FailedOnly,

        [Parameter(ParameterSetName = "FailedOnlyAsObjects")]
        [switch] $FailedOnlyAsObjects
    )
    
    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $null = $sb = New-Object System.Text.StringBuilder
        $null = $sb.AppendLine("<D365FO.Tools.Runbook.Analyzer.Output>")

        [xml]$xmlRunbook = Get-Content $Path

        $failedObjs = New-Object System.Collections.Generic.List[System.Object]

        $failedSteps = $xmlRunbook.SelectNodes("//RunbookStepList/Step/StepState[text()='Failed']")

        $failedSteps | ForEach-Object {
            $null = $sb.AppendLine("<FailedStepInfo>")

            $stepId = $_.ParentNode | Select-Object -ExpandProperty childnodes | Where-Object { $_.name -like 'ID' } | Select-Object -ExpandProperty InnerText
            $failedLogs = $xmlRunbook.SelectNodes("//RunbookLogs/Log/StepID[text()='$stepId']")

            $failedObjs.Add([PsCustomObject]@{Step = "$stepId" })

            $null = $sb.AppendLine($_.ParentNode.OuterXml)

            $failedLogs | ForEach-Object { $null = $sb.AppendLine( $_.ParentNode.OuterXml) }

            $null = $sb.AppendLine("</FailedStepInfo>")
        }
        
        if ((-not $FailedOnly) -and (-not $FailedOnlyAsObjects)) {
            $inProgressSteps = $xmlRunbook.SelectNodes("//RunbookStepList/Step/StepState[text()='InProgress']")

            $null = $sb.AppendLine("<InProgressStepInfo>")

            $inProgressSteps | ForEach-Object { $null = $sb.AppendLine( $_.ParentNode.OuterXml) }

            $null = $sb.AppendLine("</InProgressStepInfo>")

            $unprocessedSteps = $xmlRunbook.SelectNodes("//RunbookStepList/Step/StepState[text()='NotStarted']")

            $null = $sb.AppendLine("<UnprocessedStepInfo>")

            $unprocessedSteps | ForEach-Object { $null = $sb.AppendLine( $_.ParentNode.OuterXml) }

            $null = $sb.AppendLine("</UnprocessedStepInfo>")
        }

        $null = $sb.AppendLine("</D365FO.Tools.Runbook.Analyzer.Output>")

        if ($FailedOnlyAsObjects) {
            $failedObjs.ToArray()
        }
        else {
            [xml]$xmlRaw = $sb.ToString()
        
            $stringWriter = New-Object System.IO.StringWriter;
            $xmlWriter = New-Object System.Xml.XmlTextWriter $stringWriter;
            $xmlWriter.Formatting = "indented";
            $xmlRaw.WriteTo($xmlWriter);
            $xmlWriter.Flush();
            $stringWriter.Flush();
            $stringWriter.ToString();
        }
    }
}