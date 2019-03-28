SELECT name FROM sys.databases
WHERE NAME NOT IN
('master', 'model', 'msdb', 'tempdb')
