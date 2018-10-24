
<#
    .SYNOPSIS
        Start a browser session that will show the table browser
        
    .DESCRIPTION
        Makes it possible to call the table browser for a given table directly from the web browser, without worrying about the details
        
    .PARAMETER TableName
        The name of the table you want to see the rows for
        
    .PARAMETER Company
        The company for which you want to see the data from in the given table
        
        Default value is: "DAT"
        
    .PARAMETER Url
        The URL you want to execute against
        
        Default value is the Fully Qualified Domain Name registered on the machine
        
    .EXAMPLE
        PS C:\> Invoke-D365TableBrowser -TableName SalesTable
        
        Will open the table browser and show all the records in Sales Table from the "DAT" company (default value).
        
    .EXAMPLE
        PS C:\> Invoke-D365TableBrowser -TableName SalesTable -Company "USMF"
        
        Will open the table browser and show all the records in Sales Table from the "USMF" company.
        
    .NOTES
        Author: Mötz Jensen (@Splaxi)
        
        The cmdlet supports piping and can be used in advanced scenarios. See more on github and the wiki pages.
        
#>
function Invoke-D365TableBrowser {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 1 )]
        [string] $TableName,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 2 )]
        [string] $Company = $Script:Company,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default', ValueFromPipelineByPropertyName = $true, Position = 3 )]
        [string] $Url = $Script:Url
    )
    BEGIN {}

    PROCESS {
        Write-PSFMessage -Level Verbose -Message "Table name: $TableName" -Target $TableName
        $executingUrl = "$Url`?cmp=$Company&mi=SysTableBrowser&tablename=$TableName"

        Start-Process $executingUrl

        #* Allow the browser to start and process first request if it isn't running already
        Start-Sleep -Seconds 1
    }

    END {}
}