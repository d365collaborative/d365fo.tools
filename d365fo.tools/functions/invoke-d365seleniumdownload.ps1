
<#
    .SYNOPSIS
        Downloads the Selenium web driver files and deploys them to the specified destinations.
        
    .DESCRIPTION
        Downloads the Selenium web driver files and deploys them to the specified destinations.
        
    .PARAMETER RegressionSuiteAutomationTool
        Switch to specify if the Selenium files need to be installed in the Regression Suite Automation Tool folder.
        
    .PARAMETER PerfSDK
        Switch to specify if the Selenium files need to be installed in the PerfSDK folder.
        
    .EXAMPLE
        PS C:\> Invoke-D365SeleniumDownload -RegressionSuiteAutomationTool -PerfSDK
        
        This will download the Selenium zip archives and extract the files into both the Regression Suite Automation Tool folder and the PerfSDK folder.
        
    .NOTES
        Author: Kenny Saelen (@kennysaelen)
        
#>
  function Invoke-D365SeleniumDownload
  {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [switch]$RegressionSuiteAutomationTool,
        [Parameter(Mandatory = $false, Position = 1)]
        [switch]$PerfSDK
    )

    if(!$RegressionSuiteAutomationTool -and !$PerfSDK)
    {
        Write-PSFMessage -Level Critical -Message "Either the -RegressionSuiteAutomationTool or the -PerfSDK switch needs to be specified."
        Stop-PSFFunction -Message "Stopping because of no switch parameters speficied."
        return
    }
    
    $seleniumDllZipLocalPath = (Join-Path $env:TEMP "selenium-dotnet-strongnamed-2.42.0.zip")
    $ieDriverZipLocalPath = (Join-Path $env:TEMP "IEDriverServer_Win32_2.42.0.zip")
    $zipExtractionPath = (Join-Path $env:TEMP "D365Seleniumextraction")
    
    try
    {
        Write-PSFMessage -Level Host -Message "Downloading Selenium files"
        
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile("http://selenium-release.storage.googleapis.com/2.42/selenium-dotnet-strongnamed-2.42.0.zip", $seleniumDllZipLocalPath)
        $WebClient.DownloadFile("http://selenium-release.storage.googleapis.com/2.42/IEDriverServer_Win32_2.42.0.zip", $ieDriverZipLocalPath)

        Write-PSFMessage -Level Host -Message "Extracting zip files"
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($seleniumDllZipLocalPath, $zipExtractionPath)
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ieDriverZipLocalPath, $zipExtractionPath)

        $targetPath = [String]::Empty
        $seleniumPath = [String]::Empty

        if($RegressionSuiteAutomationTool)
        {
            Write-PSFMessage -Level Host -Message "Making Selenium folder structure in the Regression Suite Automation Tool folder"
            $targetPath = Join-Path ([Environment]::GetEnvironmentVariable("ProgramFiles(x86)")) "Regression Suite Automation Tool"
            $seleniumPath = Join-Path $targetPath "Common\External\Selenium"

            # Check if the Regression Suite Automation Tool is installed on the machine and Selenium not already installed
            if (Test-PathExists -Path $targetPath -Type Container)
            {
                if(-not(Test-PathExists -Path $seleniumPath -Type Container -Create))
                {
                    Write-PSFMessage -Level Critical -Message [String]::Format("The folder for the Selenium files could not be created: {0}", $seleniumPath)
                }

                Write-PSFMessage -Level Host -Message "Copying Selenium files to destination folder"
                Copy-Item (Join-Path $zipExtractionPath "IEDriverServer.exe") $seleniumPath
                Copy-Item (Join-Path $zipExtractionPath "net40\*") $seleniumPath
                Write-PSFMessage -Level Host -Message ([String]::Format("Selenium files have been downloaded and installed in the following folder: {0}", $seleniumPath))
            }
            else
            {
                Write-PSFMessage -Level Warning -Message [String]::Format("The RegressionSuiteAutomationTool switch parameter is specified but the tool could not be located in the following folder: {0}", $targetPath)
            }
        }
        
        if($PerfSDK)
        {
            Write-PSFMessage -Level Host -Message "Making Selenium folder structure in the PerfSDK folder"
            $targetPath = [Environment]::GetEnvironmentVariable("PerfSDK")
            $seleniumPath = Join-Path $targetPath "Common\External\Selenium"

            # Check if the PerfSDK is installed on the machine and Selenium not already installed
            if (Test-PathExists -Path $targetPath -Type Container)
            {
                if(-not(Test-PathExists -Path $seleniumPath -Type Container -Create))
                {
                    Write-PSFMessage -Level Critical -Message [String]::Format("The folder for the Selenium files could not be created: {0}", $seleniumPath)
                }

                Write-PSFMessage -Level Host -Message "Copying Selenium files to destination folder"
                Copy-Item (Join-Path $zipExtractionPath "IEDriverServer.exe") $seleniumPath
                Copy-Item (Join-Path $zipExtractionPath "net40\*") $seleniumPath
                Write-PSFMessage -Level Host -Message ([String]::Format("Selenium files have been downloaded and installed in the following folder: {0}", $seleniumPath))
            }
            else
            {
                Write-PSFMessage -Level Warning -Message [String]::Format("The PerfSDK switch parameter is specified but the tool could not be located in the following folder: {0}", $targetPath)
            }
        }
    }
    catch
    {
        Write-PSFMessage -Level Host -Message "Something went wrong while downloading and installing the Selenium files." -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
    finally
    {
        Write-PSFMessage -Level Host -Message "Cleaning up temporary files"
        Remove-Item -Path $seleniumDllZipLocalPath -Recurse
        Remove-Item -Path $ieDriverZipLocalPath -Recurse
        Remove-Item -Path $zipExtractionPath -Recurse
    }
}