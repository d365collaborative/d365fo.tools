
<#
    .SYNOPSIS
        Get the external IP address
        
    .DESCRIPTION
        Get the external IP address by calling an external webpage and interpret the result from that
        
    .PARAMETER SaveToClipboard
        Instruct the cmdlet to copy the IP address directly into the clipboard, to save you the trouble
        
    .EXAMPLE
        PS C:\> Get-D365ExternalIP
        
        Will call the external page, interpret the output and display it as output.
        
        A result set example:
        
        IpAddress
        ---------
        40.113.130.229
        
    .EXAMPLE
        PS C:\> Get-D365ExternalIP -SaveToClipboard
        
        Will call the external page, interpret the output and display it as output.
        It will save/copy the IP address into the clipboard.
        
        A result set example:
        
        IpAddress
        ---------
        40.113.130.229
        
    .NOTES
        Tags: DEV, Tier2, DB, Database, Debug, JIT, LCS, Azure DB, IP
        
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-D365ExternalIP {
    [CmdletBinding()]
    param (
        [switch] $SaveToClipboard
    )
    
    begin {
        
    }
    
    process {
        $res = [PSCustomObject]@{"IpAddress" = (Invoke-WebRequest -Uri "https://ifconfig.me/ip").Content }

        if ($SaveToClipboard) {
            $res.IpAddress | Set-Clipboard
        }

        $res
    }
    
    end {
        
    }
}