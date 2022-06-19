
Declare @Command as nvarchar(2000)


set @Command =' ALTER DATABASE ['+ @DestinationName + '] MODIFY NAME = [' + @ToBeName + '];
                ALTER DATABASE ['+ @SourceName +'] MODIFY NAME = ['+ @DestinationName +'];
                '

exec (@Command)