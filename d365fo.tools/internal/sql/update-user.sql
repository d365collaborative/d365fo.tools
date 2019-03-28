update userinfo
set [sid] = @sid,
NETWORKDOMAIN = @networkDomain,
IDENTITYPROVIDER = @identityProvider
, COMPANY = CASE WHEN @Company IS NULL THEN COMPANY ELSE @Company END
where [ID] = @id
AND [Id] <> 'admin'