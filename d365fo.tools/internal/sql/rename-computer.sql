BEGIN TRY
	EXEC sp_dropserver [@OldComputerName];
END TRY
BEGIN CATCH
	PRINT '@OldComputerName could not be dropped!'
END CATCH

EXEC sp_addserver [@NewComputerName], local;
