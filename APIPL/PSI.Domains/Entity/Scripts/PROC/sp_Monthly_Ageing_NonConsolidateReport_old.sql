
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
 )        
AS        
BEGIN       
--  DECLARE @TVP_MonthYear_LIST TABLE (      
--    MONTHYEAR VARCHAR(50),      
-- [TYPE] VARCHAR(20)      
--);      
--  INSERT INTO  @TVP_MonthYear_LIST (MONTHYEAR,[TYPE])VALUES('202305','CM');        
   DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];      
   WITH Age30Data              
 AS (      
  SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 0) AS Age30
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 0)*trn.Price AS Age30Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType     
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
              
  )       
   ,Age60Data              
 AS (     SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 1) AS Age60
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 1)*trn.Price AS Age60Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    ) 
  )      
   ,Age90Data              
 AS (      
       SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age90
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2)*trn.Price AS Age90Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    ) 
 )      
  ,Age120Data              
 AS (      
     SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 3) AS Age120
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 3)*trn.Price AS Age120Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )      
 )      
  ,AGE150Data              
 AS (      
   SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 4) AS Age150
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 4)*trn.Price AS Age150Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )     
 )      
  ,Age180Data              
 AS (      
     SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 5) AS Age180
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 5)*trn.Price AS Age180Amt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    ) 
 )    
  ,Age180greatherthanData              
 AS (      
     SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode2    
 ,m.ProductCategoryCode3    
 ,m.MaterialCode    
 ,trn.MonthYear    
 ,'Monthly' AS SaleSubType    
 ,'SNS' AS SalesType 
 ,ModeofType    
 ,'USD' AS Currency
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 6) AS Age180greatherthan
 ,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 6)*trn.Price AS Age180greatherthanAmt
  FROM   TRNPricePlanning trn  
   INNER JOIN @TVP_MonthYear_LIST mon ON trn.MonthYear = mon.MONTHYEAR  
INNER JOIN VW_Customers c ON trn.AccountCode = c.AccountCode    
INNER JOIN MaterialView m ON trn.MaterialCode = m.MaterialCode 
  WHERE   trn.ModeofType IN (    
  'MPO'    
  ,'PURCHASE'    
  ,'INVENTORY'    
  )       
  and m.ProductCategoryCode2=@Mg      
  and m.ProductCategoryCode3=@Mg1       
  and mon.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    ) 
 ) 
 INSERT INTO @TVPCONSOLIDATELIST (        
   Department        
   ,CustomerCode        
   ,Country        
   ,SalesOffice        
   ,SalesType        
   ,Consignee        
   ,Group_Desc        
   ,SubGroup        
   ,[Type]        
   ,MaterialCode        
   ,MonthYear        
  ,Age30  
   ,Age60  
   ,Age90  
   ,Age120  
   ,Age150  
   ,Age180  
   ,Age180Greatherthan  
   ,Age30Amt  
   ,Age60Amt  
   ,Age90Amt  
   ,Age120Amt  
   ,Age150Amt  
   ,Age180Amt  
   ,Age180greatherthanAmt       
   )        
   SELECT DISTINCT  Age30Data.DepartmentName  as Department       
   ,Age30Data.CustomerCode as CustomerCode       
   ,Age30Data.CountryName   as Country     
   ,Age30Data.SalesOfficeName as SalesOffice       
   ,Age30Data.SalesType as SalesType       
   ,Age30Data.Consignee as Consignee       
   ,Age30Data.MG1 as Group_Desc       
   ,Age30Data.MG2 as SubGroup       
   ,[Type]        
   ,Age30Data.MaterialCode  as MaterialCode    
   ,Age30Data.MonthYear as MonthYear        
  ,Age30  
   ,Age60  
   ,Age90  
   ,Age120  
   ,Age150  
   ,Age180  
   ,Age180Greatherthan  
   ,Age30Amt  
   ,Age60Amt  
   ,Age90Amt  
   ,Age120Amt  
   ,Age150Amt  
   ,Age180Amt  
   ,Age180greatherthanAmt      
    FROM Age30Data          
  INNER JOIN @TVP_MonthYear_LIST m ON Age30Data.MonthYear = m.MONTHYEAR        
 JOIN Age60Data  ON Age30Data.CustomerCode = Age60Data.CustomerCode              
  AND Age30Data.MaterialCode = Age60Data.MaterialCode              
  AND Age30Data.MonthYear = Age60Data.MonthYear              
 JOIN Age90Data  ON Age30Data.CustomerCode = Age90Data.CustomerCode              
  AND Age30Data.MaterialCode = Age90Data.MaterialCode              
  AND Age30Data.MonthYear = Age90Data.MonthYear              
 JOIN Age120Data  ON Age30Data.CustomerCode = Age120Data.CustomerCode              
  AND Age30Data.MaterialCode = Age120Data.MaterialCode              
  AND Age30Data.MonthYear = Age120Data.MonthYear       
  JOIN Age150Data  ON Age30Data.CustomerCode = Age150Data.CustomerCode              
  AND Age30Data.MaterialCode = Age150Data.MaterialCode              
  AND Age30Data.MonthYear = Age150Data.MonthYear  
  JOIN Age180Data  ON Age30Data.CustomerCode = Age180Data.CustomerCode              
  AND Age30Data.MaterialCode = Age180Data.MaterialCode              
  AND Age30Data.MonthYear = Age180Data.MonthYear 
  JOIN Age180greatherthanData  ON Age30Data.CustomerCode = Age180greatherthanData.CustomerCode              
  AND Age30Data.MaterialCode = Age180greatherthanData.MaterialCode              
  AND Age30Data.MonthYear = Age180greatherthanData.MonthYear 
 
   
  SELECT Department        
   ,CustomerCode        
   ,Country        
   ,SalesOffice        
   ,SalesType        
   ,Consignee        
   ,Group_Desc        
   ,SubGroup        
   ,[Type]        
   ,MaterialCode        
   ,MonthYear        
  ,Age30  
   ,Age60  
   ,Age90  
   ,Age120  
   ,Age150  
   ,Age180  
   ,Age180Greatherthan  
   ,Age30Amt  
   ,Age60Amt  
   ,Age90Amt  
   ,Age120Amt  
   ,Age150Amt  
   ,Age180Amt  
   ,Age180greatherthanAmt      
   FROM @TVPCONSOLIDATELIST      
         
 END
