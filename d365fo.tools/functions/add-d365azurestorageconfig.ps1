
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
        
    .PARAMETER SAS
        The SAS key that you have created for the storage account or blob container
        
    .PARAMETER Container
        The name of the blob container inside the Azure Storage Account you want to register in the configuration store
        
    .PARAMETER Temporary
        Instruct the cmdlet to only temporarily add the azure storage account configuration in the configuration store
        
    .PARAMETER Force
        Switch to instruct the cmdlet to overwrite already registered Azure Storage Account entry
        
    .EXAMPLE
        PS C:\> Add-D365AzureStorageConfig -Name "UAT-Exports" -AccountId "1234" -AccessToken "dafdfasdfasdf" -Container "testblob"
        
        This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", AccessToken "dafdfasdfasdf" and blob container "testblob".
        
    .EXAMPLE
        PS C:\> Add-D365AzureStorageConfig -Name UAT-Exports -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -AccountId "1234" -Container "testblob"
        
        This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", SAS "sv=2018-03-28&si=unlisted&sr=c&sig=AUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" and blob container "testblob".
        The SAS key enables you to provide explicit access to a given blob container inside an Azure Storage Account.
        The SAS key can easily be revoked and that way you have control over the access to the container and its content.
        
    .EXAMPLE
        PS C:\> Add-D365AzureStorageConfig -Name UAT-Exports -SAS "sv2018-03-28&siunlisted&src&sigAUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" -AccountId "1234" -Container "testblob" -Temporary
        
        This will add an entry into the list of Azure Storage Accounts that is stored with the name "UAT-Exports" with AccountId "1234", SAS "sv=2018-03-28&si=unlisted&sr=c&sig=AUOpdsfpoWE976ASDhfjkasdf(5678sdfhk" and blob container "testblob".
        The SAS key enables you to provide explicit access to a given blob container inside an Azure Storage Account.
        The SAS key can easily be revoked and that way you have control over the access to the container and its content.
        
        The configuration will only last for the rest of this PowerShell console session.
        
    .NOTES
        Tags: Azure, Azure Storage, Config, Configuration, Token, Blob, Container
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Add-D365AzureStorageConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,

        [Parameter(Mandatory = $true)]
        [string] $AccountId,

        [Parameter(Mandatory = $true, ParameterSetName = "AccessToken")]
        [string] $AccessToken,

        [Parameter(Mandatory = $true, ParameterSetName = "SAS")]
        [string] $SAS,

        [Parameter(Mandatory = $true)]
        [Alias('Blob')]
        [Alias('Blobname')]
        [string] $Container,

        [switch] $Temporary,

        [switch] $Force
    )
    
    $Details = @{AccountId = $AccountId.ToLower();
        Container          = $Container.ToLower();
    }

    if ($PSCmdlet.ParameterSetName -eq "AccessToken") { $Details.AccessToken = $AccessToken }
    if ($PSCmdlet.ParameterSetName -eq "SAS") {
        if ($SAS.StartsWith("?")) {
            $SAS = $SAS.Substring(1)
        }

        $Details.SAS = $SAS
    }

    $Accounts = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.azure.storage.accounts")

    if ($Accounts.ContainsKey($Name)) {
        if ($Force) {
            $Accounts[$Name] = $Details

            Set-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Value $Accounts
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
    }

    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.azure.storage.accounts" -Scope UserDefault }
}