update userinfo
set [ENABLE] = 1,RECVERSION = RECVERSION +1 output deleted.ID ,deleted.NAME,deleted.NETWORKALIAS
where NETWORKALIAS like @Email
and [ENABLE] = 0
