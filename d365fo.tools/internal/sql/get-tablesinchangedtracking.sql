USE [@DATABASENAME]

SELECT t.name
FROM sys.change_tracking_tables ct
INNER JOIN sys.tables t ON ct.object_id = t.object_id
ORDER BY T.[name]