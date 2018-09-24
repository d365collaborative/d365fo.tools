
DECLARE @kill varchar(8000) = '';

SELECT @kill = @kill + 'KILL ' + CONVERT(varchar(5), c.session_id) + ';'

FROM sys.dm_exec_connections AS c
JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
WHERE db_name(database_id) = '@Database' and  c.session_id <> @@SPID
exec (@kill)

DROP DATABASE [@Database]

--File should be obsolute