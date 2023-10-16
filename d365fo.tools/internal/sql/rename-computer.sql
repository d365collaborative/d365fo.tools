BEGIN TRY
	EXEC sp_dropserver @@SERVERNAME;
END TRY
BEGIN CATCH
	PRINT 'Old SQL server name could not be dropped!'
END CATCH

EXEC sp_addserver [@NewComputerName], local;
