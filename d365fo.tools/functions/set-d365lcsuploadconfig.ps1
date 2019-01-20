function Set-D365LcsUploadConfig {
    [CmdletBinding()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $false, Position = 1)]
        [int]$ProjectId = "",

        [Parameter(Mandatory = $false, Position = 2)]
        [string] $ClientId = "",

        [Parameter(Mandatory = $false, Position = 3)]
        [string] $Username = "",

        [Parameter(Mandatory = $false, Position = 4)]
        [string] $Password = "",

        [Parameter(Mandatory = $false, Position = 9)]
        [ValidateSet("https://lcsapi.lcs.dynamics.com", "https://lcsapi.eu.lcs.dynamics.com")]
        [string]$LcsApiUri = "https://lcsapi.lcs.dynamics.com",

        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User",

        [switch] $Temporary,

        [switch] $Clear
    )

    $configScope = Test-ConfigStorageLocation -ConfigStorageLocation $ConfigStorageLocation

    if (Test-PSFFunctionInterrupt) { return }

    if ($Clear) {

        Write-PSFMessage -Level Verbose -Message "Clearing all the d365fo.tools.lcs configurations."

        foreach ($item in (Get-PSFConfig -FullName d365fo.tools.lcs*)) {
            Set-PSFConfig -Fullname $item.FullName -Value ""
            if (-not $Temporary) { Register-PSFConfig -FullName $item.FullName -Scope $configScope }
        }
    }
    else {
        foreach ($key in $PSBoundParameters.Keys) {
            $value = $PSBoundParameters.Item($key)

            Write-PSFMessage -Level Verbose -Message "Working on $key with $value" -Target $value

            switch ($key) {
                "ProjectId" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.projectid" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.projectid" -Scope $configScope }
                }

                "ClientId" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.clientid" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.clientid" -Scope $configScope }
                }

                "Username" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.username" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.username" -Scope $configScope }
                }

                "Password" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.password" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.password" -Scope $configScope }
                }

                "LcsApiUri" {
                    Set-PSFConfig -FullName "d365fo.tools.lcs.upload.api.uri" -Value $value
                    if (-not $Temporary) { Register-PSFConfig -FullName "d365fo.tools.lcs.upload.api.uri" -Scope $configScope }
                }

                Default {}
            }
        }
    }

    foreach ($item in (Get-PSFConfig -FullName d365fo.tools.lcs*)) {
        $nameTemp = $item.FullName -replace "^d365fo.tools.", ""
        $name = ($nameTemp -Split "\." | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) } ) -Join ""
        
        Set-Variable -Name $name -Value $item.Value
    }
}