function Get-D365LcsUploadConfig {
    [CmdletBinding()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateSet("HashTable", "PSCustomObject")]
        [string] $OutputType = "HashTable"
    )

    $res = [Ordered]@{}

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