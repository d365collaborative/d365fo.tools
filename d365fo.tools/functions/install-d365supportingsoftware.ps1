
<#
    .SYNOPSIS
        Install software supporting F&O development
        
    .DESCRIPTION
        Installs software commonly used when doing Dynamics 365 Finance and Operations development

        Common ones: fiddler, postman, microsoft-edge, winmerge, notepadplusplus.install, azurepowershell, azure-cli, insomnia-rest-api-client, git.install

        Full list of software: https://community.chocolatey.org/packages
        
    .PARAMETER SoftwareName
        The name of the software to install
        
    .EXAMPLE
        PS C:\> Install-D365SupportingSoftware -SoftwareName vscode
        
        This will install the VSCode tool
        
    .NOTES
        Author: Dag Calafell (@dodiggitydag)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Install-D365SupportingSoftware {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $SoftwareName = $Script:SoftwareName
    )

    BEGIN {
        try {
            if(Test-Path -Path "$env:ProgramData\Chocolatey") {
                choco upgrade chocolatey -y -r
                choco upgrade all --ignore-checksums -y -r
            }
            else {
                Write-PSFMessage -Level InternalComment -Message "Installing Chocolatey"
            
                # Download and execute installation script
                [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
                Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
            }
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while installing or updating Chocolatey" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    
    PROCESS {
        if(Test-PSFFunctionInterrupt) {return}

        try {
            Write-PSFMessage -Level InternalComment -Message "Installing $SoftwareName"

            #Determine choco executable location
            #   This is needed because the path variable is not updated in this session yet
            #   This part is copied from https://chocolatey.org/install.ps1
            $chocoPath = [Environment]::GetEnvironmentVariable("ChocolateyInstall")
            if ($chocoPath -eq $null -or $chocoPath -eq '') {
                $chocoPath = "$env:ALLUSERSPROFILE\Chocolatey"
            }
            if (!(Test-Path ($chocoPath))) {
                $chocoPath = "$env:SYSTEMDRIVE\ProgramData\Chocolatey"
            }
            $chocoExePath = Join-Path $chocoPath 'bin\choco.exe'

            if (-not (Test-PathExists -Path $chocoExePath)) { return }

            $params = @(
                "install $SoftwareName",
                "-y",
                "-r",
            )

            # Use Chocolatey to install the package
            Invoke-Process -Executable $chocoExePath -Params $params
        }
        catch {
            Write-PSFMessage -Level Host -Message "Something went wrong while installing software" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    
    END {
    }
}