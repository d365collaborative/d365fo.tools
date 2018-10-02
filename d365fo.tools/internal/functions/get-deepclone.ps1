<#
.SYNOPSIS
Clone a hashtable

.DESCRIPTION
Create a deep clone of a hashtable for you to work on it without updating the original object

.PARAMETER InputObject
The hashtable you want to clone

.EXAMPLE
Get-DeepClone -InputObject $HashTable

This will clone the $HashTable variable into a new object and return it to you.

.NOTES
Author: Mötz Jensen (@Splaxi)

#>
function Get-DeepClone {
    [CmdletBinding()]
    [OutputType('System.Collections.Hashtable')]
    param(
        [parameter(Mandatory = $true)]
        [HashTable] $InputObject
    )
    process {    
        if ($InputObject -is [hashtable]) {
            $clone = @{}
            foreach ($key in $InputObject.keys) {
                $clone[$key] = Get-DeepClone $InputObject[$key]
            }
            return $clone
        }
        else {
            return $InputObject
        }        
    }
}