IF OBJECT_ID('dbo.SP_LY_ConsolidatedReport') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_LY_ConsolidatedReport];
END 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[SP_LY_ConsolidatedReport](    
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY    
 ,@Mg VARCHAR(20)    
 ,@MG1 VARCHAR(20)    
 ,@SalesSubType VARCHAR(30)    
 )        
AS   
BEGIN

SET NOCOUNT ON;
		 DECLARE @CustomerCodeCount AS INT;    
		 SET @CustomerCodeCount =0;    
    
		 SELECT @CustomerCodeCount = COUNT([CustomerCode])    
		 FROM @TVP_CUSTOMERCODE_LIST    
		 WHERE [CustomerCode] > 0;  


		 SELECT  
			  cust.CustomerId    
			 ,cust.CustomerName 
			 ,cust.CustomerCode 
			 ,d.DepartmentName    
			 ,cust.CountryId    
			 ,c.CountryName   
			 ,s.SalesOfficeName    
		INTO #TEMP_CUSTOMERS
		FROM customer cust      
		LEFT JOIN Department d ON cust.DepartmentId = d.DepartmentId    
		LEFT JOIN Country c ON cust.CountryId = c.CountryId    
		LEFT JOIN SalesOffice s ON cust.SalesOfficeId = s.SalesOfficeId    
		WHERE (cust.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0);

		SELECT DISTINCT SH.SaleEntryArchivalHeaderId
			,SH.CustomerCode
			,SE.MaterialCode
			,SP.Price
			,SP.Quantity
			,SP.MonthYear
			,SE.ModeOfTypeId
			,SH.SaleSubType
			,SH.ArchiveStatus
			,SE.OCstatus
			,SE.OCmonthYear
		INTO #TEMP_All_SALES_ENTRY
		FROM SaleEntryArchivalHeader SH
		INNER JOIN SalesArchivalEntry SE ON SH.SaleEntryArchivalHeaderId = SE.SaleEntryArchivalHeaderId
		INNER JOIN SalesArchivalEntryPriceQuantity SP ON SP.SalesArchivalEntryId = SE.SalesArchivalEntryId
		where SH.SaleSubType = @SalesSubType
			AND (SH.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0);

	   SELECT SaleEntryArchivalHeaderId
			,CustomerCode
			,MaterialCode
			,Price
			,Quantity
			,MonthYear
			,ModeOfTypeId
			,SaleSubType
			,ArchiveStatus
			,OCstatus
			,OCmonthYear  
	  INTO #TEMP_SALES_ENTRY
      FROM #TEMP_All_SALES_ENTRY   
	  WHERE ModeOfTypeId = 1 
			AND ArchiveStatus='Archived' 
			AND OCstatus='Y';
		
    --temp table to calculate price of each catergory
		SELECT 
		(cogp.Qty * cogp.Price) as Price,
		cogp.ChargeType , 
		cog.SaleTypeId , 
		cog.CustomerCode , 
		cog.MaterialCode , 
		cog.SaleSubType ,
		cogp.MonthYear
		INTO #All_Prices
		FROM  #TEMP_SALES_ENTRY as sales
		LEFT JOIN COGEntry as cog on cog.CustomerCode = sales.CustomerCode 
								AND cog.MaterialCode = sales.MaterialCode 
								AND cog.SaleSubType = 'Monthly'
		LEFT JOIN COGEntryQtyPrice as cogp ON cog.COGEntryId = cogp.COGEntryId 
								AND cogp.MonthYear = sales.MonthYear;

	 --temp table to calculate qty
    
		 WITH CTE_ALL_QTY_PRICE AS (
		 SELECT DISTINCT sales.Quantity,sales.Price ,sales.SaleSubType,sales.MonthYear,sales.CustomerCode,sales.MaterialCode
		 FROM #TEMP_All_SALES_ENTRY  sales
		 INNER JOIN ModeofType MT ON MT.ModeofTypeId = sales.ModeOfTypeId  
		 WHERE  sales.ModeOfTypeId   in (1,12,10) AND sales.OCstatus='Y')
		 SELECT SUM(sales.Quantity) as Qty,SUM(sales.Quantity * sales.Price) as Amount, sales.SaleSubType,sales.MonthYear,sales.CustomerCode,sales.MaterialCode
		 INTO #TEMP_QTY
		 FROM CTE_ALL_QTY_PRICE  sales
		 GROUP BY sales.SaleSubType,sales.MonthYear,sales.CustomerCode,sales.MaterialCode;


SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,SalesType    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryId2    
 ,m.ProductCategoryId3    
 ,m.MaterialCode    
 ,sum(temp.Qty) AS Qty
	,sum(Amount) AS Amount
	,sum(FRT_AMT) as FRT_AMT
	,sum(CST_AMT) as CST_AMT
	,sum(FOB_AMT) as FOB_AMT
	,sum(COG_AMT) as COG_AMT
	--GP AMT= SALES_AMT-COG AMT

	,sum(Amount)-sum(COALESCE(COG_AMT ,0)) as GP_AMT
	--GP%= GP AMT/SALES AMT
	,case when sum(Amount)!=0
then ((sum(Amount)-(COALESCE(SUM(COG_AMT),0)))/sum(Amount))*100
	else 0 end as GP_PER
	,TEMP.MonthYear
	,TEMP.SaleSubType
FROM (    
             
--sns data            
	SELECT s.Monthyear
		,s.CustomerCode
		,s.MaterialCode
		,s.Quantity AS Qty
		,s.Price * s.Quantity as Amount
		,'SNS' AS SalesType
		,'Monthly' AS SaleSubType
		,(s.Quantity * FRT_Prices.Price ) AS FRT_AMT
		,(s.Quantity * CST_Prices.Price) AS CST_AMT
		,(s.Quantity * FOB_Prices.Price) AS FOB_AMT
		,(s.Quantity * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  ) AS COG_AMT
	FROM TRNSalesPlanning s    
	INNER JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 2 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = s.MonthYear
	INNER JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 2 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = s.MonthYear
	INNER JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 2 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = s.MonthYear
	WHERE  s.SaleSubType= @SalesSubType 
	      AND (s.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0) 

 UNION    
     
 --adj data              
 SELECT p.Monthyear    
  ,s.CustomerCode    
  ,s.MaterialCode    
  ,p.Qty    
  ,p.Qty * cast( p.Price as decimal(18,2)) as Amount
   ,'Agent' AS SalesType    
  ,'Monthly' AS SaleSubType  
   ,p.Qty * FRT_Prices.Price  AS FRT_AMT    
   ,p.Qty * CST_Prices.Price  AS CST_AMT    
   ,p.Qty * FOB_Prices.Price  AS FOB_AMT    
   ,p.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS COG_AMT
	
 FROM AdjustmentEntry s    
 INNER JOIN AdjustmentEntryQtyPrice p ON s.AdjustmentEntryId = p.AdjustmentEntryId
 INNER JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = p.MonthYear
 INNER JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = p.MonthYear
 INNER JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = p.MonthYear
 WHERE  (s.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0) 

 UNION    
     
 --ssd data              
 SELECT p.Monthyear    
  ,s.CustomerCode    
  ,s.MaterialCode    
  ,p.Qty    
  ,p.Price * p.Qty as Amount 
  ,'Agent' AS SalesType    
  ,'Monthly' AS SaleSubType  
  ,p.Qty * FRT_Prices.Price  AS FRT_AMT    
  ,p.Qty * CST_Prices.Price  AS CST_AMT    
  ,p.Qty * FOB_Prices.Price  AS FOB_AMT    
  ,p.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS COG_AMT
	
 FROM SSDEntry s    
 INNER JOIN SSDEntryQtyPrice p ON s.SSDEntryId = p.SSDEntryId  
 INNER JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = p.MonthYear
 INNER JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = p.MonthYear
 INNER JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = p.MonthYear
  WHERE  (s.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0)   

 UNION    
     
 --Direct data              
 SELECT sales.Monthyear    
  ,sales.CustomerCode    
  ,sales.MaterialCode    
  ,TEMP_QTY.Qty AS Quantity    
  ,TEMP_QTY.Amount AS Amount    
  ,'Agent' AS SalesType    
  ,sales.SaleSubType   
  ,(TEMP_QTY.Qty * FRT_Prices.Price  ) AS FRT_AMT
  ,(TEMP_QTY.Qty * CST_Prices.Price) AS CST_AMT
  ,(TEMP_QTY.Qty * FOB_Prices.Price) AS FOB_AMT
  ,(TEMP_QTY.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)) AS COG_AMT
   FROM #TEMP_SALES_ENTRY as sales
   INNER JOIN #TEMP_QTY as TEMP_QTY ON TEMP_QTY.SaleSubType = sales.SaleSubType AND TEMP_QTY.MonthYear = cast(sales.MonthYear AS INT) AND TEMP_QTY.CustomerCode = sales.CustomerCode AND TEMP_QTY.MaterialCode = sales.MaterialCode 
   INNER JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = sales.MaterialCode AND FRT_Prices.CustomerCode = sales.CustomerCode AND FRT_Prices.MonthYear = sales.MonthYear
   INNER JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = sales.MaterialCode AND CST_Prices.CustomerCode = sales.CustomerCode AND CST_Prices.MonthYear = sales.MonthYear
   INNER JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = sales.MaterialCode AND FOB_Prices.CustomerCode = sales.CustomerCode AND FOB_Prices.MonthYear = sales.MonthYear

 ) TEMP    
INNER JOIN #TEMP_CUSTOMERS c ON TEMP.CustomerCode = c.CustomerCode    
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode  
			AND (m.ProductCategoryId2 = @Mg OR @Mg = 0)    
			AND (m.ProductCategoryId3 = @MG1 OR @MG1 = 0) 

GROUP BY DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName    
 ,SalesType    
 ,c.CustomerCode + '-' + CustomerName    
 ,c.CustomerCode    
 ,m.ProductCategoryName1    
 ,m.ProductCategoryName2    
 ,m.ProductCategoryName3    
 ,m.ProductCategoryId2    
 ,m.ProductCategoryId3    
 ,m.MaterialCode    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType 

END
GO


