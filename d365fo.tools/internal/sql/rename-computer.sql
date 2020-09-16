EXEC sp_dropserver [@OldComputerName];

EXEC sp_addserver [@NewComputerName], local;
