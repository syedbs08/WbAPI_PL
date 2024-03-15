CREATE PROCEDURE [dbo].[SP_Validate_SSD_Entries](
	@tvpSSDEntries dbo.[TVP_SSD_ENTRIES] READONLY
	)
AS
BEGIN
	DECLARE @ResultTable  AS dbo.TVP_RESULT_TABLE;

	SET NOCOUNT ON;
	BEGIN TRY
            --BEGIN TRANSACTION;
				
			    DECLARE @tempDuplicateMaterials AS [dbo].[TVP_SSD_ENTRY_DUPLICATE_ITEM];

				-- CHECK CUSTOMER CODE IS PRESENT IN DB
				INSERT INTO @ResultTable
				SELECT RowIndex +1, 104,  'RowNo: ' + CAST(RowIndex +1 AS VARCHAR(10)) + ': ' + [MaterialCode]+' is not valid Model No.' FROM  @tvpSSDEntries WHERE [MaterialId] IS NULL;

				-- CHECK TYPE CODE IS PRESENT IN DB
				INSERT INTO @ResultTable
				SELECT RowIndex +1, 104,  'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + [CustomerCode]+' is not valid Customer.' FROM  @tvpSSDEntries WHERE [CustomerId] IS NULL;

				-- CHECK DUPLICATE
				INSERT INTO @tempDuplicateMaterials
				SELECT [MaterialCode], [CustomerCode],COUNT(*) 
				FROM @tvpSSDEntries GROUP BY [MaterialCode], [CustomerCode] HAVING COUNT(*) > 1;

				INSERT INTO @ResultTable
				SELECT 0, 106, 'Model No: '+ [MaterialCode] +' with Customer: '+[CustomerCode] +' found '+CONVERT(varchar(10),DuplicateCount)+' times.' 
				FROM  @tempDuplicateMaterials;

			
        END TRY
        BEGIN CATCH
				INSERT INTO @ResultTable
				VALUES(0, 500, 'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE());
        END CATCH;

	DELETE @tempDuplicateMaterials;
	SELECT distinct RowNo, ResponseCode, ResponseMessage FROM @ResultTable;

END




GO

----------------
CREATE PROCEDURE [dbo].[SP_Insert_SSD_Entries](
	@tvpSSDEntries dbo.[TVP_SSD_ENTRIES] READONLY,
	@tvpSSDQtyPrices dbo.[TVP_SSD_ENTRY_QTY_PRICES] READONLY,
	@userId nvarchar(100),
	@attachmentId INT)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ResultTable  AS dbo.TVP_RESULT_TABLE;
	BEGIN TRY
            BEGIN TRANSACTION;
			DECLARE @ResultCount INT = 0, @SSDEntryCount INT = 0, @ModeOfTypeCount INT =0;
			DECLARE @tempModeOfType as [dbo].[TVP_MODE_OF_TYPE];

			INSERT INTO @tempModeOfType
			SELECT 
			ROW_NUMBER() OVER(ORDER BY ModeOfTypeCode ASC) AS RowNo, 
			ModeOfTypeId, 
			ModeOfTypeName, 
			ModeOfTypeCode, 
			IsACtive 
			FROM ModeOfType 
			WHERE ModeOfTypeCode in('O', 'P', 'S', 'I', 'ADJ', 'MPO');

			DECLARE @tempSSDEntry AS dbo.[TVP_SSD_ENTRIES];
			DECLARE @tempSSDEntryQtyPrices AS dbo.[TVP_SSD_ENTRY_QTY_PRICES];

			INSERT INTO @tempSSDEntry
			SELECT 
			ROW_NUMBER() OVER(ORDER BY tvp.RowIndex ASC) AS RowNo,
			tvp.RowIndex,
			tvp.[ModeofTypeId],
			customer.[CustomerId],
			tvp.[CustomerCode],
			material.[MaterialId],
			tvp.[MaterialCode],
			@attachmentId
			FROM @tvpSSDEntries as tvp
			LEFT JOIN dbo.Customer AS customer ON tvp.[CustomerCode] = customer.[CustomerCode]
			LEFT JOIN dbo.Material AS material ON material.MaterialCode = tvp.[MaterialCode];

			INSERT INTO @tempSSDEntryQtyPrices
				SELECT 
				tempSSD.RowNo,
				tvpQtyPrices.RowIndex,
				tvpQtyPrices.ColIndex,
				tvpQtyPrices.MonthYear,
				tvpQtyPrices.Qty,
				tvpQtyPrices.Price
				FROM @tvpSSDQtyPrices as tvpQtyPrices
				INNER JOIN @tempSSDEntry as tempSSD ON tvpQtyPrices.RowIndex = tempSSD.RowIndex;

			--SELECT * FROM @tempSSDEntry;
			--VALIDATE SP CALL
			INSERT INTO @ResultTable
			EXEC [dbo].[SP_Validate_SSD_Entries] @tempSSDEntry;

			IF NOT EXISTS(SELECT TOP 1 1 FROM @ResultTable)
			BEGIN
				--Archive SNS entries data
				BEGIN
					INSERT INTO [dbo].[SSDEntryArchive]
				   (
				   [SSDEntryArchiveId]
				   ,[ModeofTypeId]
				   ,[CustomerId]
				   ,[CustomerCode]
				   ,[MaterialId]
				   ,[MaterialCode]
				   ,[AttachmentId]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   ,[UpdatedDate]
				   ,[UpdatedBy])
					SELECT SSDEntryId
					,[ModeofTypeId]
				   ,[CustomerId]
				   ,[CustomerCode]
				   ,[MaterialId]
				   ,[MaterialCode]
				   ,[AttachmentId]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   ,[UpdatedDate]
				   ,[UpdatedBy]
				   FROM [dbo].[SSDEntry];

				   INSERT INTO [dbo].[SSDEntryQtyPriceArchive]
				   ([SSDEntryQtyPriceArchiveId]
				   ,[SSDEntryArchiveId]
				   ,[MonthYear]
				   ,[Qty]
				   ,[Price]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   ,[UpdatedDate]
				   ,[UpdatedBy])
				   SELECT [SSDEntryQtyPriceId]
				   ,[SSDEntryId]
				   ,[MonthYear]
				   ,[Qty]
				   ,[Price]
				   ,[CreatedDate]
				   ,[CreatedBy]
				   ,[UpdatedDate]
				   ,[UpdatedBy]
				   FROM [dbo].[SSDEntryQtyPrice];

				   DELETE FROM [dbo].[SSDEntryQtyPrice];
				   DELETE FROM [dbo].[SSDEntry];
				   
				END
				--INSERT NEW ENTRIES
				BEGIN
					SELECT @ResultCount = count(1) FROM @tempSSDEntry;
					SELECT @SSDEntryCount = count(1) FROM @tempSSDEntry;
					SELECT @ModeOfTypeCount = count(1) FROM @tempModeOfType;
					DECLARE @SSDEntryIndex INT = 1;
					WHILE (@SSDEntryIndex <= @SSDEntryCount)
					BEGIN
						DECLARE @ModeOfTypeIndex INT = 1;
						DECLARE @ModeOfTypeCode [nvarchar](10) = '';
						DECLARE @ModeofTypeId [int] = 0;
						WHILE (@ModeOfTypeIndex <= @ModeOfTypeCount)
						BEGIN
							SELECT @ModeOfTypeCode = [ModeofTypeCode], @ModeofTypeId = [ModeofTypeId] 
							FROM @tempModeOfType WHERE RowNo = @ModeOfTypeIndex;

							DECLARE @SSDEntry_LastId INT = 0;

							INSERT INTO [dbo].[SSDEntry]
						   ([ModeofTypeId]
						   ,[CustomerId]
						   ,[CustomerCode]
						   ,[MaterialId]
						   ,[MaterialCode]
						   ,[AttachmentId]
						   ,[CreatedDate]
						   ,[CreatedBy]
						   ,[UpdatedDate]
						   ,[UpdatedBy])
						   SELECT
							@ModeofTypeId
							,[CustomerId]
							,[CustomerCode]
							,[MaterialId]
							,[MaterialCode]
							,@attachmentId
							,GETDATE()
							,@userId
							,GETDATE()
							,@userId
						   FROM @tempSSDEntry where RowNo=@SSDEntryIndex;

						   SELECT @SSDEntry_LastId = SCOPE_IDENTITY();

						   IF @ModeOfTypeCode = 'O'
						   BEGIN
							INSERT INTO [dbo].[SSDEntryQtyPrice]
							   ([SSDEntryId]
							   ,[MonthYear]
							   ,[Qty]
							   ,[Price]
							   ,[CreatedDate]
							   ,[CreatedBy]
							   ,[UpdatedDate]
							   ,[UpdatedBy])
							   SELECT @SSDEntry_LastId
							   ,[MonthYear]
							   ,[Qty]
							   ,[Price]
							   ,GETDATE()
								,@userId
								,GETDATE()
								,@userId
								FROM @tempSSDEntryQtyPrices WHERE RowNo = @SSDEntryIndex;
						   END
						   ELSE
						   BEGIN
								INSERT INTO [dbo].[SSDEntryQtyPrice]
							   ([SSDEntryId]
							   ,[MonthYear]
							   ,[Qty]
							   ,[Price]
							   ,[CreatedDate]
							   ,[CreatedBy]
							   ,[UpdatedDate]
							   ,[UpdatedBy])
							   SELECT @SSDEntry_LastId
							   ,[MonthYear]
							   ,0
							   ,0
							   ,GETDATE()
								,@userId
								,GETDATE()
								,@userId
								FROM @tempSSDEntryQtyPrices WHERE RowNo = @SSDEntryIndex;
						   END

						   SET @ModeOfTypeIndex  = @ModeOfTypeIndex+1;
						END
						SET @SSDEntryIndex  = @SSDEntryIndex+1;
					END
					
				END
			END

			IF @@TRANCOUNT > 0
				COMMIT;

			IF NOT EXISTS(SELECT 1 FROM @ResultTable) 
				INSERT INTO @ResultTable
				VALUES(0, 200,(CONVERT(varchar(10), @ResultCount)+' Records'));
		
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
		INSERT INTO @ResultTable
		VALUES(0, 500, 'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE());
    END CATCH;
	
	DELETE @tempSSDEntry;
	DELETE @tempSSDEntryQtyPrices;
	DELETE @tempModeOfType;
	SELECT distinct RowNo, ResponseCode, ResponseMessage FROM @ResultTable;

END
GO
