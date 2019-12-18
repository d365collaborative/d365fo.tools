<#
    .SYNOPSIS
        Cleanup TempDB tables in Microsoft Dynamics 365 for Finance and Operations environment
        
    .DESCRIPTION
        This will cleanup X days of TempDB tables. The reason behind this process is that sp_updatestats takes significantly longer depending on the number of TempDB tables in the system. It uses Invoke-Sqlcmd.
        
    .PARAMETER SQLServerInstance
        The SQL Server Instance to connect to.
        
    .PARAMETER Days
        Temp tables older than this Days input will be dropped.
        
    .PARAMETER QueryTimeout
        Optional query timeout
        
        
    .EXAMPLE
        PS C:\> invoke-D365CleanupTempDBTables -SQLServerInstance $env:COMPUTERNAME -Days 7 -Verbose
        
        This will cleanup tempdb tables older than 7 days [create_date < GETDATE() - 7]
        $env:COMPUTERNAME is used in this case because the SQL server is located locally where the script is run.
        Verbose will output the print statements returned.
        
    .LINK
        https://docs.microsoft.com/en-us/powershell/module/sqlserver/invoke-sqlcmd?view=sqlserver-ps
        
    .LINK
        https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
        
    .LINK
        https://github.com/PaulHeisterkamp/d365fo.blog/blob/master/Tools/SQL/DropTempDBTables.sql
        
    .NOTES
        This command will log a warning to Azure DevOps in the event of a catch block.

        This cmdlet is based on the findings from Paul Heisterkamp (@braul)

        See his blog for more info:
        https://msdyn365fo.wordpress.com/2019/12/18/cleanup-tempdb-tables-in-a-msdyn365fo-sandbox-environment/
#>

function Invoke-D365CleanupTempDBTables {
	[CmdletBinding()]
	param 
	( 
	    [Parameter(Mandatory=$True, Position=0)]
	    [string]$SQLServerInstance,
        [Parameter(Mandatory=$False, Position=1)]
	    [int]$Days = 7,
        [Parameter(Mandatory=$False, Position=0)] 
	    [int]$QueryTimeout = 0
	)

$embeddedSql = @"
--Create a cursor.
DECLARE cur CURSOR
FOR
SELECT O.NAME
FROM 
	SYS.OBJECTS AS O WITH (NOLOCK),
	SYS.SCHEMAS AS S WITH (NOLOCK)
WHERE S.NAME = 'DBO'
	AND S.SCHEMA_ID = O.SCHEMA_ID         
	AND O.TYPE = 'U'          
	AND O.NAME LIKE 'T[0-9]%'
	and O.create_date < GETDATE() - `$(Days)
	
OPEN cur;
DECLARE @TableName [nvarchar](250);
	
-- Fetch first record
FETCH NEXT
FROM cur
INTO @TableName;

-- Loop all records
WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @_SQL NVARCHAR(4000)
	SET @_SQL = N'DROP TABLE ' + QUOTENAME(@TableName)
	PRINT (@_SQL)
	EXEC SP_EXECUTESQL @_SQL

	 
	-- Fetch next record
	FETCH NEXT
	FROM cur
	INTO @TableName;

END;

CLOSE cur;
DEALLOCATE cur;
"@

    <#
        These are the variables in the embedded SQL script that will be replaced. Currently
        there is only 1 replaced variable, but this design pattern is preferred for simplicity
        in the future if more are needed.
    #>

    $sqlVariables = @()
    $sqlVariables += "Days=$Days"	

    try {
	    Invoke-Sqlcmd -ServerInstance $SQLServerInstance -Database 'tempdb' -Query $embeddedSql -Variable $sqlVariables -Verbose
    }
    catch {
	    Write-Host "##vso[task.logissue type=warning;] There was an error cleaning up $Days of tables in tempdb on server $SQLServerInstance."
    }
}

