 IF OBJECT_ID('dbo.SP_AdjustmentSearch') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_AdjustmentSearch];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_AdjustmentSearch]     
  @CountryId VARCHAR(max) = NULL    
 ,@CustomerId VARCHAR(max) = NULL    
 ,@ProductCategoryId1 VARCHAR(max) = NULL    
 ,@ProductCategoryId2 VARCHAR(max) = NULL   
 ,@FromMonth INT  
 ,@ToMonth INT  
AS    
BEGIN    

SET NOCOUNT ON;

 SELECT m.ProductCategoryId1    
  ,m.ProductCategoryId2    
  ,c.CustomerId    
  ,c.CountryId    
  ,c.CustomerCode    
  ,c.CustomerName     
  ,e.MaterialCode    
  ,p.MonthYear    
  ,ISNULL(p.Price,0) as Price    
  ,ISNULL(p.Qty,0)  as Qty
  ,ISNULL(p.Amount,0) as Amount
  ,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS Mg1                      
  ,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS Mg2
 FROM AdjustmentEntry e    
 INNER JOIN AdjustmentEntryQtyPrice p ON e.AdjustmentEntryId = p.AdjustmentEntryId    
 LEFT JOIN Customer c ON e.CustomerCode = c.CustomerCode    
 LEFT JOIN Material m ON e.MaterialCode = m.MaterialCode 
 LEFT JOIN ProductCategory prod2 ON m.ProductCategoryId2=prod2.ProductCategoryId                  
 LEFT JOIN ProductCategory prod3 ON m.ProductCategoryId3=prod3.ProductCategoryId
 WHERE P.MonthYear>=@FromMonth and p.MonthYear<=@ToMonth  
 and (    
   @CountryId IS NULL    
   OR CountryId IN (    
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
   OR ProductCategoryId2 IN (    
    SELECT value    
    FROM STRING_SPLIT(@ProductCategoryId1, ',')    
    )    
   )    
  AND (    
   @ProductCategoryId2 IS NULL    
   OR ProductCategoryId3 IN (    
    SELECT value    
    FROM STRING_SPLIT(@ProductCategoryId2, ',')    
    )    
   )    
END