function Get-ProductInfoProvider
{
    Add-Type -Path "$Script:AOSPath\bin\Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.dll"
    return [Microsoft.Dynamics.BusinessPlatform.ProductInformation.Provider.ProductInfoProvider]::get_Provider();
}
