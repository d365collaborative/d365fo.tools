
<#
    .SYNOPSIS
        Analyze the runbook
        
    .DESCRIPTION
        Get all the important details from a failed runbook
        
    .PARAMETER Path
        Path to the runbook file that you work against
        
    .EXAMPLE
        PS C:\> Invoke-D365RunbookAnalyzer -Path "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook.xml"
        
        This will analyze the Runbook.xml and output all the details about failed steps, the connected error logs and all the unprocessed steps.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Invoke-D365RunbookAnalyzer | Out-File "C:\Temp\d365fo.tools\runbook-analyze-results.xml"
        
        This will find the latest runbook file and have it analyzed by the Invoke-D365RunbookAnalyzer cmdlet to output any error details.
        The output will be saved into the "C:\Temp\d365fo.tools\runbook-analyze-results.xml" file.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Invoke-D365RunbookAnalyzer {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [Alias('File')]
        [string] $Path
    )
    
    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        $null = $sb = New-Object System.Text.StringBuilder
        $null = $sb.AppendLine("<D365FOTools-Runbook-Analyzer-Output>")

        [xml]$xmlRunbook = Get-Content $Path

        $failedSteps = $xmlRunbook.SelectNodes("//RunbookStepList/Step/StepState[text()='Failed']")

        $failedSteps | ForEach-Object {
            $null = $sb.AppendLine("<FailedStepInfo>")

            $stepId = $_.ParentNode | Select-Object -ExpandProperty childnodes | Where-Object {$_.name -like 'ID'} | Select-Object -ExpandProperty InnerText
            $failedLogs = $xmlRunbook.SelectNodes("//RunbookLogs/Log/StepID[text()='$stepId']")

            $null = $sb.AppendLine($_.ParentNode.OuterXml)

            $failedLogs | ForEach-Object { $null = $sb.AppendLine( $_.ParentNode.OuterXml)}

            $null = $sb.AppendLine("</FailedStepInfo>")
        }

        $unprocessedSteps = $xmlRunbook.SelectNodes("//RunbookStepList/Step/StepState[text()='NotStarted']")

        $null = $sb.AppendLine("<UnprocessedStepInfo>")

        $unprocessedSteps | ForEach-Object { $null = $sb.AppendLine( $_.ParentNode.OuterXml)}

        $null = $sb.AppendLine("</UnprocessedStepInfo>")

        $null = $sb.AppendLine("</D365FOTools-Runbook-Analyzer-Output>")

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