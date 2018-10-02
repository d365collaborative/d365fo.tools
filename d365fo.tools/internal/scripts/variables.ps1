$Script:TimeSignals = @{}

Write-PSFMessage -Level Verbose -Message "Gathering all variables to assist the different cmdlets to function"

$Script:IsAdminRuntime = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Write-PSFMessage -Level Verbose -Message "`$Script:IsAdminRuntime: $Script:IsAdminRuntime"

$Script:WebConfig = "web.config"
Write-PSFMessage -Level Verbose -Message "`$Script:WebConfig: $Script:WebConfig"

$Script:WifServicesConfig = "wif.services.config"
Write-PSFMessage -Level Verbose -Message "`$Script:WifServicesConfig: $Script:WifServicesConfig"

$Script:Hosts = 'C:\Windows\System32\drivers\etc\hosts'
Write-PSFMessage -Level Verbose -Message "`$Script:Hosts: $Script:Hosts"

$Script:DefaultAOSName = 'usnconeboxax1aos'
Write-PSFMessage -Level Verbose -Message "`$Script:DefaultAOSName: $Script:DefaultAOSName"

$Script:IISHostFile = 'C:\Windows\System32\inetsrv\Config\applicationHost.config'
Write-PSFMessage -Level Verbose -Message "`$Script:IISHostFile: $Script:IISHostFile"

$Script:MRConfigFile = 'C:\FinancialReporting\Server\ApplicationService\bin\MRServiceHost.settings.config'
Write-PSFMessage -Level Verbose -Message "`$Script:MRConfigFile: $Script:MRConfigFile"

$Script:SqlPackage = 'C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'
Write-PSFMessage -Level Verbose -Message "`$Script:SqlPackage: $Script:SqlPackage"

$environment = Get-ApplicationEnvironment
Write-PSFMessage -Level Verbose -Message "Fetched the D365 environment object" -Target $environment

$Script:AOSPath = $environment.Aos.AppRoot
Write-PSFMessage -Level Verbose -Message "`$Script:AOSPath: $Script:AOSPath"

$dataAccess = $environment.DataAccess
Write-PSFMessage -Level Verbose -Message "Extracting the DataAccess object from the Environment object" -Target $dataAccess

$Script:DatabaseServer = $dataAccess.DbServer
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseServer: $Script:DatabaseServer"

$Script:DatabaseName = $dataAccess.Database
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseName: $Script:DatabaseName"

$Script:BinDir = $environment.Common.BinDir
Write-PSFMessage -Level Verbose -Message "`$Script:BinDir: $Script:BinDir"

$Script:PackageDirectory = $environment.Aos.PackageDirectory
Write-PSFMessage -Level Verbose -Message "`$Script:PackageDirectory: $Script:PackageDirectory"

$Script:MetaDataDir = $environment.Aos.MetadataDirectory
Write-PSFMessage -Level Verbose -Message "`$Script:MetaDataDir: $Script:MetaDataDir"

$Script:BinDirTools = $environment.Common.DevToolsBinDir
Write-PSFMessage -Level Verbose -Message "`$Script:BinDirTools: $Script:BinDirTools"

$Script:ServerRole = [ServerRole]::Unknown
$RoleVaule = $(If ($environment.Monitoring.MARole -eq "" -or $environment.Monitoring.MARole -eq "dev") {"Development"} Else {$environment.Monitoring.MARole})

if ($null -ne $RoleVaule) {
    $Script:ServerRole = [ServerRole][Enum]::Parse([type]"ServerRole", $RoleVaule, $true);
}
Write-PSFMessage -Level Verbose -Message "`$Script:ServerRole: $Script:ServerRole"

$Script:EnvironmentType = [EnvironmentType]::Unknown
$Script:CanUseTrustedConnection = $false
if ($environment.Infrastructure.HostName -like "*cloud.onebox.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::LocalHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -like "*cloudax.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::AzureHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.ax.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier1
    $Script:CanUseTrustedConnection = $true
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.operations.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier2
}
Write-PSFMessage -Level Verbose -Message "`$Script:EnvironmentType: $Script:EnvironmentType"
Write-PSFMessage -Level Verbose -Message "`$Script:CanUseTrustedConnection: $Script:CanUseTrustedConnection"

if (($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")) -and (Get-PSFConfigValue -FullName "d365fo.tools.workstation.mode") -eq $true) {
    Write-PSFMessage -Level Verbose -Message "Workstation mode is enabled. We have an active environment configured. We will load the SqlUser and SqlPwd from that configuration."
    
    $d365env = Get-PSFConfigValue -FullName "d365fo.tools.active.environment"
    $Script:Url = $d365env.URL
    $Script:DatabaseUserName = $d365env.SqlUser
    $Script:DatabaseUserPassword = $d365env.SqlPwd
    $Script:Company = $d365env.Company
}
else {
    $Script:Url = $environment.Infrastructure.HostUrl
    $Script:DatabaseUserName = $dataAccess.SqlUser
    $Script:DatabaseUserPassword = $dataAccess.SqlPwd
    $Script:Company = "DAT"

    if (($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")) -and
        ($Script:EnvironmentType -eq [EnvironmentType]::MSHostedTier2)) {
        Write-PSFMessage -Level Verbose -Message "We are on a Tier 2 MS hosted Environment. We have an active environment configured. We will load the SqlUser and SqlPwd from that configuration."

        $d365db = Get-PSFConfigValue -FullName "d365fo.tools.active.environment"
        $Script:DatabaseUserName = $d365db.SqlUser
        $Script:DatabaseUserPassword = $d365db.SqlPwd
    }
}
Write-PSFMessage -Level Verbose -Message "`$Script:Url: $Script:Url"
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseUserName: $Script:DatabaseUserName"
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseUserPassword: $Script:DatabaseUserPassword"
Write-PSFMessage -Level Verbose -Message "`$Script:Company: $Script:Company"

$Script:IsOnebox = $environment.Common.IsOneboxEnvironment
Write-PSFMessage -Level Verbose -Message "`$Script:IsOnebox: $Script:IsOnebox"

$RegSplat = @{
    Path = "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\"
    Name = "InstallationInfoDirectory"
}

$RegValue = $( if (Test-RegistryValue @RegSplat) {Join-Path (Get-ItemPropertyValue @RegSplat) "InstallationRecords"} else {""} )
$Script:InstallationRecordsDir = $RegValue
Write-PSFMessage -Level Verbose -Message "`$Script:InstallationRecordsDir: $Script:InstallationRecordsDir"

$Script:UserIsAdmin = $env:UserName -like "*admin*"

if ($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account")) {
    $azure = Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account"
    $Script:AccountId = $azure.AccountId
    $Script:AccessToken = $azure.AccessToken
    $Script:Blobname = $azure.Blobname
    Write-PSFMessage -Level Verbose -Message "`$Script:AccountId: Value configured - not shown on purpose."
    Write-PSFMessage -Level Verbose -Message "`$Script:AccessToken: Value configured - not shown on purpose."
    Write-PSFMessage -Level Verbose -Message "`$Script:Blobname: Value configured - not shown on purpose."
}

$Script:TfDir = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\"
Write-PSFMessage -Level Verbose -Message "`$Script:TfDir: $Script:TfDir"

if($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")) {
    $Script:TfsUri = (Get-PSFConfigValue -FullName "d365fo.tools.active.environment").TfsUri
}
Write-PSFMessage -Level Verbose -Message "`$Script:TfsUri: $Script:TfsUri"

if($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app")) {
    $logicApp = Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app"
    $Script:LogicAppEmail = $logicApp.Email
    $Script:LogicAppSubject = $logicApp.Subject
    $Script:LogicAppUrl = $logicApp.Url
}
Write-PSFMessage -Level Verbose -Message "`$Script:LogicAppEmail: $Script:LogicAppEmail"
Write-PSFMessage -Level Verbose -Message "`$Script:LogicAppSubject: $Script:LogicAppSubject"
Write-PSFMessage -Level Verbose -Message "`$Script:LogicAppUrl: $Script:LogicAppUrl"

$Script:SQLTools = "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn"

Write-PSFMessage -Level Verbose -Message "`$Script:SQLTools: $Script:SQLTools"
