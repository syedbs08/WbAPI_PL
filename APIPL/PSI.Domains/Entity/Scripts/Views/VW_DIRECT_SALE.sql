/****** Object:  View [dbo].[VW_DIRECT_SALE]    Script Date: 9/6/2023 11:19:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
  
ALTER VIEW [dbo].[VW_DIRECT_SALE]  
AS  
WITH TEMP (  
 SalesEntryId  
 ,CustomerId  
 ,ProductCategoryId1  
 ,ProductCategoryId2  
 ,CurrentMonthYear  
 ,LockMonthYear  
 ,MaterialId  
 ,OCmonthYear  
 ,MonthYear  
 ,Price  
 ,Quantity  
 ,ModeOfTypeId  
 ,SaleSubType  
 ,CurrencyCode  
 )  
AS (  SELECT
   SE.SalesEntryId
  ,SE.CustomerId  
  ,SE.ProductCategoryId1  
  ,SE.ProductCategoryId2  
  ,SE.CurrentMonthYear  
  ,SE.LockMonthYear  
  ,SE.MaterialId  
  ,SE.OCmonthYear  
  ,SE.MonthYear  
  ,SE.Price  
  ,SE.Quantity  
  ,SE.ModeOfTypeId  
  ,SE.SaleSubType  
  ,SE.CurrencyCode  
 FROM SalesEntry SE 
 where SE.OCstatus='Y'  
 )  
SELECT 
 T.SalesEntryId  
 ,C.CustomerCode  
 ,T.CurrentMonthYear  
 ,T.LockMonthYear  
 ,M.MaterialCode  
 ,T.OCmonthYear  
 ,T.MonthYear  
 ,T.Price  
 ,T.Quantity  
 ,T.ModeOfTypeId  
 ,T.SaleSubType  
 ,MT.ModeofTypeCode  
 ,MT.ModeofTypeName  
 ,C.CurrencyCode  
FROM TEMP T  
INNER JOIN Customer C ON T.CustomerID = C.CustomerID  
INNER JOIN Material M ON M.MaterialId = T.MaterialId  
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId  
 --select * from Customer    
GO


