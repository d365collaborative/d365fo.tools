/*Variable input @Id */
DROP TABLE IF EXISTS #TempSecurityUserRole
DROP TABLE IF EXISTS #TempRecIds

BEGIN TRANSACTION

SET NOCOUNT ON;

DECLARE @TableId AS int
        ,@RecId AS bigint
		,@AdminUserId as NVARCHAR(40) = 'Admin'
		,@InitialPartionKey as nvarchar(10) = 'initial'


SELECT SECURITYUSERROLE.* 
INTO #TempSecurityUserRole
FROM SECURITYUSERROLE 
JOIN [PARTITIONS] ON [PARTITIONS].Recid = SECURITYUSERROLE.PARTITION
WHERE [User_] = @AdminUserId
AND PARTITIONKEY = @InitialPartionKey

SELECT [RECID] 
INTO #TempRecIds
FROM #TempSecurityUserRole

SELECT @TableId = TableId
FROM SQLDICTIONARY
WHERE [NAME] = 'SECURITYUSERROLE'
AND FIELDID = 0 

/* We need to update SYSTEMSEQUENCES with the highest RECID in the table now*/
UPDATE SYSTEMSEQUENCES
SET NEXTVAL = (1 + (SELECT MAX(RECID) FROM SECURITYUSERROLE))
WHERE TABID = @TableId AND [NAME] = 'SEQNO'

 Declare @IsSeqNumThere as int
select @IsSeqNumThere = count(1) from SYSTEMSEQUENCES
  WHERE TABID = @TableId  AND [NAME] = 'SEQNO'

DECLARE @CurrentRowId AS BIGINT
 
SET @CurrentRowId = (SELECT MIN(RECID) FROM #TempRecIds)
 
WHILE @CurrentRowId IS NOT NULL
BEGIN

	if(@IsSeqNumThere = 1)
	BEGIN

		SELECT @RecId = NEXTVAL
		FROM SYSTEMSEQUENCES WHERE TABID = @TableId
		AND [NAME] = 'SEQNO'
	
		UPDATE SYSTEMSEQUENCES
		SET NEXTVAL = @RecId +1 WHERE TABID = @TableId
		AND [NAME] = 'SEQNO'
		END
	if(@IsSeqNumThere = 0)
	BEGIN
		SELECT @RecId = MAX(RECID)+1 FROM SECURITYUSERROLE
	end

	UPDATE #TempSecurityUserRole
	SET 
	[RECID] = @RecId
	,[User_] = @Id
	WHERE [RECID] = @CurrentRowId
	


	SET @CurrentRowId = (SELECT MIN(RECID) FROM #TempRecIds WHERE RECID > @CurrentRowId)
END

INSERT INTO SECURITYUSERROLE
SELECT * FROM #TempSecurityUserRole

DROP TABLE #TempSecurityUserRole
DROP TABLE #TempRecIds


commit TRANSACTION





Declare @AdminSecurityRoleCount as int

SELECT @AdminSecurityRoleCount = count(1) 
FROM SECURITYUSERROLE 
JOIN [PARTITIONS] ON [PARTITIONS].Recid = SECURITYUSERROLE.PARTITION
WHERE [User_] = @AdminUserId
AND PARTITIONKEY = @InitialPartionKey

Declare @ImportSecurityRoleCount as int

SELECT @ImportSecurityRoleCount = count(1) 
FROM SECURITYUSERROLE 
JOIN [PARTITIONS] ON [PARTITIONS].Recid = SECURITYUSERROLE.PARTITION
WHERE [User_] = @Id
AND PARTITIONKEY =  @InitialPartionKey

SET Nocount OFF;

select @AdminSecurityRoleCount - @ImportSecurityRoleCount
