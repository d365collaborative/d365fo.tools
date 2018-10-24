
<#
    .SYNOPSIS
        Invoke the AxUpdateInstaller.exe file from Software Deployable Package (SDP)
        
    .DESCRIPTION
        A cmdlet that wraps some of the cumbersome work into a streamlined process.
        The process are detailed in the Microsoft documentation here:
        https://docs.microsoft.com/en-us/dynamics365/unified-operations/dev-itpro/deployment/install-deployable-package
        
    .PARAMETER Path
        Path to the update package that you want to install into the environment
        
        The cmdlet only supports a path to an already extracted and unblocked zip-file
        
    .PARAMETER MetaDataDir
        The path to the meta data directory for the environment
        
        Default path is the same as the aos service PackagesLocalDirectory
        
    .PARAMETER QuickInstallAll
        Use this switch to let the runbook reside in memory. You will not get a runbook on disc which you can examine for steps
        
    .PARAMETER DevInstall
        Use this when running on developer box without administrator privileges (Run As Administrator)
        
    .PARAMETER Command
        The command you want the cmdlet to execute when it runs the AXUpdateInstaller.exe
        
        Valid options are:
        SetTopology
        Generate
        Import
        Execute
        RunAll
        ReRunStep
        SetStepComplete
        Export
        VersionCheck
        
        The default value is "SetTopology"
        
    .PARAMETER Step
        The step number that you want to work against
        
    .PARAMETER RunbookId
        The runbook id of the runbook that you want to work against
        
        Default value is "Runbook"
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -QuickInstallAll
        
        This will install the extracted package in c:\temp\ using a runbook in memory while executing.
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command SetTopology
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Generate -RunbookId 'MyRunbook'
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Import -RunbookId 'MyRunbook'
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command Execute -RunbookId 'MyRunbook'
        
        Manual operations that first create Topology XML from current environment, then generate runbook with id 'MyRunbook', then import it and finally execute it.
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll
        
        Create Topology XML from current environment. Using default runbook id 'Runbook' and run all the operations from generate, to import to execute.
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command RerunStep -Step 18 -RunbookId 'MyRunbook'
        
        Rerun runbook with id 'MyRunbook' from step 18.
        
    .EXAMPLE
        PS C:\> Invoke-D365SDPInstall -Path "c:\temp\" -Command SetStepComplete -Step 24 -RunbookId 'MyRunbook'
        
        Mark step 24 complete in runbook with id 'MyRunbook' and continue the runbook from the next step.
        
    .NOTES
        Author: Tommy Skaue (@skaue)
        Author: Mötz Jensen (@Splaxi)
        
        Inspired by blogpost http://dev.goshoom.net/en/2016/11/installing-deployable-packages-with-powershell/
        
#>
function Invoke-D365SDPInstall {
    [CmdletBinding(DefaultParameterSetName = 'QuickInstall')]
    param (
        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('Hotfix')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, Position = 2 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'QuickInstall', Position = 3 )]
        [switch] $QuickInstallAll,

        [Parameter(Mandatory = $false, ParameterSetName = 'DevInstall', Position = 3 )]
        [switch] $DevInstall,

        [Parameter(Mandatory = $true, ParameterSetName = 'Manual', Position = 3 )]
        [ValidateSet('SetTopology', 'Generate', 'Import', 'Execute', 'RunAll', 'ReRunStep', 'SetStepComplete', 'Export', 'VersionCheck')]
        [string] $Command = 'SetTopology',

        [Parameter(Mandatory = $false, Position = 4 )]
        [int] $Step,
        
        [Parameter(Mandatory = $false, Position = 5 )]
        [string] $RunbookId = "Runbook"
    )
    
    if ((Get-Process -Name "devenv" -ErrorAction SilentlyContinue).Count -gt 0) {
        Write-PSFMessage -Level Host -Message "It seems that you have a <c='em'>Visual Studio</c> running. Please ensure <c='em'>exit</c> Visual Studio and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of running Visual Studio."
        return
    }

    Invoke-TimeSignal -Start

    $Util = Join-Path $Path "AXUpdateInstaller.exe"
    $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'

    if (-not (Test-PathExists -Path $topologyFile, $Util -Type Leaf)) { return }
        
    Get-ChildItem -Path $Path -Recurse | Unblock-File

    if ($QuickInstallAll) {
        Write-PSFMessage -Level Verbose "Using QuickInstallAll mode"
        $param = "quickinstallall"
        Start-Process -FilePath $Util -ArgumentList  $param  -NoNewWindow -Wait
    }
    elseif ($DevInstall) {
        Write-PSFMessage -Level Verbose "Using DevInstall mode"
        $param = "devinstall"
        Start-Process -FilePath $Util -ArgumentList  $param  -NoNewWindow -Wait
    }
    else {
        $Command = $Command.ToLowerInvariant()
        $runbookFile = Join-Path $Path "$runbookId.xml"
        $serviceModelFile = Join-Path $Path 'DefaultServiceModelData.xml'
        $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                        
        if ($Command -eq 'runall') {
            Write-PSFMessage -Level Verbose "Running all manual steps in one single operation"

            $ok = Update-TopologyFile -Path $Path
            if ($ok) {
                $param = @(
                    "-runbookId=$runbookId"
                    "-topologyFile=$topologyFile"
                    "-serviceModelFile=`"$serviceModelFile`""
                    "-runbookFile=`"$runbookFile`""
                )
                & $Util generate $param
                & $Util import "-runbookfile=`"$runbookFile`""
                & $Util execute "-runbookId=`"$runbookId`""
            }
            Write-PSFMessage -Level Verbose "All manual steps complete."
        }
        else {
            $RunCommand = $true
            switch ($Command) {
                'settopology' {
                    Write-PSFMessage -Level Verbose "Updating topology file xml."
                    $ok = Update-TopologyFile -Path $Path
                    $RunCommand = $false
                }
                'generate' {
                    Write-PSFMessage -Level Verbose "Generating runbook file."
                    $param = @(
                        "generate"
                        "-runbookId=`"$runbookId`""
                        "-topologyFile=`"$topologyFile`""
                        "-serviceModelFile=`"$serviceModelFile`""
                        "-runbookFile=`"$runbookFile`""
                    )
                }
                'import' {
                    Write-PSFMessage -Level Verbose "Importing runbook file."
                    $param = @(
                        "import"
                        "-runbookfile=`"$runbookFile`""
                    )
                }
                'execute' {
                    Write-PSFMessage -Level Verbose "Executing runbook file."
                    $param = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                    )
                }
                'rerunstep' {
                    Write-PSFMessage -Level Verbose "Rerunning runbook step number $step."
                    $param = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-rerunstep=$step"
                    )
                }
                'setstepcomplete' {
                    Write-PSFMessage -Level Verbose "Marking step $step complete and continuing from next step."
                    $param = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-setstepcomplete=$step"
                    )
                }
                'export' {
                    Write-PSFMessage -Level Verbose "Exporting runbook for reuse."
                    & $Util export
                    $param = @(
                        "export"
                        "-runbookId=`"$runbookId`""
                        "-runbookfile=`"$runbookFile`""
                    )
                }
                'versioncheck' {
                    Write-PSFMessage -Level Verbose "Running version check on runbook."
                    $param = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-versioncheck=true"
                    )
                }
            }

            if ($RunCommand) { & $Util $param }
        }
    }

    Invoke-TimeSignal -End
    
}