USE [@DATABASENAME]

--Disable change tracking on tables where it is enabled.
DECLARE @SQL VARCHAR(1000)
SET QUOTED_IDENTIFIER OFF
DECLARE changeTrackingCursor CURSOR FOR
SELECT 'ALTER TABLE [' + t.name + '] DISABLE CHANGE_TRACKING'
FROM sys.change_tracking_tables ct
INNER JOIN sys.tables t ON ct.object_id = t.object_id

OPEN changeTrackingCursor
FETCH changeTrackingCursor INTO @SQL
WHILE @@Fetch_Status = 0
BEGIN
	EXEC(@SQL)
	FETCH changeTrackingCursor INTO @SQL
END

CLOSE changeTrackingCursor
DEALLOCATE changeTrackingCursor

IF (1 = (SELECT 1 FROM SYS.CHANGE_TRACKING_DATABASES WHERE DATABASE_ID = DB_ID('@DATABASENAME')))
BEGIN
    ALTER DATABASE [@DATABASENAME] SET CHANGE_TRACKING = OFF
END