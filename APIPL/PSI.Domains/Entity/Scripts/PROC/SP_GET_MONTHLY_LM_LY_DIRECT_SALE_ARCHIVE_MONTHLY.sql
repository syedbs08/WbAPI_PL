

IF OBJECT_ID('dbo.SP_GET_MONTHLY_LM_LY_DIRECT_SALE_ARCHIVE_MONTHLY') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_GET_MONTHLY_LM_LY_DIRECT_SALE_ARCHIVE_MONTHLY];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 CREATE PROC [dbo].[SP_GET_MONTHLY_LM_LY_DIRECT_SALE_ARCHIVE_MONTHLY] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY        
 ,@Mg VARCHAR(20)        
 ,@MG1 VARCHAR(20)        
 ,@SalesSubType VARCHAR(30)      
 ,@MonthYearList [dbo].[TVP_MONTHYEAR_TYPE] READONLY 
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

       
    SELECT 
   DepartmentName
   ,CustomerCode
   ,CountryName
   ,SalesOfficeName
   ,CustomerName
   ,AccountCode
   INTO #TEMP_CUSTOMERS
   FROM @TVPCUSTOMERLIST;

   SELECT DISTINCT DepartmentName AS Department        
	   ,c.CustomerCode        
	   ,CountryName AS Country        
	   ,SalesOfficeName AS SalesOffice        
	   --,a.SalesType        
	   ,a.CustomerCode +'-'+ c.CustomerName as Consignee        
	   ,prod1.ProductCategoryCode AS GROUP_DESC        
	   ,prod2.ProductCategoryCode  AS SubGroup        
	   ,prod3.ProductCategoryCode AS [Type]           
	   ,mat.MaterialCode      
	   ,a.MonthYear       
	   ,A.Quantity AS QTY              
	   ,case when @IsUSD=0 then A.Quantity * A.Price else 
	   dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode)end  AS AMT 
	   ,A.ModeOfTypeId
	INTO #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY
    FROM SalesEntryArchival A  
	INNER JOIN @MonthYearList m ON a.MonthYear = m.MONTHYEAR        
	LEFT JOIN #TEMP_CUSTOMERS c ON a.CustomerCode = c.CustomerCode              
	LEFT JOIN Material mat ON A.MaterialCode = mat.MaterialCode
	LEFT JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId        
	LEFT JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId        
	LEFT JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId
	WHERE A.ArchiveStatus = 'Archived'        
	AND A.ModeOfTypeId IN (1,2,3,4,10,12)
	AND (A.ProductCategoryId1 = @Mg OR @Mg = 0)    
	AND (A.ProductCategoryId2 = @MG1 OR @MG1 = 0)
	AND (C.CustomerCode IN ( SELECT [CustomerCode]  FROM @TVP_CUSTOMERCODE_LIST  )  OR @CustomerCodeCount = 0);  

 WITH OrderData              
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
	   ,AMT  AS O_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 1 
  )       
   ,PurchaseData              
 AS (     
	SELECT DISTINCT         
	    CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS P_QTY              
	   ,AMT  AS P_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 2 
  )      
   ,SalesData              
 AS (      
     SELECT DISTINCT         
	    CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS S_QTY              
	   ,AMT  AS S_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 3  
 )      
  ,InVentoryData              
 AS (      
    	SELECT DISTINCT         
	    CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS I_QTY              
	   ,AMT  AS I_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 4     
 )      
  ,ADJData              
 AS (      
    SELECT DISTINCT         
	    CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS ADJ_QTY              
	   ,AMT  AS ADJ_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 10  
 )      
  ,MPOData              
 AS (      
     SELECT DISTINCT         
	    CustomerCode              
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS MPO_QTY              
	   ,AMT  AS MPO_AMT
    FROM #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY 
	WHERE ModeOfTypeId = 12   
 )      
        
   SELECT DISTINCT TEMP.Department        
   ,TEMP.CustomerCode        
   ,TEMP.Country        
   ,TEMP.SalesOffice        
   ,'Monthly'   AS SaleSubType      
   ,TEMP.Consignee        
   ,TEMP.GROUP_DESC        
   ,TEMP.SubGroup     
   ,TEMP.[Type]        
   ,TEMP.MaterialCode      
   ,TEMP.MonthYear       
   ,ISNULL(O_QTY,0) AS O_QTY
   ,ISNULL(P_QTY,0) AS P_QTY       
   ,ISNULL(S_QTY,0) AS S_QTY       
   ,ISNULL(I_QTY,0) AS I_QTY      
   ,ISNULL(O_QTY,0) + ISNULL(MPO_QTY ,0) + ISNULL(ADJ_QTY ,0)  AS TotalO_QTY        
   ,ISNULL(MPO_QTY,0) AS MPO_QTY      
   ,ISNULL(ADJ_QTY,0) AS ADJ_QTY      
   ,ISNULL(O_AMT,0) AS O_AMT       
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT     
   ,O_AMT + MPO_AMT + ADJ_AMT AS TotalO_AMT      
    FROM  OrderData AS  TEMP                  
	 LEFT JOIN PurchaseData PD ON TEMP.CustomerCode = PD.CustomerCode              
		  AND TEMP.MaterialCode = PD.MaterialCode              
		  AND TEMP.MonthYear = PD.MonthYear              
	 LEFT JOIN SalesData SD ON TEMP.CustomerCode = SD.CustomerCode              
		  AND TEMP.MaterialCode = SD.MaterialCode              
		  AND TEMP.MonthYear = SD.MonthYear              
	 LEFT JOIN InVentoryData ID ON TEMP.CustomerCode = ID.CustomerCode              
		  AND TEMP.MaterialCode = ID.MaterialCode              
		  AND TEMP.MonthYear = ID.MonthYear       
	 LEFT JOIN ADJData ADJ ON TEMP.CustomerCode = ADJ.CustomerCode              
		  AND TEMP.MaterialCode = ADJ.MaterialCode              
		  AND TEMP.MonthYear = ADJ.MonthYear       
	 LEFT JOIN MPOData MPO ON TEMP.CustomerCode = MPO.CustomerCode              
		  AND TEMP.MaterialCode = MPO.MaterialCode              
		  AND TEMP.MonthYear = MPO.MonthYear  ;    
        
	--DROP TABLE #TEMP_DIRECT_SALE_ARCHIVE_MONTHLY;
 END
