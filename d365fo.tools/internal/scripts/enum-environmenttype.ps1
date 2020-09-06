Add-Type @'
public enum EnvironmentType {
    Unknown,
    LocalHostedTier1,
    AzureHostedTier1,
    MSHostedTier1,
    MSHostedTier2
}
'@

Add-Type @'
public enum ServerRole {
    Unknown,
    Development,
    Demo,
    Build,
    AOS,
    BI
}
'@


Add-Type @'
public enum LcsAssetFileType {
    Model = 1,
    ProcessDataPackage = 4,
    SoftwareDeployablePackage = 10,
    GERConfiguration = 12,
    DataPackage = 15,
    PowerBIReportModel = 19
}
'@