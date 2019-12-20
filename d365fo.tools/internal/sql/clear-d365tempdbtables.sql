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
	and O.create_date < GETDATE() - @Days
	
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