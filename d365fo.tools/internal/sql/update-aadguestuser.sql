update userinfo
set NETWORKDOMAIN = @networkDomain,
IDENTITYPROVIDER = @identityProvider
where [ID] = @id
AND [Id] <> 'admin'
