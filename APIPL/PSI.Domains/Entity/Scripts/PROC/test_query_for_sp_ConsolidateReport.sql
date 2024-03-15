DECLARE @tvpMonthYearList dbo.TVP_MONTHYEAR_TYPE,
 @tvpCustomerCodeList dbo.TVP_CUSTOMERCODE_LIST,
 @MG nvarchar(100),
 @MG1 nvarchar(100),
 @SalesSubType nvarchar(100),
 @ColumnType nvarchar(100);

INSERT INTO  @tvpMonthYearList VALUES ('202304','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202305','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202306','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202307','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202308','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202309','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202310','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202312','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202401','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202402','CM');
INSERT INTO  @tvpMonthYearList VALUES ('202403','CM');

INSERT INTO  @tvpMonthYearList VALUES ('202304','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202305','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202306','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202307','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202308','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202309','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202310','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202312','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202401','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202402','MonthlyLM');
INSERT INTO  @tvpMonthYearList VALUES ('202403','MonthlyLM');


INSERT INTO @tvpCustomerCodeList VALUES('20011790');

SET @MG = '45'; 
SET @MG1 ='0';
SET @SalesSubType='Monthly';
SET @ColumnType='LM';

 --exec dbo.sp_ConsolidateReport  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType,@ColumnType,@tvpMonthYearList;

 --exec [dbo].[SP_CM_BP_ConsolidatedReport1] @tvpCustomerCodeList,@MG,@MG1,@SalesSubType

 --exec [dbo].[SP_CM_LY_ConsolidatedReport]  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType

  DECLARE @TVPCUSTOMERLIST [dbo].[TVP_CUSTOMER_LIST] ;
   DECLARE @MonthList AS [dbo].[TVP_MONTHYEAR_TYPE];

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
	  WHERE cust.CustomerCode IN ( SELECT [CustomerCode] FROM @tvpCustomerCodeList )
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


	INSERT INTO @MonthList( MonthYear,[Type])
	SELECT MonthYear,[Type]
	FROM @tvpMonthYearList
	WHERE [type] = 'MonthlyLM';

exec [dbo].[SP_LM_ConsolidatedReport] @tvpCustomerCodeList,@MG,@MG1,@SalesSubType ,@TVPCUSTOMERLIST,@MonthList;

--monthly query
select sUm(qty) qty,sum(amt) amt,monthyear ,MaterialCode,ModeofTypeCode,CustomerCode from(
select sUm(qty) qty,sum(amount) amt,monthyear, 'AD' ModeofTypeCode,MaterialCode,CustomerCode from (
SELECT m.ProductCategoryId1   ,m.ProductCategoryId2    
  ,c.CustomerId      ,c.CountryId      ,c.CustomerCode    ,c.CustomerName     
  ,e.MaterialCode    ,p.MonthYear      ,p.Price     ,p.Qty 
  ,p.Amount FROM AdjustmentEntry e    
INNER JOIN AdjustmentEntryQtyPrice p ON e.AdjustmentEntryId = p.AdjustmentEntryId    
LEFT JOIN Customer c ON e.CustomerCode = c.CustomerCode    
LEFT JOIN Material m ON e.MaterialCode = m.MaterialCode    
WHERE P.MonthYear>='202304' and p.MonthYear<='202403'
   -- and e.MaterialCode='NI-100DXWTA'
and e.CustomerCode in('20011538')
)X
group by MonthYear,MaterialCode,CustomerCode
union
  select sum(qty) qty, sum(amount) Amt,MonthYear,'SNS' ModeofTypeCode,MaterialCode,CustomerCode from(
   SELECT sales.Monthyear            
    ,sales.CustomerCode            
    ,sales.MaterialCode            
    ,sales.Quantity as Qty            
    ,sales.Quantity * sales.Price  as Amount            
    ,'SNS' AS SalesType  
   FROM TRNSalesPlanning  as sales     
   JOIN Material mat ON sales.MaterialCode = mat.MaterialCode   
   WHERE MonthYear BETWEEN '202304' AND '202403' 
   --and sales.MaterialCode='AW-UE150KEJ8'
   AND  CustomerCode in('20011538')
	)X
	group by MonthYear ,MaterialCode,CustomerCode
	union
	 SELECT             
    sum(s.Qty) qty,
    sum(s.Qty * s.Price) as Amount,s.Monthyear ,'SSD' ModeofTypeCode,s.MaterialCode,CustomerCode
   FROM SSDentry s     
   JOIN Material mat ON s.MaterialCode = mat.MaterialCode 
   WHERE  MonthYear between '202304' and '202403'  
  -- and S.MaterialCode='AW-UE150KEJ8'
  and (s.CustomerCode in('20011538'))
   group by s.Monthyear ,s.MaterialCode,CustomerCode
   union
   select sum(Quantity) QTY,sum(Amount) AMT,MonthYear,ModeofTypeCode,MaterialCode,CustomerCode from(
select S.MaterialCode,Quantity,price,s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId,m.ModeofTypeCode
from SalesEntry s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
left join ModeofType m on m.ModeofTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  
and  CustomerCode in('20011538')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  AND S.SaleSubType= 'Monthly' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode)Xxx
    group by monthyear,MaterialCode,ModeofTypeCode,CustomerCode

	--BP,BPBP,MonthlyBP

	select sUm(qty) qty,sum(amt) amt,monthyear ,MaterialCode,ModeofTypeCode,CustomerCode from(

  select sum(qty) qty, sum(amount) Amt,MonthYear,'SNS' ModeofTypeCode,MaterialCode,CustomerCode from(
   SELECT sales.Monthyear            
    ,sales.CustomerCode            
    ,sales.MaterialCode            
    ,sales.Quantity as Qty            
    ,sales.Quantity * sales.Price  as Amount            
    ,'SNS' AS SalesType  
   FROM TRNSalesPlanning_BP  as sales     
   JOIN Material mat ON sales.MaterialCode = mat.MaterialCode   
   WHERE MonthYear BETWEEN '202304' AND '202403' and BP_YEAR='2023'
   --and sales.MaterialCode='AW-UE150KEJ8'
   AND  CustomerCode in('20011538')
	)X
	group by MonthYear ,MaterialCode,CustomerCode

   union
   select sum(Quantity) QTY,sum(USD_AMT) AMT,MonthYear,ModeofTypeCode,MaterialCode,CustomerCode from(
select S.MaterialCode,Quantity,price,s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId,m.ModeofTypeCode
from SalesEntry_bp s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
left join ModeofType m on m.ModeofTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  and BPYear='2023' 
and  CustomerCode in('20011538')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  --AND S.SaleSubType= 'bp' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode)Xxx
    group by monthyear,MaterialCode,ModeofTypeCode,CustomerCode

	--BPLM

		select sUm(qty) qty,sum(amt) amt,monthyear ,MaterialCode,ModeofTypeCode,CustomerCode from(

  select sum(qty) qty, sum(amount) Amt,MonthYear,'SNS' ModeofTypeCode,MaterialCode,CustomerCode from(
   SELECT sales.Monthyear            
    ,sales.CustomerCode            
    ,sales.MaterialCode            
    ,sales.Quantity as Qty            
    ,sales.Quantity * sales.Price  as Amount            
    ,'SNS' AS SalesType  
   FROM TRNSalesPlanningArchival_BP  as sales     
   JOIN Material mat ON sales.MaterialCode = mat.MaterialCode   
   WHERE MonthYear BETWEEN '202304' AND '202403' and BP_YEAR='2023'
   --and sales.MaterialCode='AW-UE150KEJ8'
   AND  CustomerCode in('20011846','20603208','20603407')
	)X
	group by MonthYear ,MaterialCode,CustomerCode

   union
   select sum(Quantity) QTY,sum(USD_AMT) AMT,MonthYear,ModeofTypeCode,MaterialCode,CustomerCode from(
select S.MaterialCode,Quantity,price,s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId,m.ModeofTypeCode
from SalesEntryArchival_BP s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
left join ModeofType m on m.ModeofTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  and BPYear='2023' 
and  CustomerCode in('20011846','20603208','20603407')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  --AND S.SaleSubType= 'bp' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode)Xxx
    group by monthyear,MaterialCode,ModeofTypeCode,CustomerCode

	--MonthlyLm
	SELECT SUM(Quantity) as Quantity,SUM(AMT) as AMT,MonthYear ,CustomerCode
from(SELECT SUM(Quantity) as Quantity,SUM(Quantity*price) as AMT,MonthYear,CustomerCode from
 ( SELECT  SH.CustomerCode ,SH.MaterialCode  ,SH.MonthYear                                                        
    ,(COALESCE(SH.Quantity,0)) as Quantity  ,(COALESCE(SH.price,0))  AS price  ,SH.ModeOfTypeId                                        
   ,ROW_NUMBER() OVER(PARTITION BY SH.CustomerCode ,SH.MaterialCode ,SH.MonthYear,SH.ModeOfTypeId,SH.ProductCategoryId1
   ORDER BY SH.ArchivalMonthYear DESC) AS ArchiveRank        
  FROM SalesEntryArchival SH                                    
  --left JOIN ModeofType MT ON MT.ModeofTypeId = SH.ModeOfTypeId                              
  WHERE  SH.CustomerCode in('20011846','20603208','20603407')
  and SH.ArchiveStatus='Archived'  AND ArchivalMonthYear=202309
  and   MonthYear >= '202304' and MonthYear <='202312'  and SH.ModeOfTypeId IN (1,12,10)
  )x
  WHERE ArchiveRank=1   group  by MonthYear,CustomerCode
  union
   SELECT SUM(Quantity) as Quantity,SUM(Quantity*price) as AMT,MonthYear,CustomerCode from
 ( SELECT  SH.CustomerCode ,SH.MaterialCode  ,SH.MonthYear                                                        
    ,(COALESCE(SH.Quantity,0)) as Quantity  ,(COALESCE(SH.price,0))  AS price                                          
   ,ROW_NUMBER() OVER(PARTITION BY SH.CustomerCode ,SH.MaterialCode ,SH.MonthYear,SH.accountcode
   ORDER BY SH.ArchivalMonth DESC) AS ArchiveRank                                                
  FROM TRNSalesPlanningArchival SH                                    
  WHERE  SH.CustomerCode in('20011846','20603208','20603407')   and SH.ArchiveStatus='Archived'
  AND ArchivalMonth=202309  
  and   MonthYear >=202304
  and MonthYear <=202312
  )x
  WHERE ArchiveRank=1 group  by MonthYear,CustomerCode
  )y group  by MonthYear,CustomerCode

  --MonthlyLY,BPLY
SELECT SUM(Quantity) as Quantity,SUM(AMT) as AMT,MonthYear ,CustomerCode
from(SELECT SUM(Quantity) as Quantity,SUM(Amount) as AMT,MonthYear,CustomerCode from
 ( SELECT  SH.CustomerCode ,SH.MaterialCode  ,SH.MonthYear                                                        
    ,(COALESCE(SH.Quantity,0)) as Quantity  ,(COALESCE(SH.Amount,0))  AS Amount                                          
  FROM MST_ResultSales SH  
  INNER JOIN MATERIAL M ON SH.MaterialCode=M.MaterialCode
  WHERE  SH.CustomerCode in('20011538')
  and   MonthYear >= '202204' and MonthYear <='202212'  
  )x
    group  by MonthYear,CustomerCode
  )y group  by MonthYear,CustomerCode

   




