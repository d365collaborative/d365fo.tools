
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
        [string] $RunbookId = "Runbook",

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )
    
    if ((Get-Process -Name "devenv" -ErrorAction SilentlyContinue).Count -gt 0) {
        Write-PSFMessage -Level Host -Message "It seems that you have a <c='em'>Visual Studio</c> running. Please ensure <c='em'>exit</c> Visual Studio and run the cmdlet again."
        Stop-PSFFunction -Message "Stopping because of running Visual Studio."
        return
    }

    Test-AssembliesLoaded

    if (Test-PSFFunctionInterrupt) {
        Write-PSFMessage -Level Host -Message "It seems that you have executed some cmdlets that required to <c='em'>load</c> some Dynamics 356 Finance & Operations <c='em'>assemblies</c> into memory. Please <c='em'>close and restart</c> you PowerShell session / console, and <c='em'>start a fresh</c>. Please note that you should execute the failed command <c='em'>immediately</c> after importing the module."
        Stop-PSFFunction -Message "Stopping because of loaded assemblies."
        return
    }

    $arrRunbookIds = Get-D365Runbook | Get-D365RunbookId

    if (($Command -eq "RunAll") -and ($arrRunbookIds.Runbookid -contains $RunbookId)) {
        Write-PSFMessage -Level Host -Message "It seems that you have entered an <c='em'>already used RunbookId</c>. Please consider if you are <c='em'>trying to re-run some steps</c> or simply pass <c='em'>another RunbookId</c>."
        Stop-PSFFunction -Message "Stopping because of RunbookId already used on this machine."
        return
    }

    Invoke-TimeSignal -Start

    # Input is a relative path, hence we set the path to the current directory
    if ($Path -eq ".") {
        $currentPath = [System.IO.Directory]::GetCurrentDirectory()
        Write-PSFMessage -Level Verbose "Updating path to '$currentPath' as relative paths are not supported"
        $Path = $currentPath
    }

    # $Util = Join-Path $Path "AXUpdateInstaller.exe"
    $executable = Join-Path $Path "AXUpdateInstaller.exe"

    $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'

    if (-not (Test-PathExists -Path $topologyFile, $Util -Type Leaf)) { return }
        
    Get-ChildItem -Path $Path -Recurse | Unblock-File

    if ($QuickInstallAll) {
        Write-PSFMessage -Level Verbose "Using QuickInstallAll mode"
        $params = "quickinstallall"

        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
    }
    elseif ($DevInstall) {
        Write-PSFMessage -Level Verbose "Using DevInstall mode"
        $params = "devinstall"

        Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly
    }
    else {
        $Command = $Command.ToLowerInvariant()
        $runbookFile = Join-Path $Path "$runbookId.xml"
        $serviceModelFile = Join-Path $Path 'DefaultServiceModelData.xml'
        $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                        
        if ($Command -eq 'runall') {
            Write-PSFMessage -Level Verbose "Running all manual steps in one single operation"

            #Update topology file (first command)
            $ok = Update-TopologyFile -Path $Path

            if ($ok) {
                $params = @(
                    "generate"
                    "-runbookId=`"$runbookId`""
                    "-topologyFile=`"$topologyFile`""
                    "-serviceModelFile=`"$serviceModelFile`""
                    "-runbookFile=`"$runbookFile`""
                )
                
                #Generate (second command)
                Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

                if (Test-PSFFunctionInterrupt) { return }

                $params = @(
                    "import"
                    "-runbookFile=`"$runbookFile`""
                )

                Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

                if (Test-PSFFunctionInterrupt) { return }

                $params = @(
                    "execute"
                    "-runbookId=`"$runbookId`""
                )

                Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

                if (Test-PSFFunctionInterrupt) { return }
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
                    
                    $params = @(
                        "generate"
                        "-runbookId=`"$runbookId`""
                        "-topologyFile=`"$topologyFile`""
                        "-serviceModelFile=`"$serviceModelFile`""
                        "-runbookFile=`"$runbookFile`""
                    )
                }
                'import' {
                    Write-PSFMessage -Level Verbose "Importing runbook file."
                    
                    $params = @(
                        "import"
                        "-runbookfile=`"$runbookFile`""
                    )
                }
                'execute' {
                    Write-PSFMessage -Level Verbose "Executing runbook file."
                   
                    $params = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                    )
                }
                'rerunstep' {
                    Write-PSFMessage -Level Verbose "Rerunning runbook step number $step."
                   
                    $params = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-rerunstep=$step"
                    )
                }
                'setstepcomplete' {
                    Write-PSFMessage -Level Verbose "Marking step $step complete and continuing from next step."
                   
                    $params = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-setstepcomplete=$step"
                    )
                }
                'export' {
                    Write-PSFMessage -Level Verbose "Exporting runbook for reuse."

                    $params = @(
                        "export"
                        "-runbookId=`"$runbookId`""
                        "-runbookfile=`"$runbookFile`""
                    )
                }
                'versioncheck' {
                    Write-PSFMessage -Level Verbose "Running version check on runbook."
                    
                    $params = @(
                        "execute"
                        "-runbookId=`"$runbookId`""
                        "-versioncheck=true"
                    )
                }
            }

            if ($RunCommand) {
                Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly

                if (Test-PSFFunctionInterrupt) { return }
            }
        }
    }

    Invoke-TimeSignal -End
    
}