
<#
    .SYNOPSIS
        Returns Exposed services
        
    .DESCRIPTION
        Function for getting which services there are exposed from D365
        
    .PARAMETER ClientId
        Client Id from the AppRegistration
        
    .PARAMETER ClientSecret
        Client Secret from the AppRegistration
        
    .PARAMETER D365FO
        Url fro the D365 including Https://
        
    .PARAMETER Authority
        The Authority to issue the token
        
    .EXAMPLE
        PS C:\> Get-D365ExposedService -ClientId "MyClientId" -ClientSecret "MyClientSecret"
        
        This will show a list of all the services that the D365FO instance is exposing.
        
    .NOTES
        Tags: DMF, OData, RestApi, Data Management Framework
        
        Author: Rasmus Andersen (@ITRasmus)
        
        Idea taken from http://www.ksaelen.be/wordpresses/dynamicsaxblog/2016/01/dynamics-ax-7-tip-what-services-are-exposed/
        
#>
function Get-D365ExposedService
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true, Position = 1 )]
        [string] $ClientId,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string] $ClientSecret,
        [Parameter(Mandatory = $false, Position = 3 )]
        [string] $D365FO,
        [Parameter(Mandatory = $false, Position = 4 )]
        [string] $Authority
    )

    if($D365FO -eq "") {
        $D365FO = $(Get-D365Url).Url
    }
    if($Authority -eq "") {
        $Authority = Get-InstanceIdentityProvider
    }

    Write-PSFMessage -Level Verbose -Message "Importing type 'Microsoft.IdentityModel.Clients.ActiveDirectory.dll'"
    $null = add-type -path "$script:ModuleRoot\internal\dll\Microsoft.IdentityModel.Clients.ActiveDirectory.dll" -ErrorAction Stop
    

    $url = $D365FO + "/api/services"

    Write-PSFMessage -Level Verbose -Message "D365FO : $D365FO"
    Write-PSFMessage -Level Verbose -Message "Url : $url"
    Write-PSFMessage -Level Verbose -MEssage "Authority : $Authority"
    
    $authHeader = New-AuthorizationHeader $Authority $ClientId  $ClientSecret $D365FO

    [System.Net.WebRequest] $webRequest  = New-WebRequest $url $authHeader "GET"

    $response = $webRequest.GetResponse()

    if ($response.StatusCode -eq [System.Net.HttpStatusCode]::Ok) {

        $stream = $response.GetResponseStream()
    
        $streamReader = New-Object System.IO.StreamReader($stream);
        
        $exposedServices = $streamReader.ReadToEnd()
        $streamReader.Close();
    
    }
    else {
        $statusDescription = $response.StatusDescription
        throw "Https status code : $statusDescription"
    }

    $exposedServices
}