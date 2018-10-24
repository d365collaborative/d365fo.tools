$Script:TimeSignals = @{}

Write-PSFMessage -Level Verbose -Message "Gathering all variables to assist the different cmdlets to function"

$Script:IsAdminRuntime = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$Script:WebConfig = "web.config"

$Script:WifServicesConfig = "wif.services.config"

$Script:Hosts = 'C:\Windows\System32\drivers\etc\hosts'

$Script:DefaultAOSName = 'usnconeboxax1aos'

$Script:IISHostFile = 'C:\Windows\System32\inetsrv\Config\applicationHost.config'

$Script:MRConfigFile = 'C:\FinancialReporting\Server\ApplicationService\bin\MRServiceHost.settings.config'

$Script:SqlPackage = 'C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'

$environment = Get-ApplicationEnvironment

$Script:AOSPath = $environment.Aos.AppRoot

$dataAccess = $environment.DataAccess

$Script:DatabaseServer = $dataAccess.DbServer

$Script:DatabaseName = $dataAccess.Database

$Script:BinDir = $environment.Common.BinDir

$Script:PackageDirectory = $environment.Aos.PackageDirectory

$Script:MetaDataDir = $environment.Aos.MetadataDirectory

$Script:BinDirTools = $environment.Common.DevToolsBinDir

$Script:ServerRole = [ServerRole]::Unknown
$RoleVaule = $(If ($environment.Monitoring.MARole -eq "" -or $environment.Monitoring.MARole -eq "dev") {"Development"} Else {$environment.Monitoring.MARole})

if ($null -ne $RoleVaule) {
    $Script:ServerRole = [ServerRole][Enum]::Parse([type]"ServerRole", $RoleVaule, $true);
}

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

$Script:IsOnebox = $environment.Common.IsOneboxEnvironment

$RegSplat = @{
    Path = "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\"
    Name = "InstallationInfoDirectory"
}

$RegValue = $( if (Test-RegistryValue @RegSplat) {Join-Path (Get-ItemPropertyValue @RegSplat) "InstallationRecords"} else {""} )
$Script:InstallationRecordsDir = $RegValue

$Script:UserIsAdmin = $env:UserName -like "*admin*"

if ($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account")) {
    $azure = Get-PSFConfigValue -FullName "d365fo.tools.active.azure.storage.account"
    $Script:AccountId = $azure.AccountId
    $Script:AccessToken = $azure.AccessToken
    $Script:Blobname = $azure.Blobname
}

$Script:TfDir = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\"

if($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.environment")) {
    $Script:TfsUri = (Get-PSFConfigValue -FullName "d365fo.tools.active.environment").TfsUri
}

if($null -ne (Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app")) {
    $logicApp = Get-PSFConfigValue -FullName "d365fo.tools.active.logic.app"
    $Script:LogicAppEmail = $logicApp.Email
    $Script:LogicAppSubject = $logicApp.Subject
    $Script:LogicAppUrl = $logicApp.Url
}

$Script:SQLTools = "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn"

$maskOutput = @(
"AccessToken"
)

foreach ($item in (Get-Variable -Scope Script)) {
    $val = $null

    if($maskOutput -contains $($item.Name)) {
        $val = "The variable was found - but the content masked while outputting."
    } else {
        $val = $($item.Value)
    }
    
    Write-PSFMessage -Level Verbose -Message "$($item.Name) - $val" -Target $val
}

Write-PSFMessage -Level Verbose -Message "Finished outputting all the variable content."