
<#
    .SYNOPSIS
        Test PSBoundParameters whether or not to support TrustedConnection
        
    .DESCRIPTION
        Test callers PSBoundParameters (HashTable) for details that determines whether or not a SQL Server connection should support TrustedConnection or not
        
    .PARAMETER Inputs
        HashTable ($PSBoundParameters) with the parameters from the callers invocation
        
    .EXAMPLE
        PS C:\> $UseTrustedConnection = Test-TrustedConnection $PSBoundParameters
        
        This will send the entire HashTable from the callers invocation, containing all explicit defined parameters to be analyzed whether or not the SQL Server connection should support TrustedConnection or not.
        
    .NOTES
        Author: Mötz Jensen (@splaxi)
        
#>
function Test-TrustedConnection {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
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
    elseif ($Inputs.ContainsKey("TrustedConnection")) {
        Write-PSFMessage -Level Verbose -Message "The script was calling with TrustedConnection directly. This overrides all other logic in respect that the caller should know what it is doing. Value was: $($Inputs.TrustedConnection)" -Tag $Inputs.TrustedConnection
        $Inputs.TrustedConnection
    }
    else {
        Write-PSFMessage -Level Verbose -Message "Capabilities based on the centralized logic in the psm1 file." -Target $Script:CanUseTrustedConnection
        $Script:CanUseTrustedConnection
    }
}