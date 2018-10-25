
<#
    .SYNOPSIS
        Test accessible to the configuration storage
        
    .DESCRIPTION
        Test if the desired configuration storage is accessible with the current user context
        
    .PARAMETER ConfigStorageLocation
        Parameter used to instruct where to store the configuration objects
        
        The default value is "User" and this will store all configuration for the active user
        
        Valid options are:
        "User"
        "System"
        
        "System" will store the configuration so all users can access the configuration objects
        
    .EXAMPLE
        PS C:\> Test-ConfigStorageLocation -ConfigStorageLocation "System"
        
        This will test if the current executing user has enough privileges to save to the system wide configuration storage.
        The system wide configuration storage requires administrator rights.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Test-ConfigStorageLocation {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [ValidateSet('User', 'System')]
        [string] $ConfigStorageLocation = "User"
    )
    
    $configScope = "UserDefault"

    if ($ConfigStorageLocation -eq "System") {
        if ($Script:IsAdminRuntime) {
            $configScope = "SystemDefault"
        }
        else {
            Write-PSFMessage -Level Host -Message "Unable to locate save the <c='em'>configuration objects</c> in the <c='em'>system wide configuration store</c> on the machine. Please start an elevated session and run the cmdlet again."
            Stop-PSFFunction -Message "Elevated permissions needed. Please start an elevated session and run the cmdlet again." -StepsUpward 1
            return
        }
    }

    $configScope
}