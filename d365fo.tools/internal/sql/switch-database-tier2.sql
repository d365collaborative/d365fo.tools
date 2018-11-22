
Declare @Command as nvarchar(2000)


set @Command =' ALTER DATABASE ['+ @OrigName + '] MODIFY NAME = [' + @OrigName + '_original];
                ALTER DATABASE ['+ @NewName +'] MODIFY NAME = ['+ @OrigName +'];
                '

exec (@Command)
