

  /*Variable input @Id,@SignInName,@Name,@SID, @StartUpCompany, @NetworkDomain, @IdentityProvider */

BEGIN TRANSACTION

begin TRY

DROP TABLE IF EXISTS #TempUser 

SET Nocount ON;

DECLARE @TableId AS int,
        @RecId AS bigint,
		@ExistsCompany as int

SELECT @ExistsCompany = count(1) 
  FROM [dbo].[DIRPARTYTABLE]
  join dbo.[PARTITIONS] p on p.RECID = DIRPARTYTABLE.PARTITION
  where DATAAREA = @StartUpCompany

  if(@ExistsCompany = 0)
	set @StartUpCompany ='dat'


	/* Get new recid for userInfo */
	SELECT @TableId = TableId
	FROM SQLDICTIONARY
	WHERE [NAME] = 'USERINFO'
	  AND FIELDID = 0 
  
  /* We need to update SYSTEMSEQUENCES with the highest RECID in the table now*/
  Declare @IsSeqNumThere as int
  select @IsSeqNumThere = count(1) from SYSTEMSEQUENCES
  WHERE TABID = @TableId  AND [NAME] = 'SEQNO'

  if(@IsSeqNumThere = 1)
  begin

  UPDATE SYSTEMSEQUENCES
  SET NEXTVAL = (1 + (SELECT MAX(RECID) FROM USERINFO))
  WHERE TABID = @TableId AND [NAME] = 'SEQNO'

  SELECT @RecId = NEXTVAL
  FROM SYSTEMSEQUENCES WHERE TABID = @TableId
  AND [NAME] = 'SEQNO'
  
  UPDATE SYSTEMSEQUENCES
  SET NEXTVAL = @RecId +1 WHERE TABID = @TableId
  AND [NAME] = 'SEQNO'
  end

  if(@IsSeqNumThere = 0)
  begin
	SELECT @RecId = MAX(RECID)+1 FROM USERINFO
  end


  
/* Get Admin to copy */
SELECT top 1 userInfo.* INTO #TempUser
FROM userinfo
JOIN [PARTITIONS] ON [PARTITIONS].Recid = userinfo.PARTITION
WHERE id = 'admin'
  AND PARTITIONKEY = 'initial'


/*Change row to match the new user */
UPDATE #TempUser
  SET [RECID] = @RecId
	  ,[ID] = @Id
	  ,[Name] = @Name
	  ,[SID] = @SID
	  ,[COMPANY] = @StartUpCompany
    ,[NETWORKALIAS] = @SignInName
	  ,RECVERSION = 1
    ,[NETWORKDOMAIN] = @NetworkDomain
    ,[IDENTITYPROVIDER] = @IdentityProvider
    ,[OBJECTID] = @ObjectId
    ,[EXTERNALID] = ''
    


/* Create the user */

INSERT INTO userinfo
	SELECT * FROM #TempUser

DROP TABLE #TempUser

COMMIT TRANSACTION

end TRY

begin CATCH 
ROLLBACK TRANSACTION

end CATCH

SET Nocount OFF;
select count(1) from userinfo
where [RECID] = @Recid