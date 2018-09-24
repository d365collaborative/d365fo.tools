function Test-TrustedConnection {
    [CmdletBinding()]
    param (
        [HashTable] $Inputs
    )

    if (($Inputs.ContainsKey("ImportModeTier2")) -or ($Inputs.ContainsKey("ExportModeTier2"))){
        Write-PSFMessage -Level Verbose -Message "Not capable of using Trusted Connection based on Tier validation."
        $false
    }
    elseif (($Inputs.ContainsKey("SqlUser")) -or ($Inputs.ContainsKey("SqlPwd"))) {
        Write-PSFMessage -Level Verbose -Message "Not capable of using Trusted Connection based on supplied SQL login details."
        $false
    }
    else {
        Write-PSFMessage -Level Verbose -Message "Capabilities based on the centralized logic in the psm1 file." -Target $Script:CanUseTrustedConnection
        $Script:CanUseTrustedConnection    
    }
}