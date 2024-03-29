
--sp_Monthly_Ageing_NonConsolidateReport
--sp_Monthly_NonConsolidateReport
--sp_Monthly_BP_NonConsolidateReport
--sp_Monthly_LY_NonConsolidateReport
--sp_Monthly_LM_NonConsolidateReport

IF OBJECT_ID('dbo.SP_NonConsolidateReport') IS NOT NULL  
BEGIN  
DROP PROC [dbo].[SP_NonConsolidateReport];
END 
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_NonConsolidateReport] (        
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

 SET NOCOUNT ON; 

	  DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];
	  DECLARE @TVPNONCONSOLIDATELIST_MONTHLYLMLY AS [dbo].[TVP_NONCONSOLIDATE_LIST];  
	  DECLARE @TVPNONCONSOLIDATELIST_MONTHLYLMLY_FINAL AS [dbo].[TVP_NONCONSOLIDATE_LIST];   
	  DECLARE @CUSTOMERLIST AS dbo.TVP_CUSTOMERCODE_LIST;      
	  DECLARE @MONTHLIST AS dbo.TVP_MONTHYEAR_TYPE;  
	  DECLARE @MONTHLIST_LMLY AS dbo.TVP_MONTHYEAR_TYPE;
	  DECLARE @TVPCUSTOMERLIST AS [dbo].[TVP_CUSTOMER_LIST];
	  DECLARE @CustomerCodeCount AS INT;    
	  SET @CustomerCodeCount =0;

	 INSERT INTO @CUSTOMERLIST 
	 SELECT  [CustomerCode]      
	 FROM @TVP_CUSTOMERCODE_LIST; 
		
	 INSERT INTO @MONTHLIST 
	 SELECT  MONTHYEAR,[TYPE]      
	 FROM @TVP_MonthYear_LIST; 
	
	 SELECT @CustomerCodeCount = COUNT([CustomerCode])    
	 FROM @TVP_CUSTOMERCODE_LIST    
	 WHERE [CustomerCode] > 0; 

	 WITH CTE_CUSTOMERS AS (
	   SELECT    
		 cust.CustomerId      
		,cust.CustomerName   
		,cust.CustomerCode   
		,d.DepartmentName      
		,cust.CountryId      
		,c.CountryName     
		,s.SalesOfficeName   
		,max(CustDid.AccountId)  AS AccountId    
        ,max(AC.AccountCode) AS AccountCode 
	  FROM customer cust        
	  LEFT JOIN Department d ON cust.DepartmentId = d.DepartmentId      
	  LEFT JOIN Country c ON cust.CountryId = c.CountryId      
	  LEFT JOIN SalesOffice s ON cust.SalesOfficeId = s.SalesOfficeId   
	  LEFT JOIN CustomerDID CustDid ON cust.CustomerId = CustDid.CustomerId    
	  LEFT JOIN Account AC ON CustDid.AccountId = AC.AccountId   
	  WHERE (cust.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0)
	  GROUP BY cust.CustomerId,cust.CustomerName,cust.CustomerCode,d.DepartmentName,cust.CountryId,c.CountryName,s.SalesOfficeName
	  )
	  INSERT INTO @TVPCUSTOMERLIST(
	 CustomerId
	 ,CustomerName
	 ,CustomerCode
	 ,DepartmentName
	 ,CountryId
	 ,CountryName
	 ,SalesOfficeName
	 ,AccountCode)
	 SELECT DISTINCT
	 CustomerId
	 ,CustomerName
	 ,CustomerCode
	 ,DepartmentName
	 ,CountryId
	 ,CountryName
	 ,SalesOfficeName
	 ,AccountCode
	 FROM CTE_CUSTOMERS; 

--aging
IF EXISTS( SELECT 1  FROM @MONTHLIST  WHERE [type] = 'MonthlyAgeing'  )  
 BEGIN  
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
   EXEC sp_Monthly_Ageing_NonConsolidateReport @CUSTOMERLIST,@Mg,@MG1,@SalesSubType,'MonthlyAgeing',@MONTHLIST ,@TVPCUSTOMERLIST;
   
 END  
  --MonthlyCM
   IF EXISTS( SELECT 1  FROM @MONTHLIST  WHERE [type] = 'CM'  )         
 BEGIN        
 INSERT INTO @TVPCONSOLIDATELIST      
 (        
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
 EXEC sp_Monthly_NonConsolidateReport @CUSTOMERLIST,@Mg,@MG1,@SalesSubType,'CM',@MONTHLIST,@IsUSD ,@TVPCUSTOMERLIST;     
END  

  --MonthlyBP 
 IF EXISTS (SELECT 1 FROM @MONTHLIST WHERE [type] = 'MonthlyBP' )  
 BEGIN        
 INSERT INTO @TVPCONSOLIDATELIST      
 (        
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
   ,BPO_QTY        
   ,BPP_QTY        
   ,BPS_QTY        
   ,BPI_QTY       
   ,BPTotalO_QTY      
   ,BPMPO_QTY      
   ,BPADJ_QTY      
   ,BPO_AMT        
   ,BPP_AMT        
   ,BPS_AMT        
   ,BPI_AMT        
   ,BPMPO_AMT      
   ,BPADJ_AMT      
   ,BPTotalO_AMT      
   --,StockDays        
   )       
 EXEC sp_Monthly_BP_NonConsolidateReport @CUSTOMERLIST,@Mg,@MG1,@SalesSubType,'MonthlyBP',@MONTHLIST,@IsUSD  ,@TVPCUSTOMERLIST;    
END 



 IF EXISTS (SELECT 1 FROM @MONTHLIST WHERE [type] IN('MonthlyLY' ,'MonthlyLM') )   
 BEGIN

 INSERT INTO @MONTHLIST_LMLY ([MONTHYEAR] , [TYPE])
 SELECT DISTINCT [MONTHYEAR] , '' AS [TYPE]
 FROM @MONTHLIST 
 WHERE [type] IN('MonthlyLY' ,'MonthlyLM');

 INSERT INTO @TVPNONCONSOLIDATELIST_MONTHLYLMLY      
 (        
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
 EXEC SP_GET_MONTHLY_LM_LY_DIRECT_SALE_ARCHIVE_MONTHLY 
 @CUSTOMERLIST,@Mg,@MG1,@SalesSubType,@MONTHLIST_LMLY,@IsUSD ,@TVPCUSTOMERLIST;       
 
 INSERT INTO @TVPNONCONSOLIDATELIST_MONTHLYLMLY      
 (        
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
 EXEC SP_GET_MONTHLY_TRN_PRICE_PLANNING 
 @CUSTOMERLIST,@Mg,@MG1,@SalesSubType,@MONTHLIST_LMLY,@IsUSD ,@TVPCUSTOMERLIST;       
 
 INSERT INTO @TVPNONCONSOLIDATELIST_MONTHLYLMLY_FINAL      
 (        
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
   FROM @TVPNONCONSOLIDATELIST_MONTHLYLMLY      
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

 --MonthlyLY
 IF EXISTS (SELECT 1 FROM @MONTHLIST  WHERE [type] = 'MonthlyLY' )        
 BEGIN        

 INSERT INTO @TVPCONSOLIDATELIST      
 (        
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
   ,LYO_QTY        
   ,LYP_QTY        
   ,LYS_QTY        
   ,LYI_QTY       
   ,LYTotalO_QTY      
   ,LYMPO_QTY      
   ,LYADJ_QTY      
   ,LYO_AMT        
   ,LYP_AMT        
   ,LYS_AMT        
   ,LYI_AMT        
   ,LYMPO_AMT      
   ,LYADJ_AMT      
   ,LYTotalO_AMT      
   --,StockDays        
   )       
 SELECT 
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
 FROM @TVPNONCONSOLIDATELIST_MONTHLYLMLY_FINAL;
END   

-- --MonthlyLM
IF EXISTS (SELECT 1 FROM @MONTHLIST WHERE [type] = 'MonthlyLM' )  
 BEGIN 
 INSERT INTO @TVPCONSOLIDATELIST      
 (        
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
   ,LMO_QTY        
   ,LMP_QTY        
   ,LMS_QTY        
   ,LMI_QTY       
   ,LMTotalO_QTY      
   ,LMMPO_QTY      
   ,LMADJ_QTY      
   ,LMO_AMT        
   ,LMP_AMT        
   ,LMS_AMT        
   ,LMI_AMT        
   ,LMMPO_AMT      
   ,LMADJ_AMT      
   ,LMTotalO_AMT      
   --,StockDays        
   )       
 SELECT 
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
 FROM @TVPNONCONSOLIDATELIST_MONTHLYLMLY_FINAL;

END   

 SELECT *  FROM @TVPCONSOLIDATELIST;        
END
GO