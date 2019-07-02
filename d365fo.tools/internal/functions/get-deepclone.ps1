
<#
    .SYNOPSIS
        Clone a hashtable
        
    .DESCRIPTION
        Create a deep clone of a hashtable for you to work on it without updating the original object
        
    .PARAMETER InputObject
        The hashtable you want to clone
        
    .EXAMPLE
        PS C:\> Get-DeepClone -InputObject $HashTable
        
        This will clone the $HashTable variable into a new object and return it to you.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
#>
function Get-DeepClone {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        $InputObject
    )
    process
    {
        if($InputObject -is [hashtable]) {

            $clone = @{}

            foreach($key in $InputObject.keys)
            {
                if($key -eq "EnableException") {continue}
                
                $clone[$key] = Get-DeepClone $InputObject[$key]
            }

            $clone
        } else {
            $InputObject
        }
    }
}