<#
"options": {
    "1": "Model",
    "4": "Process Data Package",
    "10": "Software Deployable Package",
    "12": "GER Configuration",
    "15": "Data Package",
    "19": "PowerBI Report Model"
}
#>
Register-PSFTeppScriptblock -Name "d365fo.tools.lcs.options" -ScriptBlock { [LcsAssetFileType]::Model, [LcsAssetFileType]::ProcessDataPackage, [LcsAssetFileType]::SoftwareDeployablePackage, [LcsAssetFileType]::GERConfiguration, [LcsAssetFileType]::DataPackage, [LcsAssetFileType]::PowerBIReportModel, [LcsAssetFileType]::ECommercePackage, [LcsAssetFileType]::NuGetPackage, [LcsAssetFileType]::RetailSelfServicePackage, [LcsAssetFileType]::CommerceCloudScaleUnitExtension }


<#
[ValidateSet("https://lcsapi.lcs.dynamics.com", "https://lcsapi.eu.lcs.dynamics.com")]
#>
Register-PSFTeppScriptblock -Name "d365fo.tools.lcs.api.urls" -ScriptBlock { 'https://lcsapi.lcs.dynamics.com', 'https://lcsapi.eu.lcs.dynamics.com', 'https://lcsapi.fr.lcs.dynamics.com', 'https://lcsapi.sa.lcs.dynamics.com', 'https://lcsapi.uae.lcs.dynamics.com', 'https://lcsapi.ch.lcs.dynamics.com', 'https://lcsapi.no.lcs.dynamics.com', 'https://lcsapi.lcs.dynamics.cn', 'https://lcsapi.gov.lcs.microsoftdynamics.us' }

