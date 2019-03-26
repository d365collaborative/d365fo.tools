
<#
    .SYNOPSIS
        Convert an object into a HashTable
        
    .DESCRIPTION
        Convert an object into a HashTable, can be used with json objects to create a HashTable
        
    .PARAMETER InputObject
        The object you want to convert
        
    .EXAMPLE
        PS C:\> $jsonString = '{"Test1":  "Test1","Test2":  "Test2"}'
        PS C:\> $jsonString | ConvertFrom-Json | ConvertTo-Hashtable
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        Original Author: Adam Bertram (@techsnips_io)
        
        Original blog post with the function explained:
        https://4sysops.com/archives/convert-json-to-a-powershell-hash-table/
        
#>

function ConvertTo-Hashtable {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseCmdletCorrectly', '')]
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process {
        ## Return null if the input is null. This can happen when calling the function
        ## recursively and a property is null
        if ($null -eq $InputObject) {
            return $null
        }

        ## Check if the input is an array or collection. If so, we also need to convert
        ## those types into hash tables as well. This function will convert all child
        ## objects into hash tables (if applicable)
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) {
                    ConvertTo-Hashtable -InputObject $object
                }
            )

            ## Return the array but don't enumerate it because the object may be pretty complex
            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject]) {
            ## If the object has properties that need enumeration
            ## Convert it to its own hash table and return it
            $hash = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            $hash
        }
        else {
            ## If the object isn't an array, collection, or other object, it's already a hash table
            ## So just return it.
            $InputObject
        }
    }
}