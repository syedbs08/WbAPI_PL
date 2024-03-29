
IF OBJECT_ID('dbo.SP_GET_MONTHLY_TRN_PRICE_PLANNING') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_GET_MONTHLY_TRN_PRICE_PLANNING];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROC [dbo].[SP_GET_MONTHLY_TRN_PRICE_PLANNING] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY        
 ,@Mg VARCHAR(20)        
 ,@MG1 VARCHAR(20)        
 ,@SalesSubType VARCHAR(30)              
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY  
 ,@IsUSD bit
 ,@TVPCUSTOMERLIST [dbo].[TVP_CUSTOMER_LIST] READONLY
 )        
AS        
BEGIN       
      
   SET NOCOUNT ON;

    DECLARE @CustomerCodeCount AS INT;      
   SET @CustomerCodeCount =0;      
      
   SELECT @CustomerCodeCount = COUNT([CustomerCode])      
   FROM @TVP_CUSTOMERCODE_LIST      
   WHERE [CustomerCode] > 0;   


   DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];    
   
   SELECT 
   DepartmentName
   ,CustomerCode
   ,CountryName
   ,SalesOfficeName
   ,CustomerName
   ,AccountCode
   INTO #TEMP_CUSTOMERS
   FROM @TVPCUSTOMERLIST;
   

  SELECT DISTINCT C.DepartmentName AS Department       
	   ,TP.AccountCode AS CustomerCode        
	   ,C.CountryName AS Country        
	   ,C.SalesOfficeName AS SalesOffice        
	   --,a.SalesType        
	   ,TP.AccountCode +'-'+ C.CustomerName as Consignee        
	   ,prod1.ProductCategoryCode AS GROUP_DESC        
	   ,prod2.ProductCategoryCode AS SubGroup        
	   ,prod3.ProductCategoryCode AS [Type]        
	   ,TP.MaterialCode      
	   ,TP.MonthYear       
	   ,TP.Quantity AS QTY              
	   ,TP.Quantity * TP.Price AS AMT
	   ,TP.ModeOfType
	INTO #TEMP_TRNPRICEPLANNING
    FROM  trnpRicePlanning TP           
	INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR         
	LEFT JOIN #TEMP_CUSTOMERS c ON TP.AccountCode = c.AccountCode              
	LEFT JOIN Material mat ON TP.MaterialCode = mat.MaterialCode          
	LEFT JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId        
	LEFT JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId        
	LEFT JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId
	WHERE TP.ModeOfType IN( 'ORDER' ,'PURCHASE' ,'SALES','INVENTORY','ADJ','MPO')
			AND (mat.ProductCategoryId2 = @Mg OR @Mg = 0 )    
			AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0) 
			AND (C.CustomerCode IN ( SELECT [CustomerCode]  FROM @TVP_CUSTOMERCODE_LIST  )  OR @CustomerCodeCount = 0);  

      
     ;WITH SNSOrderData              
 AS (      
	  SELECT DISTINCT Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice            
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,QTY AS O_QTY              
		   ,AMT AS O_AMT              
		FROM  #TEMP_TRNPRICEPLANNING                     
		WHERE    ModeOfType = 'ORDER'              
              
  )       
   ,SNSPurchaseData              
 AS (     
 	  SELECT DISTINCT 
			CustomerCode                 
		   ,MaterialCode      
		   ,MonthYear       
		   ,QTY AS P_QTY              
		   ,AMT AS P_AMT              
		FROM  #TEMP_TRNPRICEPLANNING                     
		WHERE    ModeOfType = 'PURCHASE'     
  )      
   ,SNSSalesData              
 AS (      
 	  SELECT DISTINCT 
			CustomerCode                 
		   ,MaterialCode      
		   ,MonthYear       
		   ,QTY AS S_QTY              
		   ,AMT AS S_AMT              
		FROM  #TEMP_TRNPRICEPLANNING                     
		WHERE    ModeOfType = 'SALES'       
 )      
  ,SNSInVentoryData              
 AS (      
	SELECT DISTINCT 
		CustomerCode                 
		,MaterialCode      
		,MonthYear       
		,QTY AS I_QTY              
		,AMT AS I_AMT              
	FROM  #TEMP_TRNPRICEPLANNING                     
	WHERE    ModeOfType = 'INVENTORY'        
 )      
  ,SNSADJData              
 AS (      
	SELECT DISTINCT 
		CustomerCode                 
		,MaterialCode      
		,MonthYear       
		,QTY AS ADJ_QTY              
		,AMT AS ADJ_AMT              
	FROM  #TEMP_TRNPRICEPLANNING                     
	WHERE    ModeOfType = 'ADJ' 
 )      
  ,SNSMPOData              
 AS (   
 
 	SELECT DISTINCT 
		CustomerCode                 
		,MaterialCode      
		,MonthYear       
		,QTY AS MPO_QTY              
		,AMT AS MPO_AMT              
	FROM  #TEMP_TRNPRICEPLANNING                     
	WHERE    ModeOfType = 'MPO'
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
    FROM SNSOrderData OD             
	 LEFT JOIN SNSPurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
		  AND OD.MaterialCode = PD.MaterialCode              
		  AND OD.MonthYear = PD.MonthYear              
	 LEFT JOIN SNSSalesData SD ON OD.CustomerCode = SD.CustomerCode              
		  AND OD.MaterialCode = SD.MaterialCode              
		  AND OD.MonthYear = SD.MonthYear              
	 LEFT JOIN SNSInVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
		  AND OD.MaterialCode = ID.MaterialCode              
		  AND OD.MonthYear = ID.MonthYear       
	 LEFT JOIN SNSADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
		  AND OD.MaterialCode = ADJ.MaterialCode              
		  AND OD.MonthYear = ADJ.MonthYear       
	 LEFT JOIN SNSMPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
		  AND OD.MaterialCode = MPO.MaterialCode              
		  AND OD.MonthYear = MPO.MonthYear           
       
 END
