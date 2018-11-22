
Declare @Command as nvarchar(2000)


set @Command =' ALTER DATABASE ['+ @OrigName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                ALTER DATABASE ['+ @OrigName + '] MODIFY NAME = [' + @OrigName + '_original];
                ALTER DATABASE ['+ @NewName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                ALTER DATABASE ['+ @NewName +'] MODIFY NAME = ['+ @OrigName +'];
                ALTER DATABASE ['+ @OrigName + '] SET MULTI_USER;
                ALTER DATABASE ['+ @OrigName + '_original] SET MULTI_USER;
                '

exec (@Command)
