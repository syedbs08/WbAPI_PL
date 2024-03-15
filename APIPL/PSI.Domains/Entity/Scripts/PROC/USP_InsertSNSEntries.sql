
ALTER PROCEDURE [dbo].[USP_InsertSNSEntries] (
	@OACID INT
	,@tvpSNSEntries [dbo].[TVP_SNS_ENTRIES] READONLY
	,@tvpSNSPrice dbo.TVP_SNS_PRICE_INFO READONLY
	,@tvpSNSQuantities dbo.TVP_SNS_QTY_INFO READONLY
	,@userId NVARCHAR(200)
	,@SaleSubType NVARCHAR(20)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                            
	-- interfering with SELEaCT statements.                            
	SET NOCOUNT ON

	-- TEMP TABLE FOR RETURN MESSAGE                            
	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	CREATE TABLE #TMP (
		ResponseCode VARCHAR(20)
		,ResponseMessage NVARCHAR(max)
		)

	-- Insert statements for procedure here                            
	BEGIN TRY
		BEGIN TRANSACTION;

		-- OAC Code--                            
		DECLARE @OACCode VARCHAR(20);
		
		SET @OACCode = (
				SELECT AccountCode
				FROM Account
				WHERE AccountId = @OACID
				)

		-- Current Month Year from Global Config--                          
		DECLARE @CurrentMonth VARCHAR(10);

		IF (@SaleSubType = 'Monthly')
		BEGIN
			SET @CurrentMonth = (
					SELECT ConfigValue
					FROM GlobalConfig
					WHERE ConfigKey = 'Current_Month'
						AND ConfigType = 'Direct And SNS'
					)
		END
		ELSE
		BEGIN
			SET @CurrentMonth = (
					SELECT ConfigValue
					FROM GlobalConfig
					WHERE ConfigKey = 'BP_Year'
					)
		END

		DECLARE @InValidCustomer TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);
		DECLARE @InValidSNSCustomer TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);
		DECLARE @InValidCustomerAccountMapping TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);

		INSERT INTO @InValidCustomer (
			CustomerCode
			,RowIndex
			)
		SELECT SE.CustomerCode
			,SE.RowNum
		FROM @tvpSNSEntries SE
		LEFT JOIN Customer c ON SE.CustomerCode = c.CustomerCode
		WHERE c.CustomerCode IS NULL

		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM @InValidCustomer
				)
		BEGIN
			-- CustomerIS SNS Customer                            
			INSERT INTO @InValidSNSCustomer (
				CustomerCode
				,RowIndex
				)
			SELECT DISTINCT SE.CustomerCode
				,SE.RowNum
			FROM @tvpSNSEntries SE
			LEFT JOIN (
				SELECT C.CustomerId
					,C.CustomerCode
					,CD.AccountId
					,CD.SaleTypeId
				FROM Customer C
				INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId
				) a ON SE.CustomerCode = a.CustomerCode
				AND SE.SaleTypeId = a.SaleTypeId
			WHERE a.CustomerCode IS NULL

			-- Customer mapped account                            
			INSERT INTO @InValidCustomerAccountMapping (
				CustomerCode
				,RowIndex
				)
			SELECT DISTINCT SE.CustomerCode
				,SE.RowNum
			FROM @tvpSNSEntries SE
			LEFT JOIN (
				SELECT C.CustomerId
					,C.CustomerCode
					,CD.AccountId
					,CD.SaleTypeId
				FROM Customer C
				INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId
				) a ON SE.CustomerCode = a.CustomerCode
				AND a.AccountId = @OACID
			WHERE a.CustomerCode IS NULL
		END

		-- Table variable for Material                            
		DECLARE @InValidMaterial TABLE (
			MaterialCode VARCHAR(200)
			,RowIndex INT
			);

		INSERT INTO @InValidMaterial (
			MaterialCode
			,RowIndex
			)
		SELECT SE.MaterialCode
			,SE.RowNum
		FROM @tvpSNSEntries SE
		LEFT JOIN Material M ON SE.MaterialCode = M.MaterialCode
		WHERE M.MaterialId IS NULL

		DECLARE @InValidModeleProdcutCategory TABLE (
			CategoryID INT
			,MaterialCode VARCHAR(200)
			,RowIndex INT
			)

		INSERT INTO @InValidModeleProdcutCategory (
			CategoryID
			,MaterialCode
			,RowIndex
			)
		SELECT T.CategoryID
			,T.MaterialCode
			,T.RowNum
		FROM @tvpSNSEntries T
		LEFT JOIN ProductCategory P ON P.ProductCategoryCode = Cast(T.CategoryID AS VARCHAR)
			AND P.ProductCategoryName = T.Category
		LEFT JOIN Material M ON (
				P.ProductCategoryId = M.ProductCategoryId1
				OR P.ProductCategoryId = M.ProductCategoryId2
				OR P.ProductCategoryId = M.ProductCategoryId3
				OR P.ProductCategoryId = M.ProductCategoryId4
				OR P.ProductCategoryId = M.ProductCategoryId5
				OR P.ProductCategoryId = M.ProductCategoryId6
				)
		WHERE M.MaterialId IS NULL

		IF (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidCustomer
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidMaterial
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidMaterial
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidModeleProdcutCategory
					)
				)
			--AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))      
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidSNSCustomer
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidCustomerAccountMapping
					)
				)
		BEGIN
			--- IF EVERY THING FINE-- THEN MOVE THAT CODE IN ARCHIVE TABLE                            
			INSERT INTO [dbo].[SNSEntryArchive] (
				[SNSEntryID]
				,[SaleTypeId]
				,[CustomerId]
				,[CustomerCode]
				,[MaterialId]
				,[MaterialCode]
				,[CategoryId]
				,[Category]
				,[AttachmentId]
				,[MonthYear]
				,[CreatedDate]
				,[CreatedBy]
				,[UpdatedDate]
				,[UpdatedBy]
				,[ModeofTypeId]
				,[ArchiveDate]
				,[ArchiveBy]
				,[ArchiveStatus]
				,[OACCode]
				,[SaleSubType]
				)
			SELECT SE.[SNSEntryID]
				,SE.[SaleTypeId]
				,SE.[CustomerId]
				,SE.[CustomerCode]
				,SE.[MaterialId]
				,SE.[MaterialCode]
				,SE.[CategoryId]
				,SE.[Category]
				,SE.[AttachmentId]
				,SE.[MonthYear]
				,SE.[CreatedDate]
				,SE.[CreatedBy]
				,SE.[UpdatedDate]
				,SE.[UpdatedBy]
				,SE.[ModeofTypeId]
				,GETDATE()
				,SE.[CreatedBy]
				,'Y'
				,SE.[OACCode]
				,SE.SaleSubType
			FROM SNSEntry SE
			INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode
				AND T.MaterialCode = SE.MaterialCode
			WHERE MonthYear = @CurrentMonth
				AND SaleSubType = @SaleSubType
				AND OACCode = @OACCode

			INSERT INTO [dbo].[SNSEntryQtyPriceArchive] (
				[SNSEntryQtyPriceId]
				,[SNSEntryId]
				,[MonthYear]
				,[Qty]
				,[Price]
				,[TotalAmount]
				,[Currency]
				,[CreatedDate]
				,[CreatedBy]
				,[UpdatedDate]
				,[UpdatedBy]
				,[ArchiveDate]
				,[ArchiveBy]
				,[ArchiveStatus]
				)
			SELECT SP.[SNSEntryQtyPriceId]
				,SP.[SNSEntryId]
				,SP.[MonthYear]
				,SP.[Qty]
				,SP.[Price]
				,SP.[TotalAmount]
				,SP.[Currency]
				,SP.[CreatedDate]
				,SP.[CreatedBy]
				,SP.[UpdatedDate]
				,SP.[UpdatedBy]
				,GETDATE()
				,SP.[UpdatedBy]
				,'Y'
			FROM (
				SELECT SE.SNSEntryId
					,SE.CustomerCode
				FROM SNSEntry SE
				INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode
					AND SE.MaterialCode = SN.MaterialCode
				WHERE
					--SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)               
					se.MonthYear = @CurrentMonth
					AND OACCode = @OACCode
					AND se.SaleSubType = @SaleSubType
				) a
			INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId

			---- DELETE FROM SNSEntryQtyPrice                            
			DELETE
			FROM SNSEntryQtyPrice
			WHERE SNSEntryID IN (
					SELECT SP.SNSEntryId
					FROM (
						SELECT SE.SNSEntryId
							,SE.CustomerCode
						FROM SNSEntry SE
						INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode
							AND SE.MaterialCode = SN.MaterialCode
						WHERE
							--SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)               
							SE.MonthYear = @CurrentMonth
							AND OACCode = @OACCode
							AND se.SaleSubType = @SaleSubType
						) a
					INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId
					)

			-- -- DELETE FROM SNSEntry TABLE              
			DELETE
			FROM SNSEntry
			WHERE SNSEntryId IN (
					SELECT SE.SNSEntryId
					FROM SNSEntry SE
					INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode
						AND T.MaterialCode = SE.MaterialCode
					WHERE
						--MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112))                 
						MonthYear = @CurrentMonth
					)
				AND OACCode = @OACCode
				AND SaleSubType = @SaleSubType

			DECLARE @TOTALCOUNT INT;
			DECLARE @SNS_LASTIDENTITY INT = 0;
			DECLARE @SNS TABLE (
				[CustomerID] INT
				,[CustomerCode] NVARCHAR(20)
				,[MaterialID] INT
				,[MaterialCode] NVARCHAR(20)
				,[CategoryID] INT
				,[Category] NVARCHAR(500)
				,[AttachmentID] INT
				,EXLROWNUM INT
				,[SaleTypeId] INT
				,[ModeofTypeId] INT
				,RN INT
				)

			INSERT INTO @SNS (
				[CustomerID]
				,CustomerCode
				,MaterialCode
				,CategoryID
				,[Category]
				,MaterialID
				,AttachmentID
				,EXLROWNUM
				,[SaleTypeId]
				,[ModeofTypeId]
				,RN
				)
			SELECT C.CustomerID
				,C.[CustomerCode]
				,SE.[MaterialCode]
				,[CategoryID]
				,[Category]
				,M.MaterialID
				,[AttachmentID]
				,[RowNum]
				,[SaleTypeId]
				,[ModeofTypeId]
				,ROW_NUMBER() OVER (
					ORDER BY C.[CustomerCode]
					)
			FROM @tvpSNSEntries SE
			INNER JOIN Material M ON SE.MaterialCode = M.MaterialCode
			INNER JOIN Customer C ON SE.CustomerCode = C.CustomerCode

			DECLARE @tvpAccontCodeList AS dbo.[TVP_CODE_LIST];
			DECLARE @TVPAccountCodeMaterialCodeList AS dbo.[TVP_ACCOUNT_MATERIAL_CODE_LIST];
			DECLARE @tvpMaterialCodeList AS dbo.[TVP_CODE_LIST];
			DECLARE @TvpSNSIdList AS dbo.[TVP_ID_LIST];
			DECLARE @TVPMonthList AS dbo.[TVP_ID_LIST];

			-- SET TOTAL COUNT --                            
			SET @TOTALCOUNT = (
					SELECT COUNT(*)
					FROM @SNS
					)

			DECLARE @STARTFROM INT = 1;

			-- SELECT * FROM @SNS                            
			WHILE @STARTFROM <= @TOTALCOUNT
			BEGIN
				--SELECT * FROM @SNS                            
				DECLARE @ROWNUM INT

				SET @ROWNUM = (
						SELECT EXLROWNUM
						FROM @SNS
						WHERE RN = @STARTFROM
						)

				--SELECT @ROWNUM                            
				INSERT INTO SNSEntry (
					[CustomerID]
					,[CustomerCode]
					,[MaterialID]
					,[MaterialCode]
					,[CategoryID]
					,[Category]
					,[AttachmentID]
					,[SaleTypeId]
					,[ModeofTypeId]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					,[MonthYear]
					,[OACCode]
					,[SaleSubType]
					)
				SELECT CustomerID
					,CustomerCode
					,MaterialID
					,MaterialCode
					,CategoryID
					,Category
					,AttachmentID
					,[SaleTypeId]
					,[ModeofTypeId]
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
					,@CurrentMonth -- CONVERT(NVARCHAR(6), GETDATE(), 112)                            
					,@OACCode
					,@SaleSubType
				FROM @SNS
				WHERE RN = @STARTFROM

				SELECT @SNS_LASTIDENTITY = SCOPE_IDENTITY();

				-- INSERT INTO [dbo].[SNSEntryQtyPrice] TABLE                            
				INSERT INTO [dbo].[SNSEntryQtyPrice] (
					[SNSEntryID]
					,[MonthYear]
					,[Qty]
					,[Price]
					,[TotalAmount]
					,[Currency]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					)
				SELECT @SNS_LASTIDENTITY
					,P.[MonthYear]
					,[Qty]
					,CAST([Price] AS DECIMAL(18, 2))
					,[Qty] * [Price]
					,'USD'
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
				FROM @tvpSNSQuantities Q
				INNER JOIN @tvpSNSPrice P ON Q.[RowNum] = P.[RowNum]
					AND Q.[MonthYear] = P.[MonthYear]
				WHERE Q.[RowNum] = @ROWNUM

				INSERT INTO @tvpAccontCodeList
				SELECT @OACCode;

				INSERT INTO @tvpMaterialCodeList
				SELECT MaterialCode
				FROM @SNS
				WHERE RN = @STARTFROM

				INSERT INTO @TVPAccountCodeMaterialCodeList
				SELECT @OACCode
					,MaterialCode
				FROM @SNS
				WHERE RN = @STARTFROM

				INSERT INTO @TvpSNSIdList
				SELECT @SNS_LASTIDENTITY

				SET @STARTFROM = @STARTFROM + 1
			END

			insert @TVPMonthList (ID) select distinct MonthYear from @tvpSNSQuantities;
			--- UPDATE PRICE FROM PRICING                          
			-- EXEC  USP_UpdateFinalPrice @CurrentMonth                          
			INSERT INTO @ResultTable (
				[ResponseCode]
				,[ResponseMessage]
				)
			VALUES (
				200
				,'Added ' + CAST(@TOTALCOUNT AS NVARCHAR(10)) + ' Record successfully'
				);
		END

		----- INSERT INVALID CUSTOMER NAME AND CODE                            
		--   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                            
		--   SELECT 107,' : Customer Code : ' +CustomerCode +' not belong to this Customer.' from @InValidCustomerName                            
		--- INSERT INVALID  CUSTOMER                            
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not correct.'
		FROM @InValidCustomer

		--- INSERT INVALID SNS CUSTOMER                            
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not SNS Customer.'
		FROM @InValidSNSCustomer

		--- INSERT INVALID CUSTOMER Account Mapping                           
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not belong to this account.'
		FROM @InValidCustomerAccountMapping

		--- INSERT INVALID MATERIAL                            
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Material Code : ' + MaterialCode + ' is not model.'
		FROM @InValidMaterial

		-- INSERT INVALID PRODUCTCATEGORY AND MODEL                            
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Product category : ' + CAST(CategoryID AS VARCHAR(10)) + ' and Material Code : ' + MaterialCode + ' is not a mapped.'
		FROM @InValidModeleProdcutCategory

		
			IF (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidCustomer
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidMaterial
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidMaterial
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidModeleProdcutCategory
						)
					)
				--AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))      
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidSNSCustomer
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidCustomerAccountMapping
						)
					)
			BEGIN
			
					IF (@SaleSubType = 'Monthly')
		BEGIN
		EXEC [dbo].[sp_Insert_TRNSalesPlanning] @TvpSNSIdList
					,@CurrentMonth
					,@userId
					,@SaleSubType;
		EXEC [dbo].[SP_Calculate_RollingInventory] @userId
					,@TVPAccountCodeMaterialCodeList;
						
		end
		--else
		--begin
		--EXEC [dbo].[SP_Insert_TRNSalesPlanning_BP] @TvpSNSIdList
		--			,@CurrentMonth
		--			,@userId
		--			,@SaleSubType;
		--EXEC [dbo].[SP_Calculate_RollingInventory_BP] @userId
		--			,@TVPAccountCodeMaterialCodeList,
		--			@TVPMonthList,@CurrentMonth;
		--end
			END
		

		--COMMIT TRANSACTION TRANS;  
		IF @@TRANCOUNT > 0
			COMMIT;
	END TRY

	BEGIN CATCH
		--ROLLBACK TRANSACTION TRANS;  
		IF @@TRANCOUNT > 0
			ROLLBACK;

		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
