IF OBJECT_ID('dbo.SP_COGSearch') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_COGSearch];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_COGSearch] @CountryId VARCHAR(max) = NULL  
 ,@CustomerId VARCHAR(max) = NULL  
 ,@ProductCategoryId1 VARCHAR(max) = NULL  
 ,@ProductCategoryId2 VARCHAR(max) = NULL  
 ,@SalesTypeId VARCHAR(20) NULL   
 ,@SalesSubType VARCHAR(20) NULL 
 ,@FromMonth INT
 ,@ToMonth INT
AS  
BEGIN  

SET NOCOUNT ON;

	CREATE TABLE #TEMP_FINAL_RESULT(
	CustomerId   INT NULL,
	CountryId INT NULL,
	CustomerCode NVARCHAR(50) NULL,
	CustomerName NVARCHAR(200) NULL,
	MaterialCode NVARCHAR(50) NULL,
	MonthYear    NVARCHAR(10) NULL,
	SaleSubType  NVARCHAR(50) NULL,
	SaleTypeName  NVARCHAR(50) NULL,
	FRT_Price  DECIMAL(18,6) NULL,
	CST_Price  DECIMAL(18,6) NULL,
	FOB_Price  DECIMAL(18,6) NULL
	);

                         
  SELECT                           
  cogp.Qty,
  cogp.Price,                          
  cogp.ChargeType ,                           
  cog.SaleTypeId ,                           
  cog.CustomerCode ,
  c.CustomerName,
  cog.MaterialCode ,                           
  cog.SaleSubType ,                          
  cogp.MonthYear,
  s.SaleTypeName ,
  c.CustomerId  ,
  c.CountryId
 INTO #TEMP_ALL_PRICES
 FROM   COGEntry as cog  
 INNER JOIN SaleType S ON cog.SaleTypeId = s.SaleTypeId  
 INNER JOIN COGEntryQtyPrice as cogp ON cog.COGEntryId = cogp.COGEntryId
 LEFT JOIN Customer c ON cog.CustomerCode = c.CustomerCode  
 LEFT JOIN Material m ON cog.MaterialCode = m.MaterialCode 
 WHERE  cogp.MonthYear>=@FromMonth and cogp.MonthYear<=@ToMonth
  AND (  
   @SalesTypeId IS NULL  
   OR cog.SaleTypeId IN (  
    SELECT value  
    FROM STRING_SPLIT(@SalesTypeId, ',')  
    )  
   )  
  AND (  
   @SalesSubType IS NULL  
   OR cog.SaleSubType = @SalesSubType  
   ) 
   AND (  
   @CountryId IS NULL  
   OR c.CountryId IN (  
    SELECT value  
    FROM STRING_SPLIT(@CountryId, ',')  
    )  
   )  
  AND (  
   @CustomerId IS NULL  
   OR c.CustomerId IN (  
    SELECT value  
    FROM STRING_SPLIT(@CustomerId, ',')  
    )  
   )  
  AND (  
   @ProductCategoryId1 IS NULL  
   OR m.ProductCategoryId2 IN (  
    SELECT value  
    FROM STRING_SPLIT(@ProductCategoryId1, ',')  
    )  
   )  
  AND (  
   @ProductCategoryId2 IS NULL  
   OR m.ProductCategoryId3 IN (  
    SELECT value  
    FROM STRING_SPLIT(@ProductCategoryId2, ',')  
    )  
   );   

   INSERT INTO #TEMP_FINAL_RESULT (
	CustomerId  ,
	CountryId,
	CustomerCode,
	CustomerName,
	MaterialCode,
	MonthYear   ,
	SaleSubType ,
	SaleTypeName,
	FRT_Price  ,
	CST_Price  ,
	FOB_Price  
   )
   SELECT 
	CustomerId,
	CountryId,
	CustomerCode,
	CustomerName,
	MaterialCode,
	MonthYear,
	SaleSubType,
	SaleTypeName,
	(ISNULL(QTY,0) * ISNULL(Price,0)) AS FRT_Price,
	0 AS CST_Price,
	0 AS FOB_Price
   FROM #TEMP_ALL_PRICES
   WHERE ChargeType = 'FRT';

   UPDATE TEMP
   SET TEMP.CST_Price =  (ISNULL(PRICES.QTY,0) * ISNULL(PRICES.Price,0))
   FROM #TEMP_FINAL_RESULT AS TEMP
   INNER JOIN #TEMP_ALL_PRICES AS PRICES
   ON TEMP.CustomerCode = PRICES.CustomerCode
		AND TEMP.MaterialCode = PRICES.MaterialCode
		AND TEMP.MonthYear = PRICES.MonthYear
		AND PRICES.ChargeType = 'CST';

   UPDATE TEMP
   SET TEMP.FOB_Price =  (ISNULL(PRICES.QTY,0) * ISNULL(PRICES.Price,0))
   FROM #TEMP_FINAL_RESULT AS TEMP
   INNER JOIN #TEMP_ALL_PRICES AS PRICES
   ON TEMP.CustomerCode = PRICES.CustomerCode
		AND TEMP.MaterialCode = PRICES.MaterialCode
		AND TEMP.MonthYear = PRICES.MonthYear
		AND PRICES.ChargeType = 'FOB';
    
	SELECT 
	CustomerId,
	CountryId,
	CustomerCode ,
	CustomerName,
	MaterialCode ,
	MonthYear ,
	SaleSubType ,
	SaleTypeName,
	FRT_Price   ,
	CST_Price ,
	FOB_Price ,
	FRT_Price + CST_Price + FOB_Price AS COG_PRICE
	FROM #TEMP_FINAL_RESULT;
   
END