-- This query returns the database name and first associated data file
-- for each user database on the server
-- Author: Colin Daley
-- Date: 2026-11-16
--
WITH DataFiles AS
(
    SELECT
        database_id,
        name AS LogicalFileName,
        ROW_NUMBER() OVER
        (
            PARTITION BY database_id
            ORDER BY file_id
        ) AS rn
    FROM sys.master_files
    WHERE type = 0
)
SELECT
    db.name AS [Name],
    df.LogicalFileName
FROM sys.databases AS db
LEFT JOIN DataFiles AS df
    ON db.database_id = df.database_id
    AND df.rn = 1
WHERE db.Name NOT IN ('master', 'model', 'msdb', 'tempdb')
ORDER BY db.name;
