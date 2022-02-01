enum EnvironmentType {
    Unknown
    LocalHostedTier1
    AzureHostedTier1
    MSHostedTier1
    MSHostedTier2
}

enum ServerRole {
    Unknown
    Development
    Demo
    Build
    AOS
    BI
}

enum LcsAssetFileType {
    Model = 1
    BPMArtifact = 2
    ProcessDataPackage = 4
    SoftwareDeployablePackage = 10
    GERConfiguration = 12
    DataPackage = 15
    DatabaseBackup = 17
    PowerBIReportModel = 19
    DownloadableVDH = 24
    ECommercePackage = 26
    NuGetPackage = 27
    RetailSelfServicePackage = 28
    CommerceCloudScaleUnitExtension = 29
}