
<#
    .SYNOPSIS
        Get time zone
        
    .DESCRIPTION
        Extract the time zone object from the supplied parameter
        
        Uses regex to determine whether or not the parameter is the ID or the DisplayName of a time zone
        
    .PARAMETER InputObject
        String value that you want converted into a time zone object
        
    .EXAMPLE
        PS C:\> Get-TimeZone -InputObject "UTC"
        
        This will return the time zone object based on the UTC id.
        
    .NOTES
        Tag: Time, TimeZone,
        
        Author: Mötz Jensen (@Splaxi)
#>

function Get-TimeZone {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidOverwritingBuiltInCmdlets", "")]
    [CmdletBinding()]
    [OutputType('System.TimeZoneInfo')]
    param (
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $InputObject
    )

    if ($InputObject -match "\s\-\s\[") {
        $search = [regex]::Split($InputObject, "\s\-\s\[")[0]

        [System.TimeZoneInfo]::GetSystemTimeZones() | Where-Object {$PSItem.DisplayName -eq $search} | Select-Object -First 1
    }
    else {
        try {
            [System.TimeZoneInfo]::FindSystemTimeZoneById($InputObject)
        }
        catch {
            Write-PSFMessage -Level Host -Message "Unable to translate the <c='em'>$InputObject</c> to a known .NET timezone value. Please make sure you filled in a valid timezone."
            Stop-PSFFunction -Message "Stopping because timezone wasn't found." -StepsUpward 1
            return
        }
    }
}