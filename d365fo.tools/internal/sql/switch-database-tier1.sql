
Declare @Command as nvarchar(2000)


set @Command =' ALTER DATABASE ['+ @DestinationName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                ALTER DATABASE ['+ @DestinationName + '] MODIFY NAME = [' + @ToBeName + '];
                ALTER DATABASE ['+ @SourceName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                ALTER DATABASE ['+ @SourceName +'] MODIFY NAME = ['+ @DestinationName +'];
                ALTER DATABASE ['+ @DestinationName + '] SET MULTI_USER;
                ALTER DATABASE ['+ @ToBeName + '] SET MULTI_USER;

                ALTER DATABASE ['+ @DestinationName + '] SET AUTO_CLOSE OFF WITH NO_WAIT
                '

exec (@Command)
