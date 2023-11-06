
<#
    .SYNOPSIS
        Set different RSAT configuration values
        
    .DESCRIPTION
        Update different RSAT configuration values while using the tool
        
    .PARAMETER LogGenerationEnabled
        Will set the LogGeneration property
        
        $true will make RSAT start generating logs
        $false will stop RSAT from generating logs
        
    .PARAMETER VerboseSnapshotsEnabled
        Will set the VerboseSnapshotsEnabled property
        
        $true will make RSAT start generating snapshots and store related details
        $false will stop RSAT from generating snapshots and store related details
        
    .PARAMETER AddOperatorFieldsToExcelValidationEnabled
        Will set the AddOperatorFieldsToExcelValidation property
        
        $true will make RSAT start adding the operation options in the excel parameter file
        $false will stop RSAT from adding the operation options in the excel parameter file

    .PARAMETER RSATConfigFilename
        Specifies the file name of the RSAT configuration file. Default is 'Microsoft.Dynamics.RegressionSuite.WpfApp.exe.config'
        If you are using an older version of RSAT, you might need to change this to 'Microsoft.Dynamics.RegressionSuite.WindowsApp.exe.config'
        
    .EXAMPLE
        PS C:\> Set-D365RsatConfiguration -LogGenerationEnabled $true
        
        This will enable the log generation logic of RSAT.
        
    .EXAMPLE
        PS C:\> Set-D365RsatConfiguration -VerboseSnapshotsEnabled $true
        
        This will enable the snapshot generation logic of RSAT.
        
    .EXAMPLE
        PS C:\> Set-D365RsatConfiguration -AddOperatorFieldsToExcelValidationEnabled $true
        
        This will enable the operator generation logic of RSAT.
        
    .NOTES
        Tags: RSAT, Testing, Regression Suite Automation Test, Regression, Test, Automation, Configuration
        
        Author: Mötz Jensen (@Splaxi)
#>

function Set-D365RsatConfiguration {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false)]
        [bool] $LogGenerationEnabled,

        [Parameter(Mandatory = $false)]
        [bool] $VerboseSnapshotsEnabled,

        [Parameter(Mandatory = $false)]
        [bool] $AddOperatorFieldsToExcelValidationEnabled,

        [Parameter(Mandatory = $false)]
        $RSATConfigFilename = "Microsoft.Dynamics.RegressionSuite.WpfApp.exe.config"
    )

    $configPath = Join-Path $Script:RsatPath $RSATConfigFilename

    if (-not (Test-PathExists -Path $configPath -Type Leaf)) {
        Write-PSFMessage -Level Critical -Message "The '$RSATConfigFilename' file could not be found on the system."
        Stop-PSFFunction -Message  "Stopping because the '$RSATConfigFilename' file could not be located."
        return
    }

    try {
        [xml]$xmlConfig = Get-Content $configPath

        if ($PSBoundParameters.Keys -contains "LogGenerationEnabled") {
            $logGenerationAttribute = $xmlConfig.SelectNodes('//appSettings//add[@key="LogGeneration"]')
            if ($logGenerationAttribute) {
                $logGenerationAttribute.SetAttribute('value', $LogGenerationEnabled.ToString().ToLower())
            }
        }

        if ($PSBoundParameters.Keys -contains "VerboseSnapshotsEnabled") {
            $verboseSnapshotsAttribute = $xmlConfig.SelectNodes('//appSettings//add[@key="VerboseSnapshotsEnabled"]')
            if ($verboseSnapshotsAttribute) {
                $verboseSnapshotsAttribute.SetAttribute('value', $VerboseSnapshotsEnabled.ToString().ToLower())
            }
        }

        if ($PSBoundParameters.Keys -contains "AddOperatorFieldsToExcelValidationEnabled") {
            $addOperatorFieldsToExcelValidationAttribute = $xmlConfig.SelectNodes('//appSettings//add[@key="AddOperatorFieldsToExcelValidation"]')
            if ($addOperatorFieldsToExcelValidationAttribute) {
                $addOperatorFieldsToExcelValidationAttribute.SetAttribute('value', $AddOperatorFieldsToExcelValidationEnabled.ToString().ToLower())
            }
        }

        $xmlConfig.Save($configPath)
    }
    catch {
        Write-PSFMessage -Level Host -Message "Something went wrong while updating the RSAT configuration file" -Exception $PSItem.Exception
        Stop-PSFFunction -Message "Stopping because of errors"
        return
    }
}