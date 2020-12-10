
<#
    .SYNOPSIS
        Import data into a table
        
    .DESCRIPTION
        Import bulk data into a table in the Dynamics 365 Finance & Operations database
        
    .PARAMETER Path
        Path to the folder containing the bulk files that you want to import into the table
        
    .PARAMETER TableName
        Name of the table that you want to import data into
        
        Caution:
        You will need to delete or truncate the table you want to bulk import into. If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table
    .PARAMETER Schema
        Name of the schema that you are trying to import into
        
        Default value is "dbo"
        
    .PARAMETER DatabaseServer
        The name of the database server
        
        If on-premises or classic SQL Server, use either short name og Fully Qualified Domain Name (FQDN).
        
        If Azure use the full address to the database server, e.g. server.database.windows.net
        
    .PARAMETER DatabaseName
        The name of the database
        
    .PARAMETER ShowOriginalProgress
        Instruct the cmdlet to show the standard output in the console
        
        Default is $false which will silence the standard output
        
    .PARAMETER OutputCommandOnly
        Instruct the cmdlet to only output the command that you would have to execute by hand
        
        Will include full path to the executable and the needed parameters based on your selection
        
        
    .EXAMPLE
        PS C:\> Invoke-D365BulkImportTableData -Path "C:\Temp\SalesTable" -TableName "SalesTable"
        
        This will import all the bulk data in the "C:\Temp\SalesTable" folder into the "SalesTable".
        It will use the default value "dbo" for the Schema parameter.
        It will use the default DatabaseServer value.
        It will use the default DatabaseName value.
        
        Caution:
        You will need to delete or truncate the table you want to bulk import into. If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.
        
    .EXAMPLE
        PS C:\> Invoke-D365BulkImportTableData -Path "C:\Temp\SalesTable" -Schema "dbo" -TableName "SalesTable"
        
        This will import all the bulk data in the "C:\Temp\SalesTable" folder into the "SalesTable".
        It will use the value "dbo" for the Schema parameter.
        It will use the default DatabaseServer value.
        It will use the default DatabaseName value.
        
        Caution:
        You will need to delete or truncate the table you want to bulk import into. If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.
        
    .NOTES
        Tags: Bulk, Data, Import, bacpac
        
        Author: Mötz Jensen (@Splaxi)
        
        Caution:
        You will need to delete or truncate the table you want to bulk import into. If you don't, you might experience issues while inserting new records, if you have conflicting id's in the table.
        
        You might run into issues with foreign key references and constraints. None of this is handled by this cmdlet. It will try to import the data as-is into the table and nothing more.
#>

function Invoke-D365BulkImportTableData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('File')]
        [Alias('BacpacFile')]
        [string] $Path,

        [string] $TableName,
        
        [string] $Schema = "dbo",

        [string] $DatabaseServer = $Script:DatabaseServer,

        [string] $DatabaseName = $Script:DatabaseName,

        [switch] $ShowOriginalProgress,

        [switch] $OutputCommandOnly
    )

    begin {
        $null = $((bcp) | Select-Object -First 1) -match ".*(c:\\.*bcp\.exe).*"

        $executable = $Matches[1]

        $files = Get-ChildItem -Path "$Path\*.BCP"
    }

    process {
        $params = New-Object System.Collections.Generic.List[string]

        foreach ($item in $files) {
            $params.Clear()

            $params.Add("$Schema.$TableName")
            $params.Add("in")
            $params.Add("`"$($item.Fullname)`"")
            $params.Add("-T")
            $params.Add("-n")
            $params.Add("-S $DatabaseServer")
            $params.Add("-d $DatabaseName")
            $params.Add("-E")
    
            Invoke-Process -Executable $executable -Params $params -ShowOriginalProgress:$ShowOriginalProgress -OutputCommandOnly:$OutputCommandOnly -LogPath $LogPath
        }
    }
}