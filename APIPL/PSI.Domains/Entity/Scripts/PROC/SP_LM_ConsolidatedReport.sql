            
CREATE PROC [dbo].[SP_CM_LY_ConsolidatedReport] (                
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
  FROM @TVPCUSTOMERLIST          
            
   SELECT             
   s.CustomerCode            
   ,s.Quantity                
   ,s.Amount                    
   ,s.MonthYear             
   ,s.MaterialCode            
   ,s.AccountCode            
   ,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName AS ProductCategoryName1                     
   ,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS ProductCategoryName2                    
   ,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS ProductCategoryName3                    
   ,mat.ProductCategoryId2                    
   ,mat.ProductCategoryId3                    
   INTO #TEMP_RESULT_SALES            
   FROM  MST_ResultSales s            
 INNER JOIN @TVP_MonthYear_LIST M ON s.MonthYear = M.MONTHYEAR          
   --INNER JOIN MaterialView m ON s.MaterialCode = m.MaterialCode            
 INNER JOIN Material mat ON s.MaterialCode = mat.MaterialCode            
   AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)              
   AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)                   
 LEFT JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId                  
 LEFT JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId                  
 LEFT JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId          
   WHERE  (s.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0);            
               
            
    SELECT   distinct          
   (cogp.Qty * cogp.Price) AS Price,            
   sales.CustomerCode,            
   sales.MaterialCode,            
   sales.MonthYear,            
   cogp.ChargeType            
   INTO #TEMP_ALL_QTY            
   FROM #TEMP_RESULT_SALES sales          
    LEFT JOIN COGEntry cog  on sales.CustomerCode = cog.CustomerCode           
   AND cog.MaterialCode = sales.MaterialCode  and cog.SaleSubType = 'Monthly'    
   --and cog.SaleTypeId = 2    
   INNER JOIN COGEntryQtyPrice cogp ON cog.COGEntryId = cogp.COGEntryId          
            AND cogp.MonthYear = sales.MonthYear   and cogp.ChargeType IN ('FRT','CST','FOB')           
             
            
  SELECT DISTINCT                
    c.DepartmentName                    
   ,c.CountryId                    
   ,c.CountryName                    
   ,c.SalesOfficeName AS SalesOfficeName               
   ,'SNS' AS SalesType            
   ,s.CustomerCode + '-' + c.CustomerName AS Consignee                    
   ,s.CustomerCode                   
   ,s.ProductCategoryName1 AS MG                    
   ,s.ProductCategoryName2 AS MG1                    
   ,s.ProductCategoryName3 AS MG2                    
   ,s.ProductCategoryId2                    
   ,s.ProductCategoryId3                    
   ,s.MaterialCode                    
   ,s.Quantity AS Qty                
   ,s.Amount              
   ,s.Quantity * FRT_qty.Price AS FRT_AMT           
   ,s.Quantity * CST_qty.Price AS CST_AMT            
   ,s.Quantity * FOB_qty.Price AS FOB_AMT            
   ,s.Quantity * ( FRT_qty.Price + CST_qty.Price + FOB_qty.Price) AS COG_AMT            
   ,(s.Amount - COALESCE((s.Quantity * ( FRT_qty.Price + CST_qty.Price + FOB_qty.Price)),0)) AS GP_AMT            
   , CASE WHEN s.Amount!=0               
    THEN ((s.Amount - COALESCE((s.Quantity * ( FRT_qty.Price + CST_qty.Price + FOB_qty.Price)),0)) / s.Amount ) * 100             
    ELSE 0             
    END AS GP_PER             
   ,s.MonthYear                    
   ,'Monthly' AS SaleSubType              
  FROM #TEMP_RESULT_SALES s                    
  INNER JOIN #TEMP_CUSTOMERS as c ON  s.CustomerCode = c.CustomerCode            
 LEFT JOIN #TEMP_ALL_QTY as FRT_qty on FRT_qty.ChargeType = 'FRT' AND FRT_qty.MaterialCode = s.MaterialCode AND FRT_qty.CustomerCode = s.CustomerCode AND FRT_qty.MonthYear = s.MonthYear            
 LEFT JOIN #TEMP_ALL_QTY as CST_qty on CST_qty.ChargeType = 'CST' AND CST_qty.MaterialCode = s.MaterialCode AND CST_qty.CustomerCode = s.CustomerCode AND CST_qty.MonthYear = s.MonthYear            
 LEFT JOIN #TEMP_ALL_QTY as FOB_qty on FOB_qty.ChargeType = 'FOB' AND FOB_qty.MaterialCode = s.MaterialCode AND FOB_qty.CustomerCode = s.CustomerCode AND FOB_qty.MonthYear = s.MonthYear;            
            
END 