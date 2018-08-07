<#
.SYNOPSIS
Invoke the ModelUtil.exe

.DESCRIPTION
A cmdlet that wraps some of the cumbersome work into a streamlined process 

.PARAMETER Path
Path to the model package/file that you want to install into the environment

The cmdlet only supports an already extracted ".axmodel" file

.PARAMETER BinDir
The path to the bin directory for the environment 

Default path is the same as the AOS service PackagesLocalDirectory\bin 

.PARAMETER MetaDataDir
The path to the meta data directory for the environment 

Default path is the same as the aos service PackagesLocalDirectory 

.PARAMETER Import
Switch to instruct the cmdlet to execute the Import functionality on ModelUtil.exe

Default value is: on / $true

.EXAMPLE
Invoke-D365ModelUtil -Path c:\temp\ApplicationSuiteModernDesigns_App73.axmodel

This will execute the import functionality of ModelUtil.exe and have it import the 
c:\temp\ApplicationSuiteModernDesigns_App73.axmodel file

.NOTES
General notes
#>
function Invoke-D365ModelUtil {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, ParameterSetName = 'Default', Position = 1 )]
        [Alias('Model')]
        [Alias('File')]
        [string] $Path,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $BinDir = "$Script:PackageDirectory\bin",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $MetaDataDir = "$Script:MetaDataDir",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 4 )]
        [switch] $Import = [switch]::Present
    )
    
    begin {
    }
    
    process {
        $Setup = Join-Path $BinDir "ModelUtil.exe"

        Write-PSFMessage -Level Verbose -Message "Testing if the path exists or not." -Target $Setup
        if ((Test-Path -Path $Setup -PathType Leaf) -eq $false) {
            Write-PSFMessage -Level Host -Message "Unable to locate the <c=`"red`">ModelUtil.exe</c> in the specified path. Please ensure that the path exists and you have permissions to access it."
            
            Stop-PSFFunction -Message "Stopping because unable to locate ModelUtil.exe." -Target $Setup
            return
        }

        Write-PSFMessage -Level Verbose -Message "Testing if the path exists or not." -Target $Path
        if ((Test-Path -Path $Path -PathType Leaf) -eq $false) {
            Write-PSFMessage -Level Host -Message "Unable to locate the <c=`"red`">$Path</c>path. Please ensure that the path exists and you have permissions to access it."
            
            Stop-PSFFunction -Message "Stopping because unable to locate $Path." -Target $Path
            return
        }

        Write-PSFMessage -Level Verbose -Message "Testing the execution mode" -Target $Import
        if ($Import.IsPresent) {
            Write-PSFMessage -Level Verbose -Message "Building the parameter options."
            $param = "-import -metadatastorepath=`"$MetaDataDir`" -file=`"$Path`""
        }

        Write-PSFMessage -Level Verbose -Message "Starting the $Setup with the parameter options." -Target $param
        Start-Process -FilePath $Setup -ArgumentList  $param  -NoNewWindow -Wait
    }
    
    end {
    }
}