$Script:TimeSignals = @{ }

Write-PSFMessage -Level Verbose -Message "Gathering all variables to assist the different cmdlets to function"

$serviceDrive = ($env:ServiceDrive) -replace " ", ""

# When a local Tier1 machine is domain joined, the domain users will not have the %ServiceDrive% environment variable
if ([system.string]::IsNullOrEmpty($serviceDrive)) {
    $serviceDrive = "c:"

    Write-PSFMessage -Level Host -Message "Unable to locate the %ServiceDrive% environment variable. It could indicate that the machine is either not configured with D365FO or that you have domain joined a local Tier1. We have defaulted to <c='em'>c:\</c>"
    Write-PSFMessage -Level Host -Message "This message will show every time you load the module. If you want to silence this message, please add the ServiceDrive environment variable by executing this command (remember to restart the console afterwards):"
    Write-PSFHostColor -String '<c="em">[Environment]::SetEnvironmentVariable("ServiceDrive", "C:", "Machine")</c>'
}

$script:ServiceDrive = $serviceDrive

$Script:IsAdminRuntime = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

$Script:WebConfig = "web.config"

$Script:DevConfig = "DynamicsDevConfig.xml"

$Script:WifServicesConfig = "wif.services.config"

$Script:Hosts = 'C:\Windows\System32\drivers\etc\hosts'

$Script:DefaultAOSName = 'usnconeboxax1aos'

$Script:IISHostFile = 'C:\Windows\System32\inetsrv\Config\applicationHost.config'

$Script:MRConfigFile = 'C:\FinancialReporting\Server\ApplicationService\bin\MRServiceHost.settings.config'

#Update all module variables
Update-ModuleVariables

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
$RoleVaule = $(If ($environment.Monitoring.MARole -eq "" -or $environment.Monitoring.MARole -eq "dev") { "Development" } Else { $environment.Monitoring.MARole })

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

$Script:Url = $environment.Infrastructure.HostUrl
$Script:DatabaseUserName = $dataAccess.SqlUser
$Script:DatabaseUserPassword = $dataAccess.SqlPwd
$Script:Company = "DAT"

$Script:IsOnebox = $environment.Common.IsOneboxEnvironment

$RegSplat = @{
    Path = "HKLM:\SOFTWARE\Microsoft\Dynamics\Deployment\"
    Name = "InstallationInfoDirectory"
}

$RegValue = $( if (Test-RegistryValue @RegSplat) { Join-Path (Get-ItemPropertyValue @RegSplat) "InstallationRecords" } else { "" } )
$Script:InstallationRecordsDir = $RegValue

$Script:UserIsAdmin = $env:UserName -like "*admin*"

$Script:TfDir = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\"

$Script:SQLTools = "C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn"

$Script:SSRSTools = "C:\Program Files\Microsoft SQL Server Reporting Services\Shared Tools"

$Script:DefaultTempPath = "c:\temp\d365fo.tools"

foreach ($item in (Get-PSFConfig -FullName d365fo.tools.active*)) {
    $nameTemp = $item.FullName -replace "^d365fo.tools.", ""
    $name = ($nameTemp -Split "\." | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) } ) -Join ""
    
    New-Variable -Name $name -Value $item.Value -Scope Script
}

#Active LCS Upload config extraction
Update-LcsApiVariables

$maskOutput = @(
    "AccessToken",
    "AzureStorageAccessToken",
    "Token",
    "BearerToken",
    "Password",
    "RefreshToken",
    "SAS"
    "AzureStorageSAS"
)

#Active broadcast message config extraction
Update-BroadcastVariables

#Update different PSF Configuration variables values
Update-PsfConfigVariables

#Active Azure Storage Configuration variables values
Update-AzureStorageVariables

(Get-Variable -Scope Script) | ForEach-Object {
    $val = $null

    if ($maskOutput -contains $($_.Name)) {
        $val = "The variable was found - [...REDACTED...]"
    }
    else {
        $val = $($_.Value)
    }
   
    Write-PSFMessage -Level Verbose -Message "$($_.Name) - $val" -Target $val -FunctionName "Variables.ps1"
}

Write-PSFMessage -Level Verbose -Message "Finished outputting all the variable content."