DROP TABLE IF EXISTS #usersdisabled

SELECT ID, [NAME], NETWORKALIAS
INTO #usersdisabled
FROM userinfo
where NETWORKALIAS like @Email
and [ENABLE] = 1

update userinfo
set [ENABLE] = 0,RECVERSION = RECVERSION +1
where NETWORKALIAS like @Email
and [ENABLE] = 1
AND [Id] <> 'admin'

SELECT ID, [NAME], NETWORKALIAS
FROM #usersdisabled

DROP TABLE IF EXISTS #usersdisabled