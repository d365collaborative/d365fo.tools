<#
.SYNOPSIS
Start a browser session that will show the table browser

.DESCRIPTION
Makes it possible to call the table browser for a given table directly from the web browser, without worrying about the details

.PARAMETER TableName
The name of the table you want to see the rows for

.PARAMETER Company
The company for which you want to see the data from in the given table

Default value is "DAT"

.PARAMETER Url
The URL you want to execute against

Default value is the Fully Qualified Domain Name registered on the machine

.EXAMPLE
Invoke-D365TableBrowser -TableName SalesTable

Will open the table browser and show all the records in Sales Table from the "DAT" company (default value)

.EXAMPLE
Invoke-D365TableBrowser -TableName SalesTable -Company "USMF"

Will open the table browser and show all the records in Sales Table from the "USMF" company

.NOTES
General notes
#>
function Invoke-D365TableBrowser {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', Position = 1 )]
        [string] $TableName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 2 )]
        [string] $Company = "DAT",

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', Position = 3 )]
        [string] $Url = $Script:Url
    )

    $executingUrl = "$Url`?cmp=$Company&mi=SysTableBrowser&tablename=$TableName"

    Start-Process $executingUrl
}