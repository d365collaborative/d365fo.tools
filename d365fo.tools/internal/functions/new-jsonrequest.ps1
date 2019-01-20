function New-JsonRequest {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Uri,
        
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Token,

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $Content
        
    )

    $request = New-Object -TypeName System.Net.Http.HttpRequestMessage -ArgumentList @([System.Net.Http.HttpMethod]::Post, $Uri)
    
    if (-not ($Content -eq "")) {
        $request.Content = New-Object -TypeName System.Net.Http.StringContent -ArgumentList @($Content, [System.Text.Encoding]::UTF8, "application/json")
    }

    $request.Headers.Authorization = $Token

    $request
}