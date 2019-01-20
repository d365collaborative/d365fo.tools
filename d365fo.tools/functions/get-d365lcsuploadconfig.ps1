<#
.SYNOPSIS
Get the LCS configuration details

.DESCRIPTION
Get the LCS configuration details from the configuration store

.PARAMETER OutputType
The output type you want the cmdlet to return to you

Default value is "HashTable"

Valid options:
HashTable
PSCustomObject

.EXAMPLE
PS C:\> Get-D365LcsUploadConfig

This will return the saved configuration for accessing the LCS API.
The object return will be a HashTable.

.EXAMPLE
PS C:\> Get-D365LcsUploadConfig -OutputType "PSCustomObject"

This will return the saved configuration for accessing the LCS API.
The object return will be a PSCustomObject.

.NOTES
Tags: Environment, Url, Config, Configuration, LCS, Upload, ClientId

Author: Mötz Jensen (@Splaxi)

#>

function Get-D365LcsUploadConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("HashTable", "PSCustomObject")]
        [string] $OutputType = "HashTable"
    )

    $res = [Ordered]@{}

    Write-PSFMessage -Level Verbose -Message "Extracting all the LCS configuration and building the result object."

    foreach ($item in (Get-PSFConfig -FullName d365fo.tools.lcs*)) {
        $nameTemp = $item.FullName -replace "^d365fo.tools.lcs.upload.", ""
        $name = ($nameTemp -Split "\." | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_) } ) -Join ""
        
        $res.$name = $item.Value
    }

    if ($OutputType -eq "HashTable") {
        $res
    }
    else {
        $res | ConvertTo-PsCustomObject
    }
}