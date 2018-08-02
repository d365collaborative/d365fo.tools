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

    if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsPowerShell\PSFramework\System" -Name "DoDotSource" -ErrorAction Ignore).DoDotSource) { $script:doDotSource = $true }
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
$Script:IsAdminRuntime = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$Script:AOSPath = [System.Environment]::ExpandEnvironmentVariables("%ServiceDrive%") + "\AOSService\webroot"

$Script:WebConfig = "web.config"
$Script:WifServicesConfig = "wif.services.config"
$Script:Hosts = 'C:\Windows\System32\drivers\etc\hosts'
$Script:DefaultAOSName = 'usnconeboxax1aos'
$Script:IISHostFile = 'C:\Windows\System32\inetsrv\Config\applicationHost.config'
$Script:MRConfigFile = 'C:\FinancialReporting\Server\ApplicationService\bin\MRServiceHost.settings.config'
$Script:SqlPackage = 'C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe'

$environment = Get-ApplicationEnvironment
$dataAccess = $environment.DataAccess

$Script:DatabaseServer = $dataAccess.DbServer
$Script:DatabaseName = $dataAccess.Database
$Script:DatabaseUserName = $dataAccess.SqlUser
$Script:DatabaseUserPassword = $dataAccess.SqlPwd


$Script:BinDir = $environment.Common.BinDir
$Script:PackageDirectory = $environment.Aos.PackageDirectory
$Script:MetaDataDir = $environment.Aos.MetadataDirectory

$FQDN = $environment.Infrastructure.FullyQualifiedDomainName
$Script:Url = "https://$FQDN"