
<#
    .SYNOPSIS
        Sets the start page in internet explorer
        
    .DESCRIPTION
        Function for setting the start page in internet explorer
        
    .PARAMETER Name
        Name of the D365 Instance
        
    .PARAMETER Url
        URL of the D365 for Finance & Operations instance that you want to have as your start page
        
    .EXAMPLE
        PS C:\> Set-D365StartPage -Name 'Demo1'
        
        This will update the start page for the current user to "https://Demo1.cloud.onebox.dynamics.com"
        
    .EXAMPLE
        PS C:\> Set-D365StartPage -URL "https://uat.sandbox.operations.dynamics.com"
        
        This will update the start page for the current user to "https://uat.sandbox.operations.dynamics.com"
        
    .NOTES
        Author: Rasmus Andersen (@ITRasmus)
        Author: Mötz Jensen (@Splaxi)
        
#>
function Set-D365StartPage() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Default')]
        [String] $Name,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'Url')]
        [String] $Url
    )
   
    process {
        $path = 'HKCU:\Software\Microsoft\Internet Explorer\Main\'
        $propName = 'start page'
    
        if ($PSBoundParameters.ContainsKey("URL")) {
            $value = $Url
        }
        else {
            $value = "https://$Name.cloud.onebox.dynamics.com"
        }

        Set-Itemproperty -Path $path -Name $propName -Value $value
    }
}