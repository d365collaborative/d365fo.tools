
<#
    .SYNOPSIS
        Get the details from an axscdppkg file
        
    .DESCRIPTION
        Get the details from an axscdppkg file by extracting it like a zip file.
        
        Capable of extracting the manifest details from the inner packages as well
        
    .PARAMETER Path
        Path to the axscdppkg file you want to analyze
        
    .PARAMETER ExtractionPath
        Path where you want the cmdlet to work with extraction of all the files
        
        Default value is: C:\Users\Username\AppData\Local\Temp
        
    .PARAMETER KB
        KB number of the hotfix that you are looking for
        
        Accepts wildcards for searching. E.g. -KB "4045*"
        
        Default value is "*" which will search for all KB's
        
    .PARAMETER Hotfix
        Package Id / Hotfix number the hotfix that you are looking for
        
        Accepts wildcards for searching. E.g. -Hotfix "7045*"
        
        Default value is "*" which will search for all hotfixes
        
    .PARAMETER Traverse
        Switch to instruct the cmdlet to traverse the inner packages and extract their details
        
    .PARAMETER KeepFiles
        Switch to instruct the cmdlet to keep the files for further manual analyze
        
    .PARAMETER IncludeRawManifest
        Switch to instruct the cmdlet to include the raw content of the manifest file
        
        Only works with the -Traverse option
        
    .EXAMPLE
        PS C:\> Get-D365PackageBundleDetail -Path "c:\temp\HotfixPackageBundle.axscdppkg" -Traverse
        
        This will extract all the content from the "HotfixPackageBundle.axscdppkg" file and extract all inner packages. For each inner package it will find the manifest file and fetch the KB numbers. The raw manifest file content is included to be analyzed.
        
    .EXAMPLE
        PS C:\> Get-D365PackageBundleDetail -Path "c:\temp\HotfixPackageBundle.axscdppkg" -ExtractionPath C:\Temp\20180905 -Traverse -KeepFiles
        
        This will extract all the content from the "HotfixPackageBundle.axscdppkg" file and extract all inner packages. It will extract the content into C:\Temp\20180905 and keep the files after completion.
        
    .EXAMPLE
        PS C:\> Get-D365PackageBundleDetail -Path C:\temp\HotfixPackageBundle.axscdppkg -Traverse -IncludeRawManifest
        
        This is an advanced scenario.
        
        This will traverse the "HotfixPackageBundle.axscdppkg" file and will include the raw manifest file details in the output.
        
    .EXAMPLE
        PS C:\> Get-D365PackageBundleDetail -Path C:\temp\HotfixPackageBundle.axscdppkg -Traverse -IncludeRawManifest | ForEach-Object {$_.RawManifest | Out-File "C:\temp\$($_.PackageId).txt"}
        
        This is an advanced scenario.
        
        This will traverse the "HotfixPackageBundle.axscdppkg" file and save the manifest files into c:\temp. Everything else is omitted and cleaned up.
        
    .NOTES
        Tags: Hotfix, KB, Manifest, HotfixPackageBundle, axscdppkg, Package, Bundle, Deployable
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365PackageBundleDetail {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [Alias('File')]
        [string] $Path,

        [string] $ExtractionPath = ([System.IO.Path]::GetTempPath()),

        [string] $KB = "*",

        [string] $Hotfix = "*",

        [switch] $Traverse,

        [switch] $KeepFiles,

        [switch] $IncludeRawManifest
    )
    
    begin {
        Invoke-TimeSignal -Start

        if (!(Test-Path -Path $Path -PathType Leaf)) {
            Write-PSFMessage -Level Host -Message "The <c='em'>$Path</c> file wasn't found. Please ensure the file <c='em'>exists </c> and you have enough <c='em'>permission/c> to access the file."
            Stop-PSFFunction -Message "Stopping because a file is missing."
            return
        }

        Unblock-File -Path $Path

        if(!(Test-Path -Path $ExtractionPath)) {
            Write-PSFMessage -Level Verbose -Message "The extract path didn't exists. Creating it." -Target $ExtractionPath
            $null = New-Item -Path $ExtractionPath -Force -ItemType Directory
        }

        if ($Path -notlike "*.zip") {
            $tempPathZip = Join-Path $ExtractionPath "$($(New-Guid).ToString()).zip"

            Write-PSFMessage -Level Verbose -Message "The file isn't a zip file. Copying the file to $tempPathZip" -Target $tempPathZip
            Copy-Item -Path $Path -Destination $tempPathZip -Force
            $Path = $tempPathZip
        }

        $packageTemp = Join-Path $ExtractionPath ((Get-Random -Maximum 99999).ToString())

        $oldprogressPreference = $global:progressPreference
        $global:progressPreference = 'silentlyContinue'

    }
    
    process {
        if (Test-PSFFunctionInterrupt) {return}

        Write-PSFMessage -Level Verbose -Message "Extracting the zip file to $packageTemp" -Target $packageTemp
        Expand-Archive -Path $Path -DestinationPath $packageTemp

        if ($Traverse) {
            $files = Get-ChildItem -Path $packageTemp -Filter "*.axscdp"
            
            foreach ($item in $files) {
                $filename = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
                $tempFile = Join-Path $packageTemp "$filename.zip"
        
                Write-PSFMessage -Level Verbose -Message "Coping $($item.FullName) to $tempFile" -Target $tempFile
                Copy-Item -Path $item.FullName -Destination $tempFile

                $tempDir = (Join-Path $packageTemp ($filename.Replace("DynamicsAX_", "")))
                $null = New-Item -Path $tempDir -ItemType Directory -Force

                Write-PSFMessage -Level Verbose -Message "Extracting the zip file $tempFile to $tempDir" -Target $tempDir
                Expand-Archive -Path $tempFile -DestinationPath $tempDir
            }

            $manifestFiles = Get-ChildItem -Path $packageTemp -Recurse -Filter "PackageManifest.xml"

            $namespace = @{ns = "http://schemas.datacontract.org/2004/07/Microsoft.Dynamics.AX.Servicing.SCDP.Packaging";
                           nsKB = "http://schemas.microsoft.com/2003/10/Serialization/Arrays"}

            Write-PSFMessage -Level Verbose -Message "Getting all the information from the manifest file"

            foreach ($item in $manifestFiles) {
                $raw = (Get-Content -Path $item.FullName) -join [Environment]::NewLine
                $xmlDoc = [xml]$raw
                $kbs = Select-Xml -Xml $xmlDoc -XPath "//ns:UpdatePackageManifest/ns:KBNumbers/nsKB:string" -Namespace $namespace
                $packageId = Select-Xml -Xml $xmlDoc -XPath "//ns:UpdatePackageManifest/ns:PackageId/ns:PackageId" -Namespace $namespace
                
                $strPackage = $packageId.Node.InnerText
                $arrKbs = $kbs.node.InnerText

                if($packageId.Node.InnerText -notlike $Hotfix) {continue}
                if(@($arrKbs) -notlike $KB) {continue} #* Search across an array with like

                $Obj = [PSCustomObject]@{Hotfix = $strPackage
                KBs = ($arrKbs -Join ";")}

                if($IncludeRawManifest) {$Obj.RawManifest = $raw}

                $Obj | Select-PSFObject -TypeName "D365FO.TOOLS.PackageBundleManifestDetail"
            }
        }
        else {
            Get-ChildItem -Path $packageTemp -Filter "*.*" | Select-PSFObject -TypeName "D365FO.TOOLS.PackageBundleDetail" "BaseName as Name"
        }
    }
    
    end {
        if(!$Keepfiles) {
            Remove-Item -Path $packageTemp -Recurse -Force -ErrorAction SilentlyContinue

            if(![system.string]::IsNullOrEmpty($tempPathZip)) {
                Remove-Item -Path $tempPathZip -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        $global:progressPreference = $oldprogressPreference

        Invoke-TimeSignal -End
    }
}