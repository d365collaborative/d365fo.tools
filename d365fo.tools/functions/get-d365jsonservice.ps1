
<#
    .SYNOPSIS
        Get Json based service
        
    .DESCRIPTION
        Get Json based services that are available from a Dynamics 365 Finance & Operations environment
        
    .PARAMETER Name
        The name of the json service that you are looking for
        
        Default value is "*" to display all json services
        
    .PARAMETER Url
        URL / URI for the D365FO environment you want to access
        
        If you are working against a D365FO instance, it will be the URL / URI for the instance itself
        
        If you are working against a D365 Talent / HR instance, this will have to be "http://hr.talent.dynamics.com"
        
    .PARAMETER Tenant
        Azure Active Directory (AAD) tenant id (Guid) that the D365FO environment is connected to, that you want to access
        
    .PARAMETER ClientId
        The ClientId obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER ClientSecret
        The ClientSecret obtained from the Azure Portal when you created a Registered Application
        
    .PARAMETER RawOutput
        Instructs the cmdlet to include the outer structure of the response received from the endpoint
        
        The output will still be a PSCustomObject
        
    .PARAMETER OutputAsJson
        Instructs the cmdlet to convert the output to a Json string
        
    .EXAMPLE
        PS C:\> Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will get all available service groups for the D365FO instance.
        It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> Get-D365JsonService -Name "*TS*" -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522"
        
        This will get all available service groups for the D365FO instance, which matches the "*TS*" as a name.
        It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        It will limit the output to only those matching the specified Name parameter: "*TS*"
        
    .EXAMPLE
        PS C:\> Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -RawOutput
        
        This will get all available service groups for the D365FO instance with the outer most hierarchy.
        It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .EXAMPLE
        PS C:\> Get-D365JsonService -Url "https://usnconeboxax1aos.cloud.onebox.dynamics.com" -Tenant "e674da86-7ee5-40a7-b777-1111111111111" -ClientId "dea8d7a9-1602-4429-b138-111111111111" -ClientSecret "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522" -OutputAsJson
        
        This will get all available service groups for the D365FO instance and display the result as json.
        It will contact the D365FO instance specified in the Url parameter: "https://usnconeboxax1aos.cloud.onebox.dynamics.com".
        It will authenticate againt the "https://login.microsoftonline.com/e674da86-7ee5-40a7-b777-1111111111111/oauth2/token" url with the specified Tenant parameter: "e674da86-7ee5-40a7-b777-1111111111111".
        It will authenticate with the specified ClientId parameter: "dea8d7a9-1602-4429-b138-111111111111".
        It will authenticate with the specified ClientSecret parameter: "Vja/VmdxaLOPR+alkjfsadffelkjlfw234522".
        
    .NOTES
        Tags: DMF, OData, RestApi, Data Management Framework
        
        Author: Mötz Jensen (@Splaxi)
        
        Idea taken from http://www.ksaelen.be/wordpresses/dynamicsaxblog/2016/01/dynamics-ax-7-tip-what-services-are-exposed/
        
#>
function Get-D365JsonService {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [string] $Name = "*",

        [Parameter(Mandatory = $true)]
        [string] $Url,

        [Parameter(Mandatory = $true)]
        [string] $Tenant,

        [Parameter(Mandatory = $true)]
        [string] $ClientId,

        [Parameter(Mandatory = $true)]
        [string] $ClientSecret,

        [switch] $RawOutput,

        [switch] $OutputAsJson
    )

    $bearerParms = @{
        Resource        = $Url
        ClientId        = $ClientId
        ClientSecret    = $ClientSecret
        AuthProviderUri = "https://login.microsoftonline.com/$Tenant/oauth2/token"
    }

    $bearer = Invoke-ClientCredentialsGrant @bearerParms | Get-BearerToken

    $headers = @{Authorization = $bearer }
    $Url = $Url + "/api/services"

    $res = Invoke-RestMethod -Method Get -Uri $Url -Headers $headers

    if (-not $RawOutput) {
        $res = $res.ServiceGroups | Where-Object { $_.Name -Like $Name -or $_.Name -eq $Name } | Sort-Object Name
    }
    else {
        $res.ServiceGroups = @($res.ServiceGroups | Where-Object { $_.Name -Like $Name -or $_.Name -eq $Name }) | Sort-Object Name
    }

    if ($OutputAsJson) {
        $res | ConvertTo-Json -Depth 10
    }
    else {
        $res
    }
}