update userinfo
set [ENABLE] = 0,RECVERSION = RECVERSION +1 output deleted.ID ,deleted.NAME,deleted.NETWORKALIAS
where NETWORKALIAS like @Email
and [ENABLE] = 1
