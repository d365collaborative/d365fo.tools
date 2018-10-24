
<#
    .SYNOPSIS
        Get the login name from the e-mail address
        
    .DESCRIPTION
        Extract the login name from the e-mail address by substring everything before the @ character
        
    .PARAMETER Email
        The e-mail address that you want to get the login name from
        
    .EXAMPLE
        PS C:\> Get-LoginFromEmail -Email Claire@contoso.com
        
        This will substring the e-mail address and return "Claire" as the result
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-LoginFromEmail {
    [CmdletBinding()]
    [OutputType('System.String')]
    param (
        [string]$Email
    )

    $email.Substring(0, $Email.LastIndexOf('@')).Trim()
}