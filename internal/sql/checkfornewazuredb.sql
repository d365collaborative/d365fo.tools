USE MASTER
SELECT * FROM sys.dm_database_copies WHERE Partner_database = @NewName