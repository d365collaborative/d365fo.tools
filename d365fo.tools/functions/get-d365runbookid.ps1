
<#
    .SYNOPSIS
        Get runbook id
        
    .DESCRIPTION
        Get the runbook id from inside a runbook file
        
    .PARAMETER Path
        Path to the runbook file that you want to analyse
        
        Accepts value from pipeline, also by property
        
    .EXAMPLE
        PS C:\> Get-D365RunbookId -Path "C:\DynamicsAX\InstallationRecords\Runbooks\Runbook.xml"
        
        This will inspect the Runbook.xml file and output the runbookid from inside the XML document.
        
    .EXAMPLE
        PS C:\> Get-D365Runbook | Get-D365RunbookId
        
        This will find all runbook file(s) and have them analyzed by the Get-D365RunbookId cmdlet to output the runbookid(s).
        
    .EXAMPLE
        PS C:\> Get-D365Runbook -Latest | Get-D365RunbookId
        
        This will find the latest runbook file and have it analyzed by the Get-D365RunbookId cmdlet to output the runbookid.
        
    .NOTES
        Tags: Runbook, Analyze, RunbookId, Runbooks
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365RunbookId {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [Alias('File')]
        [string] $Path
    )

    process {
        if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

        [xml]$xmlRunbook = Get-Content $Path

        [PSCustomObject]@{
            RunbookId = $xmlRunbook.SelectSingleNode("/RunbookData/RunbookID")."#text"
        }
    }
}