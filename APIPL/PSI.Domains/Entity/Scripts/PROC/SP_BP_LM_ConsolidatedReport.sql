                          
CREATE PROC [dbo].[SP_BP_LM_ConsolidatedReport](                              
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY                              
 ,@Mg VARCHAR(20)                              
 ,@MG1 VARCHAR(20)                              
 ,@SalesSubType VARCHAR(30)                              
  ,@TVPCUSTOMERLIST [dbo].[TVP_CUSTOMER_LIST] READONLY                    
  ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY                    
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
     CustomerId                          
    ,CustomerName                       
    ,CustomerCode                       
    ,DepartmentName                          
    ,CountryId                          
    ,CountryName                         
    ,SalesOfficeName                          
  INTO #TEMP_CUSTOMERS                    
  FROM @TVPCUSTOMERLIST ;        
        
  DECLARE @BP_YEAR  VARCHAR(4);          
SET @BP_YEAR=(SELECT top 1 SUBSTRING(MONTHYEAR, 1, 4) from @TVP_MonthYear_LIST);          
                          
  SELECT DISTINCT SH.SalesEntryBPId                          
   ,SH.CustomerCode                          
   ,SH.MaterialCode                          
   ,SH.Price                          
   ,SH.Quantity                          
   ,SH.MonthYear                          
   ,SH.ModeOfTypeId                          
   ,SH.SaleSubType                          
   ,SH.ArchiveStatus                          
  INTO #TEMP_All_SALES_ENTRY                          
  FROM SalesEntryArchival_BP SH                          
  INNER JOIN @TVP_MonthYear_LIST M ON SH.MonthYear = M.MONTHYEAR                    
  where SH.SaleSubType = @SalesSubType   AND BPYear=@BP_YEAR                       
   AND (SH.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0);                          
                          
    SELECT SalesEntryBPId                          
   ,CustomerCode                          
   ,MaterialCode                          
   ,Price                          
   ,Quantity                          
   ,MonthYear                          
   ,ModeOfTypeId                          
   ,SaleSubType                          
   ,ArchiveStatus                          
                         
   ,0 as OCmonthYear                            
   INTO #TEMP_SALES_ENTRY                          
      FROM #TEMP_All_SALES_ENTRY                             
   WHERE ModeOfTypeId = 1                           
   AND ArchiveStatus='Archived';                          
                            
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
 FROM   COGEntry as cog                    
 LEFT JOIN COGEntryQtyPrice as cogp ON cog.COGEntryId = cogp.COGEntryId                     
 INNER JOIN @TVP_MonthYear_LIST M ON cogp.MonthYear = M.MONTHYEAR           
    where cog.SaleSubType = @SalesSubType  
 and (cog.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0)    ;                         
                          
  --temp table to calculate qty                          
                              
   WITH CTE_ALL_QTY_PRICE AS (                          
   SELECT DISTINCT sales.Quantity,sales.Price ,sales.SaleSubType,sales.MonthYear,sales.CustomerCode,sales.MaterialCode                          
   FROM #TEMP_All_SALES_ENTRY  sales                          
   INNER JOIN ModeofType MT ON MT.ModeofTypeId = sales.ModeOfTypeId                            
   WHERE  sales.ModeOfTypeId   in (1,12,10)                     
   )                          
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
 ,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName  AS MG                        
 ,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS MG1                        
 ,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS MG2                               
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
  ,'BP' AS SaleSubType                          
  ,(s.Quantity * FRT_Prices.Price ) AS FRT_AMT                          
  ,(s.Quantity * CST_Prices.Price) AS CST_AMT                          
  ,(s.Quantity * FOB_Prices.Price) AS FOB_AMT                          
  ,(s.Quantity * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  ) AS COG_AMT                          
 FROM TRNSalesPlanningArchival_BP s                        
 INNER JOIN @TVP_MonthYear_LIST M ON s.MonthYear = M.MONTHYEAR                    
 left JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 2 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = s.MonthYear                          
 left JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 2 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = s.MonthYear                          
 left JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 2 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = s.MonthYear                          
    where S.BP_YEAR=@BP_YEAR  and (s.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0)                           
                          
    
                          
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
   left JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = sales.MaterialCode AND FRT_Prices.CustomerCode = sales.CustomerCode AND FRT_Prices.MonthYear = sales.MonthYear             
   
   
       
       
          
             
   left JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = sales.MaterialCode AND CST_Prices.CustomerCode = sales.CustomerCode AND CST_Prices.MonthYear = sales.MonthYear              
  
    
      
        
          
            
   left JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = sales.MaterialCode AND FOB_Prices.CustomerCode = sales.CustomerCode AND FOB_Prices.MonthYear = sales.MonthYear              
  
    
      
        
          
            
                          
 ) TEMP                    INNER JOIN #TEMP_CUSTOMERS c ON TEMP.CustomerCode = c.CustomerCode                              
INNER JOIN Material m ON TEMP.MaterialCode = m.MaterialCode                      
   AND (m.ProductCategoryId2 = @Mg OR @Mg = 0)                        
   AND (m.ProductCategoryId3 = @MG1 OR @MG1 = 0)                          
LEFT JOIN ProductCategory prod1 ON m.ProductCategoryId1=prod1.ProductCategoryId                            
LEFT JOIN ProductCategory prod2 ON m.ProductCategoryId2=prod2.ProductCategoryId                            
LEFT JOIN ProductCategory prod3 ON m.ProductCategoryId3=prod3.ProductCategoryId                          
                          
GROUP BY DepartmentName                              
 ,CountryId                              
 ,CountryName                              
 ,SalesOfficeName                              
 ,SalesType                              
 ,c.CustomerCode + '-' + CustomerName                              
 ,c.CustomerCode                              
 ,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName                          
 ,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName                       
 ,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName                               
 ,m.ProductCategoryId2                              
 ,m.ProductCategoryId3                              
 ,m.MaterialCode            
 ,TEMP.MonthYear                              
 ,TEMP.SaleSubType                           
                          
END 