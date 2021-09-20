
<#
    .SYNOPSIS
        Imports a .NET dll file into memory
        
    .DESCRIPTION
        Imports a .NET dll file into memory, by creating a copy (temporary file) and imports it using reflection
        
    .PARAMETER Path
        Path to the dll file you want to import
        
        Accepts an array of strings
        
    .PARAMETER UseTempFolder
        Instruct the cmdlet to create the file copy in the default temp folder
        
        This switch can be used, if writing to the original folder is not wanted or not possible
        
    .EXAMPLE
        PS C:\> Import-AssemblyFileIntoMemory -Path "C:\AOSService\PackagesLocalDirectory\Bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Framework.dll"
        
        This will create an new file named "C:\AOSService\PackagesLocalDirectory\Bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Framework.dll_shawdow.dll"
        The new file is then imported into memory using .NET Reflection.
        After the file has been imported, it will be deleted from disk.
        
    .EXAMPLE
        PS C:\> Import-AssemblyFileIntoMemory -Path "C:\AOSService\PackagesLocalDirectory\Bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Framework.dll" -UseTempFolder
        
        This will create an new file named "Microsoft.Dynamics.BusinessPlatform.ProductInformation.Framework.dll_shawdow.dll" in the temp folder
        The new file is then imported into memory using .NET Reflection.
        After the file has been imported, it will be deleted from disk.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>

function Import-AssemblyFileIntoMemory {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string[]] $Path,

        [switch] $UseTempFolder
    )

    if (-not (Test-PathExists -Path $Path -Type Leaf)) {
        Stop-PSFFunction -Message "Stopping because unable to locate file." -StepsUpward 1
        return
    }

    foreach ($itemPath in $Path) {

        if ($UseTempFolder) {
            $filename = Split-Path -Path $itemPath -Leaf
            $shadowClonePath = Join-Path $env:TEMP "$filename`_shadow.dll"
        }
        else {
            $shadowClonePath = "$itemPath`_shadow.dll"
        }

        try {
            Write-PSFMessage -Level Debug -Message "Cloning $itemPath to $shadowClonePath"
            Copy-Item -Path $itemPath -Destination $shadowClonePath -Force
    
            Write-PSFMessage -Level Debug -Message "Loading $shadowClonePath into memory"
            $null = [AppDomain]::CurrentDomain.Load(([System.IO.File]::ReadAllBytes($shadowClonePath)))
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while working against the database" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
        finally {
            Write-PSFMessage -Level Debug -Message "Removing $shadowClonePath"
            Remove-Item -Path $shadowClonePath -Force -ErrorAction SilentlyContinue
        }
    }
}