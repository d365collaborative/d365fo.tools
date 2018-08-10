# Import-Module PSFramework

$script:PSModuleRoot = $PSScriptRoot
function Import-ModuleFile {

    [CmdletBinding()]
    Param (
        [string]
        $Path
    )
    if ($doDotSource) { . $Path }
    else { $ExecutionContext.InvokeCommand.InvokeScript($false, ([ScriptBlock]::Create([io.file]::ReadAllText($Path))), $null, $null) }
}

$script:doDotSource = $false
if ($psframework_dotsourcemodule) { $script:doDotSource = $true }
if (($PSVersionTable.PSVersion.Major -lt 6) -or ($PSVersionTable.OS -like "*Windows*")) {

    if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\System" -Name "DoDotSource" -ErrorAction Ignore).DoDotSource) { $script:doDotSource = $true }
}

# All internal functions privately available within the tool set
foreach ($function in (Get-ChildItem "$script:PSModuleRoot\internal\functions\*.ps1")) {
    . Import-ModuleFile $function.FullName
}

# All public functions available within the tool set
foreach ($function in (Get-ChildItem "$script:PSModuleRoot\functions\*.ps1")) {
    . Import-ModuleFile $function.FullName
}

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

$Script:DatabaseUserName = $dataAccess.SqlUser
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseUserName: $Script:DatabaseUserName"

$Script:DatabaseUserPassword = $dataAccess.SqlPwd
Write-PSFMessage -Level Verbose -Message "`$Script:DatabaseUserPassword: $Script:DatabaseUserPassword"

$Script:BinDir = $environment.Common.BinDir
Write-PSFMessage -Level Verbose -Message "`$Script:BinDir: $Script:BinDir"

$Script:PackageDirectory = $environment.Aos.PackageDirectory
Write-PSFMessage -Level Verbose -Message "`$Script:PackageDirectory: $Script:PackageDirectory"

$Script:MetaDataDir = $environment.Aos.MetadataDirectory
Write-PSFMessage -Level Verbose -Message "`$Script:MetaDataDir: $Script:MetaDataDir"

$Script:BinDirTools = $environment.Common.DevToolsBinDir
Write-PSFMessage -Level Verbose -Message "`$Script:BinDirTools: $Script:BinDirTools"

$Script:Url = $environment.Infrastructure.HostUrl
Write-PSFMessage -Level Verbose -Message "`$Script:Url: $Script:Url"

$Script:ServerRole = [ServerRole]::Unknown
$RoleVaule = $(If ($environment.Monitoring.MARole -eq "" -or $environment.Monitoring.MARole -eq "dev") {"Development"} Else {$environment.Monitoring.MARole})  

if ($null -ne $RoleVaule) {
    $Script:ServerRole = [ServerRole][Enum]::Parse([type]"ServerRole", $RoleVaule, $true);
    Write-PSFMessage -Level Verbose -Message "`$Script:ServerRole: $Script:ServerRole"
}

$Script:EnvironmentType = [EnvironmentType]::Unknown
if ($environment.Infrastructure.HostName -like "*cloud.onebox.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::LocalHostedTier1
}
elseif ($environment.Infrastructure.HostName -like "*cloudax.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::AzureHostedTier1
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.ax.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier1
}
elseif ($environment.Infrastructure.HostName -like "*sandbox.operations.dynamics.com*") {
    $Script:EnvironmentType = [EnvironmentType]::MSHostedTier2
}
Write-PSFMessage -Level Verbose -Message "`$Script:EnvironmentType: $Script:EnvironmentType"

$Script:IsOnebox = $environment.Common.IsOneboxEnvironment
Write-PSFMessage -Level Verbose -Message "`$Script:IsOnebox: $Script:IsOnebox"

$Script:InstallationRecordsDir = Join-Path (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\" -Name "InstallationInfoDirectory") "InstallationRecords"
Write-PSFMessage -Level Verbose -Message "`$Script:InstallationRecordsDir: $Script:InstallationRecordsDir"

$Script:UserIsAdmin = $env:UserName -like "*admin*"