function Get-D365UdeDatabaseCredential {
    [CmdletBinding()]
    param (
        [Alias("Name")]
        [string] $Id = "*",

        [switch] $ShowPassword
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

        $credentials = [hashtable](Get-PSFConfigValue -FullName "d365fo.tools.ude.credentials")

        $col = @(
            foreach ($key in $credentials.Keys) {
                if ($key -like $Id) {
                    $credentials[$key]
                }
            }
        )

        if ($ShowPassword) {
            $col
        }
        else {
            $col | Select-PSFObject -Property * -ExcludeProperty Password
        }
    }
}