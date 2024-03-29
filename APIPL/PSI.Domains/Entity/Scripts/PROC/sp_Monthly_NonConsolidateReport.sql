IF OBJECT_ID('dbo.sp_Monthly_NonConsolidateReport') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[sp_Monthly_NonConsolidateReport];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE PROC [dbo].[sp_Monthly_NonConsolidateReport] (        
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY        
 ,@Mg VARCHAR(20)        
 ,@MG1 VARCHAR(20)        
 ,@SalesSubType VARCHAR(30)        
 ,@ColumnType VARCHAR(50)        
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY
 ,@IsUSD bit
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

	  PRINT N' [sp_Monthly_NonConsolidateReport1]-1'+ convert (varchar,SYSDATETIMEOFFSET());

	 SELECT    
		 CustomerId      
		,CustomerName   
		,CustomerCode   
		,DepartmentName      
		,CountryId      
		,CountryName     
		,SalesOfficeName
		,AccountCode
	 INTO #TEMP_CUSTOMERS
	 FROM @TVPCUSTOMERLIST;

	 PRINT N' [sp_Monthly_NonConsolidateReport1]-2'+ convert (varchar,SYSDATETIMEOFFSET());

	 SELECT
	      mat.MaterialId
		 ,mat.MaterialCode
		 ,mat.ProductCategoryId1
		 ,mat.ProductCategoryId2
		 ,mat.ProductCategoryId3
		,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName AS ProductCategoryName1           
		,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName AS ProductCategoryName2          
		,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName AS ProductCategoryName3 
		,prod1.ProductCategoryCode AS ProductCategoryCode1
		,prod2.ProductCategoryCode AS ProductCategoryCode2
		,prod3.ProductCategoryCode AS ProductCategoryCode3
	 INTO #TEMP_MATERIALS
	 FROM Material mat 
		LEFT JOIN ProductCategory prod1 ON mat.ProductCategoryId1=prod1.ProductCategoryId        
		LEFT JOIN ProductCategory prod2 ON mat.ProductCategoryId2=prod2.ProductCategoryId        
		LEFT JOIN ProductCategory prod3 ON mat.ProductCategoryId3=prod3.ProductCategoryId
	WHERE  (mat.ProductCategoryId2 = @Mg OR @Mg = 0)    
			AND (mat.ProductCategoryId3 = @MG1 OR @MG1 = 0);

	   
		 SELECT DISTINCT c.DepartmentName   AS Department  
		  ,C.CustomerCode
		  ,c.CountryName   AS Country             
		  ,c.SalesOfficeName AS SalesOffice  
		  ,C.CustomerCode +'-'+ C.CustomerName as Consignee 
		  ,mat.ProductCategoryName1  AS GROUP_DESC           
		  ,mat.ProductCategoryName2  AS SubGroup          
		  ,mat.ProductCategoryName3  AS [Type]
		  ,mat.MaterialCode
		  ,SE.MonthYear
		  ,SE.Quantity
		  ,CASE WHEN @IsUSD=0 
				 THEN SE.Quantity * SE.Price  
				 ELSE dbo.UDF_USDAmount(SE.Quantity, SE.Price, SE.CurrencyCode) END AS AMT
		  ,MT.ModeofTypeCode        
		 INTO #TEMP_ALL_DATA
		 FROM  SalesEntry SE  
			INNER JOIN @TVP_MonthYear_LIST m ON SE.MonthYear = m.MONTHYEAR
			INNER JOIN #TEMP_CUSTOMERS C ON SE.CustomerId = C.CustomerID 
			INNER JOIN ModeofType MT ON MT.ModeofTypeId = SE.ModeOfTypeId
			INNER JOIN #TEMP_MATERIALS mat ON SE.MaterialId  = mat.MaterialId  
		 WHERE SE.ModeOfTypeId IN (1,2,3,4,10,12)        
			AND SE.SaleSubType = 'MONTHLY'      
			AND SE.OCstatus='Y' 
			AND( @CustomerCodeCount = 0 OR C.CustomerCode IN  ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ))
			AND m.TYPE=@ColumnType
			AND MT.ModeofTypeCode IN ('O','P','S','I','ADJ','MPO','MPO');
		    
		PRINT N' [sp_Monthly_NonConsolidateReport1]-4'+ convert (varchar,SYSDATETIMEOFFSET());

		  --temp table for Order data
		SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity 
		   ,AMT 
		INTO #TEMP_Orders
		FROM #TEMP_ALL_DATA
		WHERE ModeofTypeCode = 'O'; 

		  --temp table to calcualte O_SumQTY_SSD_ADJ
		SELECT 
		S.MaterialCode
		,S.CustomerCode
		,S.MonthYear
		,S.Qty
		,S.Qty * S.Price AS Amount
		,RANK() OVER ( PARTITION BY S.MaterialCode,S.CustomerCode,S.MonthYear  ORDER BY S.Qty ) SSDEntry_rank
		INTO #TEMP_SSDEntry
		FROM SSDEntry AS S 
		INNER JOIN  #TEMP_MATERIALS mat ON s.MaterialCode = mat.MaterialCode 
		INNER JOIN @TVP_MonthYear_LIST M ON s.MonthYear = M.MONTHYEAR 
		WHERE  (S.CustomerCode IN ( SELECT [CustomerCode]  FROM @TVP_CUSTOMERCODE_LIST) OR @CustomerCodeCount = 0);

		PRINT N' [sp_Monthly_NonConsolidateReport1]-4.1'+ convert (varchar,SYSDATETIMEOFFSET());

		  --temp table to calculate O_SumAmount_SSD_ADJ
		SELECT 
		S.MaterialCode
		,S.CustomerCode
		,S.MonthYear
		,P.Qty
		,CAST(P.Qty as int)*CAST(P.Price AS DECIMAL(18, 2))  AS Amount
		,RANK() OVER ( PARTITION BY S.MaterialCode,S.CustomerCode,S.MonthYear  ORDER BY P.Qty) AS AdjustmentEntry_rank
		INTO #TEMP_AdjustmentEntry
		FROM AdjustmentEntry AS S 
		INNER JOIN AdjustmentEntryQtyPrice AS  P  ON S.MonthYear = P.MonthYear AND S.AdjustmentEntryId=P.AdjustmentEntryId
		INNER JOIN  #TEMP_MATERIALS mat ON S.MaterialCode = mat.MaterialCode 
		INNER JOIN @TVP_MonthYear_LIST M ON S.MonthYear = M.MONTHYEAR 
		WHERE  (S.CustomerCode IN ( SELECT [CustomerCode]  FROM @TVP_CUSTOMERCODE_LIST) OR @CustomerCodeCount = 0);
		

		 PRINT N' [sp_Monthly_NonConsolidateReport1]-4.2'+ convert (varchar,SYSDATETIMEOFFSET());

			
		--temp table to calculate O_Next_Month_Sale_Qty_DirectSale  and O_Next_Month_Sale_Amount_DirectSale
		WITH CTE_NEXT_MONTH_SALE AS (
		SELECT 
			vw.Quantity 
			,vw.Price
			,O.MonthYear
			,vw.CustomerCode 
			,vw.MaterialCode
		FROM  #TEMP_Orders AS O  
		INNER JOIN  VW_DIRECT_SALE as vw ON vw.CustomerCode = O.CustomerCode 
		AND vw.MaterialCode = O.MaterialCode 
		AND vw.SaleSubType='Monthly' and vw.ModeOfTypeId=3
		AND vw.MonthYear > O.MonthYear  
		AND vw.MonthYear <= (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3,  CAST(CAST(O.MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) )
		)SELECT 
			SUM(O.Quantity)/3 AS Quantity
			,SUM(O.Quantity * O.Price)/3 AS Amount
			,O.MonthYear
			,O.CustomerCode
			,O.MaterialCode
		INTO #TEMP_NEXT_MONTH_SALE
		FROM CTE_NEXT_MONTH_SALE AS O
		GROUP BY O.MonthYear ,O.CustomerCode ,O.MaterialCode;


			PRINT N' [sp_Monthly_NonConsolidateReport1]-4.2.1'+ convert (varchar,SYSDATETIMEOFFSET());
				
		SELECT  
			O.Department        
		   ,O.CustomerCode        
		   ,O.Country        
		   ,O.SalesOffice           
		   ,O.Consignee        
		   ,O.GROUP_DESC        
		   ,O.SubGroup        
		   ,O.[Type]        
		   ,O.MaterialCode      
		   ,O.MonthYear       
		   ,O.Quantity AS O_QTY  
		   ,COALESCE(A.Qty ,0)+COALESCE(S.Qty ,0)  as  O_SumQTY_SSD_ADJ
		   ,COALESCE(A.Amount ,0)+COALESCE(S.Amount ,0) as O_SumAmount_SSD_ADJ 
		   --,[dbo].[UDF_GetSumQTY_SSD_ADJ](O.MaterialCode,O.CustomerCode,O.MonthYear)as  O_SumQTY_SSD_ADJ 
		   --,[dbo].[UDF_GetSumAmount_SSD_ADJ](O.MaterialCode,O.CustomerCode,O.MonthYear) as O_SumAmount_SSD_ADJ
		   ,NMS.Quantity AS O_Next_Month_Sale_Qty_DirectSale
		   ,NMS.Amount AS O_Next_Month_Sale_Amount_DirectSale
		   --,[dbo].[UDF_Next_Month_Sale_Qty_DirectSale](O.MonthYear,O.CustomerCode,O.MaterialCode,'Monthly') AS O_Next_Month_Sale_Qty_DirectSale
		   --,[dbo].[UDF_Next_Month_Sale_Amount_DirectSale](O.MonthYear,O.CustomerCode,O.MaterialCode,'Monthly') AS O_Next_Month_Sale_Amount_DirectSale
		   ,AMT AS O_AMT 
		  INTO #TEMP_OrderData
		  FROM #TEMP_Orders AS O
		  LEFT JOIN #TEMP_AdjustmentEntry AS A ON O.MonthYear = A.MonthYear AND O.CustomerCode = A.CustomerCode AND O.MaterialCode = A.MaterialCode AND A.AdjustmentEntry_rank = 1   
		  LEFT JOIN #TEMP_SSDEntry AS S ON O.MonthYear = S.MonthYear AND O.CustomerCode = S.CustomerCode AND O.MaterialCode = S.MaterialCode AND S.SSDEntry_rank = 1
          LEFT JOIN #TEMP_NEXT_MONTH_SALE AS NMS ON O.MonthYear = NMS.MonthYear AND O.CustomerCode = NMS.CustomerCode AND O.MaterialCode = NMS.MaterialCode ;
		--select * from #TEMP_OrderData;

		PRINT N' [sp_Monthly_NonConsolidateReport1]-4.3'+ convert (varchar,SYSDATETIMEOFFSET());

		 SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity AS P_QTY  
		   ,AMT AS P_AMT 
		  INTO #TEMP_PurchaseData
		  FROM #TEMP_ALL_DATA
		  WHERE ModeofTypeCode = 'P';         
     
		SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity AS S_QTY  
		   ,AMT AS S_AMT 
		  INTO #TEMP_SalesData
		  FROM #TEMP_ALL_DATA
		  WHERE ModeofTypeCode = 'S';         
     
		SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity AS I_QTY  
		   ,AMT AS I_AMT 
		  INTO #TEMP_InVentoryData
		  FROM #TEMP_ALL_DATA
		  WHERE ModeofTypeCode = 'I';
		     
		  SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity AS ADJ_QTY  
		   ,AMT AS ADJ_AMT
		  INTO #TEMP_ADJData
		  FROM #TEMP_ALL_DATA
		  WHERE ModeofTypeCode = 'ADJ';   
	
		  SELECT  
			Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice           
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,Quantity AS MPO_QTY  
		   ,AMT AS MPO_AMT 
		  INTO #TEMP_MPOData
		  FROM #TEMP_ALL_DATA
		  WHERE ModeofTypeCode = 'MPO';  
      
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
   ,StockDays_QTY 
   ,StockDays_Amt
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
   ,O_QTY + O_SumQTY_SSD_ADJ as  O_QTY   
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,O_QTY+MPO_QTY+ADJ_QTY+O_SumQTY_SSD_ADJ AS TotalO_QTY        
   ,MPO_QTY      
   ,ADJ_QTY      
   ,OD.O_AMT + OD.O_SumAmount_SSD_ADJ as O_AMT        
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT     
   ,OD.O_AMT + MPO_AMT + ADJ_AMT + OD.O_SumAmount_SSD_ADJ AS TotalO_AMT      
   ,CASE WHEN O_Next_Month_Sale_Qty_DirectSale=0 then 0 else
   CAST(ROUND((CAST(I_QTY AS DECIMAL(18, 2))/cast( OD.O_Next_Month_Sale_Qty_DirectSale AS DECIMAL(18, 2))) *30,0)as int)  end  StockDays_QTY 
   ,CASE WHEN O_Next_Month_Sale_Amount_DirectSale =0 then 0 else
   --(I_AMT/O_Next_Month_Sale_Amount_DirectSale)*30  end  StockDays_Amt 
	 CAST(ROUND((CAST(I_AMT AS DECIMAL(18, 2))/cast( OD.O_Next_Month_Sale_Amount_DirectSale AS DECIMAL(18, 2))) *30,0)as int)  end  StockDays_Amt 
	FROM #TEMP_OrderData OD         
	--INNER JOIN @TVP_MonthYear_LIST m ON OD.MonthYear = m.MONTHYEAR        
	JOIN #TEMP_PurchaseData PD ON OD.CustomerCode = PD.CustomerCode              
	  AND OD.MaterialCode = PD.MaterialCode              
	  AND OD.MonthYear = PD.MonthYear              
	JOIN #TEMP_SalesData SD ON OD.CustomerCode = SD.CustomerCode              
	  AND OD.MaterialCode = SD.MaterialCode              
	  AND OD.MonthYear = SD.MonthYear              
	JOIN #TEMP_InVentoryData ID ON OD.CustomerCode = ID.CustomerCode              
	  AND OD.MaterialCode = ID.MaterialCode              
	  AND OD.MonthYear = ID.MonthYear       
	JOIN #TEMP_ADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode              
	  AND OD.MaterialCode = ADJ.MaterialCode              
	  AND OD.MonthYear = ADJ.MonthYear       
	JOIN #TEMP_MPOData MPO ON OD.CustomerCode = MPO.CustomerCode              
	  AND OD.MaterialCode = MPO.MaterialCode              
	  AND OD.MonthYear = MPO.MonthYear;
	  
	  DROP TABLE #TEMP_OrderData;
	  DROP TABLE #TEMP_PurchaseData;
	  DROP TABLE #TEMP_SalesData;
	  DROP TABLE #TEMP_InVentoryData;
	  DROP TABLE #TEMP_ADJData;
	  DROP TABLE #TEMP_MPOData;
        
  --UNION SNS DATA 
  PRINT N' [sp_Monthly_NonConsolidateReport1]-5'+ convert (varchar,SYSDATETIMEOFFSET());

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
	   ,TP.Quantity AS QTY              
	   ,TP.Quantity * TP.Price AS AMT              
	   --,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS AMT_USD 
	   ,TP.ModeOfType
    INTO #TEMP_ALL_TRNPRICEPLANNING
	FROM  trnpRicePlanning TP           
	INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
	INNER JOIN #TEMP_MATERIALS MV ON TP.MaterialCode = MV.MaterialCode              
	WHERE TP.ModeOfType IN( 'ORDER','PURCHASE','INVENTORY','ADJ','MPO')         
	  AND m.TYPE=@ColumnType;
	  

	  SELECT Department        
	   ,CustomerCode        
	   ,Country        
	   ,SalesOffice        
	   --,a.SalesType        
	   ,Consignee        
	   ,GROUP_DESC        
	   ,SubGroup        
	   ,[Type]        
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY               
	   ,AMT              
	   --,AMT_USD AS O_AMT_USD     
	   INTO #TEMP_SNS_ORDERS
	   FROM  #TEMP_ALL_TRNPRICEPLANNING                       
	   WHERE ModeOfType = 'ORDER'; 
      
	  PRINT N' [sp_Monthly_NonConsolidateReport1]-6'+ convert (varchar,SYSDATETIMEOFFSET());

	   --temp tbl for O_SumQTY_SSD_ADJ
		SELECT 
		S.MaterialCode
		,S.CustomerCode
		,S.MonthYear
		,S.Qty
		,S.Qty * S.Price AS Amount
		,RANK() OVER ( PARTITION BY S.MaterialCode,S.CustomerCode,S.MonthYear  ORDER BY S.Qty ) SSDEntry_rank
		INTO #TEMP_SSDEntry2
		FROM #TEMP_SNS_ORDERS AS O
		LEFT JOIN SSDEntry AS S ON O.MonthYear = S.MonthYear AND O.CustomerCode = S.CustomerCode AND O.MaterialCode = S.MaterialCode;
		  

		  PRINT N' [sp_Monthly_NonConsolidateReport1]-6.1'+ convert (varchar,SYSDATETIMEOFFSET());

		 --temp tbl for O_SumAmount_SSD_ADJ
		SELECT 
		S.MaterialCode
		,S.CustomerCode
		,S.MonthYear
		,P.Qty
		,CAST(P.Qty as int)*CAST(P.Price AS DECIMAL(18, 2))  AS Amount
		,RANK() OVER ( PARTITION BY S.MaterialCode,S.CustomerCode,S.MonthYear  ORDER BY P.Qty) AS AdjustmentEntry_rank
		INTO #TEMP_AdjustmentEntry2
		FROM #TEMP_SNS_ORDERS AS O 
		LEFT JOIN AdjustmentEntry AS S ON   O.CustomerCode = S.CustomerCode AND O.MaterialCode = S.MaterialCode
		INNER JOIN AdjustmentEntryQtyPrice AS  P  ON O.MonthYear = P.MonthYear AND S.AdjustmentEntryId=P.AdjustmentEntryId;

		 PRINT N' [sp_Monthly_NonConsolidateReport1]-6.2'+ convert (varchar,SYSDATETIMEOFFSET());

		 --temp table to calculate O_Next_Month_Sale_QTY_SNS  and O_Next_Month_Sale_Amount_SNS
		WITH CTE_NEXT_MONTH_SALE_SNS AS (
		SELECT 
			vw.Quantity 
			,vw.Price
			,O.MonthYear
			,vw.CustomerCode 
			,vw.MaterialCode
		FROM  #TEMP_Orders AS O  
		INNER JOIN  TRNSalesPlanning as vw ON vw.CustomerCode = O.CustomerCode 
		AND vw.MaterialCode = O.MaterialCode 
		AND vw.SaleSubType='Monthly' 
		AND vw.MonthYear > O.MonthYear  
		AND vw.MonthYear <= (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3,  CAST(CAST(O.MonthYear AS VARCHAR(10)) + '01' AS DATE) ) AS DATE), 112) AS INT) )
		)SELECT 
			SUM(O.Quantity)/3 AS Quantity
			,SUM(O.Quantity * O.Price)/3 AS Amount
			,O.MonthYear
			,O.CustomerCode
			,O.MaterialCode
		INTO #TEMP_NEXT_MONTH_SALE_SNS
		FROM CTE_NEXT_MONTH_SALE_SNS AS O
		GROUP BY O.MonthYear ,O.CustomerCode ,O.MaterialCode;

		 PRINT N' [sp_Monthly_NonConsolidateReport1]-6.2.1'+ convert (varchar,SYSDATETIMEOFFSET());

     ;WITH SNSOrderData              
 AS (      
	SELECT O.Department        
   ,O.CustomerCode        
   ,O.Country        
   ,O.SalesOffice        
   --,a.SalesType        
   ,O.Consignee        
   ,O.GROUP_DESC        
   ,O.SubGroup        
   ,O.[Type]        
   ,O.MaterialCode      
   ,O.MonthYear       
   ,O.QTY AS O_QTY              
   ,O.AMT AS O_AMT 
    ,COALESCE(A.Qty ,0)+COALESCE(S.Qty ,0)  as  O_SumQTY_SSD_ADJ
    ,COALESCE(A.Amount ,0)+COALESCE(S.Amount ,0) as O_SumAmount_SSD_ADJ 
	,SNS.Quantity AS O_Next_Month_Sale_QTY_SNS
	,SNS.Amount AS O_Next_Month_Sale_Amount_SNS
	--,[dbo].[UDF_Next_Month_Sale_QTY_SNS](O.MonthYear,O.CustomerCode,O.MaterialCode,'Monthly') AS O_Next_Month_Sale_QTY_SNS
	--,[dbo].[UDF_Next_Month_Sale_Amount_SNS](O.MonthYear,O.CustomerCode,O.MaterialCode,'Monthly') AS O_Next_Month_Sale_Amount_SNS

   --,AMT_USD AS O_AMT_USD         
    FROM  #TEMP_SNS_ORDERS  AS O
	 LEFT JOIN #TEMP_AdjustmentEntry2 AS A ON O.MonthYear = A.MonthYear AND O.CustomerCode = A.CustomerCode AND O.MaterialCode = A.MaterialCode AND A.AdjustmentEntry_rank = 1   
	 LEFT JOIN #TEMP_SSDEntry2 AS S ON O.MonthYear = S.MonthYear AND O.CustomerCode = S.CustomerCode AND O.MaterialCode = S.MaterialCode AND S.SSDEntry_rank = 1 
	 LEFT JOIN #TEMP_NEXT_MONTH_SALE_SNS AS SNS ON O.MonthYear = SNS.MonthYear AND O.CustomerCode = SNS.CustomerCode AND O.MaterialCode = SNS.MaterialCode
  )       
   ,SNSPurchaseData              
 AS (      
	SELECT Department        
	   ,CustomerCode        
	   ,Country        
	   ,SalesOffice        
	   --,a.SalesType        
	   ,Consignee        
	   ,GROUP_DESC        
	   ,SubGroup        
	   ,[Type]        
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS P_QTY              
	   ,AMT AS P_AMT              
   --,AMT_USD AS P_AMT_USD         
    FROM  #TEMP_ALL_TRNPRICEPLANNING                       
    WHERE ModeOfType = 'PURCHASE'      
  )      
   ,SNSSalesData              
 AS ( 
    SELECT DISTINCT NULL AS Department        
	   ,CustomerCode         
	   ,NULL AS Country        
	   ,NULL AS SalesOffice        
	   --,a.SalesType        
	   ,NULL as Consignee        
	   ,MV.ProductCategoryCode1 AS GROUP_DESC        
	   ,MV.ProductCategoryCode2 AS SubGroup        
	   ,MV.ProductCategoryCode3 AS [Type]        
	   ,MV.MaterialCode      
	   ,TP.MonthYear       
	   ,TP.Quantity AS S_QTY              
	   ,TP.Quantity * TP.Price AS S_AMT              
	   --,dbo.UDF_USDAmount(TP.Quantity, TP.Price, 'USD') AS S_AMT_USD         
    FROM  TRNSalesPlanning TP           
	INNER JOIN @TVP_MonthYear_LIST m ON TP.MonthYear = m.MONTHYEAR        
	INNER JOIN #TEMP_MATERIALS MV ON TP.MaterialCode = MV.MaterialCode              
	WHERE ( @CustomerCodeCount = 0 OR CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ))       
		AND m.TYPE=@ColumnType      
 )      
  ,SNSInVentoryData              
 AS (      

	SELECT Department        
	   ,CustomerCode        
	   ,Country        
	   ,SalesOffice        
	   --,a.SalesType        
	   ,Consignee        
	   ,GROUP_DESC        
	   ,SubGroup        
	   ,[Type]        
	   ,MaterialCode      
	   ,MonthYear       
	   ,QTY AS I_QTY              
	   ,AMT AS I_AMT              
   --,AMT_USD AS I_AMT_USD         
    FROM  #TEMP_ALL_TRNPRICEPLANNING                       
    WHERE ModeOfType = 'INVENTORY'      
 )      
  ,SNSADJData              
 AS (      
		SELECT Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice        
		   --,a.SalesType        
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,QTY AS ADJ_QTY              
		   ,AMT AS ADJ_AMT              
	   --,AMT_USD AS ADJ_AMT_USD         
		FROM  #TEMP_ALL_TRNPRICEPLANNING                       
		WHERE ModeOfType = 'ADJ'     
	)      
  ,SNSMPOData              
	AS (      

		SELECT Department        
		   ,CustomerCode        
		   ,Country        
		   ,SalesOffice        
		   --,a.SalesType        
		   ,Consignee        
		   ,GROUP_DESC        
		   ,SubGroup        
		   ,[Type]        
		   ,MaterialCode      
		   ,MonthYear       
		   ,QTY AS MPO_QTY              
		   ,AMT AS MPO_AMT              
	   --,AMT_USD AS MPO_AMT_USD         
		FROM  #TEMP_ALL_TRNPRICEPLANNING                       
		WHERE ModeOfType = 'MPO'    
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
   ,StockDays_QTY
   ,StockDays_Amt       
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
   ,OD.O_QTY+ OD.O_SumQTY_SSD_ADJ as O_QTY        
   ,P_QTY        
   ,S_QTY        
   ,I_QTY       
   ,OD.O_QTY + MPO_QTY + OD.O_SumQTY_SSD_ADJ AS TotalO_QTY      
   ,MPO_QTY      
   ,ADJ_QTY      
   ,OD.O_AMT + OD.O_SumAmount_SSD_ADJ as O_AMT     
   ,CAST(P_AMT AS DECIMAL(18, 2)) AS P_AMT        
   ,CAST(S_AMT AS DECIMAL(18, 2)) AS S_AMT          
   ,CAST(I_AMT AS DECIMAL(18, 2)) AS I_AMT          
   ,CAST(MPO_AMT AS DECIMAL(18, 2)) AS MPO_AMT         
   ,CAST(ADJ_AMT AS DECIMAL(18, 2)) AS ADJ_AMT        
   ,MPO_AMT + ADJ_AMT + OD.O_AMT + OD.O_SumAmount_SSD_ADJ AS TotalO_AMT  
   ,CASE WHEN OD.O_Next_Month_Sale_QTY_SNS = 0 then 0 else
   --(I_QTY/ OD.O_Next_Month_Sale_QTY_SNS )*30  end  StockDays_QTY 
    CAST(ROUND((CAST(I_QTY AS DECIMAL(18, 2))/cast( OD.O_Next_Month_Sale_QTY_SNS AS DECIMAL(18, 2))) *30,0)as int)  end  StockDays_QTY 
   ,CASE WHEN OD.O_Next_Month_Sale_Amount_SNS = 0 then 0 else
   --(I_AMT/ OD.O_Next_Month_Sale_Amount_SNS )*30  end  StockDays_Amt 
   CAST(ROUND((CAST(I_AMT AS DECIMAL(18, 2)) / cast(OD.O_Next_Month_Sale_Amount_SNS AS DECIMAL(18, 2))) *30,0)as int)  end  StockDays_Amt
	FROM SNSOrderData AS OD         
	JOIN #TEMP_CUSTOMERS C ON OD.CustomerCode =C.AccountCode      
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
	WHERE  ( @CustomerCodeCount = 0 OR c.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ))      
       
       PRINT N' [sp_Monthly_NonConsolidateReport1]-7'+ convert (varchar,SYSDATETIMEOFFSET());

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
   ,CAST(SUM(StockDays_QTY) AS DECIMAL(18, 2))  AS StockDays_QTY 
   ,CAST(SUM(StockDays_Amt) AS DECIMAL(18, 2))  AS StockDays_Amt 
   --, case when SUM(StockDays_Amt)=0 then 0 else (sum(I_AMT)/SUM(StockDays_Amt))*30 end as StockDays_Amt
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
   

    PRINT N' [sp_Monthly_NonConsolidateReport1]-8'+ convert (varchar,SYSDATETIMEOFFSET());
 END
 GO