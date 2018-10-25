
<#
    .SYNOPSIS
        Save an Azure Storage Account config
        
    .DESCRIPTION
        Adds an Azure Storage Account config to the configuration store
        
    .PARAMETER Name
        The logical name of the Azure Storage Account you are about to registered in the configuration store
        
    .PARAMETER AccountId
        The account id for the Azure Storage Account you want to register in the configuration store
        
    .PARAMETER AccessToken
        The access token for the Azure Storage Account you want to register in the configuration store
        
    .PARAMETER Blobname
        The name of the blob inside the Azure Storage Account you want to register in the configuration store
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects

        The default value is "User" and this will store all configuration for the active user

        Valid options are:
        "User"
        "System"

        "System" will store the configuration so all users can access the configuration objects

    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite already registered Azure Storage Account entry
        
    .EXAMPLE
        PS C:\> Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Blob "testblob"
        
        This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", AccessToken "dafdfasdfasdf" and Blob "testblob".
        
    .EXAMPLE
        PS C:\> Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Blob "testblob" -ConfigStorageLocation "System"

        This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", AccessToken "dafdfasdfasdf" and Blob "testblob".
        All configuration objects will be persisted in the system wide configuration store.
        This will enable all users to access the configuration objects and their values.
        
    .NOTES
        
        You will have to run the Initialize-D365Config cmdlet first, before this will be capable of working.
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Add-D365AzureStorageConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $AccountId,

        [Parameter(Mandatory = $true)]
        [string] $AccessToken,

        [Parameter(Mandatory = $true)]
        [Alias('Blob')]
        [string] $Blobname,

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",

        [switch] $Force
    )


    $configScope = "UserDefault"

    if ($ConfigStorageLocation -eq "System") {
        if ($Script:IsAdminRuntime) {
            $configScope = "SystemDefault"
        }
        else {
            Write-PSFMessage -Level Host -Message "Unable to locate save the <c='em'>configuration objects</c> in the <c='em'>system wide configuration store</c> on the machine. Please start an elevated session and run the cmdlet again."
            Stop-PSFFunction -Message "Elevated permissions needed. Please start an elevated session and run the cmdlet again."
        }
    }

    if ((Get-PSFConfig -FullName "d365fo.tools*").Count -eq 0) {
        Write-PSFMessage -Level Host -Message "Unable to locate the <c='em'>configuration objects</c> on the machine. Please make sure that you ran <c='em'>Initialize-D365Config</c> first."
        Stop-PSFFunction -Message "Stopping because unable to locate configuration objects."
        return
    }
    else {
        $Details = @{AccountId = $AccountId; AccessToken = $AccessToken;
            Blobname = $Blobname;
        }

        $Accounts = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")

        if (($null -eq $Accounts) -or ($Accounts.ContainsKey("Dummy"))) {$Accounts = @{}
        }
        
        if ($Accounts.ContainsKey($Name)) {
            if ($Force.IsPresent) {
                $Accounts[$Name] = $Details

                Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value $Accounts
                Get-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" | Register-PSFConfig
            }
            else {
                Write-PSFMessage -Level Host -Message "An Azure Storage Account with that name <c='em'>already exists</c>. If you want to <c='em'>overwrite</c> the already registered details please supply the <c='em'>-Force</c> parameter."
                Stop-PSFFunction -Message "Stopping because an Azure Storage Account already exists with that name."
                return
            }
        }
        else {
            $null = $Accounts.Add($Name, $Details)

            Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value $Accounts
            Get-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" | Register-PSFConfig
        }
    }
}