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

Default path is the same as the aos service packageslocaldirectory 

.PARAMETER QuickInstallAll
Use this switch to let the runbook reside in memory. You will not get a runbook on disc which you can examine for steps

.EXAMPLE
Invoke-D365SDPInstall -Path "c:\temp\" -QuickInstallAll

This will install the extracted package in c:\temp\ using a runbook in memory while executing. 

.EXAMPLE
Invoke-D365SDPInstall -Path "c:\temp\" -Command SetTopology
Invoke-D365SDPInstall -Path "c:\temp\" -Command Generate -RunbookId 'MyRunbook'
Invoke-D365SDPInstall -Path "c:\temp\" -Command Import -RunbookId 'MyRunbook'
Invoke-D365SDPInstall -Path "c:\temp\" -Command Execute -RunbookId 'MyRunbook'

Manual operations that first create Topology XML from current environment, then generate runbook with id 'MyRunbook', then import it and finally execute it. 

.EXAMPLE
Invoke-D365SDPInstall -Path "c:\temp\" -Command RunAll

Create Topology XML from current environment. Using default runbook id 'Runbook' and run all the operations from generate, to import to execute.  

.EXAMPLE
Invoke-D365SDPInstall -Path "c:\temp\" -Command RerunStep -Step 18 -RunbookId 'MyRunbook'

Rerun runbook with id 'MyRunbook' from step 18

.EXAMPLE
Invoke-D365SDPInstall -Path "c:\temp\" -Command SetStepComplete -Step 24 -RunbookId 'MyRunbook'

Mark step 24 complete in runbook with id 'MyRunbook' and continue the runbook from the next step

.NOTES
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

        [Parameter(Mandatory = $true, ParameterSetName = 'Manual', Position = 3 )]
        [ValidateSet('SetTopology', 'Generate', 'Import', 'Execute','RunAll', 'ReRunStep', 'SetStepComplete', 'Export', 'VersionCheck')]
        [string] $Command = 'SetTopology',

        [Parameter(Mandatory = $false, Position = 4 )]        
        [int] $Step,
        
        [Parameter(Mandatory = $false, Position = 5 )]        
        [string] $RunbookId = "Runbook"
    )
    
    begin {
    }
    
    process {
        
        $Util = Join-Path $Path "AXUpdateInstaller.exe"
        
        $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
        $Files = @($topologyFile, $Util)
        foreach ($item in $Files) {
            Write-PSFMessage -Level Verbose -Message "Testing file path." -Target $item

            if ((Test-Path $item -PathType Leaf) -eq $false) {
                Write-PSFMessage -Level Host -Message "The <c='em'>$item</c> file wasn't found. Please ensure the file <c='em'>exists </c> and you have enough <c='em'>permission/c> to access the file."
                Stop-PSFFunction -Message "Stopping because a file is missing."
                return
            }    
        }
        
        if ($QuickInstallAll::IsPresent) {
            Write-PSFMessage -Level Verbose "Using QuickInstallAll mode"
            $param = "quickinstallall"            
            Start-Process -FilePath $Util -ArgumentList  $param  -NoNewWindow -Wait
        }
        else {
            $Command = $Command.ToLowerInvariant()            
            $runbookFile = Join-Path $Path "$runbookId.xml"
            $serviceModelFile = Join-Path $Path 'DefaultServiceModelData.xml'
            $topologyFile = Join-Path $Path 'DefaultTopologyData.xml'
                        
            if ($Command -eq 'runall')
            {
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
                    & $Util execute "-runbookId=$runbookId"
                    & $Util import "-runbookfile=`"$runbookFile`""
                    & $Util execute "-runbookId=$runbookId"
                }
                Write-PSFMessage -Level Verbose "All manual steps complete."
            }
            else {   
                if ($Command -eq 'settopology') {
                    Write-PSFMessage -Level Verbose "Updating topology file xml."

                    $ok = Update-TopologyFile -Path $Path                
                } 
                elseif($Command -eq 'generate')
                {                    
                    Write-PSFMessage -Level Verbose "Generating runbook file."
                    $param = @(
                        "-runbookId=`"$runbookId`"" 
                        "-topologyFile=`"$topologyFile`"" 
                        "-serviceModelFile=`"$serviceModelFile`"" 
                        "-runbookFile=`"$runbookFile`""
                    )
                    & $Util generate $param
                }
                elseif($Command -eq 'import')
                {                    
                    Write-PSFMessage -Level Verbose "Importing runbook file."
                    & $Util import "-runbookfile=`"$runbookFile`""
                }
                elseif($Command -eq 'execute')
                {
                    Write-PSFMessage -Level Verbose "Executing runbook file."
                    & $Util execute "-runbookId=`"$runbookId`""
                }
                elseif($Command -eq 'rerunstep')
                {
                    Write-PSFMessage -Level Verbose "Rerunning runbook step number $step."
                    & $Util execute "-runbookId=`"$runbookId`"" "-rerunstep=$step"
                }
                elseif($Command -eq 'setstepcomplete')
                {
                    Write-PSFMessage -Level Verbose "Marking step $step complete and continuing from next step."
                    & $Util execute "-runbookId=`"$runbookId`"" "-setstepcomplete=$step"
                }
                elseif($Command -eq 'export')
                {
                    Write-PSFMessage -Level Verbose "Exporting runbook for reuse."
                    & $Util export "-runbookId=`"$runbookId`"" "-runbookfile=`"$runbookFile`""
                }
                elseif($Command -eq 'versioncheck')
                {
                    Write-PSFMessage -Level Verbose "Running version check on runbook."
                    & $Util execute "-runbookId=`"$runbookId`"" "-versioncheck=true"
                }                      
            }
        }
    }
    
    end {
    }
}

