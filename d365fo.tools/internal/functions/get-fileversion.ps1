
<#
    .SYNOPSIS
        Get the file version details
        
    .DESCRIPTION
        Get the file version details for any given file
        
    .PARAMETER Path
        Path to the file that you want to extract the file version details from
        
    .EXAMPLE
        PS C:\> Get-FileVersion -Path "C:\Program Files\Microsoft Dynamics AX\60\Server\MicrosoftDynamicsAX\Bin\AxServ32.exe"
        
        This will get the file version details for the AX AOS executable (AxServ32.exe).
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        Inspired by https://blogs.technet.microsoft.com/askpfeplat/2014/12/07/how-to-correctly-check-file-versions-with-powershell/
        
#>
function Get-FileVersion {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) { return }

    Write-PSFMessage -Level Verbose -Message "Extracting the file properties for: $Path" -Target $Path
    
    $Filepath = Get-Item -Path $Path

    [PSCustomObject]@{
        FileVersion           = $Filepath.VersionInfo.FileVersion
        ProductVersion        = $Filepath.VersionInfo.ProductVersion
        FileVersionUpdated    = "$($Filepath.VersionInfo.FileMajorPart).$($Filepath.VersionInfo.FileMinorPart).$($Filepath.VersionInfo.FileBuildPart).$($Filepath.VersionInfo.FilePrivatePart)"
        ProductVersionUpdated = "$($Filepath.VersionInfo.ProductMajorPart).$($Filepath.VersionInfo.ProductMinorPart).$($Filepath.VersionInfo.ProductBuildPart).$($Filepath.VersionInfo.ProductPrivatePart)"
    }
}