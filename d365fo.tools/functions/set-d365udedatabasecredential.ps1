
function Set-D365UdeDatabaseCredential {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Id,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("DatabaseServer")]
        [Alias("ServerName")]
        [string] $Server,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("DatabaseName")]
        [string] $Database,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("SqlUser")]
        [string] $Username,

        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("SqlPwd")]
        [string] $Password,

        [Alias("SQLJITExpirationTime")]
        [datetime] $ValidUntil = (Get-Date).AddHours(8)
    )

    begin {
        if ($null -eq (Get-Module TUN.CredentialManager -ListAvailable)) {
            Write-PSFMessage -Level Host -Message "This cmdlet needs the <c='em'>TUN.CredentialManager</c> module. Please install it from the PowerShell Gallery with <c='em'>Install-Module -Name TUN.CredentialManager</c> and try again."
            Stop-PSFFunction -Message "Stopping because the TUN.CredentialManager module is not available."

            return
        }

        if (Test-PSFFunctionInterrupt) { return }

        Import-Module TUN.CredentialManager
    }

    process {
        if (Test-PSFFunctionInterrupt) { return }
        
        $SqlServerGUID = "8c91a03d-f9b4-46c0-a305-b5dcc79ff907"

        $details = [PSCustomObject][ordered]@{
            Id         = $Id
            Server     = $($Server)
            Database   = $($Database)
            Username   = $($Username)
            Password   = $($Password)
            Expiration = $($ValidUntil.ToString("s"))
        }

        # Setting up the SQL Server Management Studio (SSMS) Credential for version 20 - 21
        20, 21 | ForEach-Object {
            New-StoredCredential `
                -UserName $Username `
                -Password $Password `
                -Persist LocalMachine `
                -Target "Microsoft:SSMS:$($_):$($Server):$($Username):$($SqlServerGUID):1" > $null
        }

        $credentials = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.ude.credentials")
        $credentials."$Id" = $details

        Set-PSFConfig -FullName "d365fo.tools.ude.credentials" -Value $credentials
        Register-PSFConfig -FullName "d365fo.tools.ude.credentials" -Scope UserDefault

        Get-D365UdeDatabaseCredential -Id $Id
    }
}