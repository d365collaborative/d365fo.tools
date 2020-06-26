--Author: Rasmus Andersen (@ITRasmus)
--Author: Charles Colombel (@dropshind)
--Author: Tommy Skaue (@skaue)
--Prepare a database in Azure SQL Database for export to SQL Server.
-- Re-assign full text catalogs to [dbo]
BEGIN
    DECLARE @catalogName NVARCHAR(256);
    DECLARE @sqlStmtTable NVARCHAR(512)
    DECLARE reassignfulltextcatalogcursor CURSOR FOR
      SELECT DISTINCT NAME
      FROM   sys.fulltext_catalogs

    -- Open cursor and disable on all tables returned
    OPEN reassignfulltextcatalogcursor

    FETCH next FROM reassignfulltextcatalogcursor INTO @catalogName

    WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @sqlStmtTable = 'ALTER AUTHORIZATION ON Fulltext Catalog::['
                              + @catalogName + '] TO [dbo]'

          EXEC Sp_executesql
            @sqlStmtTable

          FETCH next FROM reassignfulltextcatalogcursor INTO @catalogName
      END

    CLOSE reassignfulltextcatalogcursor

    DEALLOCATE reassignfulltextcatalogcursor
END

--Disable change tracking on tables where it is enabled.
DECLARE @SQL VARCHAR(1000)

SET quoted_identifier OFF

DECLARE changetrackingcursor CURSOR FOR
  SELECT 'ALTER TABLE [' + t.NAME
         + '] DISABLE CHANGE_TRACKING'
  FROM   sys.change_tracking_tables ct
         INNER JOIN sys.tables t
                 ON ct.object_id = t.object_id

OPEN changetrackingcursor

FETCH changetrackingcursor INTO @SQL

WHILE @@Fetch_Status = 0
  BEGIN
      EXEC(@SQL)

      FETCH changetrackingcursor INTO @SQL
  END

CLOSE changetrackingcursor

DEALLOCATE changetrackingcursor

--Disable change tracking on the database itself.
IF( 1 = (SELECT 1
         FROM   sys.change_tracking_databases
         WHERE  database_id = Db_id('@NewDatabase')) )
  ALTER DATABASE
  -- SET THE NAME OF YOUR DATABASE BELOW
  [@NewDatabase]

SET change_tracking = OFF

-- Ensure users can be dropped by changing ownership of certain schemas
DECLARE @SCHEMASQL VARCHAR(1000)

SET quoted_identifier OFF

DECLARE schemacursor CURSOR FOR
  SELECT 'ALTER AUTHORIZATION ON SCHEMA::[' + NAME
         + '] TO [DBO]; '
  FROM   sys.schemas
  WHERE  sys.schemas.NAME IN ( 'BACKUP', 'SHADOW', 'BatchScheduling' )

OPEN schemacursor

FETCH schemacursor INTO @SCHEMASQL

WHILE @@FETCH_STATUS = 0
  BEGIN
      EXEC(@SCHEMASQL)

      FETCH schemacursor INTO @SCHEMASQL
  END

CLOSE schemacursor

DEALLOCATE schemacursor

--Drop certificates that are tied to database users, which will cause errors when exporting the database
--if not dropped because then the corresponding user(s) can't be dropped later in the script.
--These certs are created from User options > Account > Electronic signature > "Get certificate" button in D365FO UI
DECLARE certcursor CURSOR FOR
  SELECT 'DROP CERTIFICATE ' + Quotename(c.NAME) + ';'
  FROM   sys.certificates c
  WHERE  c.principal_id IN (SELECT u.uid
                            FROM   sys.sysusers u
                            WHERE  issqlrole = 0
                                   AND hasdbaccess = 1
                                   AND NAME <> 'dbo');

OPEN certcursor;

FETCH certcursor INTO @SQL;

WHILE @@Fetch_Status = 0
  BEGIN
      EXEC(@SQL);

      FETCH certcursor INTO @SQL;
  END;

CLOSE certcursor;

DEALLOCATE certcursor;

--Remove the database level users from the database
--these will be recreated after importing in SQL Server.
DECLARE @userSQL VARCHAR(1000)

SET quoted_identifier OFF

DECLARE usercursor CURSOR FOR
  SELECT 'DROP USER [' + NAME + ']'
  FROM   sys.sysusers
  WHERE  issqlrole = 0
         AND hasdbaccess = 1
         AND NAME <> 'dbo'

OPEN usercursor

FETCH usercursor INTO @userSQL

WHILE @@Fetch_Status = 0
  BEGIN
      EXEC(@userSQL)

      FETCH usercursor INTO @userSQL
  END

CLOSE usercursor

DEALLOCATE usercursor

--Delete the SYSSQLRESOURCESTATSVIEW view as it has an Azure-specific definition in it.
--We will run db synch later to recreate the correct view for SQL Server.
IF( 1 = (SELECT 1
         FROM   sys.views
         WHERE  NAME = 'SYSSQLRESOURCESTATSVIEW') )
  DROP VIEW syssqlresourcestatsview

--Next, set system parameters ready for being a SQL Server Database.
UPDATE sysglobalconfiguration
SET    value = 'SQLSERVER'
WHERE  NAME = 'BACKENDDB'

UPDATE sysglobalconfiguration
SET    value = 0
WHERE  NAME = 'TEMPTABLEINAXDB'

--Clean up the batch server configuration, server sessions, and printers from the previous environment.
TRUNCATE TABLE sysserverconfig

TRUNCATE TABLE sysserversessions

TRUNCATE TABLE syscorpnetprinters

TRUNCATE TABLE sysclientsessions

TRUNCATE TABLE batchserverconfig

TRUNCATE TABLE batchservergroup

--Remove records which could lead to accidentally sending an email externally.
UPDATE sysemailparameters
SET    smtprelayservername = '',
       mailernoninteractive = 'SMTP'

--LANE.SWENKA 9/12/18 Forcing SMTP as Exchange provider can still email on refresh
--Remove encrypted SMTP Password record(s)
TRUNCATE TABLE sysemailsmtppassword; --GO

UPDATE logisticselectronicaddress
SET    locator = ''
WHERE  locator LIKE '%@%'; --GO

TRUNCATE TABLE printmgmtsettings

TRUNCATE TABLE printmgmtdocinstance

--Set any waiting, executing, ready, or canceling batches to withhold.
UPDATE batchjob
SET    status = 0
WHERE  status IN ( 1, 2, 5, 7 ); --GO

-- Clear encrypted hardware profile merchand properties
UPDATE dbo.retailhardwareprofile
SET    securemerchantproperties = NULL
WHERE  securemerchantproperties IS NOT NULL

--BELOW code is used to handle FULLTEXT INDEX / FULLTEST STOPLIST.
--Provided by Paul Heisterkamp (Twitter - @braul)
DECLARE @_SQL NVARCHAR(4000)

-------------------------------------------------------------------------------------
-- ALTER FULLTEXT INDEX ON [TableName] SET STOPLIST = SYSTEM'
IF Object_id('tempdb..#TMPSETSTOPLIST') IS NOT NULL
  DROP TABLE #tmpsetstoplist;

CREATE TABLE #tmpsetstoplist
  (
     tablename [NVARCHAR] (250)
  );

DECLARE cur CURSOR FOR
  SELECT Object_name(sys.fulltext_indexes.object_id) AS TableName
  FROM   sys.fulltext_indexes
  WHERE  stoplist_id != 0

OPEN cur;

DECLARE @TableName [NVARCHAR](250);

FETCH next FROM cur INTO @TableName;

WHILE @@FETCH_STATUS = 0
  BEGIN
      INSERT INTO #tmpsetstoplist
                  (tablename)
      VALUES      (@TableName);

      FETCH next FROM cur INTO @TableName;
  END;

CLOSE cur;

DEALLOCATE cur;

DECLARE cur CURSOR FOR
  SELECT tablename
  FROM   #tmpsetstoplist;

OPEN cur;

FETCH next FROM cur INTO @TableName;

WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @_SQL = N'ALTER FULLTEXT INDEX ON '
                  + Quotename(@TableName)
                  + ' SET STOPLIST = SYSTEM'

      PRINT ( @_SQL )

      EXEC Sp_executesql
        @_SQL

      FETCH next FROM cur INTO @TableName;
  END;

CLOSE cur;

DEALLOCATE cur;

-------------------------------------------------------------------------------------
-- DROP FULLTEXT STOPLIST [FullTextStopListName];
IF Object_id('tempdb..#DROPFULLTEXTSTOPLIST') IS NOT NULL
  DROP TABLE #dropfulltextstoplist;

CREATE TABLE #dropfulltextstoplist
  (
     stoplistname [NVARCHAR] (250)
  );

DECLARE cur CURSOR FOR
  SELECT NAME
  FROM   sys.fulltext_stoplists

OPEN cur;

DECLARE @StopListName [NVARCHAR](250);

FETCH next FROM cur INTO @StopListName;

WHILE @@FETCH_STATUS = 0
  BEGIN
      INSERT INTO #dropfulltextstoplist
                  (stoplistname)
      VALUES      (@StopListName);

      FETCH next FROM cur INTO @StopListName;
  END;

CLOSE cur;

DEALLOCATE cur;

DECLARE cur CURSOR FOR
  SELECT stoplistname
  FROM   #dropfulltextstoplist;

OPEN cur;

FETCH next FROM cur INTO @StopListName;

WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @_SQL = N'DROP FULLTEXT STOPLIST '
                  + Quotename(@StopListName) + ';'

      PRINT ( @_SQL )

      EXEC Sp_executesql
        @_SQL

      FETCH next FROM cur INTO @StopListName;
  END;

CLOSE cur;

DEALLOCATE cur;