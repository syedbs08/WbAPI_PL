DROP PROCEDURE IF EXISTS [dbo].[SP_Get_Customer_Country_Currency];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Get_Customer_Country_Currency]                                                           
(@customerId INT)               
                              
AS 
BEGIN                    
           SET NOCOUNT ON;
		   SELECT CS.CustomerId, CS.CustomerCode, CN.CountryId, CN.CountryCode, CN.CurrencyId, CR.CurrencyCode, CR.ExchangeRate 
			FROM Customer CS 
			INNER join Country CN 
			on CS.CountryId = CN.CountryId
			LEFT JOIN Currency CR
			on CN.CurrencyId = CR.CurrencyId
			where CS.CustomerId=@customerId
			AND CS.IsActive=1;
END 
GO


----[dbo].[SP_Validate_Sales_Entries]---------------------
DROP PROCEDURE IF EXISTS [dbo].[SP_Validate_Sales_Entries];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Validate_Sales_Entries](
	@customerId int,
	@tvpCustomerWithCurrency [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY] READONLY,
	@tvpSaleEntryHeader dbo.TVP_SALES_ENTRY_HEADERS READONLY,
	@tvpSalesQtyPrices dbo.TVP_SALES_ENTRY_QTY_PRICES READONLY
	)
AS
BEGIN
	DECLARE @ResultTable  AS dbo.TVP_RESULT_TABLE;

	SET NOCOUNT ON;
	BEGIN TRY
            --BEGIN TRANSACTION;
				
				DECLARE @CustomerCount INT = 0;
				SELECT @CustomerCount = count(1) FROM @tvpCustomerWithCurrency;
				
				IF @CustomerCount = 0
				BEGIN
					INSERT INTO @ResultTable
					SELECT 0, 101, 'Customer is not valid';
				END
				ELSE
				BEGIN
					IF EXISTS(SELECT TOP 1 1 FROM @tvpCustomerWithCurrency WHERE [CurrencyId] IS NULL)
					BEGIN
						INSERT INTO @ResultTable
						SELECT 0, 102, 'Currency is not available for the Customer/Country';
					END
				END

			    DECLARE @DuplicateMaterials AS [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM];

				-- CHECK ITEM CODE IS PRESENT IN DB
				--IF EXISTS(SELECT TOP 1 1 FROM  @tvpSaleEntryHeader WHERE ItemCodeId IS NULL)
				INSERT INTO @ResultTable
				SELECT RowIndex +1, 104,  'RowNo: ' + CAST(RowIndex +1 AS VARCHAR(10)) + ': ' + ItemCode+' is not valid Item_Code.' FROM  @tvpSaleEntryHeader WHERE ItemCodeId IS NULL;

				-- CHECK TYPE CODE IS PRESENT IN DB
				--IF EXISTS(SELECT TOP 1 1 FROM @tvpSaleEntryHeader WHERE TypeCodeId IS NULL)
				INSERT INTO @ResultTable
				SELECT RowIndex +1, 105,  'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + TypeCode+' is not valid Type.' FROM  @tvpSaleEntryHeader WHERE TypeCodeId IS NULL;

				-- CHECK DUPLICATE
				INSERT INTO @DuplicateMaterials
				SELECT ItemCode, TypeCode,COUNT(*) 
				FROM @tvpSaleEntryHeader GROUP BY ItemCode, TypeCode HAVING COUNT(*) > 1;

				--IF EXISTS(SELECT TOP 1 1 FROM @DuplicateMaterials)
				INSERT INTO @ResultTable
				SELECT 0, 106, 'Item_Code: '+ ItemCode +' with Type: '+TypeCode +' found '+CONVERT(varchar(10),DuplicateCount)+' times.' 
				FROM  @DuplicateMaterials;


		/*IF @@TRANCOUNT > 0
			COMMIT;*/
			
        END TRY
        BEGIN CATCH
            /*IF @@TRANCOUNT > 0
                ROLLBACK;*/
				INSERT INTO @ResultTable
				VALUES(0, 500, 'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE());
        END CATCH;

	DELETE @DuplicateMaterials;
	SELECT distinct RowNo, ResponseCode, ResponseMessage FROM @ResultTable;

END

------------[dbo].[SP_Archive_Sales_Entries]-------------
DROP PROCEDURE IF EXISTS [dbo].[SP_Archive_Sales_Entries];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Archive_Sales_Entries](
		@customerId int,
		@productCategoryId int,
		@productSubCategoryId int,
		@saleSubType varchar(50),
		@currentMonthYear char(6),
		@nextMonthYear char(6),
		@userId nvarchar(100),
		@tvpSalesEntries dbo.TVP_SALES_ENTRY_HEADERS READONLY,
		@tvpSalesQtyPrices dbo.TVP_SALES_ENTRY_QTY_PRICES READONLY
	)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ResultTable  AS dbo.TVP_RESULT_TABLE;

	BEGIN TRY
            --BEGIN TRANSACTION;
				
				--PRINT @currentMonthYear;
				--PRINT @nextMonthYear;

				DECLARE @IsArchived varchar(1) = '0';
				DECLARE @SaleEntryHeaderId INT = NULL;
				DECLARE @PrevSaleEntryHeaderId INT = NULL;
				DECLARE @IsPrevIdFoundInArchival varchar(1) = '0';
				SET @SaleEntryHeaderId = (SELECT TOP 1 SaleEntryHeaderId FROM dbo.SaleEntryHeader WHERE CustomerId=@customerId AND SaleTypeId=1 and SaleSubType=@saleSubType and ProductCategoryId1=@productCategoryId and ProductCategoryId2=@productSubCategoryId order by SaleEntryHeaderId desc);
				SET @PrevSaleEntryHeaderId = (SELECT TOP 1 SaleEntryHeaderId FROM dbo.SaleEntryHeader WHERE CustomerId=@customerId AND SaleTypeId=1 and SaleSubType=@saleSubType and ProductCategoryId1=@productCategoryId and ProductCategoryId2=@productSubCategoryId and CurrentMonthYear < @currentMonthYear order by SaleEntryHeaderId desc);
				IF @PrevSaleEntryHeaderId IS NULL
				BEGIN
					SET @IsPrevIdFoundInArchival = '1';
					SET @PrevSaleEntryHeaderId = (SELECT TOP 1 SaleEntryArchivalHeaderId FROM dbo.[SaleEntryArchivalHeader] WHERE CustomerId=@customerId AND SaleTypeId=1 and SaleSubType=@saleSubType and ProductCategoryId1=@productCategoryId and ProductCategoryId2=@productSubCategoryId and CurrentMonthYear < @currentMonthYear order by SaleEntryArchivalHeaderId desc);
				END

				--PRINT '@PrevSaleEntryHeaderId';
				--PRINT @PrevSaleEntryHeaderId;
				IF @SaleEntryHeaderId IS NOT NULL
				BEGIN
					DECLARE @SalesEntryId INT = NULL;
					SET @SalesEntryId = (SELECT TOP 1 SE.SalesEntryId FROM [dbo].[SalesEntry] SE
					INNER JOIN @tvpSalesEntries TSE
					ON SE.SaleEntryHeaderId = @SaleEntryHeaderId
					AND SE.MaterialId = TSE.ItemCodeId
					AND SE.ModeOfTypeId = TSE.TypeCodeId);

					IF @SalesEntryId IS NOT NULL
					BEGIN
						SET @IsArchived = '1';

						DECLARE @tvpSalesEntry TABLE(SalesEntryId int not null);
						DECLARE @tvpPrevSalesEntry TABLE(SalesEntryId int not null);

						INSERT INTO @tvpSalesEntry
						select SalesEntryId FROM SalesEntry where SaleEntryHeaderId = @SaleEntryHeaderId;

						IF @PrevSaleEntryHeaderId IS NOT NULL
						BEGIN
							IF @IsPrevIdFoundInArchival = '0'
							BEGIN
								INSERT INTO @tvpPrevSalesEntry
								select SalesEntryId FROM SalesEntry where SaleEntryHeaderId = @PrevSaleEntryHeaderId;
							END
							ELSE
							BEGIN
								INSERT INTO @tvpPrevSalesEntry
								select SalesArchivalEntryId FROM [SalesArchivalEntry] where SaleEntryArchivalHeaderId = @PrevSaleEntryHeaderId;
							END
						END

						INSERT INTO dbo.[SaleEntryArchivalHeader](
							SaleEntryArchivalHeaderId,
							[CustomerId]
						   ,[SaleTypeId]
						   ,[ProductCategoryId1]
						   ,[ProductCategoryId2]
						   ,[CurrentMonthYear]
						   ,[LockMonthYear]
						   ,[CreatedDate]
						   ,[CreatedBy]
						   ,[UpdateDate]
						   ,[UpdateBy]
						   ,[AttachmentId]
						   ,[SaleSubType]
						)
						SELECT 
						SaleEntryHeaderId,
						[CustomerId]
					   ,[SaleTypeId]
					   ,[ProductCategoryId1]
					   ,[ProductCategoryId2]
					   ,[CurrentMonthYear]
					   ,[LockMonthYear]
					   ,[CreatedDate]
					   ,[CreatedBy]
					   ,[UpdateDate]
					   ,[UpdateBy]
					   ,[AttachmentId]
					   ,[SaleSubType]
						from dbo.SaleEntryHeader
						WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

							INSERT INTO dbo.[SalesArchivalEntry](
							SalesArchivalEntryId,
							SaleEntryArchivalHeaderId,
							[MaterialId]
						   ,[ProductCategoryCode1]
						   ,[ProductCategoryCode2]
						   ,[ProductCategoryCode3]
						   ,[ProductCategoryCode4]
						   ,[ProductCategoryCode5]
						   ,[ProductCategoryCode6]
						   ,[OCmonthYear]
						   ,[OCstatus]
						   ,[FileInfoId]
						   ,[O_LockMonthConfirmedStatus]
						   ,[O_LockMonthConfirmedBy]
						   ,[O_LockMonthConfirmedDate]
						   ,[ModeOfTypeId]
							)
							SELECT DISTINCT
							SalesEntryId,
							SaleEntryHeaderId,
							[MaterialId]
						   ,[ProductCategoryCode1]
						   ,[ProductCategoryCode2]
						   ,[ProductCategoryCode3]
						   ,[ProductCategoryCode4]
						   ,[ProductCategoryCode5]
						   ,[ProductCategoryCode6]
						   ,[OCmonthYear]
						   ,[OCstatus]
						   ,[FileInfoId]
						   ,[O_LockMonthConfirmedStatus]
						   ,[O_LockMonthConfirmedBy]
						   ,[O_LockMonthConfirmedDate]
						   ,[ModeOfTypeId]
							FROM SalesEntry
							where SaleEntryHeaderId = @SaleEntryHeaderId;

						INSERT INTO [dbo].[SalesArchivalEntryPriceQuantity](
								[SalesArchivalEntryPriceQuantityId]
							   ,[SalesArchivalEntryId]
							   ,[MonthYear]
							   ,[Price]
							   ,[Quantity]
							   ,[OrderIndicationConfirmedBySaleTeam]
							   ,[OrderIndicationConfirmedBySaleTeamDate]
							   ,[OrderIndicationConfirmedByMarketingTeam]
							   ,[OrderIndicationConfirmedByMarketingTeamDate]
							   ,[O_LockMonthConfirmedBy]
							   ,[O_LockMonthConfirmedDate]
							   ,[Reason]
							   ,[IsSNS]
							   ,[IsPO]
							   ,[TermId]
							   ,[Remarks]
							   ,[CurrencyCode]
							   ,[OcIndicationMonthAttachmentIds]
							   ,[OcIndicationMonthStatus]
							   ,[OCstatus])
								SELECT
								[SalesEntryPriceQuantityId]
							   ,[SalesEntryId]
							   ,[MonthYear]
							   ,[Price]
							   ,[Quantity]
							   ,[OrderIndicationConfirmedBySaleTeam]
							   ,[OrderIndicationConfirmedBySaleTeamDate]
							   ,[OrderIndicationConfirmedByMarketingTeam]
							   ,[OrderIndicationConfirmedByMarketingTeamDate]
							   ,[O_LockMonthConfirmedBy]
							   ,[O_LockMonthConfirmedDate]
							   ,[Reason]
							   ,[IsSNS]
							   ,[IsPO]
							   ,[TermId]
							   ,[Remarks]
							   ,[CurrencyCode]
							   ,[OcIndicationMonthAttachmentIds]
							   ,[OcIndicationMonthStatus]
							   ,[OCstatus]
								FROM 
								SalesEntryPriceQuantity where SalesEntryId in 
								(select SalesEntryId FROM @tvpSalesEntry);
							
							DECLARE @IsCurrentOrLockMonthDataExists INT;
							IF @IsPrevIdFoundInArchival = '0'
							BEGIN
								set @IsCurrentOrLockMonthDataExists = (SELECT TOP 1 1 FROM SalesEntryPriceQuantity where SalesEntryId in 
								(select SalesEntryId FROM @tvpPrevSalesEntry)
								AND (MonthYear = @currentMonthYear OR MonthYear = @nextMonthYear));
							END
							ELSE
							BEGIN
								set @IsCurrentOrLockMonthDataExists = (SELECT TOP 1 1 FROM [SalesArchivalEntryPriceQuantity] where [SalesArchivalEntryId] in 
								(select SalesEntryId FROM @tvpPrevSalesEntry)
								AND (MonthYear = @currentMonthYear OR MonthYear = @nextMonthYear));
							END

							--PRINT '@IsCurrentOrLockMonthDataExists';
							--PRINT  @IsCurrentOrLockMonthDataExists;

							IF @IsCurrentOrLockMonthDataExists = 1
							BEGIN
								INSERT INTO @ResultTable
								VALUES(0, 201, CONVERT(varchar(12), @PrevSaleEntryHeaderId));

								IF @SaleEntryHeaderId != @PrevSaleEntryHeaderId
								BEGIN
									DELETE FROM SalesEntryPriceQuantity
									where SalesEntryId in
									(select SalesEntryId FROM SalesEntry where SaleEntryHeaderId = @SaleEntryHeaderId);

									DELETE FROM SalesEntry
									where SaleEntryHeaderId = @SaleEntryHeaderId;

									DELETE FROM SaleEntryHeader
									where SaleEntryHeaderId = @SaleEntryHeaderId;
								END 
								ELSE
								BEGIN
									DELETE FROM SalesEntryPriceQuantity
									where SalesEntryId in
									(select SalesEntryId FROM @tvpSalesEntry)
									AND (MonthYear != @currentMonthYear AND MonthYear != @nextMonthYear);
								END
							END
							ELSE
							BEGIN
								INSERT INTO @ResultTable
								VALUES(0, 201, '0');

								DELETE FROM SalesEntryPriceQuantity
								where SalesEntryId in
								(select SalesEntryId FROM SalesEntry where SaleEntryHeaderId = @SaleEntryHeaderId);

								DELETE FROM SalesEntry
								where SaleEntryHeaderId = @SaleEntryHeaderId;

								DELETE FROM SaleEntryHeader
								where SaleEntryHeaderId = @SaleEntryHeaderId;
							END

							
					END
				END

		/*IF @@TRANCOUNT > 0
			COMMIT;*/

		INSERT INTO @ResultTable
				VALUES(0, 200, @IsArchived);

        END TRY
        BEGIN CATCH
            /*IF @@TRANCOUNT > 0
                ROLLBACK;*/
				INSERT INTO @ResultTable
				VALUES(0, 500, 'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE());
        END CATCH;

		SELECT distinct RowNo, ResponseCode, ResponseMessage FROM @ResultTable;
END
GO

------[dbo].[SP_Insert_Sales_Entries]------------------

DROP PROCEDURE IF EXISTS [dbo].[SP_Insert_Sales_Entries];
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Insert_Sales_Entries](
	@customerId int,
	@productCategoryId int,
	@productSubCategoryId int,
	@tvpSalesEntries dbo.TVP_SALES_ENTRY_ROWS READONLY,
	@tvpSalesQuantities dbo.TVP_SALES_ENTRY_QUANTITIES READONLY,
	@tvpSalesPrices dbo.TVP_SALES_ENTRY_PRICES READONLY,
	@userId nvarchar(100),
	@attachmentId INT,
	@saleSubType varchar(50),
	@isValid BIT)
AS
BEGIN

	SET NOCOUNT ON;
	DECLARE @ResultTable  AS dbo.TVP_RESULT_TABLE;

	DECLARE @currentMonthYear char(6), @nextMonthYear char(6);

	--SET @currentmonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())), 2);
	--SET @currentYear = CONVERT(VARCHAR(4),YEAR(getdate()));
	--SET @currentMonthYear = @currentYear+@currentmonth;
	select @currentMonthYear = 
	ConfigValue from [dbo].[GlobalConfig] where ConfigKey='Current_Month' and ConfigType='Direct And SNS';
	DECLARE @dtCurrentMonthYear datetime = CONVERT(datetime, @currentMonthYear+'01', 112);

	--SET @nextMonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())+1), 2);
	--SET @nextYear = CONVERT(VARCHAR(4),YEAR(getdate())+1);
	--SET @nextMonthYear = @currentYear+@nextMonth;

	--IF(@currentmonth = '12')  SET @nextMonthYear =@nextYear+'01';
	SET @nextMonthYear = (SELECT FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM'));

	SET NOCOUNT ON;
	BEGIN TRY
            BEGIN TRANSACTION;

			   --SET @responseMessage = '';
			   DECLARE @ResultCount INT = 0, @SalesEntryCount INT = 0;

			   DECLARE @CustomerWithCurrency  AS [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY];
				
				INSERT INTO @CustomerWithCurrency
				Exec [dbo].[SP_Get_Customer_Country_Currency] @customerId;

				DECLARE @LocalCurrencyCode nvarchar(10);
				SET @LocalCurrencyCode = (SELECT TOP 1 CurrencyCode from @CustomerWithCurrency);

			   DECLARE @SalesQtyPrices AS dbo.TVP_SALES_ENTRY_QTY_PRICES;

				DECLARE @TempSaleEntryHeader AS dbo.TVP_SALES_ENTRY_HEADERS;

				INSERT INTO @TempSaleEntryHeader
				SELECT 
				ROW_NUMBER() OVER(ORDER BY tvp.RowIndex ASC) AS RowNo,
				tvp.RowIndex,
				tvp.UploadFlag,
				tvp.Class1,
				tvp.Class2,
				tvp.Class3,
				tvp.Class4,
				tvp.Class5,
				tvp.Class6,
				tvp.Class7,
				tvp.Class8,
				tvp.ItemCode,
				material.MaterialId,
				tvp.ModelNumber,
				modeType.ModeofTypeId,
				tvp.TypeCode,
				tvp.Comments,
				tvp.Currency,
				1 --SalesTypeId
				FROM @tvpSalesEntries as tvp
				LEFT JOIN dbo.ModeofType AS modeType ON tvp.TypeCode = modeType.ModeofTypeCode
				LEFT JOIN dbo.Material AS material ON material.MaterialCode = tvp.ItemCode;

				INSERT INTO @SalesQtyPrices
				SELECT 
				tvp_price.RowIndex,
				temp.RowNo,
				tvp_price.PriceMonthName,
				tvp_price.Price,
				tvp_qty.Qty,
				CASE WHEN temp.TypeCode = 'P' OR temp.TypeCode = 'S' OR temp.TypeCode = 'I' THEN @LocalCurrencyCode
				ELSE 'USD' END AS Currency
				FROM @tvpSalesQuantities as tvp_qty
				INNER JOIN @tvpSalesPrices as tvp_price  ON tvp_price.RowIndex = tvp_qty.RowIndex AND tvp_price.PriceMonthName =tvp_qty.QtyMonthName  
				INNER JOIN @TempSaleEntryHeader as temp ON tvp_qty.RowIndex = temp.RowIndex;

				--validation sp call
				INSERT INTO @ResultTable
				Exec dbo.[SP_Validate_Sales_Entries] @customerId, @CustomerWithCurrency, @TempSaleEntryHeader, @SalesQtyPrices;

				IF NOT EXISTS(SELECT TOP 1 1 FROM @ResultTable) AND @isValid = 1
					BEGIN

					--Archive sales entries data
					DECLARE @IsArchived VARCHAR(1) = '0';
					DECLARE @PrevSaleEntryHeaderId VARCHAR(12) = '0';
					DECLARE @ArchivalResultTable  AS dbo.TVP_RESULT_TABLE;
					INSERT INTO @ArchivalResultTable
					Exec dbo.[SP_Archive_Sales_Entries] @customerId, @productCategoryId, @productSubCategoryId,
					@saleSubType, @currentMonthYear, @nextMonthYear, @userId, @TempSaleEntryHeader, @SalesQtyPrices;

					--Insert Archival Error Log into Result
					INSERT INTO @ResultTable
					SELECT * FROM @ArchivalResultTable WHERE ResponseCode!=200 and ResponseCode!=201;

					SET @IsArchived = (SELECT TOP 1 ResponseMessage FROM @ArchivalResultTable where ResponseCode=200);
					SET @PrevSaleEntryHeaderId = (SELECT TOP 1 ResponseMessage FROM @ArchivalResultTable where ResponseCode=201);
					DECLARE @tempPrevSalesEntryPriceQtyTable  AS dbo.[TVP_SALESENTRY_PRICE_QTY_INFO];
					--PRINT '@PrevSaleEntryHeaderId';
					--PRINT @PrevSaleEntryHeaderId;
					IF @PrevSaleEntryHeaderId IS NOT NULL AND @PrevSaleEntryHeaderId != '0'
					BEGIN
						--PRINT @PrevSaleEntryHeaderId;
						IF EXISTS(SELECT TOP 1 1 FROM dbo.SaleEntryHeader WHERE SaleEntryHeaderId =@PrevSaleEntryHeaderId)
						BEGIN
							INSERT INTO @tempPrevSalesEntryPriceQtyTable
							SELECT PQ.[SalesEntryPriceQuantityId]
								  ,PQ.[SalesEntryId]
								  ,SE.[SaleEntryHeaderId]
								  ,PQ.[MonthYear]
								  ,PQ.[Price]
								  ,PQ.[Quantity] 
								  ,SE.[MaterialId]
								  ,SE.[OCmonthYear]
								  ,SE.[OCstatus]
								  ,SE.[ModeOfTypeId] FROM 
							[dbo].[SalesEntryPriceQuantity] PQ
							INNER JOIN [dbo].[SalesEntry] SE
							ON PQ.SalesEntryId = SE.SalesEntryId
							WHERE SE.SaleEntryHeaderId=@PrevSaleEntryHeaderId;
						END
						ELSE
						BEGIN
							INSERT INTO @tempPrevSalesEntryPriceQtyTable
							SELECT PQ.[SalesArchivalEntryPriceQuantityId] as [SalesEntryPriceQuantityId]
								  ,PQ.[SalesArchivalEntryId] as [SalesEntryId]
								  ,SE.[SaleEntryArchivalHeaderId] as [SaleEntryHeaderId]
								  ,PQ.[MonthYear]
								  ,PQ.[Price]
								  ,PQ.[Quantity] 
								  ,SE.[MaterialId]
								  ,SE.[OCmonthYear]
								  ,SE.[OCstatus]
								  ,SE.[ModeOfTypeId] FROM 
							[dbo].[SalesArchivalEntryPriceQuantity] PQ
							INNER JOIN [dbo].[SalesArchivalEntry] SE
							ON PQ.[SalesArchivalEntryId] = SE.[SalesArchivalEntryId]
							WHERE SE.[SaleEntryArchivalHeaderId]=@PrevSaleEntryHeaderId
						END
					END
						IF EXISTS(SELECT TOP 1 1 FROM @ArchivalResultTable where ResponseCode=200)
																																																																																																			BEGIN
						BEGIN
							DECLARE @SalesEntryHeader_LastId INT = 0 ;
							INSERT INTO dbo.SaleEntryHeader(
								CustomerId,
								SaleTypeId,
								ProductCategoryId1,
								ProductCategoryId2,
								CurrentMonthYear,
								LockMonthYear,
								CreatedDate,
								CreatedBy,
								UpdateDate,
								UpdateBy,
								AttachmentId,
								SaleSubType
								)
								VALUES(
								@customerId,
								1,
								@productCategoryId,
								@productSubCategoryId,
								@currentMonthYear,
								@nextMonthYear,
								GETDATE(),
								@userId,
								GETDATE(),
								@userId,
								@attachmentId,
								@saleSubType);

							SELECT @SalesEntryHeader_LastId = SCOPE_IDENTITY();
					
							SELECT @ResultCount = count(1) FROM @TempSaleEntryHeader;
							SELECT @SalesEntryCount = count(1) FROM @TempSaleEntryHeader;
							DECLARE @SalesEntryIndex INT = 1;
							WHILE (@SalesEntryIndex <= @SalesEntryCount)
							BEGIN
						
								IF (@SalesEntryHeader_LastId > 0)
								BEGIN

									DECLARE @SalesEntry_LastId INT = 0;
									DECLARE @TempMaterialId int = 0;
									DECLARE @TempModeOfTypeId int = 0;

									SELECT @TempMaterialId = temp.ItemCodeId,
									@TempModeOfTypeId = temp.TypeCodeId
									FROM @TempSaleEntryHeader AS temp
									where temp.RowNo = @SalesEntryIndex;

									INSERT INTO dbo.SalesEntry(
									SaleEntryHeaderId,
									MaterialId,
									ProductCategoryCode1,
									ProductCategoryCode2,
									ProductCategoryCode3,
									ProductCategoryCode4,
									ProductCategoryCode5,
									ProductCategoryCode6,
									OCmonthYear,
									OCstatus,
									ModeOfTypeId
									)
									SELECT DISTINCT
									@SalesEntryHeader_LastId,
									temp.ItemCodeId,
									temp.Class1,
									temp.Class2,
									temp.Class3,
									temp.Class4,
									temp.Class5,
									temp.Class6,
									@currentMonthYear,
									'Y' AS OCstatus,
									temp.TypeCodeId
									FROM @TempSaleEntryHeader AS temp
									where temp.RowNo = @SalesEntryIndex;

									SELECT @SalesEntry_LastId = SCOPE_IDENTITY();

									IF(@SalesEntry_LastId > 0)
									BEGIN
										IF @PrevSaleEntryHeaderId IS NOT NULL
										BEGIN
											--PRINT 'PRICE QTY';
											DECLARE @tempCurrentSalesQtyPrices AS dbo.[TVP_SALES_ENTRY_MATERIAL_QTY_PRICES];
											INSERT INTO @tempCurrentSalesQtyPrices
											SELECT sqp.[RowIndex], sqp.[RowNo],
											ROW_NUMBER() OVER(ORDER BY sqp.[PriceMonthName] ASC) AS PriceQtyRowNo, 
											sqp.[PriceMonthName],
											sqp.[Price], sqp.[Qty],
											sqp.[Currency] FROM @SalesQtyPrices AS sqp
											WHERE sqp.RowNo = @SalesEntryIndex;

											DECLARE @SalesPriceQtyIndex INT = 1;
											DECLARE @SalesPriceQtyCount INT = 0;
											SELECT @SalesPriceQtyCount = count(1) FROM @tempCurrentSalesQtyPrices;
											DECLARE @IsPrevDataUpdated VARCHAR(1) = '0';
											--PRINT @SalesPriceQtyCount;
											WHILE (@SalesPriceQtyIndex <= @SalesPriceQtyCount)
											BEGIN
												--PRINT 'LOOP';
												--PRINT @SalesPriceQtyIndex;
												--PRINT '@TempMaterialId';
												--PRINT @TempMaterialId;
												--PRINT '@TempModeOfTypeId';
												--PRINT @TempModeOfTypeId;
												
												DECLARE @TempMonthYear [nvarchar](20) = '';
												DECLARE @TempQty int = 0;
												DECLARE @TempPrice decimal(18,2) = 0;
												SELECT @TempMonthYear = [PriceMonthName], @TempQty=[Qty], @TempPrice=[Price] 
												FROM  @tempCurrentSalesQtyPrices
												WHERE PriceQtyRowNo = @SalesPriceQtyIndex;

												--PRINT '@TempMonthYear';
												--PRINT @TempMonthYear;
												--PRINT '@TempQty';
												--PRINT @TempQty;
												--PRINT '@TempPrice';
												--PRINT @TempPrice;

												IF EXISTS (SELECT TOP 1 1 FROM @tempPrevSalesEntryPriceQtyTable WHERE 
												[MaterialId]=@TempMaterialId AND [ModeOfTypeId]=@TempModeOfTypeId AND [MonthYear]=@TempMonthYear
												AND ([Quantity] != @TempQty OR [Price] != @TempPrice)
												AND ([MonthYear] = @currentMonthYear OR [MonthYear] = @nextMonthYear))
												BEGIN
													--PRINT 'NO';
													SET @IsPrevDataUpdated = '1';
													INSERT INTO dbo.SalesEntryPriceQuantity(
													SalesEntryId,
													MonthYear,
													Price,
													Quantity,
													CurrencyCode,
													OCstatus)
													SELECT DISTINCT
													@SalesEntry_LastId,
													PriceMonthName,
													Price,
													Qty,
													Currency,
													'N' AS OCstatus
													FROM @tempCurrentSalesQtyPrices AS sqp
													WHERE PriceQtyRowNo = @SalesPriceQtyIndex;
												END
												ELSE
												BEGIN
													--PRINT 'YES';
													INSERT INTO dbo.SalesEntryPriceQuantity(
													SalesEntryId,
													MonthYear,
													Price,
													Quantity,
													CurrencyCode,
													OCstatus)
													SELECT DISTINCT
													@SalesEntry_LastId,
													PriceMonthName,
													Price,
													Qty,
													Currency,
													'Y' AS OCstatus
													FROM @tempCurrentSalesQtyPrices AS sqp
													WHERE PriceQtyRowNo = @SalesPriceQtyIndex;
												END
												SET @SalesPriceQtyIndex  = @SalesPriceQtyIndex+1;
											END
											IF @IsPrevDataUpdated = '1'
											BEGIN
												UPDATE dbo.SalesEntry SET OCstatus='N'
												WHERE SalesEntryId = @SalesEntry_LastId;
											END
											ELSE
											BEGIN
												DELETE FROM SalesEntryPriceQuantity
												where SalesEntryId in
												(select SalesEntryId FROM SalesEntry where SaleEntryHeaderId = @PrevSaleEntryHeaderId);

												DELETE FROM SalesEntry
												where SaleEntryHeaderId = @PrevSaleEntryHeaderId;

												DELETE FROM SaleEntryHeader
												where SaleEntryHeaderId = @PrevSaleEntryHeaderId;
											END
										END
										ELSE
										BEGIN
											INSERT INTO dbo.SalesEntryPriceQuantity(
											SalesEntryId,
											MonthYear,
											Price,
											Quantity,
											CurrencyCode,
											OCstatus)
											SELECT DISTINCT
											@SalesEntry_LastId,
											PriceMonthName,
											Price,
											Qty,
											Currency,
											'Y' AS OCstatus
											FROM @SalesQtyPrices AS sqp
											WHERE sqp.RowNo = @SalesEntryIndex;
										END
									END
								END

								SET @SalesEntryIndex  = @SalesEntryIndex+1;

							END

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
	
	DELETE @TempSaleEntryHeader;
	DELETE @SalesQtyPrices;
	SELECT distinct RowNo, ResponseCode, ResponseMessage FROM @ResultTable;

END
GO
