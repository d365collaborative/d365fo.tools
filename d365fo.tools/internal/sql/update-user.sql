update userinfo
set [sid] = @sid,
NETWORKDOMAIN = @networkDomain,
IDENTITYPROVIDER = @identityProvider
where [ID] = @id
