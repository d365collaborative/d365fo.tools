
<#
    .SYNOPSIS
        Get the RSAT playback files
        
    .DESCRIPTION
        Get all the RSAT playback files from the last executions
        
    .PARAMETER Path
        The path where the RSAT tool will be writing the files
        
        The default path is:
        "C:\Users\USERNAME\AppData\Roaming\regressionTool\playback"
        
    .PARAMETER Name
        Name of Test Case that you are looking for
        
        Default value is "*" which will search for all Test Cases and their corresponding files
        
    .PARAMETER ExecutionUsername
        Name of the user account has been running the RSAT tests on a machine that isn't the same as the current user
        
        Will enable you to log on to RSAT server that is running the tests from a console, automated, and is other account than the current user
        
    .EXAMPLE
        PS C:\> Get-D365RsatPlaybackFile
        
        This will get all the RSAT playback files.
        It will search for the files in the current user AppData system folder.
        
    .EXAMPLE
        PS C:\> Get-D365RsatPlaybackFile -Name *4080*
        
        This will get all the RSAT playback files which has "4080" as part of its name.
        It will search for the files in the current user AppData system folder.
        
    .EXAMPLE
        PS C:\> Get-D365RsatPlaybackFile -ExecutionUsername RSAT-ServiceAccount
        
        This will get all the RSAT playback files that were executed by the RSAT-ServiceAccount user.
        It will search for the files in the RSAT-ServiceAccount user AppData system folder.
        
    .NOTES
        Tags: RSAT, Testing, Regression Suite Automation Test, Regression, Test, Automation, Playback
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-D365RsatPlaybackFile {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string] $Path = $Script:RsatplaybackPath,
        
        [Parameter(Mandatory = $false)]
        [string] $Name = "*",

        [Parameter(Mandatory = $false, ParameterSetName = "ExecutionUser")]
        [string] $ExecutionUsername
    )
    
    if ($PSCmdlet.ParameterSetName -eq "ExecutionUser") {
        $Path = $Path.Replace("$($env:UserName)", $ExecutionUsername)

        if (-not (Test-PathExists -Path $Path -Type Container)) { return }
    }

    Get-ChildItem -Path $Path -Recurse | Where-Object { $_.Name -like $Name } | Select-PSFObject "LastWriteTime as LastRuntime", "Name as Filename", "Fullname as File"
}