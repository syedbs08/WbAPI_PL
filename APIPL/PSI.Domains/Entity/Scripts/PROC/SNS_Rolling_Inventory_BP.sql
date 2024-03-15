

CREATE TABLE [dbo].[TRNPricePlanning_BP](
	[TRNPricePlanningId] [int] IDENTITY(1,1) NOT NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[BP_YEAR] [int] NULL
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[TRNSalesPlanning_BP](
	[TRNSalesPlanningId] [int] IDENTITY(1,1) NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[BP_YEAR] [int] NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[TRNSalesPlanningArchival_BP](
	[TRNSalesPlanningId] [int] IDENTITY(1,1) NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[BP_YEAR] [int] NULL,
	ArchiveStatus [varchar](50) NULL,
	ArchivalDate DATETIME
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[TRNPricePlanningArchival_BP](
	[TRNPricePlanningId] [int] IDENTITY(1,1) NOT NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[BP_YEAR] [int] NULL,
	ArchiveStatus [varchar](50) NULL,
	ArchivalDate DATETIME
) ON [PRIMARY]
GO

  
                                   
CREATE PROCEDURE [dbo].[Sp_Direct_SNS_Archive] (    
 @CurrentMonth CHAR(6) = NULL    
 ,@CreatedBy NVARCHAR(max) = NULL    
 ,@Global_Current_Month CHAR(6) = NULL    
 ,@Lock_Month CHAR(6) = NULL    
 ,@SalesType NVARCHAR(50) = NULL    
 )    
AS    
BEGIN    
 SET NOCOUNT ON    
    
 DECLARE @error TABLE (    
  error NVARCHAR(max)    
  ,Id VARCHAR(max)    
  ,SaleType VARCHAR(50)    
  );    
 --Direct Sale                          
 DECLARE @SaleEntryHeaderIds TABLE (Id INT);    
 DECLARE @SalesEntryIds TABLE (Id INT);    
 DECLARE @SalesArchivalEntryId TABLE (Id INT);    
 DECLARE @DirectSaleIds VARCHAR(max);    
 --SNS                          
 DECLARE @SNSEntryIds TABLE (Id INT);    
 DECLARE @SNSIds VARCHAR(max);    
    
 BEGIN TRY    
  BEGIN TRANSACTION    
    
  --Direct Sale start                          
  INSERT INTO @SaleEntryHeaderIds    
  SELECT SaleEntryHeaderId    
  FROM SaleEntryHeader    
  WHERE CurrentMonthYear = @CurrentMonth and SaleSubType=@SalesType;    
    
UPDATE SaleEntryArchivalHeader SET ArchiveStatus='' WHERE CurrentMonthYear = @CurrentMonth  
and SaleSubType=@SalesType;  
  
  
  SELECT @DirectSaleIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')    
  FROM @SaleEntryHeaderIds;    
    
  INSERT INTO @SalesEntryIds    
  SELECT SalesEntryId    
  FROM SalesEntry    
  WHERE SaleEntryHeaderId IN (    
    SELECT id    
    FROM @SaleEntryHeaderIds    
    );    
    
  --if data is exist is table then first delete and insert                               
  IF (    
    SELECT count(*)    
    FROM SaleEntryArchivalHeader    
    WHERE SaleEntryArchivalHeaderId IN (    
      SELECT id    
      FROM @SaleEntryHeaderIds    
      )    
    ) > 0    
  BEGIN    
   INSERT INTO @SalesArchivalEntryId    
   SELECT SalesArchivalEntryId    
   FROM SalesArchivalEntry    
   WHERE SaleEntryArchivalHeaderId IN (    
     SELECT id    
     FROM @SaleEntryHeaderIds    
     );    
    
   DELETE    
   FROM SalesArchivalEntryPriceQuantity    
   WHERE SalesArchivalEntryId IN (    
     SELECT id    
     FROM @SalesArchivalEntryId    
     );    
    
   DELETE    
   FROM SalesArchivalEntry    
   WHERE SaleEntryArchivalHeaderId IN (    
     SELECT id    
     FROM @SaleEntryHeaderIds    
     );    
    
   DELETE    
   FROM SaleEntryArchivalHeader    
   WHERE SaleEntryArchivalHeaderId IN (    
     SELECT id    
     FROM @SaleEntryHeaderIds    
     );    
  END    
    
  INSERT INTO dbo.[SaleEntryArchivalHeader] (    
   SaleEntryArchivalHeaderId    
   ,ArchivalMonthYear    
   ,ArchiveBy    
   ,ArchiveDate    
   ,ArchiveStatus    
   ,[CustomerId]    
   ,CustomerCode    
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
  SELECT SaleEntryHeaderId    
   ,@CurrentMonth    
   ,@CreatedBy    
   ,GETDATE()    
   ,'Archived'    
   ,[CustomerId]    
   ,CustomerCode    
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
  FROM dbo.SaleEntryHeader    
  WHERE SaleEntryHeaderId IN (    
    SELECT id    
    FROM @SaleEntryHeaderIds    
    );    
    
  INSERT INTO dbo.[SalesArchivalEntry] (    
   SalesArchivalEntryId    
   ,SaleEntryArchivalHeaderId    
   ,ArchiveDate    
   ,[MaterialId]    
   ,MaterialCode    
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
  SELECT DISTINCT SalesEntryId    
   ,SaleEntryHeaderId    
   ,GETDATE()    
   ,[MaterialId]    
   ,MaterialCode    
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
  WHERE SaleEntryHeaderId IN (    
    SELECT id    
    FROM @SaleEntryHeaderIds    
    );    
    
  INSERT INTO [dbo].[SalesArchivalEntryPriceQuantity] (    
   [SalesArchivalEntryPriceQuantityId]    
   ,[SalesArchivalEntryId]    
   ,ArchiveDate    
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
   )    
  SELECT [SalesEntryPriceQuantityId]    
   ,[SalesEntryId]    
   ,getdate()    
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
  FROM SalesEntryPriceQuantity    
  WHERE SalesEntryId IN (    
    SELECT id    
    FROM @SalesEntryIds    
    );    
    
                               
  --Direct Sale end                          
  --SNS Start   
  if(@SalesType='Monthly')
  begin
  
   delete from TRNPricePlanningArchival where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                      
   insert into TRNPricePlanningArchival  
   (AccountCode,  
   MonthYear,  
   MaterialCode,  
   ModeofType,  
   Type,  
   Quantity,  
   CreatedDate,  
   CreatedBy,  
   UpdatedDate,  
   UpdatedBy,  
    Price,  
   CurrentMonthYear,  
   ArchivalDate,  
   ArchiveStatus  
   )  
   select AccountCode  
   ,MonthYear  
   ,MaterialCode  
   ,ModeofType  
   ,Type  
   ,Quantity  
   ,CreatedDate  
   ,CreatedBy  
   ,UpdatedDate  
   ,UpdatedBy  
   ,Price  
   ,@CurrentMonth  
   ,GETDATE()  
   ,'Archived'  
   from TRNPricePlanning;  
  
  delete TRNSalesPlanningArchival where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                   
 insert into TRNSalesPlanningArchival  
 (  
 MonthYear,  
 CustomerCode,  
 MaterialCode,  
 Quantity,  
 Amount,  
 AccountCode,  
 CreatedDate,  
 CreatedBy,  
 UpdatedDate,  
 UpdatedBy,  
 ArchivalDate,  
 Price,  
 ArchiveStatus  
 )  
 select  MonthYear,  
 CustomerCode,  
 MaterialCode,  
 Quantity,  
 Amount,  
 AccountCode,  
 CreatedDate,  
 CreatedBy,  
 UpdatedDate,  
 UpdatedBy,  
 getdate(),  
 Price,  
 'Archived'  
 from TRNSalesPlanning where MonthYear=@CurrentMonth  
  end
  else 
  begin

  
   delete from TRNPricePlanningArchival_BP where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                      
   insert into TRNPricePlanningArchival_BP 
   (AccountCode,  
   MonthYear,  
   MaterialCode,  
   ModeofType,  
   Type,  
   Quantity,  
   CreatedDate,  
   CreatedBy,  
   UpdatedDate,  
   UpdatedBy,  
    Price,  
   ArchivalDate,  
   ArchiveStatus  
   )  
   select AccountCode  
   ,MonthYear  
   ,MaterialCode  
   ,ModeofType  
   ,Type  
   ,Quantity  
   ,CreatedDate  
   ,CreatedBy  
   ,UpdatedDate  
   ,UpdatedBy  
   ,Price  
   ,GETDATE()  
   ,'Archived'  
   from TRNPricePlanning_BP;  
  
  delete TRNSalesPlanningArchival_BP where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                   
 insert into TRNSalesPlanningArchival_BP  
 (  
 MonthYear,  
 CustomerCode,  
 MaterialCode,  
 Quantity,  
 Amount,  
 AccountCode,  
 CreatedDate,  
 CreatedBy,  
 UpdatedDate,  
 UpdatedBy,  
 ArchivalDate,  
 Price,  
 ArchiveStatus  
 )  
 select  MonthYear,  
 CustomerCode,  
 MaterialCode,  
 Quantity,  
 Amount,  
 AccountCode,  
 CreatedDate,  
 CreatedBy,  
 UpdatedDate,  
 UpdatedBy,  
 getdate(),  
 Price,  
 'Archived'  
 from TRNSalesPlanning_BP where MonthYear=@CurrentMonth 
  end
  --sns end  
                           
  SELECT @SNSIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')    
  FROM @SNSEntryIds;    
    
  COMMIT;    
 END TRY    
    
 BEGIN CATCH    
  ROLLBACK;    
    
  INSERT INTO @error (    
   error    
   ,id    
   )    
  VALUES (    
   ERROR_MESSAGE()    
   ,@SNSIds    
   );    
 END CATCH;    
    
 IF (    
   SELECT count(*)    
   FROM @error    
   ) = 0    
 BEGIN    
  INSERT INTO @error (    
   id    
   ,error    
   ,SaleType    
   )    
  VALUES (    
   @DirectSaleIds    
   ,NULL    
   ,'Direct'    
   );    
    
  INSERT INTO @error (    
   id    
   ,error    
   ,SaleType    
   )    
  VALUES (    
   @SNSIds    
   ,NULL    
   ,'SNS'    
   );    
    
  SELECT *    
  FROM @error    
 END    
 ELSE    
 BEGIN    
  SELECT *    
  FROM @error    
 END    
END 


  
--CREATE PROCEDURE [dbo].[SP_ADD_PLAN_FOR_SNS_TRANSMISSION]    
-- -- Add the parameters for the stored procedure here                        
-- @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY    
-- ,@CurrentMonth INT    
-- ,@Type VARCHAR(10)    
-- ,@CreatedBy NVARCHAR(max)    
-- ,@PlanTypeCode INT    
-- ,@PlanTypeName VARCHAR(30)    
--AS    
--BEGIN    
-- -- SET NOCOUNT ON added to prevent extra result sets from                        
-- -- interfering with SELECT statements.                        
-- SET NOCOUNT ON;    
    
-- DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]    
-- --DECLARE @AccountCodeTable AS [dbo].[TVP_CODE_LIST]    
    
-- -- Insert statements for procedure here                        
-- BEGIN TRY    
--  --INSERT INTO @AccountCodeTable (Code)    
--  --SELECT AccountCode    
--  --FROM VW_Customers    
--  --WHERE CustomerCode IN (    
--  --  SELECT CustomerCode    
--  --  FROM @TVP_CUSTOMERCODE_LIST    
--  --  );  
   
-- delete from TransmissionData where Status='Pending' and SaleType=@Type and CustomerCode in (select CustomerCode from @TVP_CUSTOMERCODE_LIST);  
    
--  DECLARE @CurrentMonthDate VARCHAR(10);    
    
--  ---- Need to get Total Month count -- Current month +5                          
--  SET @CurrentMonthDate = CAST(CAST(@CurrentMonth AS VARCHAR(10)) + '01' AS DATE)    
    
--  CREATE TABLE #tmpMonthData (MonthData INT)    
    
--  DECLARE @StartMonth INT = 0;    
--  DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                          
    
--  WHILE @StartMonth <= @EndMonth    
--  BEGIN    
--   INSERT INTO #tmpMonthData (MonthData)    
--   VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))    
    
--   SET @StartMonth = @StartMonth + 1    
--  END;    
    
--  CREATE TABLE #tmpPlanData (    
--   CustomerCode VARCHAR(200)    
--   ,MaterialCode VARCHAR(200)    
--   ,CurrentMonthYear INT    
--   ,LockMonthYear INT    
--   ,MonthYear INT    
--   ,ModeOfTypeID INT    
--   ,Quantity INT    
--   ,Amount INT    
--   ,SalesValue INT    
--   ,[Plan] VARCHAR(50)    
--   ,SaleType VARCHAR(50)    
--   ,SaleSequenceType VARCHAR(4)    
--   ,SalesSequenceTypeText VARCHAR(4)    
--   )    
--  if(@Type='Monthly')  
--  begin  
--  INSERT INTO #tmpPlanData (    
--   CustomerCode    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,LockMonthYear    
--   ,MonthYear    
--   ,ModeOfTypeID    
--   ,Quantity    
--   ,Amount    
--   ,SalesValue    
--   ,[Plan]    
--   ,SaleType    
--   ,SaleSequenceType    
--   ,SalesSequenceTypeText    
--   )    
--  SELECT AccountCode AS CustomerCode    
--   ,p.MaterialCode    
--   ,0    
--   ,0    
--   ,P.MonthYear    
--   ,2    
--   ,sum(Quantity)   
--   ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) ,0)=0    
--   then ROUND(sum(Quantity)*sum(Price),0)  
-- else ROUND(cast(sum(Quantity) AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) AS decimal(18,2)),0) end AS Amount  
--   ,ROUND(sum(Quantity)*sum(Price),0) AS SaleValues    
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'01' AS SequenceType    
--   ,'P' AS SaleSequenceTypeText    
--  FROM  TRNPricePlanning  p    
--  LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData    
--  WHERE SaleSubType=@Type and ModeofType IN ('PURCHASE')    
--   AND AccountCode IN ( SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST )  
--   AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--  UNION    
      
--  SELECT AccountCode as CustomerCode    
--   ,MaterialCode    
--   ,0    
--   ,0    
--   ,S.MonthYear    
--   ,2    
--   ,sum(S.Quantity) AS Quantity    
--   ,0 as Amount  
--   --,sum(S.Quantity)*sum(S.Price) AS SaleValues    
--   ,ROUND(sum(S.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, AccountCode, MonthYear, @Type) ,0)  
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'02' AS SequenceType    
--   ,'S' AS SaleSequenceTypeText    
--  FROM TRNSalesPlanning S    
--  LEFT JOIN #tmpMonthData MD ON S.MonthYear = MD.MonthData    
--  WHERE SaleSubType=@Type   
--AND AccountCode IN ( SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST )  
--   AND MD.MonthData IS NOT NULL    
--   group by AccountCode,MonthYear,MaterialCode    
      
--  UNION    
      
--  SELECT AccountCode AS CustomerCode    
--   ,P.MaterialCode    
--   ,0    
--   ,0    
--   ,P.MonthYear    
--   ,4   
--   ,sum(Quantity)  
--   ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) ,0)=0  then ROUND(sum(Quantity)*sum(price),0)  
-- else ROUND(cast(sum(Quantity) AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) AS decimal(18,2)),0) end AS Amount  
--   ,ROUND(sum(Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](p.MaterialCode, AccountCode, MonthYear, @Type),0)  
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'03' AS SaleSequenceType    
--   ,'I' AS SalesSequenceTypeText    
--  FROM TRNPricePlanning p     
--  LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData    
   
--  WHERE SaleSubType=@Type and ModeofType IN ('INVENTORY')    
--AND AccountCode IN (      
--     SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST      
--     )  
--   AND MD.MonthData IS NOT NULL    
--  group by AccountCode,MonthYear,MaterialCode   
--  end  
--  else  
--    begin  
--  INSERT INTO #tmpPlanData (    
--   CustomerCode    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,LockMonthYear    
--   ,MonthYear    
--   ,ModeOfTypeID    
--   ,Quantity    
--   ,Amount    
--   ,SalesValue    
--   ,[Plan]    
--   ,SaleType    
--   ,SaleSequenceType    
--   ,SalesSequenceTypeText    
--   )    
--  SELECT AccountCode AS CustomerCode    
--   ,p.MaterialCode    
--   ,0    
--   ,0    
--   ,P.MonthYear    
--   ,2    
--   ,sum(Quantity)   
--   ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) ,0)=0    
--   then ROUND(sum(Quantity)*sum(Price),0)  
-- else ROUND(cast(sum(Quantity) AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) AS decimal(18,2)),0) end AS Amount  
--   ,ROUND(sum(Quantity)*sum(Price),0) AS SaleValues    
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'01' AS SequenceType    
--   ,'P' AS SaleSequenceTypeText    
--  FROM  TRNPricePlanning_BP  p    
--  LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData    
--  WHERE  ModeofType IN ('PURCHASE')    
--   AND AccountCode IN ( SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST )  
--   AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--  UNION    
      
--  SELECT AccountCode as CustomerCode    
--   ,MaterialCode    
--   ,0    
--   ,0    
--   ,S.MonthYear    
--   ,2    
--   ,sum(S.Quantity) AS Quantity    
--   ,0 as Amount  
--   --,sum(S.Quantity)*sum(S.Price) AS SaleValues    
--   ,ROUND(sum(S.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, AccountCode, MonthYear, @Type) ,0)  
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'02' AS SequenceType    
--   ,'S' AS SaleSequenceTypeText    
--  FROM TRNSalesPlanning_BP S    
--  LEFT JOIN #tmpMonthData MD ON S.MonthYear = MD.MonthData    
--  WHERE  AccountCode IN ( SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST )  
--   AND MD.MonthData IS NOT NULL    
--   group by AccountCode,MonthYear,MaterialCode    
      
--  UNION    
      
--  SELECT AccountCode AS CustomerCode    
--   ,P.MaterialCode    
--   ,0    
--   ,0    
--   ,P.MonthYear    
--   ,4   
--   ,sum(Quantity)  
--   ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) ,0)=0  then ROUND(sum(Quantity)*sum(price),0)  
-- else ROUND(cast(sum(Quantity) AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,AccountCode,cast(MonthYear AS INT)) AS decimal(18,2)),0) end AS Amount  
--   ,ROUND(sum(Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](p.MaterialCode, AccountCode, MonthYear, @Type),0)  
--   ,'SNS_Plan' AS [Plan]    
--   ,'Monthly'    
--   ,'03' AS SaleSequenceType    
--   ,'I' AS SalesSequenceTypeText    
--  FROM TRNPricePlanning_BP p     
--  LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData    
   
--  WHERE  ModeofType IN ('INVENTORY')    
--AND AccountCode IN (      
--     SELECT [CustomerCode]      
--     FROM @TVP_CUSTOMERCODE_LIST      
--     )  
--   AND MD.MonthData IS NOT NULL    
--  group by AccountCode,MonthYear,MaterialCode   
  
--  end  
    
--  -- INSERT DATA IN TRANSMISSION TABLE                        
--  INSERT INTO TransmissionData (    
--   CustomerCode    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,LockMonthYear    
--   ,MonthYear    
--   ,ModeOfTypeID    
--   ,Qty    
--   ,Amount    
--   ,SaleValue    
--   ,[Plan]    
--   ,SaleType    
--   ,SaleSequenceType    
--   ,SalesSequenceTypeText    
--   ,CreatedBy    
--   ,EDIStatus    
--   ,STATUS    
--   ,PlanTypeCode    
--   ,PlanTypeName    
--   ,SaleSubType  
--   )    
--  SELECT DISTINCT CustomerCode    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,LockMonthYear    
--   ,MonthYear    
--   ,ModeOfTypeID    
--   ,COALESCE(Quantity, 0) as Quantity    
--   ,COALESCE(Amount, 0) as Amount    
--   ,COALESCE(SalesValue, 0) as SalesValue    
--   ,[Plan]    
--   ,SaleType    
--   ,SaleSequenceType    
--   ,SalesSequenceTypeText    
--   ,@CreatedBy    
--   ,'Pending'    
--   ,'Pending'    
--   ,@PlanTypeCode    
--   ,@PlanTypeName   
--   ,@Type  
--  FROM #tmpPlanData    
--  ORDER BY MaterialCode    
--   ,ModeOfTypeID    
--   ,MonthYear    
    
--  DECLARE @TotalNumber INT    
    
--  SET @TotalNumber = (    
--    SELECT COUNT(1)    
--    FROM #tmpPlanData    
--    )    
    
--  --DROP TABLE #tmpData                           
--  INSERT INTO @ResultTable (    
--   [ResponseCode]    
--   ,[ResponseMessage]    
--   )    
--  VALUES (    
--   200    
--   ,'Tansmission Executed successfully'    
--   --,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'    
--   );    
-- END TRY    
    
-- BEGIN CATCH    
--  INSERT INTO @ResultTable (    
--   [ResponseCode]    
--   ,[ResponseMessage]    
--   )    
--  VALUES (    
--   500    
--   ,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))    
--   );    
-- END CATCH    
    
-- -- DROP TEMP TABLE                        
-- DROP TABLE #tmpMonthData    
    
-- DROP TABLE #tmpPlanData    
    
-- SELECT DISTINCT [ResponseCode]    
--  ,[ResponseMessage]    
-- FROM @ResultTable    
--END 

  
--CREATE PROCEDURE [dbo].[SP_ADD_CONSOLIDATED_TRANSMISSION]    
-- -- Add the parameters for the stored procedure here              
-- @Type VARCHAR(20)    
-- ,@CurrentMonth INT    
-- ,@CreatedBy VARCHAR(max)    
-- ,@PlanTypeCode INT    
-- ,@PlanTypeName VARCHAR(30)    
--AS    
--BEGIN    
----DECLARE    
    
---- @Type VARCHAR(20) ='Monthly'    
---- ,@CurrentMonth INT=202306    
---- ,@CreatedBy VARCHAR(max)='TEST'    
---- ,@PlanTypeCode INT=103    
---- ,@PlanTypeName VARCHAR(30)='CONSOLI'    
-- -- SET NOCOUNT ON added to prevent extra result sets from                          
-- -- interfering with SELECT statements.                          
-- SET NOCOUNT ON;    
-- declare @CustomerCode VARCHAR(30)='20603841';--default customer code for consoli'    
-- DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]    
-- CREATE TABLE #AccountTable (    
--   AccountCode VARCHAR(50)    
--   );    
-- -- Insert statements for procedure here                                    
-- BEGIN TRY    
--  -- Insert statements for procedure here                          
--  DECLARE @CurrentMonthDate VARCHAR(10);    
    
--  ---- Need to get Total Month count -- Current month +5                                
--  SET @CurrentMonthDate = CAST(CAST(@CurrentMonth AS VARCHAR(10)) + '01' AS DATE)    
    
--  CREATE TABLE #ConsoleTMPMonthData (MonthData INT)    
    
--  DECLARE @StartMonth INT = 0;    
--  DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                              
    
--  delete from TransmissionData where CustomerCode='20603841' and Status='Pending';    
    
--  WHILE @StartMonth <= @EndMonth    
--  BEGIN    
--   INSERT INTO #ConsoleTMPMonthData (MonthData)    
--   VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))    
    
--   SET @StartMonth = @StartMonth + 1    
--  END;    
    
--  -- Check if the temporary table exists                
--  IF OBJECT_ID('tempdb.dbo.#ConsoleTMP') IS NOT NULL    
--  BEGIN    
--   -- Drop the temporary table                
--   DROP TABLE #ConsoleTMP;    
--  END    
    
--  CREATE TABLE #ConsoleTMP (    
--   CustomerCode VARCHAR(50)    
--   ,CurrentMonthYear INT    
--   ,MaterialCode VARCHAR(50)    
--   ,MonthYear INT    
--   ,ModeOfTypeId INT    
--   ,ModeOfTypeText VARCHAR(20)    
--   ,TotalAmount decimal(18,2)    
--   ,TotalQuantity INT    
--   ,SalesValue decimal(18,2)    
--   ,PLanName VARCHAR(20)    
--   ,SaleSequenceType VARCHAR(2)    
--   ,DataOrderBy INT    
--   );    
       
--   -- SELECT Customer which is TransmissionList -- Collabo                          
    
--  WITH CTECollabo (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  AS (    
--   -- PURCHASE DATA                        
--   SELECT @CustomerCode    
--    ,@CurrentMonth    
--    ,VD.MaterialCode    
--    ,VD.MonthYear    
--    ,'P' AS ModeText    
-- ,sum(Quantity)   
--    ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE_BY_MATEIALCODE](1,@Type,MaterialCode,cast(MonthYear AS INT)) ,0)=0  then sum(Quantity)*sum(PRICE)  
-- else sum(Quantity)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE_BY_MATEIALCODE](1,@Type,MaterialCode,cast(MonthYear AS INT)) AS decimal(18,2)) end  
--    , sum(Quantity)*sum(PRICE) as SalesValue    
--    ,'Consoli' AS PlanName    
--    ,'01' AS SaleSequenceType    
--    ,1    
--   FROM  [dbo].[VW_DIRECT_SALE_Consoli_Transmission] VD     
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear    
--   WHERE VD.SaleSubType = @Type    
--   AND  ModeOfTypeId in (1,12,10)   
--   group by MaterialCode,MonthYear,SaleSubType  
--   -- SALE DATA                        
       
--   UNION    
       
--   SELECT @CustomerCode   
--    ,@CurrentMonth    
--    ,VD.MaterialCode    
--    ,VD.MonthYear    
--    ,'S' AS ModeText    
--    ,SUM(Quantity)  
--    ,0 as TotalAmount    
--    ,SUM(Quantity)*SUM(PRICE) as SalesValue    
--    ,'Consoli' AS PlanName    
--    ,'02' AS SaleSequenceType    
--    ,2    
--   FROM  [dbo].[VW_DIRECT_SALE_Consoli_Transmission] VD     
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear    
--   WHERE VD.SaleSubType = @Type    
--    AND VD.ModeOfTypeId IN (3)    
--    group by MaterialCode,MonthYear,SaleSubType  
--   -- INVENTORY DATA                        
       
--   UNION    
       
--   SELECT @CustomerCode    
--    ,@CurrentMonth    
--    ,VD.MaterialCode    
--    ,VD.MonthYear    
--    ,'I' AS ModeText    
--    ,0    
--    ,0    
--    ,0    
--    ,'Consoli' AS PlanName    
--    ,'03' AS SaleSequenceType    
--    ,3    
--   FROM  [dbo].[VW_DIRECT_SALE_Consoli_Transmission] VD     
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear    
--   WHERE VD.SaleSubType = @Type    
--    AND VD.ModeOfTypeId IN (4)    
--   group by MaterialCode,MonthYear,SaleSubType  
--   )    
--  INSERT INTO #ConsoleTMP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  SELECT @CustomerCode    
--   ,@CurrentMonth    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--  FROM CTECollabo;    
     
--  WITH CTEAdjustment (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  AS (    
--   SELECT AE.CustomerCode    
--    ,0    
--    ,AE.MaterialCode    
--    ,AP.MonthYear    
--    ,2    
--    ,'P'    
--    ,AP.Qty    
--    ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,CustomerCode,cast(AP.MonthYear AS INT)),0)=0  then cast(Qty AS INT)*cast(AP.Price as decimal(18,2))  
-- else cast(Qty AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,CustomerCode,cast(AP.MonthYear AS INT)) AS decimal(18,2)) end  
-- ,cast(Qty AS INT)*cast(AP.Price as decimal(18,2)) AS SalesValue    
--    ,'Consoli'    
--    ,'01' AS SaleSequenceType    
--    ,7    
--   FROM [dbo].[AdjustmentEntry] AE    
--   INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId    
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear    
       
--   UNION    
       
--   SELECT AE.CustomerCode    
--    ,0    
--    ,AE.MaterialCode    
--    ,AP.MonthYear    
--    ,3    
--    ,'S'    
--    ,CAST(AP.Qty AS INT)    
--    ,0    
--    ,CAST(AP.Qty AS INT)*CAST(AP.Price AS DECIMAL(18,2))     
--    ,'Consoli'    
--    ,'02' AS SaleSequenceType    
--    ,8    
--   FROM [dbo].[AdjustmentEntry] AE    
--   INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId    
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear    
       
--   UNION    
       
--   SELECT AE.CustomerCode    
--    ,0    
--    ,AE.MaterialCode    
--    ,AP.MonthYear    
--    ,4    
--    ,'I'    
--    ,0    
--    ,0    
--    ,0    
--    ,'Consoli'    
--    ,'03' AS SaleSequenceType    
--    ,9    
--   FROM [dbo].[AdjustmentEntry] AE    
--   INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId    
--   INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear    
      
--   )    
--  INSERT INTO #ConsoleTMP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  SELECT @CustomerCode    
--   ,@CurrentMonth    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--  FROM CTEAdjustment    
--   ;    
    
--  ---SSD--     
--  WITH CTESSD (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  AS (    
--   SELECT SE.CustomerCode    
--    ,@CurrentMonth    
--    ,SE.MaterialCode    
--    ,SP.MonthYear    
--    ,2    
--    ,'P'    
--    ,SP.Qty    
-- ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,CustomerCode,cast(SP.MonthYear AS INT)),0)=0  then SP.Price * SP.Qty   
-- else cast(Qty AS INT)* cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,CustomerCode,cast(SP.MonthYear AS INT)) AS decimal(18,2)) end  
--    ,SP.Price * SP.Qty    
--    ,'Consoli' AS PlanName    
--    ,'01' AS SaleSequenceType    
--    ,10    
--   FROM [dbo].[SSDEntryQtyPrice] SP    
--   INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SE.SSDEntryID    
--   INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData    
--   WHERE SE.ModeOfTypeId = 1    
       
--   UNION    
       
--   SELECT SE.CustomerCode    
--    ,@CurrentMonth    
--    ,SE.MaterialCode    
--    ,SP.MonthYear    
--    ,2    
--    ,'S'    
--    ,SP.Qty    
-- ,0  
--    ,SP.Price * SP.Qty   
--    ,'Consoli' AS PlanName    
--    ,'02' AS SaleSequenceType    
--    ,11    
--   FROM [dbo].[SSDEntryQtyPrice] SP    
--   INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SE.SSDEntryID    
--   INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData    
--   WHERE SE.ModeOfTypeId = 1    
       
--   UNION    
       
--   SELECT SE.CustomerCode    
--    ,@CurrentMonth    
--    ,SE.MaterialCode    
--    ,SP.MonthYear    
--    ,2    
--    ,'I'    
--    ,0    
--    ,0    
--    ,0    
--    ,'Consoli' AS PlanName    
--    ,'03' AS SaleSequenceType    
--    ,12    
--   FROM [dbo].[SSDEntryQtyPrice] SP    
--   INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SE.SSDEntryID    
--   INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData    
--   WHERE SE.ModeOfTypeId = 1    
--   )    
--  INSERT INTO #ConsoleTMP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  SELECT CustomerCode    
--   ,@CurrentMonth    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,SalesValue    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--  FROM CTESSD    
    
--  --SNS DATA     
      
    
--  INSERT INTO #AccountTable (    
--   AccountCode    
       
--   )    
--  SELECT distinct AccountCode    
--  FROM Account;    
--    if(@Type='Monthly')  
-- BEGIN  
--  WITH CTESNS (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount  
--   ,SalesValue  
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  AS (    
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'P'    
--    ,sum(p.Quantity) as TotalQuantity    
-- ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) ,0)=0  
-- then sum(p.Quantity)*sum(p.Price) else sum(p.Quantity)*cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) AS decimal(18,2)) end  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
--    ,'Consoli' AS PLanName    
--    ,'01' AS SequenceType    
--    ,13    
--   FROM  
--   TRNPricePlanning p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE SaleSubType=@Type and  ModeofType IN ('PURCHASE','MPO')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   UNION    
       
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'S'    
--    ,sum(p.Quantity) as TotalQuantity    
-- ,0  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
--    ,'Consoli' AS PLanName    
--    ,'02' AS SequenceType    
--    ,14    
--   FROM TRNPricePlanning p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE SaleSubType=@Type and ModeofType IN ('SALES')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   UNION    
       
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'I'    
--    ,sum(p.Quantity) as TotalQuantity    
--    ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)),0)=0  
-- then sum(p.Quantity)*sum(p.Price) else sum(p.Quantity)*cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) AS decimal(18,2)) end  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
-- ,'Consoli' AS PLanName    
--    ,'03' AS SequenceType    
--    ,15    
--   FROM TRNPricePlanning p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE SaleSubType=@Type and ModeofType IN ('INVENTORY')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--    group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   )    
       
--  INSERT INTO #ConsoleTMP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalAmount    
--   ,TotalQuantity    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  SELECT @CustomerCode    
--   ,@CurrentMonth    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--  FROM CTESNS  ;  
--  END  
--  ELSE  
--  BEGIN  
--  WITH CTESNSBP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount  
--   ,SalesValue  
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  AS (    
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'P'    
--    ,sum(p.Quantity) as TotalQuantity    
-- ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) ,0)=0  
-- then sum(p.Quantity)*sum(p.Price) else sum(p.Quantity)*cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](2,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) AS decimal(18,2)) end  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
--    ,'Consoli' AS PLanName    
--    ,'01' AS SequenceType    
--    ,13    
--   FROM  
--   TRNPricePlanning_BP p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE   ModeofType IN ('PURCHASE','MPO')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   UNION    
       
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'S'    
--    ,sum(p.Quantity) as TotalQuantity    
-- ,0  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
--    ,'Consoli' AS PLanName    
--    ,'02' AS SequenceType    
--    ,14    
--   FROM TRNPricePlanning_BP p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE  ModeofType IN ('SALES')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--   group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   UNION    
       
--   SELECT p.AccountCode    
--    ,@CurrentMonth    
--    ,MaterialCode    
--    ,MonthYear    
--    ,2    
--    ,'I'    
--    ,sum(p.Quantity) as TotalQuantity    
--    ,case when COALESCE([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)),0)=0  
-- then sum(p.Quantity)*sum(p.Price) else sum(p.Quantity)*cast([dbo].[UDF_COG_CST_FRT_FOB_TOTALPRICE](1,@Type,MaterialCode,P.AccountCode,cast(P.MonthYear AS INT)) AS decimal(18,2)) end  
--    ,sum(p.Quantity)*[dbo].[UDF_GetSalesValueForSNSConsolidation](MaterialCode, P.AccountCode, MonthYear, @Type)   
-- ,'Consoli' AS PLanName    
--    ,'03' AS SequenceType    
--    ,15    
--   FROM TRNPricePlanning_BP p    
--   LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData    
--   LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode    
--   WHERE  ModeofType IN ('INVENTORY')    
--    AND a.AccountCode IS NOT NULL    
--    AND MD.MonthData IS NOT NULL    
--    group by p.AccountCode,p.MonthYear,p.MaterialCode    
--   )    
       
--  INSERT INTO #ConsoleTMP (    
--   CustomerCode    
--   ,CurrentMonthYear    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalAmount    
--   ,TotalQuantity    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--   )    
--  SELECT @CustomerCode    
--   ,@CurrentMonth    
--   ,MaterialCode    
--   ,MonthYear    
--   ,ModeOfTypeId    
--   ,ModeOfTypeText    
--   ,TotalQuantity    
--   ,TotalAmount    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,DataOrderBy    
--  FROM CTESNSBP  ;  
--  end  
--  --Insert Data in Transmission data for file write                                    
--  INSERT INTO TransmissionData (    
--   CustomerCode    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,MonthYear    
--   ,Qty    
--   ,Amount    
--   ,SaleValue    
--   ,[Plan]    
--   ,SaleType    
--   ,SaleSequenceType    
--   ,SalesSequenceTypeText    
--   ,CreatedBy    
--   ,EDIStatus    
--   ,[Status]    
--   ,PlanTypeCode    
--   ,PlanTypeName    
--   ,SaleSubType    
--   )    
--  SELECT DISTINCT '20603841'--default customer code for consoli    
--   ,MaterialCode    
--   ,CurrentMonthYear    
--   ,MonthYear    
--   ,COALESCE(sum(TotalQuantity), 0)    
--   ,COALESCE(sum(TotalAmount), 0)    
--   ,COALESCE(sum(SalesValue), 0)    
--   ,PLanName    
--   ,@Type    
--   ,SaleSequenceType    
--   ,ModeOfTypeText    
--   ,@CreatedBy    
--   ,'Pending'    
--   ,'Pending'    
--   ,@PlanTypeCode    
--   ,@PlanTypeName    
--   ,@Type    
--  FROM #ConsoleTMP    
--  group by MaterialCode    
--   ,CurrentMonthYear    
--   ,MonthYear    
--   ,PLanName    
--   ,SaleSequenceType    
--   ,ModeOfTypeText    
       
--  ORDER BY MaterialCode    
--   ,MonthYear    
    
--  DECLARE @TotalNumber INT    
    
--  SET @TotalNumber = (    
--    SELECT COUNT(1)    
--    FROM #ConsoleTMP    
--    )    
    
--  INSERT INTO @ResultTable (    
--   [ResponseCode]    
--   ,[ResponseMessage]    
--   )    
--  VALUES (    
--   200    
--   ,'Tansmission Executed successfully'    
--   --,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'    
--   );    
-- END TRY    
    
-- BEGIN CATCH    
--  INSERT INTO @ResultTable (    
--   [ResponseCode]    
--   ,[ResponseMessage]    
--   )    
--  VALUES (    
--   500    
--   ,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))    
--   );    
-- END CATCH    
    
-- DROP TABLE #ConsoleTMP    
    
-- DROP TABLE #AccountTable    
    
-- DROP TABLE #ConsoleTMPMonthData    
    
-- SELECT DISTINCT [ResponseCode]    
--  ,[ResponseMessage]    
-- FROM @ResultTable    
--END


  
--CREATE PROC [dbo].[SP_Insert_TRNSalesPlanning_BP] (        
-- @userId VARCHAR(max)    
-- )        
--AS        
--BEGIN      
--declare @BPMonthYear int=0;  
--DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE];  
--BEGIN TRY  
--  BEGIN TRANSACTION;  
--SET @BPMonthYear = (  
--     SELECT ConfigValue  
--     FROM GlobalConfig  
--     WHERE ConfigKey = 'BP_Year'  
--     );  
-- DECLARE @tvpCustomerMaterialSalesPlannings AS [dbo].[TVP_SALES_PLANNING];        
-- INSERT INTO @tvpCustomerMaterialSalesPlannings        
-- SELECT NULL        
--  ,p.MonthYear        
--  ,CustomerCode        
--  ,MaterialCode        
--  ,Qty        
--  ,Qty * Price AS [Amount]        
--  ,OACCode        
--  ,Price       
--  ,SaleSubType      
--  ,@BPMonthYear      
-- FROM SNSEntry s        
-- INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId        
-- WHERE       
--   S.MonthYear >= CAST(@BPMonthYear AS INT)     
--  AND s.SaleSubType = 'BP';        
    
-- MERGE [dbo].[TRNSalesPlanning_BP] AS Target        
-- USING @tvpCustomerMaterialSalesPlannings AS Source        
--  ON Source.[MonthYear] = Target.[MonthYear]        
--   AND Source.[CustomerCode] = Target.[CustomerCode]        
--   AND Source.[MaterialCode] = Target.[MaterialCode]        
--   AND Source.[AccountCode] = Target.[AccountCode]       
       
--   -- For Insert                        
-- WHEN NOT MATCHED BY Target        
--  THEN        
--   INSERT (        
--    [MonthYear]        
--    ,[CustomerCode]        
--    ,[MaterialCode]        
--    ,[Quantity]        
--    ,[Amount]        
--    ,[AccountCode]        
--    ,[CreatedDate]        
--    ,[CreatedBy]        
--    ,[UpdatedDate]        
--    ,[UpdatedBy]        
--    ,Price       
     
-- ,BP_YEAR      
--    )        
--   VALUES (        
--    Source.[MonthYear]        
--    ,Source.[CustomerCode]        
--    ,Source.[MaterialCode]        
--    ,Source.[Quantity]        
--    ,Source.[Amount]        
--    ,Source.[AccountCode]        
--    ,GETDATE()        
--    ,@userId        
--    ,GETDATE()        
--    ,@userId        
--    ,Source.[Price]       
      
-- ,Source.[BP_YEAR]       
--    )        
--    -- For Updates                        
-- WHEN MATCHED        
--  THEN        
--   UPDATE        
--   SET Target.[Quantity] = Source.[Quantity]        
--    ,Target.[Price] = Source.[Price]        
--    ,Target.[UpdatedDate] = GETDATE()        
--    ,Target.[UpdatedBy] = @userId;        
  
-- DECLARE @TVPAccountCodeMaterialCodeList AS dbo.[TVP_ACCOUNT_MATERIAL_CODE_LIST];  
-- DECLARE @TVPMonthList AS dbo.[TVP_ID_LIST];  
--    insert @TVPMonthList (ID)   
--    select distinct MonthYear from @tvpCustomerMaterialSalesPlannings;  
-- INSERT INTO @TVPAccountCodeMaterialCodeList  
--    SELECT AccountCode  
--     ,MaterialCode  
--    FROM @tvpCustomerMaterialSalesPlannings;  
-- EXEC SP_Calculate_RollingInventory_BP @userId,  
-- @TVPAccountCodeMaterialCodeList,@TVPMonthList,  
-- @BPMonthYear;  
--  COMMIT;      
-- END TRY   
--  BEGIN CATCH      
--  ROLLBACK;   
--  INSERT INTO @ResultTable (          
--   [ResponseCode]          
--   ,[ResponseMessage]          
--   )          
--  VALUES (          
--   500          
--   ,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))          
--   );   
-- END CATCH   
-- SELECT DISTINCT [ResponseCode]    
--  ,[ResponseMessage]    
-- FROM @ResultTable    
--END


         
--CREATE PROCEDURE [dbo].[SP_Calculate_RollingInventory_BP] (      
-- @userId NVARCHAR(100)      
-- ,@tvpAccontMaterialCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST] READONLY      
-- ,@TVPMonthList [dbo].[TVP_ID_LIST] READONLY    
-- ,@BP_YEAR INT    
-- )      
--AS      
--BEGIN      
-- -- SET NOCOUNT ON added to prevent extra result sets from                
-- -- interfering with SELEaCT statements.                
-- SET NOCOUNT ON      
      
-- -- Insert statements for procedure here                
-- BEGIN TRY      
--  BEGIN TRANSACTION      
      
--  DECLARE      
--   @accountMaterialCount INT      
--   ,@materialCount INT;      
      
--  DECLARE @tvpSNSEntryQtyPrices AS [dbo].[TVP_SNS_ENTRY_QTY_PRICES];      
--  DECLARE @tvpPricePlannings AS [dbo].[TVP_PRICE_PLANNING];      
--  DECLARE @tvpAccontMaterialCodeListWithRowNo [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO];      
--  DECLARE @tvpAccountMaterialDistCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST];      
      
--  IF NOT EXISTS (      
--    SELECT TOP 1 1      
--    FROM @tvpAccontMaterialCodeList      
--    )      
--  BEGIN      
--   INSERT INTO @tvpAccountMaterialDistCodeList      
--   SELECT DISTINCT [AccountCode]      
--    ,MaterialCode      
--   FROM [dbo].[TRNPricePlanning_BP] WHERE  BP_YEAR=@BP_YEAR;      
      
--   INSERT INTO @tvpAccontMaterialCodeListWithRowNo (      
--    [AccountCode]      
--    ,[MaterialCode]      
--    ,RowNo      
--    )      
--   SELECT DISTINCT [AccountCode]      
--    ,[MaterialCode]      
--    ,ROW_NUMBER() OVER (      
--     ORDER BY [AccountCode]      
--      ,[MaterialCode] ASC      
--     ) AS RowNo      
--   FROM @tvpAccountMaterialDistCodeList;      
--  END      
--  ELSE      
--  BEGIN      
--   IF EXISTS (      
--     SELECT TOP 1 1      
--     FROM @tvpAccontMaterialCodeList      
--     WHERE AccountCode IS NOT NULL      
--      AND AccountCode != ''      
--      AND (      
--       MaterialCode IS NULL      
--       OR MaterialCode = ''      
--       )      
--     )      
--   BEGIN      
--    --PRINT 'MaterialCode IS EMPTY';            
--    INSERT INTO @tvpAccountMaterialDistCodeList      
--    SELECT DISTINCT [AccountCode]      
--     ,MaterialCode      
--    FROM [dbo].[TRNPricePlanning_BP]      
--    WHERE  BP_YEAR=@BP_YEAR AND  [AccountCode] IN (      
--      SELECT DISTINCT [AccountCode]      
--      FROM @tvpAccontMaterialCodeList      
--      WHERE AccountCode IS NOT NULL      
--       AND AccountCode != ''     
--      );      
      
--    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (      
--     [AccountCode]      
--     ,[MaterialCode]      
--     ,RowNo      
--     )      
--    SELECT DISTINCT [AccountCode]      
--     ,[MaterialCode]      
--     ,ROW_NUMBER() OVER (      
--      ORDER BY [AccountCode]      
--       ,[MaterialCode] ASC      
--      ) AS RowNo      
--    FROM @tvpAccountMaterialDistCodeList;      
--   END      
--   ELSE      
--   BEGIN      
--    --PRINT 'MaterialCode IS NOT EMPTY';            
--    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (      
--     [AccountCode]      
--     ,[MaterialCode]      
--     ,RowNo      
--     )      
--    SELECT [AccountCode]      
--     ,[MaterialCode]      
--     ,ROW_NUMBER() OVER (      
--      ORDER BY [AccountCode]      
--       ,[MaterialCode] ASC      
--      ) AS RowNo      
--    FROM @tvpAccontMaterialCodeList;      
--   END      
--  END      
      
--  --- TAKE Sales From TRNSALESPLANNING      
--  INSERT INTO @tvpSNSEntryQtyPrices      
--  SELECT       
         
--   SE.MonthYear      
--   ,SE.CustomerCode      
--   ,SE.MaterialCode      
--   ,SE.Quantity      
--   ,SE.Amount      
--   ,SE.AccountCode      
--  FROM dbo.TRNSalesPlanning_BP SE      
--  WHERE SE.MonthYear >= (select top 1 id from @TVPMonthList order by id asc)       
--   AND SE.MonthYear <= (select top 1 id from @TVPMonthList order by id desc)        
--   AND SE.[AccountCode] IN (      
--    SELECT [AccountCode]      
--    FROM @tvpAccontMaterialCodeListWithRowNo      
--    )      
--   AND SE.[MaterialCode] IN (      
--    SELECT [MaterialCode]      
--    FROM @tvpAccontMaterialCodeListWithRowNo      
--    );      
      
--  SET @accountMaterialCount = (      
--    SELECT COUNT(1)      
--    FROM @tvpAccontMaterialCodeListWithRowNo      
--    );      
      
--  --SET @materialCount = (SELECT COUNT(1) from @tvpAccontMaterialCodeListWithRowNo);              
--  DECLARE @accountMaterialIndex INT = 1;      
--  DECLARE @activeAccountCode NVARCHAR(50) = '';      
--  DECLARE @activeMaterialCode NVARCHAR(50) = '';      
               
--  WHILE (@accountMaterialIndex <= @accountMaterialCount)      
--  BEGIN      
--   SELECT @activeAccountCode = AccountCode      
--    ,@activeMaterialCode = MaterialCode      
--   FROM @tvpAccontMaterialCodeListWithRowNo      
--   WHERE RowNo = @accountMaterialIndex;      
--   DECLARE @activeMonthYear INT = (select top 1 id from @TVPMonthList order by id asc);      
--   DECLARE @monthIndex INT = 0;      
--   declare @EndMonthYear int =(select top 1 id from @TVPMonthList order by id desc);    
      
--   WHILE @activeMonthYear <= @EndMonthYear      
--   BEGIN      
--    DECLARE @activeNextMonthYear INT = 0;      
--    DECLARE @activePrevMonthYear INT = 0;      
                
--    DECLARE @activeMonth DATE = CONVERT(DATETIME, CONCAT (      
--       CAST(@activeMonthYear AS VARCHAR(6))      
--       ,'01'      
--       ), 112);      
               
--    SET @activeNextMonthYear = (      
--      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)      
--      );      
--    SET @activePrevMonthYear = (      
--      SELECT CAST(FORMAT(DATEADD(month, - 1, @activeMonth), 'yyyyMM') AS INT)      
--      );      
      
                
--    IF @monthIndex != 0      
--    BEGIN      
--     --INSERT/UPDATE SALES START              
--     DECLARE @totalQty INT = 0;      
      
--     SET @totalQty = (      
--       SELECT SUM([Quantity])      
--       FROM @tvpSNSEntryQtyPrices      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--       );      
      
--     IF EXISTS (      
--       SELECT TOP 1 1      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--        AND ModeOfType = 'SALES'      
--        AND Type = 'S&S'      
--       )      
--     BEGIN      
--      UPDATE @tvpPricePlannings      
--      SET [Quantity] = ISNULL(@totalQty, 0)      
--      WHERE AccountCode = @activeAccountCode      
--       AND MaterialCode = @activeMaterialCode      
--       AND MonthYear = @activeMonthYear      
--       AND ModeOfType = 'SALES'      
--       AND Type = 'S&S';      
--     END      
--     ELSE      
--     BEGIN      
--      INSERT INTO @tvpPricePlannings (      
--       [AccountCode]      
--       ,[MonthYear]      
--       ,[MaterialCode]      
--       ,[ModeofType]      
--       ,[Type]      
--       ,[Quantity]      
--       ,Price      
--       )      
--      SELECT @activeAccountCode      
--       ,@activeMonthYear      
--       ,@activeMaterialCode      
--       ,'SALES'      
--       ,'S&S'      
--       ,ISNULL(@totalQty, 0)      
--       ,0;      
--     END      
      
--     --INSERT/UPDATE SALES END              
--     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE START              
--     DECLARE @activeCurrentMonthOrderQty INT = 0;      
--     DECLARE @activeNextMonthPurchaseQty INT = 0;      
--     DECLARE @activeCurrentMonthOrderPrice DECIMAL = 0;      
--     DECLARE @activeNextMonthPurchasePrice DECIMAL = 0;      
      
--     SET @activeCurrentMonthOrderQty = (      
--       SELECT [Quantity]      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--        AND [ModeofType] = 'ORDER'      
--       );      
--     SET @activeCurrentMonthOrderPrice = (      
--       SELECT [Price]      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--        AND [ModeofType] = 'ORDER'      
--       );      
      
--     IF EXISTS (      
--       SELECT TOP 1 1      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeNextMonthYear      
--        AND [ModeofType] = 'PURCHASE'      
--        AND Type = 'S&S'      
--       )      
--     BEGIN      
--      SET @activeNextMonthPurchaseQty = (      
--        SELECT [Quantity]      
--        FROM @tvpPricePlannings      
--        WHERE AccountCode = @activeAccountCode      
--         AND MaterialCode = @activeMaterialCode      
--         AND MonthYear = @activeNextMonthYear      
--         AND [ModeofType] = 'PURCHASE'      
--         AND Type = 'S&S'      
--        );      
--      SET @activeNextMonthPurchasePrice = (      
--        SELECT [Price]      
--        FROM @tvpPricePlannings      
--        WHERE AccountCode = @activeAccountCode      
--         AND MaterialCode = @activeMaterialCode      
--         AND MonthYear = @activeNextMonthYear      
--         AND [ModeofType] = 'PURCHASE'      
--         AND Type = 'S&S'      
--        );      
      
--      IF @activeCurrentMonthOrderQty != @activeNextMonthPurchaseQty      
--      BEGIN      
--       UPDATE @tvpPricePlannings      
--       SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)      
--        ,Price = ISNULL(@activeCurrentMonthOrderPrice, 0)      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeNextMonthYear      
--        AND [ModeofType] = 'PURCHASE'      
--        AND Type = 'S&S';      
--      END      
--     END      
--     ELSE      
--     BEGIN      
--      INSERT INTO @tvpPricePlannings (      
--       [AccountCode]      
--       ,[MonthYear]      
--       ,[MaterialCode]      
--       ,[ModeofType]      
--       ,[Type]      
--       ,[Quantity]      
--       ,Price      
--       )      
--      SELECT @activeAccountCode      
--       ,@activeNextMonthYear      
--       ,@activeMaterialCode      
--       ,'PURCHASE'      
--       ,'S&S'      
--       ,ISNULL(@activeCurrentMonthOrderQty, 0)      
--       ,ISNULL(@activeCurrentMonthOrderPrice, 0);      
--     END      
      
--     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE END              
--     --CURRENT MONTH ORDER == CURRENT MONTH GIT START            
--     IF EXISTS (      
--       SELECT TOP 1 1      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--        AND [ModeofType] = 'GIT Arrivals'      
--       )      
--     BEGIN      
--      UPDATE @tvpPricePlannings      
--      SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)      
--       ,[Price] = ISNULL(@activeCurrentMonthOrderPrice, 0)      
--      WHERE AccountCode = @activeAccountCode      
--       AND MaterialCode = @activeMaterialCode      
--       AND MonthYear = @activeMonthYear      
--       AND [ModeofType] = 'GIT Arrivals';      
--     END      
--     ELSE      
--     BEGIN      
--      INSERT INTO @tvpPricePlannings (      
--       [AccountCode]      
--       ,[MonthYear]      
--       ,[MaterialCode]      
--       ,[ModeofType]      
--       ,[Type]      
--       ,[Quantity]      
--       ,Price      
--       )      
--      SELECT @activeAccountCode      
--       ,@activeMonthYear      
--       ,@activeMaterialCode      
--       ,'GIT Arrivals'      
--       ,NULL      
--       ,ISNULL(@activeCurrentMonthOrderQty, 0)      
--       ,ISNULL(@activeCurrentMonthOrderQty, 0);      
--     END      
      
--     --CURRENT MONTH ORDER == CURRENT MONTH GIT end            
            
----Current Month Inventory=(nxt month sales qty* n month turnover days)/30    
       
--     DECLARE @activeCurrentInventoryQty INT = 0;      
          
--     DECLARE @activeCurrentInventoryPrice DECIMAL = 0;      
        
      
--     SET @activeCurrentInventoryQty = (      
--       SELECT ([Quantity]*[dbo].[UDF_Turnover_Days](MonthYear,AccountCode,MaterialCode))/30    
--       FROM @tvpPricePlannings     
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeNextMonthYear      
--        AND [ModeofType] = 'SALES'      
--       );      
--     SET @activeCurrentInventoryPrice = (      
--       SELECT [Price]      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeNextMonthYear      
--        AND [ModeofType] = 'SALES'      
--       );      
       
--     IF EXISTS (      
--       SELECT TOP 1 1      
--       FROM @tvpPricePlannings      
--       WHERE AccountCode = @activeAccountCode      
--        AND MaterialCode = @activeMaterialCode      
--        AND MonthYear = @activeMonthYear      
--        AND [ModeofType] = 'INVENTORY'      
--       )      
--     BEGIN      
--      --PRINT '@update INVENTORY';              
--      UPDATE @tvpPricePlannings      
--      SET [Quantity] = @activeCurrentInventoryQty      
--       ,Price = @activeCurrentInventoryPrice      
--      WHERE AccountCode = @activeAccountCode      
--       AND MaterialCode = @activeMaterialCode      
--       AND MonthYear = @activeMonthYear      
--       AND [ModeofType] = 'INVENTORY';      
--     END      
--     ELSE      
--     BEGIN      
--      --PRINT '@insert INVENTORY';              
--      INSERT INTO @tvpPricePlannings (      
--       [AccountCode]      
--       ,[MonthYear]      
--       ,[MaterialCode]      
--       ,[ModeofType]      
--       ,[Type]      
--       ,[Quantity]      
--       ,Price      
--       )      
--      SELECT @activeAccountCode      
--       ,@activeMonthYear      
--       ,@activeMaterialCode      
--       ,'INVENTORY'      
--       ,NULL      
--       ,@activeCurrentInventoryQty      
--       ,@activeCurrentInventoryPrice;      
--     END      
--    END      
      
--    --PRINT '@monthIndex';              
--    --PRINT @monthIndex;              
--    SET @monthIndex = @monthIndex + 1;      
--    --PRINT @monthIndex;              
--    SET @activeMonthYear = (      
--      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)      
--      );      
--     --PRINT '@activeMonthYear';              
--     --PRINT @activeMonthYear;              
--     --END              
--     --SET @materialIndex = @materialIndex + 1;              
--   END      
      
--   SET @accountMaterialIndex = @accountMaterialIndex + 1;      
--  END      
      
--  --INSERT OR UPDATE              
--  --PRINT 'MERGE STATEMENT';              
--  --SELECT * FROM @tvpPricePlannings;     
--  UPDATE @tvpPricePlannings SET BP_YEAR=@BP_YEAR;    
--  MERGE [dbo].[TRNPricePlanning_BP] AS Target      
--  USING @tvpPricePlannings AS Source      
--   ON Source.[AccountCode] = Target.[AccountCode]      
--    AND Source.[MonthYear] = Target.[MonthYear]      
--    AND Source.[MaterialCode] = Target.[MaterialCode]      
--    AND Source.[ModeofType] = Target.[ModeofType]      
-- AND Source.BP_YEAR = Target.BP_YEAR     
--    -- For Insert              
--  WHEN NOT MATCHED BY Target      
--   THEN      
--    INSERT (      
--     [AccountCode]      
--     ,[MonthYear]      
--     ,[MaterialCode]      
--     ,[ModeofType]      
--     ,[Type]      
--     ,[Quantity]      
--     ,[CreatedDate]      
--     ,[CreatedBy]      
--     ,[UpdatedDate]      
--     ,[UpdatedBy]      
--     ,Price    
--  ,BP_YEAR    
--     )      
--    VALUES (      
--     Source.[AccountCode]      
--     ,Source.[MonthYear]      
--     ,Source.[MaterialCode]      
--     ,Source.[ModeofType]      
--     ,Source.[Type]      
--     ,COALESCE(Source.[Quantity],0)      
--     ,GETDATE()      
--     ,@userId      
--     ,GETDATE()      
--     ,@userId      
--     ,COALESCE(Source.[Price],0)    
--  ,@BP_Year    
--     )      
--     -- For Updates              
--  WHEN MATCHED      
--   THEN      
--    UPDATE      
--    SET Target.[Quantity] = COALESCE(Source.[Quantity],0)     
--     ,Target.[Price] = COALESCE(Source.[Price],0)      
--     ,Target.[UpdatedDate] = GETDATE()      
--     ,Target.[UpdatedBy] = @userId;      
      
--  COMMIT;      
-- END TRY      
      
-- BEGIN CATCH      
--  ROLLBACK;      
-- END CATCH      
--END 

      
      
--CREATE PROC [dbo].[SP_Insert_TRNSalesPlanning] (      
-- @TvpSNSIdList [dbo].[TVP_ID_LIST] readonly      
-- ,@currentMonthYear VARCHAR(6)      
-- ,@userId VARCHAR(max)     
-- ,@SaleSubType VARCHAR(30)    
    
-- )      
--AS      
--BEGIN      
-- DECLARE @tvpCustomerMaterialSalesPlannings AS [dbo].[TVP_SALES_PLANNING];      
      
-- INSERT INTO @tvpCustomerMaterialSalesPlannings      
-- SELECT NULL      
--  ,p.MonthYear      
--  ,CustomerCode      
--  ,MaterialCode      
--  ,Qty      
--  ,Qty * Price AS [Amount]      
--  ,OACCode      
--  ,Price     
--  ,SaleSubType    
--  ,@currentMonthYear    
-- FROM SNSEntry s      
-- INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId      
-- WHERE s.SNSEntryId IN (      
--   SELECT id      
--   FROM @TvpSNSIdList      
--   )      
--  AND p.MonthYear >= @currentMonthYear      
--  AND s.SaleSubType = 'Monthly';      
      
-- MERGE [dbo].[TRNSalesPlanning] AS Target      
-- USING @tvpCustomerMaterialSalesPlannings AS Source      
--  ON Source.[MonthYear] = Target.[MonthYear]      
--   AND Source.[CustomerCode] = Target.[CustomerCode]      
--   AND Source.[MaterialCode] = Target.[MaterialCode]      
--   AND Source.[AccountCode] = Target.[AccountCode]     
--   AND Source.[SaleSubType] = Target.[SaleSubType]    
--   -- For Insert                      
-- WHEN NOT MATCHED BY Target      
--  THEN      
--   INSERT (      
--    [MonthYear]      
--    ,[CustomerCode]      
--    ,[MaterialCode]      
--    ,[Quantity]      
--    ,[Amount]      
--    ,[AccountCode]      
--    ,[CreatedDate]      
--    ,[CreatedBy]      
--    ,[UpdatedDate]      
--    ,[UpdatedBy]      
--    ,Price     
-- ,SaleSubType    
-- ,BP_YEAR    
--    )      
--   VALUES (      
--    Source.[MonthYear]      
--    ,Source.[CustomerCode]      
--    ,Source.[MaterialCode]      
--    ,Source.[Quantity]      
--    ,Source.[Amount]      
--    ,Source.[AccountCode]      
--    ,GETDATE()      
--    ,@userId      
--    ,GETDATE()      
--    ,@userId      
--    ,Source.[Price]     
-- ,Source.[SaleSubType]     
-- ,Source.[BP_YEAR]     
--    )      
--    -- For Updates                      
-- WHEN MATCHED      
--  THEN      
--   UPDATE      
--   SET Target.[Quantity] = Source.[Quantity]      
--    ,Target.[Price] = Source.[Price]      
--    ,Target.[UpdatedDate] = GETDATE()      
--    ,Target.[UpdatedBy] = @userId;      
--END

  
--CREATE PROCEDURE [dbo].[USP_InsertSNSEntries] (  
-- @OACID INT  
-- ,@tvpSNSEntries [dbo].[TVP_SNS_ENTRIES] READONLY  
-- ,@tvpSNSPrice dbo.TVP_SNS_PRICE_INFO READONLY  
-- ,@tvpSNSQuantities dbo.TVP_SNS_QTY_INFO READONLY  
-- ,@userId NVARCHAR(200)  
-- ,@SaleSubType NVARCHAR(20)  
-- )  
--AS  
--BEGIN  
-- -- SET NOCOUNT ON added to prevent extra result sets from                              
-- -- interfering with SELEaCT statements.                              
-- SET NOCOUNT ON  
  
-- -- TEMP TABLE FOR RETURN MESSAGE                              
-- DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]  
  
-- CREATE TABLE #TMP (  
--  ResponseCode VARCHAR(20)  
--  ,ResponseMessage NVARCHAR(max)  
--  )  
  
-- -- Insert statements for procedure here                              
-- BEGIN TRY  
--  BEGIN TRANSACTION;  
  
--  -- OAC Code--                              
--  DECLARE @OACCode VARCHAR(20);  
    
--  SET @OACCode = (  
--    SELECT AccountCode  
--    FROM Account  
--    WHERE AccountId = @OACID  
--    )  
  
--  -- Current Month Year from Global Config--                            
--  DECLARE @CurrentMonth VARCHAR(10);  
  
--  IF (@SaleSubType = 'Monthly')  
--  BEGIN  
--   SET @CurrentMonth = (  
--     SELECT ConfigValue  
--     FROM GlobalConfig  
--     WHERE ConfigKey = 'Current_Month'  
--      AND ConfigType = 'Direct And SNS'  
--     )  
--  END  
--  ELSE  
--  BEGIN  
--   SET @CurrentMonth = (  
--     SELECT ConfigValue  
--     FROM GlobalConfig  
--     WHERE ConfigKey = 'BP_Year'  
--     )  
--  END  
  
--  DECLARE @InValidCustomer TABLE (  
--   CustomerCode VARCHAR(200)  
--   ,RowIndex INT  
--   );  
--  DECLARE @InValidSNSCustomer TABLE (  
--   CustomerCode VARCHAR(200)  
--   ,RowIndex INT  
--   );  
--  DECLARE @InValidCustomerAccountMapping TABLE (  
--   CustomerCode VARCHAR(200)  
--   ,RowIndex INT  
--   );  
  
--  INSERT INTO @InValidCustomer (  
--   CustomerCode  
--   ,RowIndex  
--   )  
--  SELECT SE.CustomerCode  
--   ,SE.RowNum  
--  FROM @tvpSNSEntries SE  
--  LEFT JOIN Customer c ON SE.CustomerCode = c.CustomerCode  
--  WHERE c.CustomerCode IS NULL  
  
--  IF NOT EXISTS (  
--    SELECT TOP 1 1  
--    FROM @InValidCustomer  
--    )  
--  BEGIN  
--   -- CustomerIS SNS Customer                              
--   INSERT INTO @InValidSNSCustomer (  
--    CustomerCode  
--    ,RowIndex  
--    )  
--   SELECT DISTINCT SE.CustomerCode  
--    ,SE.RowNum  
--   FROM @tvpSNSEntries SE  
--   LEFT JOIN (  
--    SELECT C.CustomerId  
--     ,C.CustomerCode  
--     ,CD.AccountId  
--     ,CD.SaleTypeId  
--    FROM Customer C  
--    INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId  
--    ) a ON SE.CustomerCode = a.CustomerCode  
--    AND SE.SaleTypeId = a.SaleTypeId  
--   WHERE a.CustomerCode IS NULL  
  
--   -- Customer mapped account                              
--   INSERT INTO @InValidCustomerAccountMapping (  
--    CustomerCode  
--    ,RowIndex  
--    )  
--   SELECT DISTINCT SE.CustomerCode  
--    ,SE.RowNum  
--   FROM @tvpSNSEntries SE  
--   LEFT JOIN (  
--    SELECT C.CustomerId  
--     ,C.CustomerCode  
--     ,CD.AccountId  
--     ,CD.SaleTypeId  
--    FROM Customer C  
--    INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId  
--    ) a ON SE.CustomerCode = a.CustomerCode  
--    AND a.AccountId = @OACID  
--   WHERE a.CustomerCode IS NULL  
--  END  
  
--  -- Table variable for Material                              
--  DECLARE @InValidMaterial TABLE (  
--   MaterialCode VARCHAR(200)  
--   ,RowIndex INT  
--   );  
  
--  INSERT INTO @InValidMaterial (  
--   MaterialCode  
--   ,RowIndex  
--   )  
--  SELECT SE.MaterialCode  
--   ,SE.RowNum  
--  FROM @tvpSNSEntries SE  
--  LEFT JOIN Material M ON SE.MaterialCode = M.MaterialCode  
--  WHERE M.MaterialId IS NULL  
  
--  DECLARE @InValidModeleProdcutCategory TABLE (  
--   CategoryID INT  
--   ,MaterialCode VARCHAR(200)  
--   ,RowIndex INT  
--   )  
  
--  INSERT INTO @InValidModeleProdcutCategory (  
--   CategoryID  
--   ,MaterialCode  
--   ,RowIndex  
--   )  
--  SELECT T.CategoryID  
--   ,T.MaterialCode  
--   ,T.RowNum  
--  FROM @tvpSNSEntries T  
--  LEFT JOIN ProductCategory P ON P.ProductCategoryCode = Cast(T.CategoryID AS VARCHAR)  
--   AND P.ProductCategoryName = T.Category  
--  LEFT JOIN Material M ON (  
--    P.ProductCategoryId = M.ProductCategoryId1  
--    OR P.ProductCategoryId = M.ProductCategoryId2  
--    OR P.ProductCategoryId = M.ProductCategoryId3  
--    OR P.ProductCategoryId = M.ProductCategoryId4  
--    OR P.ProductCategoryId = M.ProductCategoryId5  
--    OR P.ProductCategoryId = M.ProductCategoryId6  
--    )  
--  WHERE M.MaterialId IS NULL  
  
--  IF (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidCustomer  
--     )  
--    )  
--   AND (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidMaterial  
--     )  
--    )  
--   AND (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidMaterial  
--     )  
--    )  
--   AND (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidModeleProdcutCategory  
--     )  
--    )  
--   --AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))        
--   AND (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidSNSCustomer  
--     )  
--    )  
--   AND (  
--    NOT EXISTS (  
--     SELECT TOP 1 1  
--     FROM @InValidCustomerAccountMapping  
--     )  
--    )  
--  BEGIN  
--   --- IF EVERY THING FINE-- THEN MOVE THAT CODE IN ARCHIVE TABLE                              
--   INSERT INTO [dbo].[SNSEntryArchive] (  
--    [SNSEntryID]  
--    ,[SaleTypeId]  
--    ,[CustomerId]  
--    ,[CustomerCode]  
--    ,[MaterialId]  
--    ,[MaterialCode]  
--    ,[CategoryId]  
--    ,[Category]  
--    ,[AttachmentId]  
--    ,[MonthYear]  
--    ,[CreatedDate]  
--    ,[CreatedBy]  
--    ,[UpdatedDate]  
--    ,[UpdatedBy]  
--    ,[ModeofTypeId]  
--    ,[ArchiveDate]  
--    ,[ArchiveBy]  
--    ,[ArchiveStatus]  
--    ,[OACCode]  
--    ,[SaleSubType]  
--    )  
--   SELECT SE.[SNSEntryID]  
--    ,SE.[SaleTypeId]  
--    ,SE.[CustomerId]  
--    ,SE.[CustomerCode]  
--    ,SE.[MaterialId]  
--    ,SE.[MaterialCode]  
--    ,SE.[CategoryId]  
--    ,SE.[Category]  
--    ,SE.[AttachmentId]  
--    ,SE.[MonthYear]  
--    ,SE.[CreatedDate]  
--    ,SE.[CreatedBy]  
--    ,SE.[UpdatedDate]  
--    ,SE.[UpdatedBy]  
--    ,SE.[ModeofTypeId]  
--    ,GETDATE()  
--    ,SE.[CreatedBy]  
--    ,'Y'  
--    ,SE.[OACCode]  
--    ,SE.SaleSubType  
--   FROM SNSEntry SE  
--   INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode  
--    AND T.MaterialCode = SE.MaterialCode  
--   WHERE MonthYear = @CurrentMonth  
--    AND SaleSubType = @SaleSubType  
--    AND OACCode = @OACCode  
  
--   INSERT INTO [dbo].[SNSEntryQtyPriceArchive] (  
--    [SNSEntryQtyPriceId]  
--    ,[SNSEntryId]  
--    ,[MonthYear]  
--    ,[Qty]  
--    ,[Price]  
--    ,[TotalAmount]  
--    ,[Currency]  
--    ,[CreatedDate]  
--    ,[CreatedBy]  
--    ,[UpdatedDate]  
--    ,[UpdatedBy]  
--    ,[ArchiveDate]  
--    ,[ArchiveBy]  
--    ,[ArchiveStatus]  
--    )  
--   SELECT SP.[SNSEntryQtyPriceId]  
--    ,SP.[SNSEntryId]  
--    ,SP.[MonthYear]  
--    ,SP.[Qty]  
--    ,SP.[Price]  
--    ,SP.[TotalAmount]  
--    ,SP.[Currency]  
--    ,SP.[CreatedDate]  
--    ,SP.[CreatedBy]  
--    ,SP.[UpdatedDate]  
--    ,SP.[UpdatedBy]  
--    ,GETDATE()  
--    ,SP.[UpdatedBy]  
--    ,'Y'  
--   FROM (  
--    SELECT SE.SNSEntryId  
--     ,SE.CustomerCode  
--    FROM SNSEntry SE  
--    INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode  
--     AND SE.MaterialCode = SN.MaterialCode  
--    WHERE  
--     --SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)                 
--     se.MonthYear = @CurrentMonth  
--     AND OACCode = @OACCode  
--     AND se.SaleSubType = @SaleSubType  
--    ) a  
--   INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId  
  
--   ---- DELETE FROM SNSEntryQtyPrice                              
--   DELETE  
--   FROM SNSEntryQtyPrice  
--   WHERE SNSEntryID IN (  
--     SELECT SP.SNSEntryId  
--     FROM (  
--      SELECT SE.SNSEntryId  
--       ,SE.CustomerCode  
--      FROM SNSEntry SE  
--      INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode  
--       AND SE.MaterialCode = SN.MaterialCode  
--      WHERE  
--       --SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)                 
--       SE.MonthYear = @CurrentMonth  
--       AND OACCode = @OACCode  
--       AND se.SaleSubType = @SaleSubType  
--      ) a  
--     INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId  
--     )  
  
--   -- -- DELETE FROM SNSEntry TABLE                
--   DELETE  
--   FROM SNSEntry  
--   WHERE SNSEntryId IN (  
--     SELECT SE.SNSEntryId  
--     FROM SNSEntry SE  
--     INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode  
--      AND T.MaterialCode = SE.MaterialCode  
--     WHERE  
--      --MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112))                   
--      MonthYear = @CurrentMonth  
--     )  
--    AND OACCode = @OACCode  
--    AND SaleSubType = @SaleSubType  
  
--   DECLARE @TOTALCOUNT INT;  
--   DECLARE @SNS_LASTIDENTITY INT = 0;  
--   DECLARE @SNS TABLE (  
--    [CustomerID] INT  
--    ,[CustomerCode] NVARCHAR(20)  
--    ,[MaterialID] INT  
--    ,[MaterialCode] NVARCHAR(20)  
--    ,[CategoryID] INT  
--    ,[Category] NVARCHAR(500)  
--    ,[AttachmentID] INT  
--    ,EXLROWNUM INT  
--    ,[SaleTypeId] INT  
--    ,[ModeofTypeId] INT  
--    ,RN INT  
--    )  
  
--   INSERT INTO @SNS (  
--    [CustomerID]  
--    ,CustomerCode  
--    ,MaterialCode  
--    ,CategoryID  
--    ,[Category]  
--    ,MaterialID  
--    ,AttachmentID  
--    ,EXLROWNUM  
--    ,[SaleTypeId]  
--    ,[ModeofTypeId]  
--    ,RN  
--    )  
--   SELECT C.CustomerID  
--    ,C.[CustomerCode]  
--    ,SE.[MaterialCode]  
--    ,[CategoryID]  
--    ,[Category]  
--    ,M.MaterialID  
--    ,[AttachmentID]  
--    ,[RowNum]  
--    ,[SaleTypeId]  
--    ,[ModeofTypeId]  
--    ,ROW_NUMBER() OVER (  
--     ORDER BY C.[CustomerCode]  
--     )  
--   FROM @tvpSNSEntries SE  
--   INNER JOIN Material M ON SE.MaterialCode = M.MaterialCode  
--   INNER JOIN Customer C ON SE.CustomerCode = C.CustomerCode  
  
--   DECLARE @tvpAccontCodeList AS dbo.[TVP_CODE_LIST];  
--   DECLARE @TVPAccountCodeMaterialCodeList AS dbo.[TVP_ACCOUNT_MATERIAL_CODE_LIST];  
--   DECLARE @tvpMaterialCodeList AS dbo.[TVP_CODE_LIST];  
--   DECLARE @TvpSNSIdList AS dbo.[TVP_ID_LIST];  
--   DECLARE @TVPMonthList AS dbo.[TVP_ID_LIST];  
  
--   -- SET TOTAL COUNT --                              
--   SET @TOTALCOUNT = (  
--     SELECT COUNT(*)  
--     FROM @SNS  
--     )  
  
--   DECLARE @STARTFROM INT = 1;  
  
--   -- SELECT * FROM @SNS                              
--   WHILE @STARTFROM <= @TOTALCOUNT  
--   BEGIN  
--    --SELECT * FROM @SNS                              
--    DECLARE @ROWNUM INT  
  
--    SET @ROWNUM = (  
--      SELECT EXLROWNUM  
--      FROM @SNS  
--      WHERE RN = @STARTFROM  
--      )  
  
--    --SELECT @ROWNUM                              
--    INSERT INTO SNSEntry (  
--     [CustomerID]  
--     ,[CustomerCode]  
--     ,[MaterialID]  
--     ,[MaterialCode]  
--     ,[CategoryID]  
--     ,[Category]  
--     ,[AttachmentID]  
--     ,[SaleTypeId]  
--     ,[ModeofTypeId]  
--     ,[CreatedDate]  
--     ,[CreatedBy]  
--     ,[UpdatedDate]  
--     ,[UpdatedBy]  
--     ,[MonthYear]  
--     ,[OACCode]  
--     ,[SaleSubType]  
--     )  
--    SELECT CustomerID  
--     ,CustomerCode  
--     ,MaterialID  
--     ,MaterialCode  
--     ,CategoryID  
--     ,Category  
--     ,AttachmentID  
--     ,[SaleTypeId]  
--     ,[ModeofTypeId]  
--     ,GETDATE()  
--     ,@userId  
--     ,GETDATE()  
--     ,@userId  
--     ,@CurrentMonth -- CONVERT(NVARCHAR(6), GETDATE(), 112)                              
--     ,@OACCode  
--     ,@SaleSubType  
--    FROM @SNS  
--    WHERE RN = @STARTFROM  
  
--    SELECT @SNS_LASTIDENTITY = SCOPE_IDENTITY();  
  
--    -- INSERT INTO [dbo].[SNSEntryQtyPrice] TABLE                              
--    INSERT INTO [dbo].[SNSEntryQtyPrice] (  
--     [SNSEntryID]  
--     ,[MonthYear]  
--     ,[Qty]  
--     ,[Price]  
--     ,[TotalAmount]  
--     ,[Currency]  
--     ,[CreatedDate]  
--     ,[CreatedBy]  
--     ,[UpdatedDate]  
--     ,[UpdatedBy]  
--     )  
--    SELECT @SNS_LASTIDENTITY  
--     ,P.[MonthYear]  
--     ,[Qty]  
--     ,CAST([Price] AS DECIMAL(18, 2))  
--     ,[Qty] * [Price]  
--     ,'USD'  
--     ,GETDATE()  
--     ,@userId  
--     ,GETDATE()  
--     ,@userId  
--    FROM @tvpSNSQuantities Q  
--    INNER JOIN @tvpSNSPrice P ON Q.[RowNum] = P.[RowNum]  
--     AND Q.[MonthYear] = P.[MonthYear]  
--    WHERE Q.[RowNum] = @ROWNUM  
  
--    INSERT INTO @tvpAccontCodeList  
--    SELECT @OACCode;  
  
--    INSERT INTO @tvpMaterialCodeList  
--    SELECT MaterialCode  
--    FROM @SNS  
--    WHERE RN = @STARTFROM  
  
--    INSERT INTO @TVPAccountCodeMaterialCodeList  
--    SELECT @OACCode  
--     ,MaterialCode  
--    FROM @SNS  
--    WHERE RN = @STARTFROM  
  
--    INSERT INTO @TvpSNSIdList  
--    SELECT @SNS_LASTIDENTITY  
  
--    SET @STARTFROM = @STARTFROM + 1  
--   END  
  
--   insert @TVPMonthList (ID) select distinct MonthYear from @tvpSNSQuantities;  
--   --- UPDATE PRICE FROM PRICING                            
--   -- EXEC  USP_UpdateFinalPrice @CurrentMonth                            
--   INSERT INTO @ResultTable (  
--    [ResponseCode]  
--    ,[ResponseMessage]  
--    )  
--   VALUES (  
--    200  
--    ,'Added ' + CAST(@TOTALCOUNT AS NVARCHAR(10)) + ' Record successfully'  
--    );  
--  END  
  
--  ----- INSERT INVALID CUSTOMER NAME AND CODE                              
--  --   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                              
--  --   SELECT 107,' : Customer Code : ' +CustomerCode +' not belong to this Customer.' from @InValidCustomerName                              
--  --- INSERT INVALID  CUSTOMER                              
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  SELECT 107  
--   ,' : Customer Code : ' + CustomerCode + ' is not correct.'  
--  FROM @InValidCustomer  
  
--  --- INSERT INVALID SNS CUSTOMER                              
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  SELECT 107  
--   ,' : Customer Code : ' + CustomerCode + ' is not SNS Customer.'  
--  FROM @InValidSNSCustomer  
  
--  --- INSERT INVALID CUSTOMER Account Mapping                             
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  SELECT 107  
--   ,' : Customer Code : ' + CustomerCode + ' is not belong to this account.'  
--  FROM @InValidCustomerAccountMapping  
  
--  --- INSERT INVALID MATERIAL                              
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  SELECT 107  
--   ,' : Material Code : ' + MaterialCode + ' is not model.'  
--  FROM @InValidMaterial  
  
--  -- INSERT INVALID PRODUCTCATEGORY AND MODEL                              
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  SELECT 107  
--   ,' : Product category : ' + CAST(CategoryID AS VARCHAR(10)) + ' and Material Code : ' + MaterialCode + ' is not a mapped.'  
--  FROM @InValidModeleProdcutCategory  
  
    
--   IF (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidCustomer  
--      )  
--     )  
--    AND (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidMaterial  
--      )  
--     )  
--    AND (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidMaterial  
--      )  
--     )  
--    AND (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidModeleProdcutCategory  
--      )  
--     )  
--    --AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))        
--    AND (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidSNSCustomer  
--      )  
--     )  
--    AND (  
--     NOT EXISTS (  
--      SELECT TOP 1 1  
--      FROM @InValidCustomerAccountMapping  
--      )  
--     )  
--   BEGIN  
     
--     IF (@SaleSubType = 'Monthly')  
--  BEGIN  
--  EXEC [dbo].[sp_Insert_TRNSalesPlanning] @TvpSNSIdList  
--     ,@CurrentMonth  
--     ,@userId  
--     ,@SaleSubType;  
--  EXEC [dbo].[SP_Calculate_RollingInventory] @userId  
--     ,@TVPAccountCodeMaterialCodeList;  
        
--  end  
--  --else  
--  --begin  
--  --EXEC [dbo].[SP_Insert_TRNSalesPlanning_BP] @TvpSNSIdList  
--  --   ,@CurrentMonth  
--  --   ,@userId  
--  --   ,@SaleSubType;  
--  --EXEC [dbo].[SP_Calculate_RollingInventory_BP] @userId  
--  --   ,@TVPAccountCodeMaterialCodeList,  
--  --   @TVPMonthList,@CurrentMonth;  
--  --end  
--   END  
    
  
--  --COMMIT TRANSACTION TRANS;    
--  IF @@TRANCOUNT > 0  
--   COMMIT;  
-- END TRY  
  
-- BEGIN CATCH  
--  --ROLLBACK TRANSACTION TRANS;    
--  IF @@TRANCOUNT > 0  
--   ROLLBACK;  
  
--  INSERT INTO @ResultTable (  
--   [ResponseCode]  
--   ,[ResponseMessage]  
--   )  
--  VALUES (  
--   500  
--   ,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))  
--   );  
-- END CATCH  
  
-- SELECT DISTINCT [ResponseCode]  
--  ,[ResponseMessage]  
-- FROM @ResultTable  
--END  

  
--CREATE PROC [dbo].[SP_Insert_TRNSalesPlanning_BP] (        
-- @userId VARCHAR(max)    
-- )        
--AS        
--BEGIN      
--declare @BPMonthYear int=0;  
--DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE];  
--BEGIN TRY  
--  BEGIN TRANSACTION;  
--SET @BPMonthYear = (  
--     SELECT ConfigValue  
--     FROM GlobalConfig  
--     WHERE ConfigKey = 'BP_Year'  
--     );  
-- DECLARE @tvpCustomerMaterialSalesPlannings AS [dbo].[TVP_SALES_PLANNING];        
-- INSERT INTO @tvpCustomerMaterialSalesPlannings        
-- SELECT NULL        
--  ,p.MonthYear        
--  ,CustomerCode        
--  ,MaterialCode        
--  ,Qty        
--  ,Qty * Price AS [Amount]        
--  ,OACCode        
--  ,Price       
--  ,SaleSubType      
--  ,@BPMonthYear      
-- FROM SNSEntry s        
-- INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId        
-- WHERE       
--   S.MonthYear >= CAST(@BPMonthYear AS INT)     
--  AND s.SaleSubType = 'BP';        
    
-- MERGE [dbo].[TRNSalesPlanning_BP] AS Target        
-- USING @tvpCustomerMaterialSalesPlannings AS Source        
--  ON Source.[MonthYear] = Target.[MonthYear]        
--   AND Source.[CustomerCode] = Target.[CustomerCode]        
--   AND Source.[MaterialCode] = Target.[MaterialCode]        
--   AND Source.[AccountCode] = Target.[AccountCode]       
       
--   -- For Insert                        
-- WHEN NOT MATCHED BY Target        
--  THEN        
--   INSERT (        
--    [MonthYear]        
--    ,[CustomerCode]        
--    ,[MaterialCode]        
--    ,[Quantity]        
--    ,[Amount]        
--    ,[AccountCode]        
--    ,[CreatedDate]        
--    ,[CreatedBy]        
--    ,[UpdatedDate]        
--    ,[UpdatedBy]        
--    ,Price       
     
-- ,BP_YEAR      
--    )        
--   VALUES (        
--    Source.[MonthYear]        
--    ,Source.[CustomerCode]        
--    ,Source.[MaterialCode]        
--    ,Source.[Quantity]        
--    ,Source.[Amount]        
--    ,Source.[AccountCode]        
--    ,GETDATE()        
--    ,@userId        
--    ,GETDATE()        
--    ,@userId        
--    ,Source.[Price]       
      
-- ,Source.[BP_YEAR]       
--    )        
--    -- For Updates                        
-- WHEN MATCHED        
--  THEN        
--   UPDATE        
--   SET Target.[Quantity] = Source.[Quantity]        
--    ,Target.[Price] = Source.[Price]        
--    ,Target.[UpdatedDate] = GETDATE()        
--    ,Target.[UpdatedBy] = @userId;        
  
-- DECLARE @TVPAccountCodeMaterialCodeList AS dbo.[TVP_ACCOUNT_MATERIAL_CODE_LIST];  
-- DECLARE @TVPMonthList AS dbo.[TVP_ID_LIST];  
--    insert @TVPMonthList (ID)   
--    select distinct MonthYear from @tvpCustomerMaterialSalesPlannings;  
-- INSERT INTO @TVPAccountCodeMaterialCodeList  
--    SELECT AccountCode  
--     ,MaterialCode  
--    FROM @tvpCustomerMaterialSalesPlannings;  
-- EXEC SP_Calculate_RollingInventory_BP @userId,  
-- @TVPAccountCodeMaterialCodeList,@TVPMonthList,  
-- @BPMonthYear;  
--  COMMIT;      
-- END TRY   
--  BEGIN CATCH      
--  ROLLBACK;   
--  INSERT INTO @ResultTable (          
--   [ResponseCode]          
--   ,[ResponseMessage]          
--   )          
--  VALUES (          
--   500          
--   ,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))          
--   );   
-- END CATCH   
-- SELECT DISTINCT [ResponseCode]    
--  ,[ResponseMessage]    
-- FROM @ResultTable    
--END