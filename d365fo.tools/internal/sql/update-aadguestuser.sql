update userinfo
set NETWORKDOMAIN = @networkDomain,
IDENTITYPROVIDER = @identityProvider,
OBJECTID = @objectId
where [ID] = @id
AND [Id] <> 'admin'
