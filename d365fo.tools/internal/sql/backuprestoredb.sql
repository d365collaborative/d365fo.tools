Declare @BackupTo as varchar(404) = @BackupDirectory + '\' + @NewName + '.bak'
Declare @BackupName as varchar(150) = @NewName + 'Bacpac full database backup'
Declare @BackupCommand as varchar(1000)

set @BackupCommand = 'BACKUP DATABASE ['  + @CurrentDatabase + '] TO  DISK = '''  + @BackupTo + ''' WITH COPY_ONLY, COMPRESSION, NOFORMAT, INIT,  NAME = ''' + @BackupName + ''', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
exec (@BackupCommand)

Declare @MoveCommand as nvarchar(1000)
Declare @MoveResult as nvarchar(1000)

SELECT  @MoveCommand =  'select @MoveResult = STUFF(( select '',Move '''''' + name + '''''' to '''''' +  LEFT([filename],LEN([filename]) - charindex(''\'',reverse([filename]),1) + 1) +''' + @NewName + ''' + RIGHT([filename], CHARINDEX(''.'', REVERSE([filename]))) +'''''''' from sys.sysfiles FOR XML PATH('''')), 1, 1, '''')'
exec sp_executesql  @MoveCommand,N'@MoveResult varchar(1000) output',@MoveResult output

Declare @RestoreCommand as varchar(4000)

set  @RestoreCommand =  ' RESTORE DATABASE [' + @NewName + '] FROM  DISK = ''' + @BackupTo + ''' WITH  FILE = 1, ' + @MoveResult + ',  NOUNLOAD,  REPLACE, STATS = 5'
              
exec (@RestoreCommand)
