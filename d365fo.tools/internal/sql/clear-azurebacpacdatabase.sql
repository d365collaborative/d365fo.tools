--Author: Rasmus Andersen (@ITRasmus)
--Author: Charles Colombel (@dropshind)
--Author: Tommy Skaue (@skaue)

--Prepare a database in Azure SQL Database for export to SQL Server.

-- Re-assign full text catalogs to [dbo]
BEGIN
    DECLARE @catalogName nvarchar(256);
    DECLARE @sqlStmtTable nvarchar(512)

    DECLARE reassignFullTextCatalogCursor CURSOR
       FOR SELECT DISTINCT name
       FROM sys.fulltext_catalogs 
       
       -- Open cursor and disable on all tables returned
       OPEN reassignFullTextCatalogCursor
       FETCH NEXT FROM reassignFullTextCatalogCursor INTO @catalogName

       WHILE @@FETCH_STATUS = 0
       BEGIN
              SET @sqlStmtTable = 'ALTER AUTHORIZATION ON Fulltext Catalog::[' + @catalogName + '] TO [dbo]'
              EXEC sp_executesql @sqlStmtTable
              FETCH NEXT FROM reassignFullTextCatalogCursor INTO @catalogName
       END
       CLOSE reassignFullTextCatalogCursor
       DEALLOCATE reassignFullTextCatalogCursor
END

--Disable change tracking on tables where it is enabled.
declare
@SQL varchar(1000)
set quoted_identifier off
declare changeTrackingCursor CURSOR for
select 'ALTER TABLE [' + t.name + '] DISABLE CHANGE_TRACKING'
from sys.change_tracking_tables c, sys.tables t
where t.object_id = c.object_id
OPEN changeTrackingCursor
FETCH changeTrackingCursor into @SQL
WHILE @@Fetch_Status = 0
BEGIN
exec(@SQL)
FETCH changeTrackingCursor into @SQL
END
CLOSE changeTrackingCursor
DEALLOCATE changeTrackingCursor

--Disable change tracking on the database itself.
IF(1=(SELECT 1 FROM SYS.CHANGE_TRACKING_DATABASES WHERE DATABASE_ID = DB_ID('@NewDatabase')))
ALTER DATABASE
-- SET THE NAME OF YOUR DATABASE BELOW
[@NewDatabase]
set CHANGE_TRACKING = OFF

-- Ensure users can be dropped by changing ownership of certain schemas
DECLARE @SCHEMASQL VARCHAR(1000)
SET QUOTED_IDENTIFIER OFF
DECLARE SCHEMACURSOR CURSOR FOR
SELECT 'ALTER AUTHORIZATION ON SCHEMA::[' + NAME + '] TO [DBO]; '
FROM SYS.SCHEMAS
WHERE SYS.SCHEMAS.NAME IN ('BACKUP','SHADOW')
OPEN SCHEMACURSOR
FETCH SCHEMACURSOR INTO @SCHEMASQL
WHILE @@FETCH_STATUS = 0
BEGIN
EXEC(@SCHEMASQL)
FETCH SCHEMACURSOR INTO @SCHEMASQL
END
CLOSE SCHEMACURSOR
DEALLOCATE SCHEMACURSOR

--Drop certificates that are tied to database users, which will cause errors when exporting the database
--if not dropped because then the corresponding user(s) can't be dropped later in the script.
--These certs are created from User options > Account > Electronic signature > "Get certificate" button in D365FO UI
DECLARE certCursor CURSOR for
select 'DROP CERTIFICATE ' + QUOTENAME(c.name) + ';'
from sys.certificates c 
where c.principal_id in (
	select u.uid
	from sys.sysusers u
	where issqlrole = 0 and hasdbaccess = 1 and name <> 'dbo'
)
;
OPEN certCursor;
FETCH certCursor into @SQL;
WHILE @@Fetch_Status = 0
BEGIN
	exec(@SQL);
	FETCH certCursor into @SQL;
END;
CLOSE certCursor;
DEALLOCATE certCursor; 							    

--Remove the database level users from the database
--these will be recreated after importing in SQL Server.								    
declare
@userSQL varchar(1000)
set quoted_identifier off
declare userCursor CURSOR for
select 'DROP USER [' + name +']'
from sys.sysusers
where issqlrole = 0 and hasdbaccess = 1 and name <> 'dbo'
OPEN userCursor
FETCH userCursor into @userSQL
WHILE @@Fetch_Status = 0
BEGIN
exec(@userSQL)
FETCH userCursor into @userSQL
END
CLOSE userCursor
DEALLOCATE userCursor
--Delete the SYSSQLRESOURCESTATSVIEW view as it has an Azure-specific definition in it.
--We will run db synch later to recreate the correct view for SQL Server.
if(1=(select 1 from sys.views where name = 'SYSSQLRESOURCESTATSVIEW'))
DROP VIEW SYSSQLRESOURCESTATSVIEW
--Next, set system parameters ready for being a SQL Server Database.
update sysglobalconfiguration
set value = 'SQLSERVER'
where name = 'BACKENDDB'
update sysglobalconfiguration
set value = 0
where name = 'TEMPTABLEINAXDB'
--Clean up the batch server configuration, server sessions, and printers from the previous environment.
TRUNCATE TABLE SYSSERVERCONFIG
TRUNCATE TABLE SYSSERVERSESSIONS
TRUNCATE TABLE SYSCORPNETPRINTERS
TRUNCATE TABLE SYSCLIENTSESSIONS
TRUNCATE TABLE BATCHSERVERCONFIG
TRUNCATE TABLE BATCHSERVERGROUP
--Remove records which could lead to accidentally sending an email externally.
UPDATE SysEmailParameters
SET SMTPRELAYSERVERNAME = '', MAILERNONINTERACTIVE = 'SMTP' --LANE.SWENKA 9/12/18 Forcing SMTP as Exchange provider can still email on refresh
--Remove encrypted SMTP Password record(s)
TRUNCATE TABLE SYSEMAILSMTPPASSWORD
;--GO
UPDATE LogisticsElectronicAddress
SET LOCATOR = ''
WHERE Locator LIKE '%@%'
;--GO
TRUNCATE TABLE PrintMgmtSettings
TRUNCATE TABLE PrintMgmtDocInstance
--Set any waiting, executing, ready, or canceling batches to withhold.
UPDATE BatchJob
SET STATUS = 0
WHERE STATUS IN (1,2,5,7)
;--GO
-- Clear encrypted hardware profile merchand properties
update dbo.RETAILHARDWAREPROFILE set SECUREMERCHANTPROPERTIES = null where SECUREMERCHANTPROPERTIES is not null


--BELOW code is used to handle FULLTEXT INDEX / FULLTEST STOPLIST.
--Provided by Paul Heisterkamp (Twitter - @braul)
DECLARE @_SQL NVARCHAR(4000)

-------------------------------------------------------------------------------------
-- ALTER FULLTEXT INDEX ON [TableName] SET STOPLIST = SYSTEM'
IF object_id('tempdb..#TMPSETSTOPLIST') IS NOT NULL
	DROP TABLE #TMPSETSTOPLIST;
CREATE TABLE #TMPSETSTOPLIST (
	TableName [nvarchar] (250)
	);

DECLARE cur CURSOR
FOR
select object_NAME(sys.fulltext_indexes.object_id) as TableName from sys.fulltext_indexes where stoplist_id != 0

OPEN cur;

DECLARE @TableName [nvarchar](250);

FETCH NEXT
FROM cur
INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #TMPSETSTOPLIST (TableName)
		VALUES (@TableName);		

	FETCH NEXT
		FROM cur
		INTO @TableName;
END;

CLOSE cur;

DEALLOCATE cur;

DECLARE cur CURSOR
FOR
SELECT TableName
FROM #TMPSETSTOPLIST;

OPEN cur;

FETCH NEXT
	FROM cur
	INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @_SQL = N'ALTER FULLTEXT INDEX ON ' + QUOTENAME(@TableName) + ' SET STOPLIST = SYSTEM'
	PRINT (@_SQL)
	EXEC SP_EXECUTESQL @_SQL

	FETCH NEXT
		FROM cur
		INTO @TableName;
END;

CLOSE cur;

DEALLOCATE cur;

-------------------------------------------------------------------------------------
-- DROP FULLTEXT STOPLIST [FullTextStopListName];
IF object_id('tempdb..#DROPFULLTEXTSTOPLIST') IS NOT NULL
	DROP TABLE #DROPFULLTEXTSTOPLIST;
CREATE TABLE #DROPFULLTEXTSTOPLIST (
	StopListName [nvarchar] (250)
	);

DECLARE cur CURSOR
FOR
select name from sys.fulltext_stoplists

OPEN cur;

DECLARE @StopListName [nvarchar](250);

FETCH NEXT
FROM cur
INTO @StopListName;

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO #DROPFULLTEXTSTOPLIST (StopListName)
		VALUES (@StopListName);		

	FETCH NEXT
		FROM cur
		INTO @StopListName;
END;

CLOSE cur;

DEALLOCATE cur;

DECLARE cur CURSOR
FOR
SELECT StopListName
FROM #DROPFULLTEXTSTOPLIST;

OPEN cur;

FETCH NEXT
FROM cur
INTO @StopListName;

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @_SQL = N'DROP FULLTEXT STOPLIST ' + QUOTENAME(@StopListName) + ';'
	PRINT (@_SQL)
	EXEC SP_EXECUTESQL @_SQL

	FETCH NEXT
		FROM cur
		INTO @StopListName;
END;

CLOSE cur;

DEALLOCATE cur;
