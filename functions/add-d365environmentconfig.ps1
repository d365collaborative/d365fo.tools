<#
.SYNOPSIS
Save an environment config

.DESCRIPTION
Adds an environment config to the configuration store

.PARAMETER Name
The logical name of the environment you are about to registered in the configuration

.PARAMETER URL
The URL to the environment you want the module to use when possible

.PARAMETER SqlUser
The login name for the SQL Server instance

.PARAMETER SqlPwd
The password for the SQL Server user

.PARAMETER Company 
The company you want to work against when calling any browser based cmdlets

The default value is "DAT"

.PARAMETER Force
Switch to instruct the cmdlet to overwrite already registered environment entry

.EXAMPLE
Add-D365EnvironmentConfig -Name "Customer-UAT" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF" -Company "DAT"

This will add an entry into the list of environments that is stored with the name "Customer-UAT" 
and with the URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF".
The company is registered "DAT".

.EXAMPLE
Add-D365EnvironmentConfig -Name "Customer-UAT" -URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF" -Company "DAT" -SqlUser "SqlAdmin" -SqlPwd "Pass@word1"

This will add an entry into the list of environments that is stored with the name "Customer-UAT" 
and with the URL "https://usnconeboxax1aos.cloud.onebox.dynamics.com/?cmp=USMF".
It will register the SqlUser as "SqlAdmin" and the SqlPassword to "Pass@word1".

This it useful for working on Tier 2 environments where the SqlUser and SqlPassword cannot be
extracted from the environment itself.

.NOTES

You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.

#>
function Add-D365EnvironmentConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $URL,

        [string] $SqlUser = "sqladmin",

        [string] $SqlPwd,      

        [string] $Company = "DAT",

        [switch] $Force
    )

    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $Details = @{URL = $URL; Company = $Company;
            SqlUser = $SqlUser; SqlPwd = $SqlPwd;           
        }

        $Environments = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.environments")

        if($null -eq $Environments) {$Environments = @{}}
        
        if ($Environments.ContainsKey($Name)) {
            if ($Force.IsPresent) {
                $Environments[$Name] = $Details

                Set-PSFConfig -FullName "d365fo.tools.environments" -Value $Environments   
                Get-PSFConfig -FullName "d365fo.tools.environments" | Register-PSFConfig
            }
            else {
                Write-PSFMessage -Level Host -Message "An environment with that name <c='em'>already exists</c>. You want to <c='em'>overwrite</c> the already registered details please supply the <c='em'>-Force</c> parameter."
                Stop-PSFFunction -Message "Stopping because an environment already exists with that name."
                return
            }
        }
        else {
            $null = $Environments.Add($Name, $Details)

            Set-PSFConfig -FullName "d365fo.tools.environments" -Value $Environments   
            Get-PSFConfig -FullName "d365fo.tools.environments" | Register-PSFConfig
        }
    }
}