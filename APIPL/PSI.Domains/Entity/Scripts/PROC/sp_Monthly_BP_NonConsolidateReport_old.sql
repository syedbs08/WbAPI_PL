/****** Object:  StoredProcedure [dbo].[sp_Monthly_BP_NonConsolidateReport]    Script Date: 9/7/2023 9:04:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 ALTER PROC [dbo].[sp_Monthly_BP_NonConsolidateReport] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY        
 ,@Mg VARCHAR(20)        
 ,@MG1 VARCHAR(20)        
 ,@SalesSubType VARCHAR(30)        
 ,@ColumnType VARCHAR(50)        
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY
 ,@IsUSD bit=0
 )        
AS        
BEGIN       
--  DECLARE @TVP_MonthYear_LIST TABLE (      
--    MONTHYEAR VARCHAR(50),      
-- [TYPE] VARCHAR(20)      
--);      
--  INSERT INTO  @TVP_MonthYear_LIST (MONTHYEAR,[TYPE])VALUES('202305','CM');        
   DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];      
   WITH OrderData              
 AS (      
  SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
   ,A.Quantity AS O_QTY              
  ,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS O_AMT   
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'O'       
  and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
  and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
              
  )       
   ,PurchaseData              
 AS (     SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
   ,A.Quantity AS P_QTY  
   ,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS P_AMT 
   
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'P'        
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
   and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
  )      
   ,SalesData              
 AS (      
      SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
   ,A.Quantity AS S_QTY              
,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS S_AMT     
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'S'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
   and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
 )      
  ,InVentoryData              
 AS (      
    SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
    ,A.Quantity AS I_QTY              
,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS I_AMT         
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'I'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
   and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
 )      
  ,ADJData              
 AS (      
    SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
    ,A.Quantity AS ADJ_QTY 
	,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS ADJ_AMT 
   
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'ADJ'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
   and c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )       
 )      
  ,MPOData              
 AS (      
    SELECT DISTINCT DepartmentName AS Department        
   ,c.CustomerCode        
   ,CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   --,a.SalesType        
   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,a.MonthYear       
    ,A.Quantity AS MPO_QTY              
   ,case when @IsUSD=0 then A.Quantity * A.Price else 
   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end AS MPO_AMT 
    FROM VW_DIRECT_SALE_MONTHLY A          
  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
  INNER JOIN VW_Customers c ON a.CustomerCode = c.CustomerCode              
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode              
  WHERE    A.ModeofTypeCode = 'MPO'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
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
   ,O_QTY        
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,TotalO_QTY      
   ,MPO_QTY      
   ,ADJ_QTY      
   ,O_AMT        
   ,P_AMT        
   ,S_AMT        
   ,I_AMT        
   ,MPO_AMT      
   ,ADJ_AMT      
   ,TotalO_AMT      
   --,StockDays        
   )        
   SELECT DISTINCT OD.Department        
   ,OD.CustomerCode        
   ,OD.Country        
   ,OD.SalesOffice        
   ,'Monthly'  AS SaleSubType      
   ,OD.Consignee        
   ,OD.GROUP_DESC        
   ,OD.SubGroup     
   ,OD.[Type]        
   ,OD.MaterialCode      
   ,OD.MonthYear       
,O_QTY   
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,O_QTY+MPO_QTY+ADJ_QTY AS TotalO_QTY        
   ,MPO_QTY      
   ,ADJ_QTY      
   ,O_AMT        
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT     
   ,O_AMT+MPO_AMT+ADJ_AMT AS TotalO_AMT      
    FROM OrderData OD         
  INNER JOIN @TVP_MonthYear_LIST m ON OD.MonthYear = m.MONTHYEAR        
 JOIN PurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
  AND OD.MaterialCode = PD.MaterialCode              
  AND OD.MonthYear = PD.MonthYear              
 JOIN SalesData SD ON OD.CustomerCode = SD.CustomerCode              
  AND OD.MaterialCode = SD.MaterialCode              
  AND OD.MonthYear = SD.MonthYear              
 JOIN InVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
  AND OD.MaterialCode = ID.MaterialCode              
  AND OD.MonthYear = ID.MonthYear       
  JOIN ADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
  AND OD.MaterialCode = ADJ.MaterialCode              
  AND OD.MonthYear = ADJ.MonthYear       
      
  JOIN MPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
  AND OD.MaterialCode = MPO.MaterialCode              
  AND OD.MonthYear = MPO.MonthYear       
        
  --UNION SNS DATA      
      
     ;WITH SNSOrderData              
 AS (      
  SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS O_QTY              
   ,TP.Quantity * TP.Price AS O_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS O_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'ORDER'        
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
              
  )       
   ,SNSPurchaseData              
 AS (      SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS P_QTY              
   ,TP.Quantity * TP.Price AS P_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS P_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'PURCHASE'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
  )      
   ,SNSSalesData              
 AS (      
         SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS S_QTY              
   ,TP.Quantity * TP.Price AS S_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS S_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'SALES'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
 )      
  ,SNSInVentoryData              
 AS (      
       SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS I_QTY              
   ,TP.Quantity * TP.Price AS I_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS I_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'INVENTORY'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
 )      
  ,SNSADJData              
 AS (      
       SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS ADJ_QTY              
   ,TP.Quantity * TP.Price AS ADJ_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS ADJ_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'ADJ'       
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
 )      
  ,SNSMPOData              
 AS (      
       SELECT DISTINCT NULL AS Department        
   ,TP.AccountCode AS CustomerCode        
   ,NULL AS Country        
   ,NULL AS SalesOffice        
   --,a.SalesType        
   ,NULL as Consignee        
   ,MV.ProductCategoryCode1 AS GROUP_DESC        
   ,ProductCategoryCode2 AS SubGroup        
   ,ProductCategoryCode3 AS [Type]        
   ,MV.MaterialCode      
   ,TP.MonthYear       
   ,TP.Quantity AS MPO_QTY              
   ,TP.Quantity * TP.Price AS MPO_AMT              
   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS MPO_AMT_USD         
    FROM  trnpRicePlanning TP           
  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
  INNER JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode              
  WHERE    TP.ModeOfType = 'MPO'        
   and mv.ProductCategoryCode2=@Mg      
  and mv.ProductCategoryCode3=@Mg1       
  and m.TYPE=@ColumnType      
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
   ,O_QTY        
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,TotalO_QTY      
   ,MPO_QTY      
   ,ADJ_QTY      
   ,O_AMT        
   ,P_AMT        
   ,S_AMT        
   ,I_AMT        
   ,MPO_AMT      
   ,ADJ_AMT      
   ,TotalO_AMT      
   --,StockDays        
   )      
   SELECT DISTINCT C.DepartmentName AS Department        
   ,C.CustomerCode        
   ,C.CountryName AS Country        
   ,SalesOfficeName AS SalesOffice        
   ,'Monthly'  AS SaleSubType       
   ,c.CustomerCode + '-' + CustomerName AS  Consignee      
   ,OD.GROUP_DESC        
   ,OD.SubGroup        
   ,OD.[Type]        
   ,OD.MaterialCode      
   ,OD.MonthYear       
   ,O_QTY as O_QTY        
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,O_QTY+MPO_QTY+ADJ_QTY AS TotalO_QTY      
   ,MPO_QTY      
   ,ADJ_QTY      
   ,O_AMT
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT        
   ,MPO_AMT+ADJ_AMT+O_AMT AS TotalO_AMT      
    FROM SNSOrderData OD         
  INNER JOIN @TVP_MonthYear_LIST m ON OD.MonthYear = m.MONTHYEAR       
  INNER JOIN VW_Customers C ON OD.CustomerCode =C.AccountCode      
 JOIN SNSPurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
  AND OD.MaterialCode = PD.MaterialCode              
  AND OD.MonthYear = PD.MonthYear              
 JOIN SNSSalesData SD ON OD.CustomerCode = SD.CustomerCode              
  AND OD.MaterialCode = SD.MaterialCode              
  AND OD.MonthYear = SD.MonthYear              
 JOIN SNSInVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
  AND OD.MaterialCode = ID.MaterialCode              
  AND OD.MonthYear = ID.MonthYear       
  JOIN SNSADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
  AND OD.MaterialCode = ADJ.MaterialCode              
  AND OD.MonthYear = ADJ.MonthYear       
      
  JOIN SNSMPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
  AND OD.MaterialCode = MPO.MaterialCode              
  AND OD.MonthYear = MPO.MonthYear       
  where  c.CustomerCode IN (        
    SELECT [CustomerCode]        
    FROM @TVP_CUSTOMERCODE_LIST        
    )      
       
      
  SELECT       
   Department        
   ,CustomerCode        
   , Country        
   ,SalesOffice        
   ,'Monthly'  AS SaleSubType       
   ,Consignee      
   ,GROUP_DESC        
   ,SubGroup        
   ,[Type]        
   ,MaterialCode      
   ,MonthYear       
 ,SUM(O_QTY ) AS O_QTY      
   ,SUM(P_QTY)  AS P_QTY      
   ,SUM(S_QTY)  AS S_QTY      
   ,SUM(I_QTY) AS I_QTY      
   ,SUM(TotalO_QTY) AS TotalO_QTY      
   ,SUM(MPO_QTY) AS MPO_QTY      
   ,SUM(ADJ_QTY) AS ADJ_QTY      
   ,CAST(SUM(O_AMT) AS DECIMAL(18, 2)) AS  O_AMT      
   ,CAST(SUM(P_AMT) AS DECIMAL(18, 2)) AS P_AMT       
   ,CAST(SUM(S_AMT) AS DECIMAL(18, 2)) AS S_AMT        
   ,CAST(SUM(I_AMT) AS DECIMAL(18, 2)) AS I_AMT      
   ,CAST(SUM(MPO_AMT) AS DECIMAL(18, 2)) AS MPO_AMT      
   ,CAST(SUM(ADJ_AMT) AS DECIMAL(18, 2)) AS ADJ_AMT      
   ,CAST(SUM(TotalO_AMT) AS DECIMAL(18, 2))  AS TotalO_AMT      
   FROM @TVPCONSOLIDATELIST      
   GROUP BY       
   Department        
   ,CustomerCode        
   , Country        
   ,SalesOffice        
   ,Consignee      
   ,GROUP_DESC        
   ,SubGroup        
   ,[Type]        
   ,MaterialCode      
   ,MonthYear       
 END
