alter PROCEDURE [dbo].[SP_Insert_TRNPricePlanning]        
(        
@userId nvarchar(100) ,    
@currentMonthYear int ,    
@lockMonthYear int ,    
@resultMonthYear int ,    
@lastForecastMonthYear int    
)        
AS        
BEGIN        
    -- SET NOCOUNT ON added to prevent extra result sets from        
    -- interfering with SELEaCT statements.        
    SET NOCOUNT ON        
        
    -- Insert statements for procedure here        
        
 BEGIN TRY        
        
  BEGIN TRANSACTION        
        
 --DECLARE @resultMonthYear int, @currentMonthYear int, @lockMonthYear int, @lastForecastMonthYear int;      
 --select @currentMonthYear =       
 --CAST(ConfigValue AS INT) from [dbo].[GlobalConfig] where ConfigKey='Current_Month' and ConfigType='Direct And SNS';      
      
 DECLARE @dtCurrentMonthYear datetime = CONVERT(datetime, CAST(@currentMonthYear AS VARCHAR(6))+'01', 112);      
      
 --SET @currentMonthYear = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));      
 --SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));      
 --SET @lockMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));      
 --SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));      
      
 --SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, @dtCurrentMonthYear), 'yyyyMM') AS INT));      
 --SET @lockMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM') AS INT));      
 --SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, @dtCurrentMonthYear), 'yyyyMM') AS INT));      
      
 DECLARE @tvpAccounMaterialPricePlannings  AS [dbo].[TVP_PRICE_PLANNING];      
 DECLARE @tvpCustomerMaterialSalesPlannings  AS [dbo].[TVP_SALES_PLANNING]      
      
 --ARCHIVE PREVIOUS LOADED DATA      
 INSERT INTO [dbo].[TRNPricePlanningArchival]      
 SELECT [AccountCode]      
           ,[MonthYear]      
           ,[MaterialCode]      
           ,[ModeofType]      
           ,[Type]      
           ,[Quantity]      
           ,[CreatedDate]      
           ,[CreatedBy]      
           ,[UpdatedDate]      
           ,[UpdatedBy],@currentMonthYear,getdate() FROM [dbo].[TRNPricePlanning];      
      
 INSERT INTO [dbo].[TRNSalesPlanningArchival]      
 SELECT [MonthYear]      
      ,[CustomerCode]      
      ,[MaterialCode]      
      ,[Quantity]      
      ,[Amount]      
      ,[AccountCode]      
      ,[CreatedDate]      
      ,[CreatedBy]      
      ,[UpdatedDate]      
      ,[UpdatedBy] ,getdate()     
 FROM [dbo].[TRNSalesPlanning]      
       
 --TRUNCATE TABLE [dbo].[TRNPricePlanning];      
 --TRUNCATE TABLE [dbo].[TRNSalesPlanning];      
      
  /*      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'GIT Arrivals', NULL,  SUM(Quantity)      
   from Mst_CurrentLockMonthPurchaseGit      
   where MonthYear >= @currentMonthYear AND ATP_CASE in ( '01', '11')      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
   */      
      
   -- result month git from current month purchase      
   INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, @resultMonthYear, MaterialCode, 'GIT Arrivals', NULL, SUM(Quantity)      
   from [dbo].[Mst_CurrentLockMonthPurchase]      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear =@currentMonthYear AND ATP_CASE in ( '01', '11')      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
  --INSERT ORDER      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'ORDER', NULL, SUM(Quantity)      
   from MST_CurrentMonthOrder      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear >= @resultMonthYear      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
   --INSERT PURCHASE      
   -- RESULT PURCHASE      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'PURCHASE', 'S&S', SUM(Quantity)      
   from MST_ResultPurchase      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear = @resultMonthYear       
   --AND ATP_CASE in ( '01', '11')      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
   --CURRENT MONTH PURCHASE      
   INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'PURCHASE', 'S&S', SUM(Quantity)      
   from [dbo].[Mst_CurrentLockMonthPurchase]      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear = @currentMonthYear  AND ATP_CASE in ( '01', '11')      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
   -- LOCK & INDICATION MONTH PURCHASE      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'PURCHASE', 'S&S', SUM(Quantity)      
   from [dbo].[Mst_CurrentLockMonthPurchase]      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear >= @lockMonthYear AND ATP_CASE = '01'      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
   -- LOCK & INDICATION MONTH MPO      
   INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'MPO', 'MPO', SUM(Quantity)      
   from [dbo].[Mst_CurrentLockMonthPurchase]      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear >= @lockMonthYear AND ATP_CASE = '11'      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
       
  --INSERT SALES      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'SALES', 'S&S', SUM(Quantity)      
   from MST_ResultSales      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear >= @resultMonthYear
   and SalesOrganizationCode=1000
   GROUP BY MonthYear, AccountCode,  MaterialCode;  
      
   --INSERT INVENTORY      
  INSERT INTO @tvpAccounMaterialPricePlannings      
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'INVENTORY', NULL, SUM(Quantity)      
    from Mst_ResultInventory      
   where AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND MonthYear >= @resultMonthYear      
   GROUP BY MonthYear, AccountCode, MaterialCode;      
      
      
 MERGE [dbo].[TRNPricePlanning] AS Target      
    USING @tvpAccounMaterialPricePlannings AS Source      
    ON Source.[AccountCode] = Target.[AccountCode]      
 AND Source.[MonthYear] = Target.[MonthYear]      
 AND Source.[MaterialCode] = Target.[MaterialCode]      
 AND Source.[ModeofType] = Target.[ModeofType]      
          
    -- For Insert      
    WHEN NOT MATCHED BY Target THEN      
        INSERT ([AccountCode]      
      ,[MonthYear]      
      ,[MaterialCode]      
      ,[ModeofType]      
      ,[Type]      
      ,[Quantity]      
      ,[CreatedDate]      
      ,[CreatedBy]      
      ,[UpdatedDate]      
      ,[UpdatedBy])       
        VALUES (Source.[AccountCode],Source.[MonthYear], Source.[MaterialCode],      
  Source.[ModeofType],Source.[Type],Source.[Quantity],      
  GETDATE(), @userId, GETDATE(), @userId)      
          
    -- For Updates      
    WHEN MATCHED THEN UPDATE SET      
        Target.[Quantity] = Source.[Quantity],      
        Target.[UpdatedDate]= GETDATE(),      
  Target.[UpdatedBy] = @userId;      
      
      
  -- CUSTOMER WISE SALE      
   INSERT INTO @tvpCustomerMaterialSalesPlannings      
    SELECT NULL, [MonthYear], [CustomerCode], [MaterialCode], [Quantity], [Amount],      
    [AccountCode] from MST_ResultSales      
    WHERE AccountCode IS NOT NULL AND MaterialCode IS NOT NULL AND [CustomerCode] IS NOT NULL AND      
     [MonthYear] >=@resultMonthYear and SalesOrganizationCode=1000;      
      
      
    MERGE [dbo].[TRNSalesPlanning] AS Target      
   USING @tvpCustomerMaterialSalesPlannings AS Source      
   ON Source.[MonthYear] = Target.[MonthYear]      
   AND Source.[CustomerCode] = Target.[CustomerCode]      
   AND Source.[MaterialCode] = Target.[MaterialCode]      
   AND Source.[AccountCode] = Target.[AccountCode]      
          
   -- For Insert      
   WHEN NOT MATCHED BY Target THEN      
    INSERT ([MonthYear]      
     ,[CustomerCode]      
     ,[MaterialCode]      
     ,[Quantity]      
     ,[Amount]      
     ,[AccountCode]      
     ,[CreatedDate]      
     ,[CreatedBy]      
     ,[UpdatedDate]      
     ,[UpdatedBy])       
    VALUES (Source.[MonthYear],Source.[CustomerCode], Source.[MaterialCode],      
    Source.[Quantity],Source.[Amount],Source.[AccountCode],      
    GETDATE(), @userId, GETDATE(), @userId)      
          
   -- For Updates      
   WHEN MATCHED THEN UPDATE SET      
    Target.[Quantity] = Source.[Quantity],      
    Target.[UpdatedDate]= GETDATE(),      
    Target.[UpdatedBy] = @userId;      
      
   COMMIT;        
 END TRY        
 BEGIN CATCH        
  ROLLBACK;        
         
 END CATCH        
        
          
END 