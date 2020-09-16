
<#
    .SYNOPSIS
        Save a broadcast message config
        
    .DESCRIPTION
        Adds a broadcast message config to the configuration store
        
    .PARAMETER Name
        The logical name of the broadcast configuration you are about to register in the configuration store
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to send a message to
        
    .PARAMETER URL
        URL / URI for the D365FO environment you want to send a message to
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER TimeZone
        Id of the Time Zone your environment is running in
        
        You might experience that the local VM running the D365FO is running another Time Zone than the computer you are running this cmdlet from
        
        All available .NET Time Zones can be traversed with tab for this parameter
        
        The default value is "UTC"
        
    .PARAMETER EndingInMinutes
        Specify how many minutes into the future you want this message / maintenance window to last
        
        Default value is 60 minutes
        
        The specified StartTime will always be based on local Time Zone. If you specify a different Time Zone than the local computer is running, the start and end time will be calculated based on your selection.
        
    .PARAMETER OnPremise
        Specify if environnement is an D365 OnPremise
        
        Default value is "Not set" (= Cloud Environnement)
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily add the broadcast message configuration in the configuration store
        
    .PARAMETER Force
        Instruct the cmdlet to overwrite the broadcast message configuration with the same name
        
    .EXAMPLE
        PS C:\> Add-D365BroadcastMessageConfig -Name "UAT" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will create a new broadcast message configuration with the name "UAT".
        It will save "e674da86-7ee5-40a7-b777-1111111111111" as the Azure Active Directory guid.
        It will save "https://usnconeboxax1aos.cloud.onebox.dynamics.com" as the D365FO environment.
        It will save "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will save "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        It will use the default value "UTC" Time Zone for converting the different time and dates.
        It will use the default end time which is 60 minutes.
        
    .EXAMPLE
        PS C:\> Add-D365BroadcastMessageConfig -Name "UAT" -OnPremise -Tenant "https://adfs.local/adfs" -URL "https://ax-sandbox.d365fo.local" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will create a new broadcast message configuration with the name "UAT".
        It will target an OnPremise environment.
        It will save "https://adfs.local/adfs" as the OAuth Tenant Provider.
        It will save "https://ax-sandbox.d365fo.local" as the D365FO environment.
        It will save "dea8d7a9-1602-4429-b138-111111111111" as the ClientId.
        It will save "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" as ClientSecret.
        It will use the default value "UTC" Time Zone for converting the different time and dates.
        It will use the default end time which is 60 minutes.
        
    .NOTES
        Tags: Servicing, Broadcast, Message, Users, Environment, Config, Configuration, ClientId, ClientSecret
        
        Author: Mötz Jensen (@Splaxi)
        
    .LINK
        Clear-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365ActiveBroadcastMessageConfig
        
    .LINK
        Get-D365BroadcastMessageConfig
        
    .LINK
        Remove-D365BroadcastMessageConfig
        
    .LINK
        Send-D365BroadcastMessage
        
    .LINK
        Set-D365ActiveBroadcastMessageConfig
#>

function Add-D365BroadcastMessageConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Alias('$AADGuid')]
        [string] $Tenant,

        [Alias('URI')]
        [string] $URL,

        [string] $ClientId,

        [string] $ClientSecret,

        [string] $TimeZone = "UTC",

        [int] $EndingInMinutes = 60,

        [switch] $OnPremise,

        [switch] $Temporary,

        [switch] $Force
    )

    if (((Get-PSFConfig -FullName "d365fo.tools.broadcast.*.name").Value -contains $Name) -and (-not $Force)) {
        Write-PSFMessage -Level Host -Message "A broadcast message configuration with <c='em'>$Name</c> as name <c='em'>already exists</c>. If you want to <c='em'>overwrite</c> the current configuration, please supply the <c='em'>-Force</c> parameter."
        Stop-PSFFunction -Message "Stopping because a broadcast message configuration already exists with that name."
        return
    }

    $configName = ""

    #The ':keys' label is used to have a continue inside the switch statement itself
    :keys foreach ($key in $PSBoundParameters.Keys) {
        
        $configurationValue = $PSBoundParameters.Item($key)
        $configurationName = $key.ToLower()
        $fullConfigName = ""

        Write-PSFMessage -Level Verbose -Message "Working on $key with $configurationValue" -Target $configurationValue
        
        switch ($key) {
            "Name" {
                $configName = $Name.ToLower()
                $fullConfigName = "d365fo.tools.broadcast.$configName.name"
            }

            {"Temporary","Force" -contains $_} {
                continue keys
            }

            "TimeZone" {
                $timeZoneFound = Get-TimeZone -InputObject $TimeZone

                if (Test-PSFFunctionInterrupt) { return }
                
                $fullConfigName = "d365fo.tools.broadcast.$configName.$configurationName"
                $configurationValue = $timeZoneFound.Id
            }

            Default {
                $fullConfigName = "d365fo.tools.broadcast.$configName.$configurationName"
            }
        }

        Write-PSFMessage -Level Verbose -Message "Setting $fullConfigName to $configurationValue" -Target $configurationValue
        Set-PSFConfig -FullName $fullConfigName -Value $configurationValue
        if (-not $Temporary) { Register-PSFConfig -FullName $fullConfigName -Scope UserDefault }
    }
}