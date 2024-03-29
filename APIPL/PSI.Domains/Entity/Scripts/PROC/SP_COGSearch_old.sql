/****** Object:  StoredProcedure [dbo].[SP_COGSearch]    Script Date: 9/24/2023 9:57:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[SP_COGSearch] @CountryId VARCHAR(max) = NULL  
 ,@CustomerId VARCHAR(max) = NULL  
 ,@ProductCategoryId1 VARCHAR(max) = NULL  
 ,@ProductCategoryId2 VARCHAR(max) = NULL  
 ,@SalesTypeId INT NULL  
 ,@SalesSubType VARCHAR(20) NULL 
 ,@FromMonth INT
 ,@ToMonth INT
AS  
BEGIN  
 SELECT c.CustomerId  
  ,c.CountryId  
  ,c.CustomerCode  
  ,c.CustomerName  
  ,e.MaterialCode  
  ,p.MonthYear  
  ,cast(p.Price AS VARCHAR(100)) Price  
  ,cast(p.Qty AS VARCHAR(10)) Qty  
  ,ChargeType  
  ,e.SaleSubType  
  ,s.SaleTypeName  
 FROM COGEntry e  
 INNER JOIN SaleType S ON e.SaleTypeId = s.SaleTypeId  
 INNER JOIN COGEntryQtyPrice p ON e.COGEntryId = p.COGEntryId  
 LEFT JOIN Customer c ON e.CustomerCode = c.CustomerCode  
 LEFT JOIN Material m ON e.MaterialCode = m.MaterialCode  
 WHERE
 P.MonthYear>=@FromMonth and p.MonthYear<=@ToMonth
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
  AND (  
   @SalesTypeId IS NULL  
   OR e.SaleTypeId = @SalesTypeId  
   )  
  AND (  
   @SalesSubType IS NULL  
   OR SaleSubType = @SalesSubType  
   )  
END