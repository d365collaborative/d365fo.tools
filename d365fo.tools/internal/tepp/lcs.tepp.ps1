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
Register-PSFTeppScriptblock -Name "d365fo.tools.lcs.options" -ScriptBlock { enum LcsAssetFileType {
    Model = 1
    ProcessDataPackage = 4
    SoftwareDeployablePackage = 10
    GERConfiguration = 12
    DataPackage = 15
    PowerBIReportModel = 19
}; [LcsAssetFileType]::Model, [LcsAssetFileType]::ProcessDataPackage, [LcsAssetFileType]::SoftwareDeployablePackage, [LcsAssetFileType]::GERConfiguration, [LcsAssetFileType]::DataPackage, [LcsAssetFileType]::PowerBIReportModel }


<#
[ValidateSet("https://lcsapi.lcs.dynamics.com", "https://lcsapi.eu.lcs.dynamics.com")]
#>
Register-PSFTeppScriptblock -Name "d365fo.tools.lcs.api.urls" -ScriptBlock { 'https://lcsapi.lcs.dynamics.com', 'https://lcsapi.eu.lcs.dynamics.com' }