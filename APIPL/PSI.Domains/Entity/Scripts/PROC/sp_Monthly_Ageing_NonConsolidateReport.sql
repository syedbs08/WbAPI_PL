IF OBJECT_ID('dbo.sp_Monthly_Ageing_NonConsolidateReport') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[sp_Monthly_Ageing_NonConsolidateReport];
END 
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                  
 CREATE PROC [dbo].[sp_Monthly_Ageing_NonConsolidateReport] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY                          
 ,@Mg VARCHAR(20)                          
 ,@MG1 VARCHAR(20)                          
 ,@SalesSubType VARCHAR(30)                          
 ,@ColumnType VARCHAR(50)                          
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY                     
 ,@TVPCUSTOMERLIST [dbo].[TVP_NONCONSOLIDATE_CUSTOMER_LIST] READONLY              
 ,@IsUSD bit              
 )                          
AS                          
BEGIN                         
 SET NOCOUNT ON;                  
                   
	DECLARE  @Preceding_MonthYear_List AS dbo.TVP_MONTHYEAR_TYPE;
	DECLARE @FirstDate NVARCHAR(10);
	DECLARE @CustomerCodeCount AS INT;                        
	SET @CustomerCodeCount =0;                        
  
	SELECT TOP 1 @FirstDate = MONTHYEAR FROM @TVP_MonthYear_LIST ORDER BY MONTHYEAR ASC;
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -1, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -2, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -3, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -4, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -4, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');
	INSERT INTO  @Preceding_MonthYear_List VALUES ( (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -6, CAST(CAST(@FirstDate AS VARCHAR) + '01' AS DATE) ) AS DATE), 112) AS INT) ),'MonthlyAgeing');

	INSERT INTO @Preceding_MonthYear_List
	SELECT MonthYear , [TYPE] FROM @TVP_MonthYear_LIST  where [TYPE] = 'MonthlyAgeing';
  
  SELECT @CustomerCodeCount = COUNT([CustomerCode])                        
  FROM @TVP_CUSTOMERCODE_LIST                        
  WHERE [CustomerCode] > 0;                     
                  
  SELECT                      
   CustomerId                        
  ,CustomerName                     
  ,CustomerCode                     
  ,DepartmentName                        
  ,CountryId                        
  ,CountryName                       
  ,SalesOfficeName                  
  ,AccountCode          
  ,CurrencyCode          
  INTO #TEMP_CUSTOMERS                  
  FROM @TVPCUSTOMERLIST;    
      
  SELECT mat.MaterialId                    
,mat.MaterialCode                    
INTO #TEMP_MATERIALS                    
FROM Material mat                    
WHERE 
mat.IsActive =1 AND
 (                    
  mat.ProductCategoryId2 = @Mg                    
  OR @Mg = 0                    
  )                    
 AND (               
  mat.ProductCategoryId3 = @MG1                    
  OR @MG1 = 0                    
  );     
    
  CREATE TABLE #TEMP_AGEING_DATA    
  (    
  Department VARCHAR(50),    
  CustomerCode VARCHAR(50),    
  Country VARCHAR(50),    
  SalesOffice VARCHAR(50),    
  SalesType VARCHAR(50),    
   Consignee VARCHAR(50),    
  Group_Desc VARCHAR(50),    
  SubGroup VARCHAR(50),    
  [Type] VARCHAR(50),    
  MaterialCode VARCHAR(50),    
   MonthYear VARCHAR(50),    
  Age30 INT,    
  Age60 INT,    
  Age90 INT,    
  Age120 INT,    
  Age150 INT,    
  Age180 INT,    
  Age180Greatherthan INT,    
  Age30Amt DECIMAL(18,2),    
  Age60Amt DECIMAL(18,2),    
  Age90Amt  DECIMAL(18,2),    
  Age120Amt DECIMAL(18,2),    
  Age150Amt DECIMAL(18,2),    
  Age180Amt DECIMAL(18,2),    
  Age180greatherthanAmt DECIMAL(18,2),    
  )    
  --DIRECTSALE    
                       
  SELECT                    
  DepartmentName                      
  ,CountryId                      
  ,CountryName                      
  ,SalesOfficeName AS SalesOfficeName                      
  ,C.CustomerCode + ' ' + C.CustomerName AS Consignee         
  ,c.CustomerCode                      
  --,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName AS MG                      
  --,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS MG1                      
  --,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS MG2                      
  --,prod2.ProductCategoryCode  AS ProductCategoryCode2                    
  --,prod3.ProductCategoryCode  AS ProductCategoryCode3                  
  ,mat.MaterialCode                      
  ,SalesEntry.MonthYear                      
  ,'Monthly' AS SaleSubType                      
  ,'SNS' AS SalesType                   
  ,SalesEntry.ModeofTypeId                      
  ,'USD' AS Currency                  
  ,  SalesEntry.Price   AS Price            
  ,SalesEntry.Quantity                  
  ,'MonthlyAgeing' AS monthType                  
  INTO #TEMP_SalesEntry                  
  FROM   SalesEntry SalesEntry 
 INNER JOIN @Preceding_MonthYear_List pml ON SalesEntry.MonthYear = pml.MonthYear
 INNER JOIN #TEMP_CUSTOMERS c ON SalesEntry.CustomerCode = c.CustomerCode                      
 INNER JOIN #TEMP_MATERIALS mat ON SalesEntry.MaterialCode = mat.MaterialCode                         
  WHERE   SalesEntry.ModeofTypeId IN (2,4)                                  
 AND (@CustomerCodeCount = 0 OR  c.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ))                  
               
                      
    --Inventory data        
  SELECT DISTINCT MonthYear,
  CustomerCode,
  Materialcode,
  MAX(Price) AS Price 
  INTO #TEMP_PRICE_DATA 
  FROM #TEMP_SalesEntry      
  GROUP BY  MonthYear,CustomerCode,Materialcode; 

                
  SELECT  [CustomerCode], Materialcode,MonthYear,ModeOfTypeid,Quantity     
  INTO #TEMP_DIRECTSALE_AGEING  
  FROM #TEMP_SalesEntry; 

 SELECT sum(Quantity) AS INV_QTY,
  temp.Materialcode,
  temp.CustomerCode,
  temp.MonthYear
 INTO #TEMP_INV_QTY
 FROM #TEMP_DIRECTSALE_AGEING AS temp
 INNER JOIN @TVP_MonthYear_LIST mon ON mon.MonthYear = temp.MonthYear
 WHERE temp.ModeofTypeID IN (4)
 GROUP BY temp.Materialcode, temp.CustomerCode, temp.MonthYear;

 SELECT sum(Quantity) AS PUR_QTY,
  temp.Materialcode,
  temp.CustomerCode,
  temp.MonthYear
 INTO #TEMP_PUR_QTY
 FROM #TEMP_DIRECTSALE_AGEING as temp
 WHERE temp.ModeofTypeID IN (2)
 GROUP BY temp.Materialcode, temp.CustomerCode, temp.MonthYear; 


 SELECT
 MonthYear
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -0, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D30_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -1, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D60_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -2, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D90_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -3, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D120_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -4, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D150_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -5, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D180_LV_YYYYMM                  
 ,(CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -6, CAST(CAST(MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) ) as D210_LV_YYYYMM                  
  INTO #TEMP_DateRanges    
  FROM @TVP_MonthYear_LIST where [TYPE] = 'MonthlyAgeing';       
                  
 --30 D Direct Sale
 WITH CTE_30D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D30_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D30_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --60 D Direct Sale
 CTE_60D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D60_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D60_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --90 D Direct Sale
 CTE_90D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D90_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D90_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --120 D Direct Sale
 CTE_120D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D120_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D120_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --150 D Direct Sale
 CTE_150D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D150_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D150_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --180 D Direct Sale
 CTE_180D_DIRECT_SALE AS(
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D180_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D180_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --210 D Direct Sale
 CTE_210D_DIRECT_SALE AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D210_LV_YYYYMM
 FROM #TEMP_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D210_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode)             
                  
  --Direct Sale aginig Data calculation   
 SELECT 
 temp.MonthYear,
 temp.Materialcode,
 temp.CustomerCode,
 d30.INV_QTY,
 CASE WHEN (d30.PUR_QTY < d30.INV_QTY) 
		THEN d30.PUR_QTY 
		ELSE d30.INV_QTY END AS D30_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY) < d60.INV_QTY ) 
		THEN d60.PUR_QTY 
		ELSE (d60.INV_QTY - d30.PUR_QTY ) END AS D60_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY) < d90.INV_QTY ) 
		THEN d90.PUR_QTY
		ELSE (d60.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY) ) END AS D90_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY) < d120.INV_QTY ) 
		THEN d120.PUR_QTY
		ELSE (d120.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY) ) END AS D120_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY) < d150.INV_QTY ) 
		THEN d150.PUR_QTY
		ELSE (d150.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY) ) END AS D150_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY) < d180.INV_QTY ) 
		THEN d180.PUR_QTY
		ELSE (d180.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY ) ) END AS D180_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY + d210.PUR_QTY) < d210.INV_QTY ) 
		THEN d210.PUR_QTY
		ELSE (d210.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY) ) END AS D210_QTY

INTO #TEMP_ALL_DIRECT_SALES_QTY
FROM #TEMP_INV_QTY AS temp
LEFT JOIN CTE_30D_DIRECT_SALE AS d30 
	ON  temp.MonthYear = d30.MonthYear
		AND temp.Materialcode = d30.Materialcode
		AND temp.CustomerCode = d30.CustomerCode
LEFT JOIN CTE_60D_DIRECT_SALE AS d60 
	ON  temp.MonthYear = d60.MonthYear
		AND temp.Materialcode = d60.Materialcode
		AND temp.CustomerCode = d60.CustomerCode
LEFT JOIN CTE_90D_DIRECT_SALE AS d90 
	ON  temp.MonthYear = d90.MonthYear
		AND temp.Materialcode = d90.Materialcode
		AND temp.CustomerCode = d90.CustomerCode
LEFT JOIN CTE_120D_DIRECT_SALE AS d120 
	ON  temp.MonthYear = d120.MonthYear
		AND temp.Materialcode = d120.Materialcode
		AND temp.CustomerCode = d120.CustomerCode
LEFT JOIN CTE_150D_DIRECT_SALE AS d150 
	ON  temp.MonthYear = d150.MonthYear
		AND temp.Materialcode = d150.Materialcode
		AND temp.CustomerCode = d150.CustomerCode
LEFT JOIN CTE_180D_DIRECT_SALE AS d180 
	ON  temp.MonthYear = d180.MonthYear
		AND temp.Materialcode = d180.Materialcode
		AND temp.CustomerCode = d180.CustomerCode
LEFT JOIN CTE_210D_DIRECT_SALE AS d210 
	ON  temp.MonthYear = d210.MonthYear
		AND temp.Materialcode = d210.Materialcode
		AND temp.CustomerCode = d210.CustomerCode;

--Sales entry details
SELECT DISTINCT
	SE.DepartmentName  as Department                         
   ,SE.CustomerCode as CustomerCode                         
   ,SE.CountryName   as Country                       
   ,SE.SalesOfficeName as SalesOffice                      
   ,SE.SalesType as SalesType                         
   ,SE.Consignee as Consignee                         
   ,'' as Group_Desc                         
   ,'' as SubGroup                         
   ,SE.monthType AS [Type]
   ,TEMP.MonthYear
   ,TEMP.MaterialCode
INTO #TEMP_SalesEntry_Details
FROM #TEMP_ALL_DIRECT_SALES_QTY as TEMP
LEFT JOIN #TEMP_SalesEntry as SE
	ON SE.MonthYear = TEMP.MonthYear
		AND SE.CustomerCode = TEMP.CustomerCode
		AND SE.MaterialCode = TEMP.MaterialCode;

--final insert
INSERT INTO #TEMP_AGEING_DATA     
	SELECT 
		temp3.Department                         
	   ,temp1.CustomerCode                         
	   ,temp3.Country                       
	   ,temp3.SalesOffice                      
	   ,temp3.SalesType                         
	   ,temp3.Consignee                         
	   ,temp3.Group_Desc                         
	   ,temp3.SubGroup                         
	   ,temp3.[Type]                          
	   ,temp1.MaterialCode  as MaterialCode                      
	   ,temp1.MonthYear as MonthYear, 
	 CASE WHEN temp1.D30_QTY > 0 THEN temp1.D30_QTY ELSE 0 END Age30,
	 CASE WHEN temp1.D60_QTY > 0 THEN temp1.D60_QTY ELSE 0 END Age60,
	 CASE WHEN temp1.D90_QTY > 0 THEN temp1.D90_QTY ELSE 0 END Age90,
	 CASE WHEN temp1.D120_QTY > 0 THEN temp1.D120_QTY ELSE 0 END Age120,
	 CASE WHEN temp1.D150_QTY > 0 THEN temp1.D150_QTY ELSE 0 END Age150,
	 CASE WHEN temp1.D180_QTY > 0 THEN temp1.D180_QTY ELSE 0 END Age180,
	 CASE WHEN temp1.D210_QTY > 0 THEN temp1.D210_QTY ELSE 0 END Age180Greatherthan,
	 (CASE WHEN temp1.D30_QTY > 0 THEN temp1.D30_QTY ELSE 0 END) * temp2.Price AS Age30Amt,
	 (CASE WHEN temp1.D60_QTY > 0 THEN temp1.D60_QTY ELSE 0 END) * temp2.Price AS Age60Amt,
	 (CASE WHEN temp1.D90_QTY > 0 THEN temp1.D90_QTY ELSE 0 END) * temp2.Price AS Age90Amt,
	 (CASE WHEN temp1.D120_QTY > 0 THEN temp1.D120_QTY ELSE 0 END) * temp2.Price AS Age120Amt,
	 (CASE WHEN temp1.D150_QTY > 0 THEN temp1.D150_QTY ELSE 0 END) * temp2.Price AS Age150Amt,
	 (CASE WHEN temp1.D180_QTY > 0 THEN temp1.D180_QTY ELSE 0 END) * temp2.Price AS Age180Amt,
	 (CASE WHEN temp1.D210_QTY > 0 THEN temp1.D210_QTY ELSE 0 END) * temp2.Price AS Age180greatherthanAmt
	FROM #TEMP_ALL_DIRECT_SALES_QTY as temp1
	LEFT JOIN #TEMP_PRICE_DATA as temp2
		ON temp1.MonthYear = temp2.MonthYear
			AND temp1.Materialcode = temp2.Materialcode
			AND temp1.CustomerCode = temp2.CustomerCode
	LEFT JOIN #TEMP_SalesEntry_Details as temp3
		ON temp1.MonthYear = temp3.MonthYear
			AND temp1.Materialcode = temp3.Materialcode
			AND temp1.CustomerCode = temp3.CustomerCode;

   --TRP PRICING --All Transactions                  
  SELECT                    
   C.DepartmentName                      
  ,C.CountryId                      
  ,C.CountryName                      
  ,C.SalesOfficeName AS SalesOfficeName                      
  ,C.CustomerCode + ' ' + C.CustomerName AS Consignee         
  ,c.CustomerCode                      
  --,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName AS MG                      
  --,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS MG1                      
  --,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS MG2                      
  --,prod2.ProductCategoryCode  AS ProductCategoryCode2                    
  --,prod3.ProductCategoryCode  AS ProductCategoryCode3                  
  ,mat.MaterialCode                      
  ,trn.MonthYear                      
  ,'Monthly' AS SaleSubType                      
  ,'SNS' AS SalesType                   
  ,trn.ModeofType                      
  ,'USD' AS Currency                  
  ,  trn.Price   AS Price            
  ,trn.AccountCode                  
  ,trn.Quantity                  
  ,'MonthlyAgeing' AS monthType                  
  INTO #TEMP_TRNPRICEPLANNING                  
  FROM   TRNPricePlanning trn       
 INNER JOIN @Preceding_MonthYear_List pml ON trn.MonthYear = pml.MonthYear
 INNER JOIN #TEMP_CUSTOMERS c ON trn.AccountCode = c.AccountCode                      
 INNER JOIN #TEMP_MATERIALS mat ON trn.MaterialCode = mat.MaterialCode                          
  WHERE   trn.ModeofType IN ('MPO','PURCHASE','INVENTORY')                                  
 AND (@CustomerCodeCount = 0 OR  trn.AccountCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST )) ; 
 
 --TRN PRICE DATA
 select distinct MonthYear,
  CustomerCode,
  Materialcode,
  max(Price) as Price 
  into #TEMP_TRN_PRICE_DATA 
  from #TEMP_TRNPRICEPLANNING      
  group by  MonthYear,CustomerCode,Materialcode; 

  SELECT  [CustomerCode], Materialcode,MonthYear,ModeofType,Quantity     
  INTO #TEMP_TRN_AGEING  
  FROM #TEMP_TRNPRICEPLANNING; 

  --Inventory Qty
  SELECT sum(Quantity) as INV_QTY,
  temp.Materialcode,
  temp.CustomerCode,
  temp.MonthYear
 INTO #TEMP_TRN_INV_QTY
 FROM #TEMP_TRN_AGEING as temp
 INNER JOIN @TVP_MonthYear_LIST mon on mon.MonthYear = temp.MonthYear
 WHERE temp.ModeofType IN ( 'INVENTORY') AND  mon.[TYPE] = 'MonthlyAgeing' 
 GROUP BY temp.Materialcode, temp.CustomerCode, temp.MonthYear;

  --Purchase Qty
  SELECT sum(Quantity) as PUR_QTY,
  temp.Materialcode,
  temp.CustomerCode,
  temp.MonthYear
 INTO #TEMP_TRN_PUR_QTY
 FROM #TEMP_TRN_AGEING as temp
 WHERE temp.ModeofType IN ('MPO','PURCHASE')
 GROUP BY temp.Materialcode, temp.CustomerCode, temp.MonthYear; 

  --30 D TRN
  WITH CTE_TEMP_30D_TRN AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D30_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D30_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

  --60 D TRN
   CTE_TEMP_60D_TRN AS (
 SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D60_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D60_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

  --90 D TRN
 CTE_TEMP_90D_TRN AS (SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D90_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D90_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --120 D TRN
 CTE_TEMP_120D_TRN AS  (SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D120_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D120_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --150 D TRN
 CTE_TEMP_150D_TRN AS (SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D150_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D150_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --180 D TRN
 CTE_TEMP_180D_TRN AS  (SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D180_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D180_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode),

 --210 D TRN
 CTE_TEMP_210D_TRN  AS (SELECT 
 inv_qty.Materialcode,
 inv_qty.CustomerCode,
 inv_qty.INV_QTY,
 CASE WHEN pur_qty.PUR_QTY > 0 THEN pur_qty.PUR_QTY ELSE 0 END AS PUR_QTY,
 inv_qty.MonthYear,
 date_range.D210_LV_YYYYMM
 FROM #TEMP_TRN_INV_QTY inv_qty
 LEFT JOIN #TEMP_DateRanges date_range 
	ON inv_qty.MonthYear = date_range.MonthYear
 LEFT JOIN #TEMP_TRN_PUR_QTY pur_qty 
	ON pur_qty.MonthYear = date_range.D210_LV_YYYYMM
		AND pur_qty.Materialcode = inv_qty.Materialcode
		AND pur_qty.CustomerCode = inv_qty.CustomerCode)

  --TRN Pricing aginig Data calculation

 SELECT 
 temp.MonthYear,
 temp.Materialcode,
 temp.CustomerCode,
 d30.INV_QTY,
 CASE WHEN (d30.PUR_QTY < d30.INV_QTY) 
		THEN d30.PUR_QTY 
		ELSE d30.INV_QTY END AS D30_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY) < d60.INV_QTY ) 
		THEN d60.PUR_QTY 
		ELSE (d60.INV_QTY - d30.PUR_QTY ) END AS D60_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY) < d90.INV_QTY ) 
		THEN d90.PUR_QTY
		ELSE (d60.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY) ) END AS D90_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY) < d120.INV_QTY ) 
		THEN d120.PUR_QTY
		ELSE (d120.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY) ) END AS D120_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY) < d150.INV_QTY ) 
		THEN d150.PUR_QTY
		ELSE (d150.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY) ) END AS D150_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY) < d180.INV_QTY ) 
		THEN d180.PUR_QTY
		ELSE (d180.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY ) ) END AS D180_QTY,

 CASE WHEN ((d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY + d210.PUR_QTY) < d210.INV_QTY ) 
		THEN d210.PUR_QTY
		ELSE (d210.INV_QTY - (d30.PUR_QTY + d60.PUR_QTY + d90.PUR_QTY + d120.PUR_QTY + d150.PUR_QTY + d180.PUR_QTY) ) END AS D210_QTY
INTO #TEMP_ALL_TRN_QTY
FROM #TEMP_TRN_INV_QTY AS temp
LEFT JOIN CTE_TEMP_30D_TRN AS d30 
	ON  temp.MonthYear = d30.MonthYear
		AND temp.Materialcode = d30.Materialcode
		AND temp.CustomerCode = d30.CustomerCode
LEFT JOIN CTE_TEMP_60D_TRN AS d60 
	ON  temp.MonthYear = d60.MonthYear
		AND temp.Materialcode = d60.Materialcode
		AND temp.CustomerCode = d60.CustomerCode
LEFT JOIN CTE_TEMP_90D_TRN AS d90 
	ON  temp.MonthYear = d90.MonthYear
		AND temp.Materialcode = d90.Materialcode
		AND temp.CustomerCode = d90.CustomerCode
LEFT JOIN CTE_TEMP_120D_TRN AS d120 
	ON  temp.MonthYear = d120.MonthYear
		AND temp.Materialcode = d120.Materialcode
		AND temp.CustomerCode = d120.CustomerCode
LEFT JOIN CTE_TEMP_150D_TRN AS d150 
	ON  temp.MonthYear = d150.MonthYear
		AND temp.Materialcode = d150.Materialcode
		AND temp.CustomerCode = d150.CustomerCode
LEFT JOIN CTE_TEMP_180D_TRN AS d180 
	ON  temp.MonthYear = d180.MonthYear
		AND temp.Materialcode = d180.Materialcode
		AND temp.CustomerCode = d180.CustomerCode
LEFT JOIN CTE_TEMP_210D_TRN AS d210 
	ON  temp.MonthYear = d210.MonthYear
		AND temp.Materialcode = d210.Materialcode
		AND temp.CustomerCode = d210.CustomerCode;

--TRN Pricing details
SELECT DISTINCT
	TP.DepartmentName  as Department                         
   ,TP.CustomerCode as CustomerCode                         
   ,TP.CountryName   as Country                       
   ,TP.SalesOfficeName as SalesOffice                      
   ,TP.SalesType as SalesType                         
   ,TP.Consignee as Consignee                         
   ,'' as Group_Desc                         
   ,'' as SubGroup                         
   ,TP.monthType AS [Type]
   ,TEMP.MonthYear
   ,TEMP.MaterialCode
INTO #TEMP_TRN_PRICING_Details
FROM #TEMP_ALL_TRN_QTY as TEMP
LEFT JOIN #TEMP_TRNPRICEPLANNING as TP
	ON TP.MonthYear = TEMP.MonthYear
		AND TP.CustomerCode = TEMP.CustomerCode
		AND TP.MaterialCode = TEMP.MaterialCode;

INSERT INTO #TEMP_AGEING_DATA     
	SELECT 
		temp3.Department                         
	   ,temp1.CustomerCode                         
	   ,temp3.Country                       
	   ,temp3.SalesOffice                      
	   ,temp3.SalesType                         
	   ,temp3.Consignee                         
	   ,temp3.Group_Desc                         
	   ,temp3.SubGroup                         
	   ,temp3.[Type]                          
	   ,temp1.MaterialCode  as MaterialCode                      
	   ,temp1.MonthYear as MonthYear, 
	 CASE WHEN temp1.D30_QTY > 0 THEN temp1.D30_QTY ELSE 0 END Age30,
	 CASE WHEN temp1.D60_QTY > 0 THEN temp1.D60_QTY ELSE 0 END Age60,
	 CASE WHEN temp1.D90_QTY > 0 THEN temp1.D90_QTY ELSE 0 END Age90,
	 CASE WHEN temp1.D120_QTY > 0 THEN temp1.D120_QTY ELSE 0 END Age120,
	 CASE WHEN temp1.D150_QTY > 0 THEN temp1.D150_QTY ELSE 0 END Age150,
	 CASE WHEN temp1.D180_QTY > 0 THEN temp1.D180_QTY ELSE 0 END Age180,
	 CASE WHEN temp1.D210_QTY > 0 THEN temp1.D210_QTY ELSE 0 END Age180Greatherthan,
	 (CASE WHEN temp1.D30_QTY > 0 THEN temp1.D30_QTY ELSE 0 END) * temp2.Price AS Age30Amt,
	 (CASE WHEN temp1.D60_QTY > 0 THEN temp1.D60_QTY ELSE 0 END) * temp2.Price AS Age60Amt,
	 (CASE WHEN temp1.D90_QTY > 0 THEN temp1.D90_QTY ELSE 0 END) * temp2.Price AS Age90Amt,
	 (CASE WHEN temp1.D120_QTY > 0 THEN temp1.D120_QTY ELSE 0 END) * temp2.Price AS Age120Amt,
	 (CASE WHEN temp1.D150_QTY > 0 THEN temp1.D150_QTY ELSE 0 END) * temp2.Price AS Age150Amt,
	 (CASE WHEN temp1.D180_QTY > 0 THEN temp1.D180_QTY ELSE 0 END) * temp2.Price AS Age180Amt,
	 (CASE WHEN temp1.D210_QTY > 0 THEN temp1.D210_QTY ELSE 0 END) * temp2.Price AS Age180greatherthanAmt
	FROM #TEMP_ALL_TRN_QTY as temp1
	LEFT JOIN #TEMP_TRN_PRICE_DATA as temp2
		ON temp1.MonthYear = temp2.MonthYear
			AND temp1.Materialcode = temp2.Materialcode
			AND temp1.CustomerCode = temp2.CustomerCode
	LEFT JOIN #TEMP_TRN_PRICING_Details as temp3
		ON temp1.MonthYear = temp3.MonthYear
			AND temp1.Materialcode = temp3.Materialcode
			AND temp1.CustomerCode = temp3.CustomerCode;    
    
	SELECT *FROM #TEMP_AGEING_DATA;    


	DROP TABLE #TEMP_CUSTOMERS;
	DROP TABLE #TEMP_SalesEntry;
	DROP TABLE #TEMP_PRICE_DATA;
	DROP TABLE #TEMP_DIRECTSALE_AGEING;
	DROP TABLE #TEMP_INV_QTY;
	DROP TABLE #TEMP_PUR_QTY;
	DROP TABLE #TEMP_DateRanges;
	DROP TABLE #TEMP_ALL_DIRECT_SALES_QTY;
	DROP TABLE #TEMP_SalesEntry_Details;
	DROP TABLE #TEMP_AGEING_DATA;
	DROP TABLE #TEMP_TRNPRICEPLANNING;
	DROP TABLE #TEMP_TRN_PRICE_DATA;
	DROP TABLE #TEMP_TRN_AGEING;
	DROP TABLE #TEMP_TRN_INV_QTY;
	DROP TABLE #TEMP_TRN_PUR_QTY;
	DROP TABLE #TEMP_ALL_TRN_QTY;
	DROP TABLE #TEMP_TRN_PRICING_Details;

                  
END 