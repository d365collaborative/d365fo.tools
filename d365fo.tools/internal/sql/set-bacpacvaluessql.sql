--Author: Rasmus Andersen (@ITRasmus)
--Author: Tommy Skaue (@skaue)
--Author: Mötz Jensen (@Splaxi)

DROP USER IF EXISTS [axretailruntimeuser]
DROP USER IF EXISTS [axretaildatasyncuser]
DROP USER IF EXISTS [axmrruntimeuser]
DROP USER IF EXISTS [axdeployuser]
DROP USER IF EXISTS [axdbadmin]
DROP USER IF EXISTS [axdeployextuser]
DROP USER IF EXISTS [NT AUTHORITY\NETWORK SERVICE]

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axdeployuser')
BEGIN
	CREATE USER axdeployuser FROM LOGIN axdeployuser
	EXEC sp_addrolemember 'db_owner', 'axdeployuser'
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axdbadmin')
BEGIN
	ALTER AUTHORIZATION ON database::@DATABASENAME TO sa

	CREATE USER axdbadmin FROM LOGIN axdbadmin
	EXEC sp_addrolemember 'db_owner', 'axdbadmin'
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axmrruntimeuser')
BEGIN
	CREATE USER axmrruntimeuser FROM LOGIN axmrruntimeuser
	EXEC sp_addrolemember 'db_datareader', 'axmrruntimeuser'
	EXEC sp_addrolemember 'db_datawriter', 'axmrruntimeuser'
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axretaildatasyncuser')
BEGIN
	CREATE USER axretaildatasyncuser FROM LOGIN axretaildatasyncuser
	IF (DATABASE_PRINCIPAL_ID('DataSyncUsersRole') IS NOT NULL)
	BEGIN
		EXEC sp_addrolemember 'DataSyncUsersRole', 'axretaildatasyncuser'
	END
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axretailruntimeuser')
BEGIN
	CREATE USER axretailruntimeuser FROM LOGIN axretailruntimeuser
	IF (DATABASE_PRINCIPAL_ID('UsersRole') IS NOT NULL)
	BEGIN
		EXEC sp_addrolemember 'UsersRole', 'axretailruntimeuser'

	END
	
	IF (DATABASE_PRINCIPAL_ID('ReportUsersRole') IS NOT NULL)
	BEGIN
		EXEC sp_addrolemember 'ReportUsersRole', 'axretailruntimeuser'
	END
END

IF EXISTS (SELECT * FROM sys.syslogins WHERE NAME = 'axdeployextuser')
BEGIN
	CREATE USER axdeployextuser FROM LOGIN axdeployextuser
	IF (DATABASE_PRINCIPAL_ID('DeployExtensibilityRole') IS NOT NULL)
	BEGIN
		EXEC sp_addrolemember 'DeployExtensibilityRole', 'axdeployextuser'
	END
END

CREATE USER [NT AUTHORITY\NETWORK SERVICE] FROM LOGIN [NT AUTHORITY\NETWORK SERVICE]
EXEC sp_addrolemember 'db_owner', 'NT AUTHORITY\NETWORK SERVICE'

UPDATE T1
SET T1.storageproviderid = 0
    , T1.accessinformation = ''
    , T1.modifiedby = 'Admin'
    , T1.modifieddatetime = getdate()
FROM docuvalue T1
WHERE T1.storageproviderid = 1 --Azure storage


IF((SELECT 1
FROM SYS.CHANGE_TRACKING_DATABASES
WHERE DATABASE_ID = DB_ID('@DATABASENAME')) IS NULL)
BEGIN
	ALTER DATABASE [@DATABASENAME] SET CHANGE_TRACKING = ON (CHANGE_RETENTION = 6 DAYS, AUTO_CLEANUP = ON)
END

;--GO
DROP PROCEDURE IF EXISTS SP_ConfigureTablesForChangeTracking
DROP PROCEDURE IF EXISTS SP_ConfigureTablesForChangeTracking_V2
;--GO
-- Begin Refresh Retail FullText Catalogs
DECLARE @RFTXNAME NVARCHAR(MAX);
DECLARE @RFTXSQL NVARCHAR(MAX);
DECLARE retail_ftx CURSOR FOR
SELECT OBJECT_SCHEMA_NAME(object_id) + '.' + OBJECT_NAME(object_id) fullname
FROM SYS.FULLTEXT_INDEXES
WHERE FULLTEXT_CATALOG_ID = (SELECT TOP 1
	FULLTEXT_CATALOG_ID
FROM SYS.FULLTEXT_CATALOGS
WHERE NAME = 'COMMERCEFULLTEXTCATALOG');
OPEN retail_ftx;
FETCH NEXT FROM retail_ftx INTO @RFTXNAME;

BEGIN TRY
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'Refreshing Full Text Index ' + @RFTXNAME;
		EXEC SP_FULLTEXT_TABLE @RFTXNAME, 'activate';
		SET @RFTXSQL = 'ALTER FULLTEXT INDEX ON ' + @RFTXNAME + ' START FULL POPULATION';
		EXEC SP_EXECUTESQL @RFTXSQL;
		FETCH NEXT FROM retail_ftx INTO @RFTXNAME;
	END
END TRY
BEGIN CATCH
	PRINT error_message()
END CATCH

CLOSE retail_ftx;
DEALLOCATE retail_ftx;
-- End Refresh Retail FullText Catalogs

--Next, set system parameters ready for being a SQL Server Database.
UPDATE sysglobalconfiguration
SET    value = 'SQLSERVER'
WHERE  NAME = 'BACKENDDB'

UPDATE sysglobalconfiguration
SET    value = 0
WHERE  NAME = 'TEMPTABLEINAXDB'