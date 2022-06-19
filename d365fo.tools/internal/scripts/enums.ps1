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
    ProcessDataPackage = 4
    SoftwareDeployablePackage = 10
    GERConfiguration = 12
    DataPackage = 15
    PowerBIReportModel = 19
    ECommercePackage = 26
    NuGetPackage = 27
    RetailSelfServicePackage = 28
    CommerceCloudScaleUnitExtension = 29
}