
<#
    .SYNOPSIS
        Get a web request object
        
    .DESCRIPTION
        Get a prepared web request object with all necessary headers and tokens in place
        
    .PARAMETER RequestUrl
        The URL you want to work against
        
    .PARAMETER AuthorizationHeader
        The Authorization Header object that you want to use for you web request
        
    .PARAMETER Action
        The HTTP action you want to preform
        
    .EXAMPLE
        PS C:\> New-WebRequest -RequestUrl "https://login.windows.net/contoso/.well-known/openid-configuration" -AuthorizationHeader $null -Action GET
        
        This will create a new web request object that will work against the "https://login.windows.net/contoso/.well-known/openid-configuration" URL.
        The HTTP action is GET and in this case we don't need an Authorization Header in place.
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function New-WebRequest {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    param    (
        $RequestUrl,
        $AuthorizationHeader,
        $Action
    )
    
    Write-PSFMessage -Level Verbose -Message "New Request $RequestUrl, $Action"
    $request = [System.Net.WebRequest]::Create($RequestUrl)

    if ($null -ne $AuthorizationHeader) {
        $request.Headers["Authorization"] = $AuthorizationHeader.CreateAuthorizationHeader()
    }

    $request.Method = $Action
    
    $request
}