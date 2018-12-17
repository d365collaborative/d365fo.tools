DROP TABLE IF EXISTS #usersenabled

SELECT ID, [NAME], NETWORKALIAS
INTO #usersenabled
FROM userinfo
where NETWORKALIAS like @Email
and [ENABLE] = 0

update userinfo
set [ENABLE] = 1,RECVERSION = RECVERSION +1
where NETWORKALIAS like @Email
and [ENABLE] = 0

SELECT ID, [NAME], NETWORKALIAS
FROM #usersenabled

DROP TABLE IF EXISTS #usersenabled