
function Start-D365UdeSsmsSession {
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $Id,

        [ValidateSet(20, 21)]
        [int] $Version = 20
    )

    process {
        $udeCreds = Get-D365UdeDatabaseCredential -Id $Id

        if ($null -eq $udeCreds) {
            Write-PSFMessage -Level Host -Message "No credential found for Id '$Id'. Please check the Id and try again."
            Stop-PSFFunction -Message "Stopping because no matching credential was found."

            return
        }

        if (Test-PSFFunctionInterrupt) { return }

        # Hack to get the SSMS executable path from the registry
        $ssmsInstalled = Get-ChildItem `
            -Path Registry::HKEY_CLASSES_ROOT\ssms.*\shell\Open\Command | `
            Select-Object -ExpandProperty PsPath | `
            ForEach-Object { (Get-ItemProperty -Path $_)."(Default)" } | `
            Select-String -Pattern '^[\"]?(.*ssms\.exe)["]?\s*"%1"' | `
            ForEach-Object { $_.Matches.Groups[1].Value } | Select-Object -Unique

        $executablePath = $ssmsInstalled | `
            Where-Object { $_ -match "Microsoft SQL Server Management Studio $($Version)\b" } | `
            Select-Object -First 1

        & $executablePath -S $($udeCreds.Server) -d $($udeCreds.Database) -U $($udeCreds.Username)
    }
}