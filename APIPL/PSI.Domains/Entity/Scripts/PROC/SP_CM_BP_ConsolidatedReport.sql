    CREATE PROC [dbo].[SP_CM_BP_ConsolidatedReport](                    
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
                    
     PRINT N' SP_CM_BP_ConsolidatedReport-1'+ convert (varchar,SYSDATETIMEOFFSET());                    
                    
                 
 SELECT                 
  SH.CustomerCode                  
  ,SH.SaleSubType                
  ,SH.MaterialCode                 
  ,SH.ModeOfTypeId                
  ,SH.MonthYear                
  ,SH.Price                
  ,SH.Quantity                
  ,SH.SalesEntryId                
  INTO #TEMP_ALL_SALES_ENTRY                
  FROM SalesEntry SH                    
  INNER JOIN @TVP_MonthYear_LIST M ON SH.MonthYear = M.MONTHYEAR              
  INNER JOIN Material mat ON SH.MaterialCode = mat.MaterialCode                
   AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)                  
   AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)               
  WHERE  SH.ModeOfTypeId IN (1,10,12)                   
  AND( @CustomerCodeCount = 0  OR SH.CustomerCode IN (SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ));                
                
                
  --temp table to calculate price of each catergory                
 SELECT   distinct              
 (cogp.Qty * cogp.Price) as Price,                
 cogp.ChargeType ,                 
 cog.SaleTypeId ,                 
 cog.CustomerCode ,                 
 cog.MaterialCode ,                 
 cog.SaleSubType ,                
 cogp.MonthYear                
 INTO #All_Prices                
 --FROM  #TEMP_ALL_SALES_ENTRY as sales                
 --LEFT JOIN       
 from       
 COGEntry  cog              
 LEFT JOIN COGEntryQtyPrice as cogp ON cog.COGEntryId = cogp.COGEntryId         
   INNER JOIN @TVP_MonthYear_LIST M ON cogp.MonthYear = M.MONTHYEAR       
    where cog.SaleSubType = @SalesSubType;                
                
 PRINT N' SP_CM_BP_ConsolidatedReport-2'+ convert (varchar,SYSDATETIMEOFFSET());                
                
 --temp table to calculate qty  and amount               
 SELECT SUM(Quantity) as Qty,SUM(Quantity*price) AS Amount ,  CustomerCode, MaterialCode , MonthYear                
 INTO #TEMP_QTY_AMOUNT              
 FROM #TEMP_ALL_SALES_ENTRY                 
 GROUP BY  CustomerCode, MaterialCode , MonthYear;                
                
                
  --temp table of direct data                
  SELECT                 
  distinct  sales.Monthyear                    
   ,sales.CustomerCode                    
   ,sales.MaterialCode                 
   ,TEMP_QTY_AMNT.Qty                
   ,TEMP_QTY_AMNT.Amount                
   ,'Agent' AS SalesType                    
   ,sales.SaleSubType                 
   ,TEMP_QTY_AMNT.Qty * FRT_Prices.Price  AS FRT_Price                
   ,TEMP_QTY_AMNT.Qty * CST_Prices.Price AS CST_Price                
   ,TEMP_QTY_AMNT.Qty * FOB_Prices.Price AS FOB_Price                
   ,TEMP_QTY_AMNT.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS TOTAL_Price                
 INTO #Temp_DirectData                
 FROM #TEMP_ALL_SALES_ENTRY sales                 
  JOIN #TEMP_QTY_AMOUNT as TEMP_QTY_AMNT               
 ON  TEMP_QTY_AMNT.MonthYear = sales.MonthYear               
    AND TEMP_QTY_AMNT.CustomerCode = sales.CustomerCode               
    AND TEMP_QTY_AMNT.MaterialCode = sales.MaterialCode                 
 left JOIN #All_Prices as FRT_Prices               
   ON FRT_Prices.ChargeType= 'FRT'               
    AND FRT_Prices.SaleTypeId = 1               
    AND FRT_Prices.MaterialCode = sales.MaterialCode               
    AND FRT_Prices.CustomerCode = sales.CustomerCode               
    AND FRT_Prices.MonthYear = sales.MonthYear                
 left JOIN #All_Prices as CST_Prices               
   ON CST_Prices.ChargeType= 'CST'               
    AND CST_Prices.SaleTypeId = 1               
    AND CST_Prices.MaterialCode = sales.MaterialCode               
    AND CST_Prices.CustomerCode = sales.CustomerCode               
    AND CST_Prices.MonthYear = sales.MonthYear                
 left JOIN #All_Prices as FOB_Prices               
   ON FOB_Prices.ChargeType= 'FOB'               
    AND FOB_Prices.SaleTypeId = 1               
    AND FOB_Prices.MaterialCode = sales.MaterialCode               
    AND FOB_Prices.CustomerCode = sales.CustomerCode               
    AND FOB_Prices.MonthYear = sales.MonthYear                
 WHERE sales.SaleSubType= @SalesSubType                   
 AND( @CustomerCodeCount = 0  OR sales.CustomerCode IN (SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ));                  
             
 PRINT N' SP_CM_BP_ConsolidatedReport-3'+ convert (varchar,SYSDATETIMEOFFSET());                
                
                    
WITH CTE_FINAL_RESULT AS                  
(                        
   --sns data                                      
   SELECT sales.Monthyear                        
    ,sales.CustomerCode                        
    ,sales.MaterialCode                        
    ,sales.Quantity as Qty                        
    ,sales.Quantity * sales.Price  as Amount                        
    ,'SNS' AS SalesType                        
    ,@SalesSubType as SaleSubType                      
    ,sales.Quantity * FRT_Prices.Price  AS FRT_AMT                        
    ,sales.Quantity * CST_Prices.Price  AS CST_AMT                        
    ,sales.Quantity * FOB_Prices.Price  AS FOB_AMT                        
    ,sales.Quantity * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS COG_AMT                       
                         
   FROM TRNSalesPlanning  as sales                   
   INNER JOIN @TVP_MonthYear_LIST M ON sales.MonthYear = M.MONTHYEAR                  
   JOIN Material mat ON sales.MaterialCode = mat.MaterialCode                    
  AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)                      
  AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)                   
  LEFT JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 2 AND FRT_Prices.MaterialCode = sales.MaterialCode AND FRT_Prices.CustomerCode = sales.CustomerCode AND FRT_Prices.MonthYear = sales.MonthYear               
  
    
     
  LEFT JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 2 AND CST_Prices.MaterialCode = sales.MaterialCode AND CST_Prices.CustomerCode = sales.CustomerCode AND CST_Prices.MonthYear = sales.MonthYear               
  
    
     
  LEFT JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 2 AND FOB_Prices.MaterialCode = sales.MaterialCode AND FOB_Prices.CustomerCode = sales.CustomerCode AND FOB_Prices.MonthYear = sales.MonthYear               
  
    
     
   WHERE  sales.SaleSubType= @SalesSubType                     
   AND  (sales.CustomerCode IN (SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST) OR @CustomerCodeCount = 0)                        
                         
                              
                    
 UNION                        
                         
   ----adj data                                      
   SELECT P.Monthyear                        
    ,s.CustomerCode                    
    ,s.MaterialCode                        
    ,p.Qty                        
    ,p.Qty*cast( p.price as decimal(18,2)) as Amount                        
    ,'ADJ' AS SalesType                        
    ,@SalesSubType AS SaleSubType                      
    ,p.Qty * FRT_Prices.Price  AS FRT_AMT                        
    ,p.Qty * CST_Prices.Price  AS CST_AMT                        
    ,p.Qty * FOB_Prices.Price  AS FOB_AMT                        
    ,p.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS COG_AMT                       
                         
   FROM AdjustmentEntry s                    
   JOIN Material mat ON s.MaterialCode = mat.MaterialCode                    
   AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)                      
   AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)        
  INNER JOIN AdjustmentEntryQtyPrice p ON s.AdjustmentEntryId = p.AdjustmentEntryId       
   INNER JOIN @TVP_MonthYear_LIST M ON P.MonthYear = M.MONTHYEAR        
  LEFT JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = p.MonthYear                    
  LEFT JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = p.MonthYear                    
  LEFT JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = p.MonthYear                    
   WHERE  (s.CustomerCode IN (SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST)  OR @CustomerCodeCount = 0)              
                         
 UNION                        
                         
    --ssd data                                      
   SELECT s.Monthyear                        
    ,s.CustomerCode                        
    ,s.MaterialCode                        
    ,s.Qty                        
    ,s.Qty * s.Price as Amount                        
    ,'SSD' AS SalesType                        
    ,@SalesSubType AS SaleSubType                      
    ,s.Qty * FRT_Prices.Price  AS FRT_AMT                        
    ,s.Qty * CST_Prices.Price  AS CST_AMT                        
    ,s.Qty * FOB_Prices.Price  AS FOB_AMT                        
    ,s.Qty * (FRT_Prices.Price +  CST_Prices.Price + FOB_Prices.Price)  AS COG_AMT                       
                         
   FROM SSDentry s                  
   INNER JOIN @TVP_MonthYear_LIST M ON s.MonthYear = M.MONTHYEAR                  
   JOIN Material mat ON s.MaterialCode = mat.MaterialCode                    
   AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)                      
   AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)                   
   --INNER JOIN SSDentryQtyPrice p ON s.SSDEntryId = p.SSDEntryId                     
   LEFT  JOIN #All_Prices as FRT_Prices ON FRT_Prices.ChargeType= 'FRT' AND FRT_Prices.SaleTypeId = 1 AND FRT_Prices.MaterialCode = s.MaterialCode AND FRT_Prices.CustomerCode = s.CustomerCode AND FRT_Prices.MonthYear = s.MonthYear                    
   LEFT  JOIN #All_Prices as CST_Prices ON CST_Prices.ChargeType= 'CST' AND CST_Prices.SaleTypeId = 1 AND CST_Prices.MaterialCode = s.MaterialCode AND CST_Prices.CustomerCode = s.CustomerCode AND CST_Prices.MonthYear = s.MonthYear                    
   LEFT JOIN #All_Prices as FOB_Prices ON FOB_Prices.ChargeType= 'FOB' AND FOB_Prices.SaleTypeId = 1 AND FOB_Prices.MaterialCode = s.MaterialCode AND FOB_Prices.CustomerCode = s.CustomerCode AND FOB_Prices.MonthYear = s.MonthYear                    
   WHERE  (s.CustomerCode IN ( SELECT [CustomerCode]  FROM @TVP_CUSTOMERCODE_LIST) OR @CustomerCodeCount = 0)             
           
 UNION                        
                      
     --Direct data                      
    SELECT Monthyear                       
    ,CustomerCode                        
    ,MaterialCode                      
    ,Qty                       
    ,Amount                        
    ,SalesType                        
    ,@SalesSubType as SaleSubType                        
    , FRT_Price AS FRT_AMT                        
    , CST_Price AS CST_AMT                        
    , FOB_Price AS FOB_AMT                        
    , TOTAL_Price AS COG_AMT                    
    FROM #Temp_DirectData                     
                           
 )              
           
SELECT DISTINCT DepartmentName                        
 ,CountryId                        
 ,CountryName                        
 ,SalesOfficeName AS SalesOfficeName                        
 ,SalesType                        
 ,c.CustomerCode + '-' + CustomerName AS Consignee                        
 ,c.CustomerCode                             
 ,TEMP.MaterialCode                        
  ,sum(temp.Qty) AS Qty                        
 ,sum(Amount) AS Amount                        
 ,sum(FRT_AMT) as FRT_AMT                        
 ,sum(CST_AMT) as CST_AMT                        
 ,sum(FOB_AMT) as FOB_AMT                        
 ,sum(COG_AMT) as COG_AMT                        
 --GP AMT= SALES_AMT-COG AMT                        
                        
 ,sum(Amount)-sum(COALESCE(COG_AMT,0)) as GP_AMT                        
 --GP%= GP AMT/SALES AMT                        
 ,case when (sum(Amount))!=0                        
 then ((sum(Amount)-(COALESCE(SUM(COG_AMT),0)))/sum(Amount))*100                        
 else 0 end as GP_PER                        
 ,TEMP.MonthYear                        
 ,TEMP.SaleSubType                        
INTO #TEMP_REPORT_RESULT                  
FROM  CTE_FINAL_RESULT AS TEMP                        
INNER JOIN #TEMP_CUSTOMERS c ON TEMP.CustomerCode = c.CustomerCode       
--WHERE SalesType='ADJ'      
GROUP BY DepartmentName                        
 ,CountryId                        
 ,CountryName                        
 ,SalesOfficeName                        
 ,SalesType                        
 ,c.CustomerCode + '-' + CustomerName                        
 ,c.CustomerCode                            
 ,TEMP.MaterialCode                        
 ,TEMP.MonthYear                        
 ,TEMP.SaleSubType;                    
                     
            
SELECT DepartmentName                      
  ,CountryId                      
  ,CountryName                      
  ,SalesOfficeName                      
  ,SalesType                      
  ,Consignee                      
  ,CustomerCode                  
  ,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName  AS MG                      
  ,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS MG1                      
  ,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS MG2                      
  ,m.ProductCategoryId2                      
  ,m.ProductCategoryId3                      
  ,m.MaterialCode                     
  ,COALESCE(Qty ,0) as Qty                
  ,COALESCE(Amount ,0) as Amount                
  ,COALESCE(FRT_AMT,0) as  FRT_AMT                
  ,COALESCE(CST_AMT ,0) as CST_AMT                
  ,COALESCE(FOB_AMT,0) as  FOB_AMT                
  ,COALESCE(COG_AMT ,0) as COG_AMT                
  ,COALESCE(GP_AMT  ,0) as GP_AMT           
  ,COALESCE(GP_PER,0) as GP_PER                
  ,TEMP.MonthYear                  
  ,SaleSubType                  
  FROM #TEMP_REPORT_RESULT TEMP              
  INNER JOIN Material m ON TEMP.MaterialCode = m.MaterialCode                    
   AND (m.ProductCategoryId2 = @Mg OR @Mg = 0)                      
   AND (m.ProductCategoryId3 = @MG1 OR @MG1 = 0)                           
  LEFT JOIN ProductCategory prod1 ON m.ProductCategoryId1=prod1.ProductCategoryId                          
  LEFT JOIN ProductCategory prod2 ON m.ProductCategoryId2=prod2.ProductCategoryId                          
  LEFT JOIN ProductCategory prod3 ON m.ProductCategoryId3=prod3.ProductCategoryId        
  ;            
              
  drop table #TEMP_CUSTOMERS;          
  drop table #TEMP_ALL_SALES_ENTRY;          
  drop table #All_Prices;          
  drop table #TEMP_REPORT_RESULT;          
  drop table #Temp_DirectData;  
  DROP TABLE #TEMP_QTY_AMOUNT;  
           
END 