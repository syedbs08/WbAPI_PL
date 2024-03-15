    
    
CREATE PROC [dbo].[SP_Insert_TRNSalesPlanning_BP] (    
 @TvpSNSIdList [dbo].[TVP_ID_LIST] readonly    
 ,@currentMonthYear VARCHAR(6)    
 ,@userId VARCHAR(max)   
 ,@SaleSubType VARCHAR(30)  
  
 )    
AS    
BEGIN    
 DECLARE @tvpCustomerMaterialSalesPlannings AS [dbo].[TVP_SALES_PLANNING];    
    
 INSERT INTO @tvpCustomerMaterialSalesPlannings    
 SELECT NULL    
  ,p.MonthYear    
  ,CustomerCode    
  ,MaterialCode    
  ,Qty    
  ,Qty * Price AS [Amount]    
  ,OACCode    
  ,Price   
  ,SaleSubType  
  ,@currentMonthYear  
 FROM SNSEntry s    
 INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId    
 WHERE s.SNSEntryId IN (    
   SELECT id    
   FROM @TvpSNSIdList    
   )    
  AND p.MonthYear >= @currentMonthYear    
  --AND s.SaleSubType = 'Monthly';    
    
 MERGE [dbo].[TRNSalesPlanning_BP] AS Target    
 USING @tvpCustomerMaterialSalesPlannings AS Source    
  ON Source.[MonthYear] = Target.[MonthYear]    
   AND Source.[CustomerCode] = Target.[CustomerCode]    
   AND Source.[MaterialCode] = Target.[MaterialCode]    
   AND Source.[AccountCode] = Target.[AccountCode]   
   AND Source.[SaleSubType] = Target.[SaleSubType]  
   -- For Insert                    
 WHEN NOT MATCHED BY Target    
  THEN    
   INSERT (    
    [MonthYear]    
    ,[CustomerCode]    
    ,[MaterialCode]    
    ,[Quantity]    
    ,[Amount]    
    ,[AccountCode]    
    ,[CreatedDate]    
    ,[CreatedBy]    
    ,[UpdatedDate]    
    ,[UpdatedBy]    
    ,Price   
 ,SaleSubType  
 ,BP_YEAR  
    )    
   VALUES (    
    Source.[MonthYear]    
    ,Source.[CustomerCode]    
    ,Source.[MaterialCode]    
    ,Source.[Quantity]    
    ,Source.[Amount]    
    ,Source.[AccountCode]    
    ,GETDATE()    
    ,@userId    
    ,GETDATE()    
    ,@userId    
    ,Source.[Price]   
 ,Source.[SaleSubType]   
 ,Source.[BP_YEAR]   
    )    
    -- For Updates                    
 WHEN MATCHED    
  THEN    
   UPDATE    
   SET Target.[Quantity] = Source.[Quantity]    
    ,Target.[Price] = Source.[Price]    
    ,Target.[UpdatedDate] = GETDATE()    
    ,Target.[UpdatedBy] = @userId;    
END