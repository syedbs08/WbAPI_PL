IF OBJECT_ID('dbo.sp_Monthly_BP_NonConsolidateReport') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[sp_Monthly_BP_NonConsolidateReport];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROC [dbo].[sp_Monthly_BP_NonConsolidateReport] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY        
 ,@Mg VARCHAR(20)        
 ,@MG1 VARCHAR(20)        
 ,@SalesSubType VARCHAR(30)        
 ,@ColumnType VARCHAR(50)        
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY
 ,@IsUSD bit=0
 ,@TVPCUSTOMERLIST [dbo].[TVP_CUSTOMER_LIST] READONLY
 )        
AS        
BEGIN       

   SET NOCOUNT ON;

   DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];  
    DECLARE @CustomerCodeCount AS INT;      
	 SET @CustomerCodeCount =0;      
      
	 SELECT @CustomerCodeCount = COUNT([CustomerCode])      
	 FROM @TVP_CUSTOMERCODE_LIST      
	 WHERE [CustomerCode] > 0;   
   
   SELECT 
   DepartmentName
   ,CustomerCode
   ,CountryName
   ,SalesOfficeName
   ,CustomerName
   ,AccountCode
   INTO #TEMP_CUSTOMERS
   FROM @TVPCUSTOMERLIST;
   --WHERE CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST);    
   
     SELECT DISTINCT c.DepartmentName AS Department        
	   ,c.CustomerCode        
	   ,c.CountryName AS Country        
	   ,c.SalesOfficeName AS SalesOffice        
	   --,a.SalesType        
	   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
	   ,prod1.ProductCategoryCode AS GROUP_DESC        
	   ,prod2.ProductCategoryCode AS SubGroup        
	   ,prod3.ProductCategoryCode AS [Type]        
	   ,mat.MaterialCode      
	   ,a.MonthYear       
	   ,A.Quantity AS QTY              
	  ,CASE WHEN @IsUSD=0 
				THEN A.Quantity * A.Price 
				ELSE dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)END AS AMT 
	  ,A.ModeofTypeCode
	INTO #TEMP_DIRECT_SALE_MONTHLY
    FROM VW_DIRECT_SALE_MONTHLY A          
	  INNER JOIN @TVP_MonthYear_LIST m ON a.MonthYear = m.MONTHYEAR        
	  INNER JOIN #TEMP_CUSTOMERS c ON a.CustomerCode = c.CustomerCode              
	  --JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode   
	  INNER JOIN Material mat ON A.MaterialCode = mat.MaterialCode  
			AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0)    
			AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0)         
	  JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId        
	  JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId        
	  JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId
	WHERE A.ModeofTypeCode IN('O','P' ,'S','I','ADJ','MPO') 
		AND m.TYPE=@ColumnType;    


   WITH CTE_OrderData              
 AS (      
	SELECT 
		Department        
	   ,CustomerCode        
	   ,Country        
	   ,SalesOffice        
	   --,SalesType        
	   ,Consignee        
	   ,GROUP_DESC        
	   ,SubGroup        
	   ,[Type]        
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS O_QTY              
	   ,AMT AS O_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'O'
  )       
   ,CTE_PurchaseData              
 AS (    
	SELECT       
	   CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS P_QTY              
	   ,AMT AS P_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'P'
  )      
   ,CTE_SalesData              
 AS (      
	SELECT        
	   CustomerCode               
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS S_QTY              
	   ,AMT AS S_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'S'      
 )      
  ,CTE_InVentoryData              
 AS (      
	SELECT        
	   CustomerCode                
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS I_QTY              
	   ,AMT AS I_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'I'       
 )      
  ,CTE_ADJData              
 AS (      
	SELECT        
	   CustomerCode                
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS ADJ_QTY              
	   ,AMT AS ADJ_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'ADJ'      
 )      
  ,CTE_MPOData              
 AS (      
	SELECT       
	   CustomerCode               
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS MPO_QTY              
	   ,AMT AS MPO_AMT   
    FROM #TEMP_DIRECT_SALE_MONTHLY
	WHERE ModeofTypeCode = 'MPO'       
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
   ,O_QTY + MPO_QTY + ADJ_QTY AS TotalO_QTY        
   ,MPO_QTY      
   ,ADJ_QTY      
   ,O_AMT        
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT     
   ,O_AMT + MPO_AMT + ADJ_AMT AS TotalO_AMT      
    FROM CTE_OrderData OD         
	 JOIN CTE_PurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
		  AND OD.MaterialCode = PD.MaterialCode              
		  AND OD.MonthYear = PD.MonthYear              
	 JOIN CTE_SalesData SD ON OD.CustomerCode = SD.CustomerCode              
		  AND OD.MaterialCode = SD.MaterialCode              
		  AND OD.MonthYear = SD.MonthYear              
	 JOIN CTE_InVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
		  AND OD.MaterialCode = ID.MaterialCode              
		  AND OD.MonthYear = ID.MonthYear       
	  JOIN CTE_ADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
		  AND OD.MaterialCode = ADJ.MaterialCode              
		  AND OD.MonthYear = ADJ.MonthYear       
	  JOIN CTE_MPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
		  AND OD.MaterialCode = MPO.MaterialCode              
		  AND OD.MonthYear = MPO.MonthYear;
	
	
        
  --UNION SNS DATA      

    SELECT 
		DISTINCT C.DepartmentName  AS Department        
	   ,TP.AccountCode AS CustomerCode        
	   ,C.CountryName  AS Country        
	   ,C.SalesOfficeName AS SalesOffice        
	   --,a.SalesType        
	   ,c.CustomerCode + '-' + CustomerName  as Consignee        
	   ,prod1.ProductCategoryCode AS GROUP_DESC        
	   ,prod2.ProductCategoryCode AS SubGroup        
	   ,prod3.ProductCategoryCode AS [Type]        
	   ,mat.MaterialCode      
	   ,TP.MonthYear       
	   ,TP.Quantity AS QTY              
	   ,TP.Quantity * TP.Price AS AMT              
	   ,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS AMT_USD 
	   ,TP.ModeOfType
	INTO #TEMP_TRN_PRICE_PLANING
    FROM  trnpRicePlanning TP
	  INNER JOIN #TEMP_CUSTOMERS C ON TP.AccountCode =C.AccountCode  
	  INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
	  --JOIN MaterialView MV ON TP.MaterialCode = MV.MaterialCode  
	  INNER JOIN Material mat ON TP.MaterialCode = mat.MaterialCode  
			AND (mat.ProductCategoryId2 = @Mg  OR @Mg = 0)    
			AND (mat.ProductCategoryId3 = @MG1  OR @MG1 = 0)         
	  JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId        
	  JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId        
	  JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId
	WHERE TP.ModeOfType IN( 'ORDER' ,'PURCHASE' ,'SALES','INVENTORY','ADJ','MPO')                   
	  AND m.[TYPE]=@ColumnType 

      
     ;WITH CTE_SNSOrderData              
 AS (      
	SELECT 
		Department        
		,CustomerCode        
		,Country        
		,SalesOffice        
		--,SalesType        
		,Consignee        
		,GROUP_DESC        
		,SubGroup        
		,[Type]        
		,MaterialCode      
		,MonthYear       
		,QTY AS O_QTY              
		,AMT AS O_AMT              
		,AMT_USD AS O_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'ORDER'            
              
  )       
   ,CTE_SNSPurchaseData              
 AS (     
	SELECT         
		CustomerCode                
		,MaterialCode      
		,MonthYear       
		,QTY AS P_QTY              
		,AMT AS P_AMT              
		,AMT_USD AS P_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'PURCHASE'       
  )      
   ,CTE_SNSSalesData              
 AS (   
 	SELECT        
		CustomerCode               
		,MaterialCode      
		,MonthYear       
		,QTY AS S_QTY              
		,AMT AS S_AMT              
		,AMT_USD AS S_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'SALES'       
 )      
  ,CTE_SNSInVentoryData              
 AS (      

  	SELECT       
		CustomerCode               
		,MaterialCode      
		,MonthYear       
		,QTY AS I_QTY              
		,AMT AS I_AMT              
		,AMT_USD AS I_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'INVENTORY'     
 )      
  ,CTE_SNSADJData              
 AS (      

   	SELECT 
		CustomerCode               
		,MaterialCode      
		,MonthYear       
		,QTY AS ADJ_QTY              
		,AMT AS ADJ_AMT              
		,AMT_USD AS ADJ_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'ADJ'
 )      
  ,CTE_SNSMPOData              
 AS (  
 
    SELECT     
		CustomerCode               
		,MaterialCode      
		,MonthYear       
		,QTY AS MPO_QTY              
		,AMT AS MPO_AMT              
		,AMT_USD AS MPO_AMT_USD         
    FROM  #TEMP_TRN_PRICE_PLANING            
	WHERE    ModeOfType = 'MPO'     
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
   SELECT DISTINCT  OD.Department        
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
	   ,O_QTY as O_QTY        
	   ,P_QTY        
	   ,S_QTY        
	   ,I_QTY       
	   ,O_QTY + MPO_QTY + ADJ_QTY AS TotalO_QTY      
	   ,MPO_QTY      
	   ,ADJ_QTY      
	   ,O_AMT
	   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
	   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
	   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
	   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
	   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT        
	   ,MPO_AMT + ADJ_AMT + O_AMT AS TotalO_AMT      
    FROM CTE_SNSOrderData OD                   
	 JOIN CTE_SNSPurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
		  AND OD.MaterialCode = PD.MaterialCode              
		  AND OD.MonthYear = PD.MonthYear              
	 JOIN CTE_SNSSalesData SD ON OD.CustomerCode = SD.CustomerCode              
		  AND OD.MaterialCode = SD.MaterialCode              
		  AND OD.MonthYear = SD.MonthYear              
	 JOIN CTE_SNSInVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
		  AND OD.MaterialCode = ID.MaterialCode              
		  AND OD.MonthYear = ID.MonthYear       
	 JOIN CTE_SNSADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
		  AND OD.MaterialCode = ADJ.MaterialCode              
		  AND OD.MonthYear = ADJ.MonthYear       
	 JOIN CTE_SNSMPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
		  AND OD.MaterialCode = MPO.MaterialCode              
		  AND OD.MonthYear = MPO.MonthYear;       
   	
	

  SELECT       
	   Department        
	   ,CustomerCode        
	   ,Country        
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
   GROUP BY Department,CustomerCode,Country,SalesOffice,Consignee,GROUP_DESC,SubGroup,[Type] ,MaterialCode ,MonthYear       
 END
 GO
