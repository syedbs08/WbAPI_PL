  
  
-- =============================================          
-- Author:      <Author, , Name>          
-- Create Date: <Create Date, , >          
-- Description: <Description, , >          
-- =============================================          
ALTER PROCEDURE [dbo].[SP_Calculate_RollingInventory] (  
 @userId NVARCHAR(100)  
 ,@tvpAccontMaterialCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST] READONLY  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELEaCT statements.          
 SET NOCOUNT ON  
  
 -- Insert statements for procedure here          
 BEGIN TRY  
  BEGIN TRANSACTION  
  
  DECLARE @resultMonthYear INT  
   ,@currentMonthYear INT  
   ,@lockMonthYear INT  
   ,@lastForecastMonthYear INT  
   ,@accountMaterialCount INT  
   ,@materialCount INT;  
  
  --SET @currentMonthYear = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));        
  --SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));        
  --SET @lockMonth = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));        
  --SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));        
  SELECT @currentMonthYear = CAST(ConfigValue AS INT)  
  FROM [dbo].[GlobalConfig]  
  WHERE ConfigKey = 'Current_Month'  
   AND ConfigType = 'Direct And SNS';  
  
  DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, CAST(@currentMonthYear AS VARCHAR(6)) + '01', 112);  
  
  SET @resultMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, - 1, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  SET @lockMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  SET @lastForecastMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, 6, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  
  --PRINT '@currentMonthYear';      
  --PRINT @currentMonthYear;      
  --PRINT '@currentMonthYear';      
  --PRINT @currentMonthYear;      
  --PRINT '@resultMonthYear';      
  --PRINT @resultMonthYear;      
  --PRINT '@lockMonthYear';      
  --PRINT @lockMonthYear;      
  --PRINT '@lastForecastMonthYear';      
  --PRINT @lastForecastMonthYear;      
  DECLARE @tvpSNSEntryQtyPrices AS [dbo].[TVP_SNS_ENTRY_QTY_PRICES];  
  DECLARE @tvpPricePlannings AS [dbo].[TVP_PRICE_PLANNING];  
  --DECLARE @tvpAccounMaterialPricePlannings  AS [dbo].[TVP_PRICE_PLANNING];        
  DECLARE @tvpAccontMaterialCodeListWithRowNo [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO];  
  DECLARE @tvpAccountMaterialDistCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST];  
  
  --select * from @tvpAccontMaterialCodeListWithRowNo      
  IF NOT EXISTS (  
    SELECT TOP 1 1  
    FROM @tvpAccontMaterialCodeList  
    )  
  BEGIN  
   INSERT INTO @tvpAccountMaterialDistCodeList  
   SELECT DISTINCT [AccountCode]  
    ,MaterialCode  
   FROM [dbo].[TRNPricePlanning];  
  
   INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
    [AccountCode]  
    ,[MaterialCode]  
    ,RowNo  
    )  
   SELECT DISTINCT [AccountCode]  
    ,[MaterialCode]  
    ,ROW_NUMBER() OVER (  
     ORDER BY [AccountCode]  
      ,[MaterialCode] ASC  
     ) AS RowNo  
   FROM @tvpAccountMaterialDistCodeList;  
  END  
  ELSE  
  BEGIN  
   IF EXISTS (  
     SELECT TOP 1 1  
     FROM @tvpAccontMaterialCodeList  
     WHERE AccountCode IS NOT NULL  
      AND AccountCode != ''  
      AND (  
       MaterialCode IS NULL  
       OR MaterialCode = ''  
       )  
     )  
   BEGIN  
    --PRINT 'MaterialCode IS EMPTY';      
    INSERT INTO @tvpAccountMaterialDistCodeList  
    SELECT DISTINCT [AccountCode]  
     ,MaterialCode  
    FROM [dbo].[TRNPricePlanning]  
    WHERE [AccountCode] IN (  
      SELECT DISTINCT [AccountCode]  
      FROM @tvpAccontMaterialCodeList  
      WHERE AccountCode IS NOT NULL  
       AND AccountCode != ''  
      );  
  
    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
     [AccountCode]  
     ,[MaterialCode]  
     ,RowNo  
     )  
    SELECT DISTINCT [AccountCode]  
     ,[MaterialCode]  
     ,ROW_NUMBER() OVER (  
      ORDER BY [AccountCode]  
       ,[MaterialCode] ASC  
      ) AS RowNo  
    FROM @tvpAccountMaterialDistCodeList;  
   END  
   ELSE  
   BEGIN  
    --PRINT 'MaterialCode IS NOT EMPTY';      
    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
     [AccountCode]  
     ,[MaterialCode]  
     ,RowNo  
     )  
    SELECT [AccountCode]  
     ,[MaterialCode]  
     ,ROW_NUMBER() OVER (  
      ORDER BY [AccountCode]  
       ,[MaterialCode] ASC  
      ) AS RowNo  
    FROM @tvpAccontMaterialCodeList;  
   END  
  END  
  
  /*SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;      
        
 IF NOT EXISTS( SELECT TOP 1 1 FROM @tvpAccontMaterialCodeListWithRowNo)        
 BEGIN        
  INSERT INTO @tvpMaterialDistCodeList        
  SELECT distinct MaterialCode        
  FROM [dbo].[TRNPricePlanning];        
        
  INSERT INTO @tvpAccontMaterialCodeListWithRowNo(Code, RowNo)        
  SELECT distinct Code, ROW_NUMBER() OVER(ORDER BY Code ASC) AS RowNo        
  FROM @tvpMaterialDistCodeList;        
 END        
 ELSE        
 BEGIN        
  INSERT INTO @tvpAccontMaterialCodeListWithRowNo(Code, RowNo)        
  SELECT Code, ROW_NUMBER() OVER(ORDER BY Code ASC) AS RowNo        
  FROM @tvpAccontMaterialCodeListWithRowNo;        
 END        
  */  
  INSERT INTO @tvpSNSEntryQtyPrices  
  SELECT SE.SNSEntryId  
   ,SQ.SNSEntryQtyPriceId  
   ,SQ.MonthYear  
   ,SE.CustomerCode  
   ,SE.MaterialCode  
   ,SQ.Qty AS Quantity  
   ,SQ.Price AS Amount  
   ,SE.OACCode AS [AccountCode]  
  FROM [dbo].[SNSEntry] SE  
  INNER JOIN [dbo].[SNSEntryQtyPrice] SQ ON SE.SNSEntryId = SQ.SNSEntryId  
  WHERE SE.MonthYear >= @currentMonthYear  
   AND SE.MonthYear <= @lastForecastMonthYear  
   AND SQ.MonthYear >= @currentMonthYear  
   AND SQ.MonthYear <= @lastForecastMonthYear  
   AND SE.[OACCode] IN (  
    SELECT [AccountCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    )  
   AND SE.[MaterialCode] IN (  
    SELECT [MaterialCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  --SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;        
  --SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;        
  --SELECT * FROM @tvpSNSEntryQtyPrices;        
  INSERT INTO @tvpPricePlannings  
  SELECT [TRNPricePlanningId]  
   ,[AccountCode]  
   ,[MonthYear]  
   ,[MaterialCode]  
   ,[ModeofType]  
   ,[Type]  
   ,[Quantity]  
  FROM [dbo].[TRNPricePlanning]  
  WHERE MonthYear >= @resultMonthYear  
   AND [AccountCode] IN (  
    SELECT [AccountCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    )  
   AND [MaterialCode] IN (  
    SELECT [MaterialCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  SET @accountMaterialCount = (  
    SELECT COUNT(1)  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  --SET @materialCount = (SELECT COUNT(1) from @tvpAccontMaterialCodeListWithRowNo);        
  DECLARE @accountMaterialIndex INT = 1;  
  DECLARE @activeAccountCode NVARCHAR(50) = '';  
  DECLARE @activeMaterialCode NVARCHAR(50) = '';  
  
  --PRINT '@accountMaterialCount';      
  --PRINT @accountMaterialCount;          
  --print '@materialCount';      
  --print @materialCount;          
  WHILE (@accountMaterialIndex <= @accountMaterialCount)  
  BEGIN  
   SELECT @activeAccountCode = AccountCode  
    ,@activeMaterialCode = MaterialCode  
   FROM @tvpAccontMaterialCodeListWithRowNo  
   WHERE RowNo = @accountMaterialIndex;  
  
   --PRINT '@activeAccountCode';      
   --PRINT @activeAccountCode;      
   --PRINT '@activeMaterialCode';      
   --PRINT @activeMaterialCode      
   --DECLARE @materialIndex int = 1;        
   --WHILE (@materialIndex <= @materialCount)        
   --BEGIN        
   --SET @activeMaterialCode = (SELECT CODE FROM @tvpAccontMaterialCodeListWithRowNo WHERE RowNo = @materialIndex);        
   --insert into @tvpAccounMaterialPricePlannings        
   --SELECT * FROM @tvpPricePlannings        
   --WHERE AccountCode = @activeAccountCode AND MaterialCode = @activeMaterialCode;        
   --CHECK IF RESULT MONTH GIT IS EQUAL TO CURRENT MONTH PURCHASE        
   DECLARE @activeMonthYear INT = @resultMonthYear;  
   DECLARE @monthIndex INT = 0;  
  
   WHILE @activeMonthYear <= @lastForecastMonthYear  
   BEGIN  
    DECLARE @activeNextMonthYear INT = 0;  
    DECLARE @activePrevMonthYear INT = 0;  
    --PRINT '@activeMonthYear';        
    --PRINT @activeMonthYear;        
    DECLARE @activeMonth DATE = CONVERT(DATETIME, CONCAT (  
       CAST(@activeMonthYear AS VARCHAR(6))  
       ,'01'  
       ), 112);  
  
    --PRINT '@activeMonth';        
    --PRINT @activeMonth;        
    SET @activeNextMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
    SET @activePrevMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, - 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
  
    --PRINT '@activeNextMonthYear';        
    --PRINT @activeNextMonthYear;        
    --PRINT '@activePrevMonthYear';        
    --PRINT @activePrevMonthYear;        
    IF @monthIndex != 0  
    BEGIN  
     --INSERT/UPDATE SALES START        
     DECLARE @totalQty INT = 0;  
  
     SET @totalQty = (  
       SELECT SUM([Quantity])  
       FROM @tvpSNSEntryQtyPrices  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
       );  
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND ModeOfType = 'SALES'  
        AND Type = 'S&S'  
       )  
     BEGIN  
      UPDATE @tvpPricePlannings  
      SET [Quantity] = ISNULL(@totalQty, 0)  
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND ModeOfType = 'SALES'  
       AND Type = 'S&S';  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]  
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'SALES'  
       ,'S&S'  
       ,ISNULL(@totalQty, 0);  
     END  
  
     --INSERT/UPDATE SALES END        
     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE START        
     DECLARE @activeCurrentMonthOrderQty INT = 0;  
     DECLARE @activeNextMonthPurchaseQty INT = 0;  
  
     SET @activeCurrentMonthOrderQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'ORDER'  
       );  
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeNextMonthYear  
        AND [ModeofType] = 'PURCHASE'  
        AND Type = 'S&S'  
       )  
     BEGIN  
      SET @activeNextMonthPurchaseQty = (  
        SELECT [Quantity]  
        FROM @tvpPricePlannings  
        WHERE AccountCode = @activeAccountCode  
         AND MaterialCode = @activeMaterialCode  
         AND MonthYear = @activeNextMonthYear  
         AND [ModeofType] = 'PURCHASE'  
         AND Type = 'S&S'  
        );  
  
      IF @activeCurrentMonthOrderQty != @activeNextMonthPurchaseQty  
      BEGIN  
       UPDATE @tvpPricePlannings  
       SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeNextMonthYear  
        AND [ModeofType] = 'PURCHASE'  
        AND Type = 'S&S';  
      END  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]  
       )  
      SELECT @activeAccountCode  
       ,@activeNextMonthYear  
       ,@activeMaterialCode  
       ,'PURCHASE'  
       ,'S&S'  
       ,ISNULL(@activeCurrentMonthOrderQty, 0);  
     END  
  
     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE END        
     --CURRENT MONTH ORDER == CURRENT MONTH GIT START      
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'GIT Arrivals'  
       )  
     BEGIN  
      UPDATE @tvpPricePlannings  
      SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)  
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND [ModeofType] = 'GIT Arrivals';  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]  
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'GIT Arrivals'  
       ,NULL  
       ,ISNULL(@activeCurrentMonthOrderQty, 0);  
     END  
  
     --CURRENT MONTH ORDER == CURRENT MONTH GIT START      
     --CALCULATE INVENTORY        
     --PRINT '@CALCULATE INVENTORY';        
     --PRINT '@activeMonthYear';        
     --PRINT @activeMonthYear;        
     --PRINT '@activePrevMonthYear';        
     --PRINT @activePrevMonthYear;        
     DECLARE @activePrevMonthInventoryQty INT = 0;  
     DECLARE @activeCurrentMonthPurchaseQty INT = 0;  
     DECLARE @activeCurrentMonthMpoQty INT = 0;  
     DECLARE @activeCurrentSalesQty INT = 0;  
     DECLARE @activeCurrentInventoryQty INT = 0;  
  
     SET @activePrevMonthInventoryQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activePrevMonthYear  
        AND [ModeofType] = 'INVENTORY'  
       );  
     SET @activeCurrentMonthPurchaseQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'PURCHASE'  
       );  
     SET @activeCurrentMonthMpoQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'MPO'  
       );  
     SET @activeCurrentSalesQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'SALES'  
       );  
     SET @activeCurrentInventoryQty = ISNULL(@activePrevMonthInventoryQty, 0) + ISNULL(@activeCurrentMonthPurchaseQty, 0) + ISNULL(@activeCurrentMonthMpoQty, 0) - ISNULL(@activeCurrentSalesQty, 0);  
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'INVENTORY'  
       )  
     BEGIN  
      --PRINT '@update INVENTORY';        
      UPDATE @tvpPricePlannings  
      SET [Quantity] = @activeCurrentInventoryQty  
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND [ModeofType] = 'INVENTORY';  
     END  
     ELSE  
     BEGIN  
      --PRINT '@insert INVENTORY';        
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]  
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'INVENTORY'  
       ,NULL  
       ,@activeCurrentInventoryQty;  
     END  
    END  
  
    --PRINT '@monthIndex';        
    --PRINT @monthIndex;        
    SET @monthIndex = @monthIndex + 1;  
    --PRINT @monthIndex;        
    SET @activeMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
     --PRINT '@activeMonthYear';        
     --PRINT @activeMonthYear;        
     --END        
     --SET @materialIndex = @materialIndex + 1;        
   END  
  
   SET @accountMaterialIndex = @accountMaterialIndex + 1;  
  END  
  
  --INSERT OR UPDATE        
  --PRINT 'MERGE STATEMENT';        
  --SELECT * FROM @tvpPricePlannings;        
  MERGE [dbo].[TRNPricePlanning] AS Target  
  USING @tvpPricePlannings AS Source  
   ON Source.[AccountCode] = Target.[AccountCode]  
    AND Source.[MonthYear] = Target.[MonthYear]  
    AND Source.[MaterialCode] = Target.[MaterialCode]  
    AND Source.[ModeofType] = Target.[ModeofType]  
    -- For Insert        
  WHEN NOT MATCHED BY Target  
   THEN  
    INSERT (  
     [AccountCode]  
     ,[MonthYear]  
     ,[MaterialCode]  
     ,[ModeofType]  
     ,[Type]  
     ,[Quantity]  
     ,[CreatedDate]  
     ,[CreatedBy]  
     ,[UpdatedDate]  
     ,[UpdatedBy]  
     )  
    VALUES (  
     Source.[AccountCode]  
     ,Source.[MonthYear]  
     ,Source.[MaterialCode]  
     ,Source.[ModeofType]  
     ,Source.[Type]  
     ,Source.[Quantity]  
     ,GETDATE()  
     ,@userId  
     ,GETDATE()  
     ,@userId  
     )  
     -- For Updates        
  WHEN MATCHED  
   THEN  
    UPDATE  
    SET Target.[Quantity] = Source.[Quantity]  
     ,Target.[UpdatedDate] = GETDATE()  
     ,Target.[UpdatedBy] = @userId;  
  
  COMMIT;  
 END TRY  
  
 BEGIN CATCH  
  ROLLBACK;  
 END CATCH  
END