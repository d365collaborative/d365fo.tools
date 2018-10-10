<#
.SYNOPSIS
Invoke the SCDPBundleInstall.exe file

.DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process 

.PARAMETER Path
Path to the update package that you want to install into the environment

The cmdlet only supports an already extracted ".axscdppkg" file

.PARAMETER MetaDataDir
The path to the meta data directory for the environment 

Default path is the same as the aos service PackagesLocalDirectory 

.PARAMETER InstallOnly
Switch to instruct the cmdlet to only run the Install option and ignore any TFS / VSTS folders
and source control in general

Use it when testing an update on a local development machine (VM) / onebox

.EXAMPLE
Invoke-D365SCDPBundleInstall -Path "c:\temp\HotfixPackageBundle.axscdppkg"

This will install the "HotfixPackageBundle.axscdppkg" into the default 
PackagesLocalDirectory location on the machine

.NOTES
Author: Mötz Jensen (@splaxi)
#>
function Invoke-D365SCDPBundleInstall {
    [CmdletBinding(DefaultParameterSetName = 'InstallOnly')]
    param (
        [Parameter(Mandatory = $True, ParameterSetName = 'InstallOnly', Position = 0 )]
        [switch] $InstallOnly,

        [Parameter(Mandatory = $False, ParameterSetName = 'Tfs', Position = 0 )]
        [ValidateSet('Prepare', 'Install')]
        [string] $Command = 'Prepare',

        [Parameter(Mandatory = $True, Position = 1 )]
        [Alias('Hotfix')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $False, Position = 2 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $False, ParameterSetName = 'Tfs', Position = 3 )]
        [string] $TfsWorkspaceDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $False, ParameterSetName = 'Tfs', Position = 4 )]
        [string] $TfsUri = "$Script:TfsUri",

        [Parameter(Mandatory = $False, Position = 4 )]
        [switch] $ShowModifiedFiles,

        [Parameter(Mandatory = $False, Position = 5 )]
        [switch] $ShowProgress      

    )
    
    Invoke-TimeSignal -Start
    $StartTime = Get-Date
    $executable = Join-Path $Script:BinDir "\bin\SCDPBundleInstall.exe"

    if (!(Test-PathExists -Path $Path,$executable -Type Leaf)) {return}
    if (!(Test-PathExists -Path $MetaDataDir -Type Container)) {return}
    
    Unblock-File -Path $Path #File is typically downloaded and extracted

    if ($InstallOnly) {
        $param = @("-install", 
        "-packagepath=$Path", 
        "-metadatastorepath=$MetaDataDir")
    }
    else{

        if ($TfsUri -eq ""){
            Write-PSFMessage -Level Host -Message "No TFS URI provided. Unable to complete the command."
            Stop-PSFFunction -Message "Stopping because missing TFS URI parameter."
            return
        }

        switch($Command){
            "Prepare" {
                $param = @("-prepare")
            }
            "Install"{
                $param = @("-install")
            }
        }
        $param = $param + @("-packagepath=`"$Path`"",
                            "-metadatastorepath=`"$MetaDataDir`"",
                            "-tfsworkspacepath=`"$TfsWorkspaceDir`"",
                            "-tfsprojecturi=`"$TfsUri`"")
    }

    Write-PSFMessage -Level Verbose -Message "Invoking SCDPBundleInstall.exe" -Target $param    
    
    if ($ShowProgress) {
        
        $process = Start-Process -FilePath $executable -ArgumentList $param -PassThru

        while (-not ($process.HasExited)) {
            
            $timeout = New-TimeSpan -Days 1
            $stopwatch = [Diagnostics.StopWatch]::StartNew();
            $bundleRoot = "$env:localappdata\temp\SCDPBundleInstall"
            [xml]$manifest = Get-Content $(join-path $bundleRoot "PackageDependencies.dgml") -ErrorAction SilentlyContinue
            $bundleCounter = 0
            
            if ($manifest)
            {
                $bundleTotalCount = $manifest.DirectedGraph.Nodes.ChildNodes.Count
            }            
            
            while ($manifest -and (-not ($process.HasExited)) -and $stopwatch.elapsed -lt $timeout)
            {    
                $currentBundleFolder = Get-ChildItem $bundleRoot -Directory -ErrorAction SilentlyContinue
        
                if ($currentBundleFolder)
                {
                    $currentBundle = $currentBundleFolder.Name
        
                    if ($announcedBundle -ne $currentBundle)
                    {
                        $announcedBundle = $currentBundle
                        $bundleCounter = $bundleCounter + 1
                        Write-PSFMessage -Level Verbose -Message "$bundleCounter/$bundleTotalCount : Processing hotfix package $announcedBundle"                            
                    }
                }
            }
            Start-Sleep -Milliseconds 100             
        }         
    }
    else {
        Start-Process -FilePath $executable -ArgumentList $param -NoNewWindow -Wait
    }
    
    if ($ShowModifiedFiles) {
        $res = Get-ChildItem -Path $MetaDataDir -Recurse | Where-Object {$_.LastWriteTime -gt $StartTime}

        $res | ForEach-Object {
            Write-PSFMessage -Level Verbose -Message "Object modified by the install: $($_.FullName)"
        }

        $res
    }

    Invoke-TimeSignal -End
}