<#
.SYNOPSIS
Rename as D365FO Demo/Dev box

.DESCRIPTION
The Rename function, changes the config values used by a D365FO dev box for identifying its name. Standard it is called 'usnconeboxax1aos'

.PARAMETER NewName
The new name wanted for the D365FO instance

.PARAMETER AosServiceWebRootPath
Path to the webroot folder for the AOS service 'Default value : C:\AOSService\Webroot

.PARAMETER IISServerApplicationHostConfigFile
Path to the IISService Application host file, [Where the binding configurations is stored] 'Default value : C:\Windows\System32\inetsrv\Config\applicationHost.config'

.PARAMETER HostsFile
Place of the host file on the current system [Local DNS record] ' Default value C:\Windows\System32\drivers\etc\hosts'

.PARAMETER BackupExtension
Backup name for all the files that are changed

.PARAMETER MRConfigFile
Parameter description

.EXAMPLE
Rename-D365Instance -NewName 'Demo1'

.NOTES
The function restarts the IIS Service.

Elevated privileges are required
#>

function Rename-D365Instance {
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$NewName,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$AosServiceWebRootPath = $Script:AOSPath,

        [Parameter(Mandatory = $false, Position = 3)]
        [string]$IISServerApplicationHostConfigFile = $Script:IISHostFile,

        [Parameter(Mandatory = $false, Position = 4)]
        [string]$HostsFile = $Script:Hosts,

        [Parameter(Mandatory = $false, Position = 5)]
        [string]$BackupExtension,

        [Parameter(Mandatory = $false, Position = 6)]
        [string]$MRConfigFile = $Script:MRConfigFile

    )

    Write-Verbose "Testing elevated runtime"

    if (!$Script:IsAdminRuntime) {
        Write-Host "The cmdlet needs administrator permission (Run As Administrator) to be able to update the configuration. Please start an elevated session and run the cmdlet again." -ForegroundColor Yellow
        Write-Error "Elevated permissions needed. Please start an elevated session and run the cmdlet again." -ErrorAction Stop
    }

    $OldName = Get-D365InstanceName

    Write-Verbose "Renaming from $OldName"

    # Variables
    $replaceValue = $OldName
    $NewNameDot = "$NewName."
    $replaceValueDot = "$replaceValue."



    $WebConfigFile = join-Path -path $AosServiceWebRootPath $Script:WebConfig
    $WifServicesFile = Join-Path -Path $AosServiceWebRootPath $Script:WifServicesConfig

    Write-Verbose "Testing files"
    Write-Verbose "WebConfig $WebConfigFile"
    Write-Verbose "WifServices $WifServicesFile"
    Write-Verbose "IISBindings $IISServerApplicationHostConfigFile"
    Write-Verbose "Management Reporter $MRConfigFile"

    #Test files
    if ( (Test-Path $WebConfigFile) -eq $false) {throw [System.IO.FileNotFoundException] "$WebConfigFile not found."}
    if ( (Test-Path $WifServicesFile) -eq $false) { throw [System.IO.FileNotFoundException] "$WifServicesFile not found." }
    if ( (Test-Path $IISServerApplicationHostConfigFile) -eq $false) { throw [System.IO.FileNotFoundException] "$IISServerApplicationHostConfigFile not found." }
    if ( (Test-Path $HostsFile) -eq $false) { throw [System.IO.FileNotFoundException] "$HostsFile not found." }
    if ( (Test-Path $MRConfigFile) -eq $false) { throw [System.IO.FileNotFoundException] "$MRConfigFile not found." }

    #IIS stop required before file changes
    iisreset /stop

    write-verbose "BackupExtension set to $BackupExtension"

    if ($BackupExtension -eq '') {
        Write-Verbose "Settings default backup extension"
        $BackupExtension = "bak"
    }

    write-verbose "BackupExtension set to $BackupExtension"
    # Backup files
    if ($null -ne $BackupExtension -and $BackupExtension -ne '') {
        Write-Verbose "Backing up files"
        Backup-File $WebConfigFile $BackupExtension
        Backup-File $WifServicesFile $BackupExtension
        Backup-File $IISServerApplicationHostConfigFile $BackupExtension
        Backup-File $HostsFile $BackupExtension
        Backup-File $MRConfigFile $BackupExtension
    }

    # WebConfig - D365 web config file
    Rename-ConfigValue $WebConfigFile $NewName $replaceValue
    # Wif.Services - D365 web config file (services)
    Rename-ConfigValue $WifServicesFile $NewName $replaceValue
    #ApplicationHost - IIS Bindings
    Rename-ConfigValue $IISServerApplicationHostConfigFile $NewNameDot $replaceValueDot
    #Hosts file - local DNS cache
    Rename-ConfigValue $HostsFile $NewNameDot $replaceValueDot
    #Management Reporter
    Rename-ConfigValue $MRConfigFile $NewName $replaceValue

    #Start IIS again
    iisreset /start

    (Get-D365EnvironmentSettings).Infrastructure.FullyQualifiedDomainName
}


