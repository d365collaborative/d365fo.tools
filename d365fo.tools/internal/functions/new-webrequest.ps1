function New-WebRequest ($RequestUrl, $AuthorizationHeader, $Action) {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]

    
    Write-PSFMessage -Level Verbose -Message "New Request $RequestUrl, $Action"        
    $request = [System.Net.WebRequest]::Create($RequestUrl)
    if ($null -ne $AuthorizationHeader) {
        $request.Headers["Authorization"] = $AuthorizationHeader.CreateAuthorizationHeader()
    }
    $request.Method = $Action
    
    $request
}