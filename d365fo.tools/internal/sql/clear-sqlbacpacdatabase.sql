
update sysglobalconfiguration
set value = 'SQLAZURE'
where name = 'BACKENDDB'

update sysglobalconfiguration
set value = 1
where name = 'TEMPTABLEINAXDB'

drop procedure if exists XU_DisableEnableNonClusteredIndexes
drop procedure if exists SP_ConfigureTablesForChangeTracking
drop procedure if exists SP_ConfigureTablesForChangeTracking_V2

IF  EXISTS(SELECT name FROM sys.schemas WHERE name = 'NT AUTHORITY\NETWORK SERVICE')
BEGIN
	drop schema [NT AUTHORITY\NETWORK SERVICE]
END


IF DATABASE_PRINCIPAL_ID('NT AUTHORITY\NETWORK SERVICE') IS NOT NULL
BEGIN
    drop user [NT AUTHORITY\NETWORK SERVICE]
END

IF DATABASE_PRINCIPAL_ID('axdbadmin') IS NOT NULL
BEGIN
    drop user axdbadmin
END

IF DATABASE_PRINCIPAL_ID('axdeployuser') IS NOT NULL
BEGIN
    drop user axdeployuser
END

IF DATABASE_PRINCIPAL_ID('axmrruntimeuser') IS NOT NULL
BEGIN
    drop user axmrruntimeuser
END

IF DATABASE_PRINCIPAL_ID('axretaildatasyncuser') IS NOT NULL
BEGIN
    drop user axretaildatasyncuser
END

IF DATABASE_PRINCIPAL_ID('axretailruntimeuser') IS NOT NULL
BEGIN
    drop user axretailruntimeuser
END

IF DATABASE_PRINCIPAL_ID('axdeployextuser') IS NOT NULL
BEGIN
    drop user axdeployextuser
END
;

DROP USER IF EXISTS [axdbreadonlyuser];

DISABLE TRIGGER ALL ON dbo.RETAILHARDWAREPROFILE
-- Clear encrypted hardware profile merchand properties
update dbo.RETAILHARDWAREPROFILE set SECUREMERCHANTPROPERTIES = null where SECUREMERCHANTPROPERTIES is not null
;
ENABLE TRIGGER ALL ON dbo.RETAILHARDWAREPROFILE

