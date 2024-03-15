DECLARE @tvpMonthYearList dbo.TVP_MONTHYEAR_TYPE,
 @tvpCustomerCodeList dbo.TVP_CUSTOMERCODE_LIST,
 @MG nvarchar(100),
 @MG1 nvarchar(100),
 @SalesSubType nvarchar(100),
 @ColumnType nvarchar(100),
 @TVPCUSTOMERLIST [dbo].[TVP_CUSTOMER_LIST] ,
 @IsUSD bit ;

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

INSERT INTO @tvpCustomerCodeList VALUES('20011538');

SET @MG = '250'; 
SET @MG1 ='262';
SET @SalesSubType='Monthly';
SET @ColumnType='CM';
SET @IsUSD = 0;

exec dbo.SP_NonConsolidateReport  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType,@ColumnType,@tvpMonthYearList,@IsUSD;

--WITH CTE_CUSTOMERS AS (
--	   SELECT    
--		 cust.CustomerId      
--		,cust.CustomerName   
--		,cust.CustomerCode   
--		,d.DepartmentName      
--		,cust.CountryId      
--		,c.CountryName     
--		,s.SalesOfficeName   
--		,max(CustDid.AccountId)  AS AccountId    
--        ,max(AC.AccountCode) AS AccountCode 
--	  FROM customer cust        
--	  LEFT JOIN Department d ON cust.DepartmentId = d.DepartmentId      
--	  LEFT JOIN Country c ON cust.CountryId = c.CountryId      
--	  LEFT JOIN SalesOffice s ON cust.SalesOfficeId = s.SalesOfficeId   
--	  LEFT JOIN CustomerDID CustDid ON cust.CustomerId = CustDid.CustomerId    
--	  LEFT JOIN Account AC ON CustDid.AccountId = AC.AccountId   
--	  WHERE cust.CustomerCode IN ( SELECT [CustomerCode] FROM @tvpCustomerCodeList )
--	  GROUP BY cust.CustomerId,cust.CustomerName,cust.CustomerCode,d.DepartmentName,cust.CountryId,c.CountryName,s.SalesOfficeName
--	  )
--	  INSERT INTO @TVPCUSTOMERLIST(
--	 CustomerId
--	 ,CustomerName
--	 ,CustomerCode
--	 ,DepartmentName
--	 ,CountryId
--	 ,CountryName
--	 ,SalesOfficeName
--	 ,AccountCode)
--	 SELECT DISTINCT
--	 CustomerId
--	 ,CustomerName
--	 ,CustomerCode
--	 ,DepartmentName
--	 ,CountryId
--	 ,CountryName
--	 ,SalesOfficeName
--	 ,AccountCode
--	 FROM CTE_CUSTOMERS; 


-- exec dbo.sp_Monthly_NonConsolidateReport  @tvpCustomerCodeList,@MG,@MG1,@SalesSubType,@ColumnType,@tvpMonthYearList,@IsUSD,@TVPCUSTOMERLIST;



--MONTHLY AND MONTHLY LY AND BPLY
select sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,sUm(I_QTY) I_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(O_QTY) O_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT
--,monthyear ,MaterialCode,ModeofTypeCode,CustomerCode,type
from(
select sUm(qty) O_QTY,sum(amount) O_AMT,
0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT,
monthyear, 'AD' ModeofTypeCode,MaterialCode,CustomerCode,'ADJ' as type from (
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
  select
  0 as O_QTY,0 AS O_AMT,
  0 P_QTY,0 as P_AMT,
  sum(qty) S_QTY, sum(amount) S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT

  ,MonthYear,'SNS' ModeofTypeCode,MaterialCode,CustomerCode,'SNS' as type from(
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
   AND  ACCOUNTCODE in('20011538')
	)X
	group by MonthYear ,MaterialCode,CustomerCode
	union
	 SELECT             
    sum(s.Qty) O_QTY,
    sum(s.Qty * s.Price) as O_AMT,
	0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 I_QTY,0 MPO_AMT,
	s.Monthyear ,'SSD' ModeofTypeCode,s.MaterialCode,CustomerCode,'SSD' as type
   FROM SSDentry s     
   JOIN Material mat ON s.MaterialCode = mat.MaterialCode 
   WHERE  MonthYear between '202304' and '202403'  
  -- and S.MaterialCode='AW-UE150KEJ8'
  and (s.CustomerCode in('20011538'))
   group by s.Monthyear ,s.MaterialCode,CustomerCode
   union
   select 
   sUm(O_QTY) O_QTY,sum(O_AMT) O_AMT,
sUm(P_QTY) P_QTY,sUm(P_AMT) as P_AMT,
sUm(S_QTY) S_QTY,sUm(S_AMT) S_AMT,
sUm(I_QTY) I_QTY,sUm(I_AMT) I_AMT,
sUm(ADJ_QTY) ADJ_QTY,sUm(ADJ_AMT) ADJ_AMT,
sUm(MPO_QTY) MPO_QTY,sUm(MPO_AMT) MPO_AMT,
   MonthYear,ModeofTypeCode,MaterialCode,CustomerCode,'SALES' as type from(
select S.MaterialCode,

 CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity) 
        ELSE 0 
    END AS O_QTY,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity) 
        ELSE 0 
    END AS P_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity) 
        ELSE 0 
    END AS S_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity) 
        ELSE 0 
    END AS I_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity) 
        ELSE 0 
    END AS ADJ_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity) 
        ELSE 0 
    END AS MPO_QTY 
	,

	CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity*Price) 
        ELSE 0 
    END AS O_AMT,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity*Price) 
        ELSE 0 
    END AS P_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity*Price) 
        ELSE 0 
    END AS S_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity*Price) 
        ELSE 0 
    END AS I_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity*Price) 
        ELSE 0 
    END AS ADJ_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity*Price) 
        ELSE 0 
    END AS MPO_AMT ,
	s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId
 ,'sales' as ModeofTypeCode
from SalesEntry s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
--left join ModeofType m on m.ModeOfTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  
and  CustomerCode in('20011538')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  AND S.SaleSubType= 'Monthly' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,2,3,4,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   --group by monthyear,MaterialCode,ModeofTypeCode,CustomerCode,type


   --MONTHLYBP,BP,BPBP
   select sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,sUm(I_QTY) I_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(O_QTY) O_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT
,CustomerCode
--,monthyear ,MaterialCode,ModeofTypeCode,type
from(

   select 
   sUm(O_QTY) O_QTY,sum(O_AMT) O_AMT,
sUm(P_QTY) P_QTY,sUm(P_AMT) as P_AMT,
sUm(S_QTY) S_QTY,sUm(S_AMT) S_AMT,
sUm(I_QTY) I_QTY,sUm(I_AMT) I_AMT,
sUm(ADJ_QTY) ADJ_QTY,sUm(ADJ_AMT) ADJ_AMT,
sUm(MPO_QTY) MPO_QTY,sUm(MPO_AMT) MPO_AMT,
   MonthYear,ModeofTypeCode,MaterialCode,CustomerCode,'SALES' as type from(
select S.MaterialCode,

 CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity) 
        ELSE 0 
    END AS O_QTY,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity) 
        ELSE 0 
    END AS P_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity) 
        ELSE 0 
    END AS S_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity) 
        ELSE 0 
    END AS I_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity) 
        ELSE 0 
    END AS ADJ_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity) 
        ELSE 0 
    END AS MPO_QTY 
	,

	CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity*Price) 
        ELSE 0 
    END AS O_AMT,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity*Price) 
        ELSE 0 
    END AS P_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity*Price) 
        ELSE 0 
    END AS S_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity*Price) 
        ELSE 0 
    END AS I_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity*Price) 
        ELSE 0 
    END AS ADJ_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity*Price) 
        ELSE 0 
    END AS MPO_AMT ,
	s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId
 ,'sales' as ModeofTypeCode
from SalesEntry_BP s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
--left join ModeofType m on m.ModeOfTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  
and  CustomerCode in 
--('20011538')
('20011846','20603208','20603407')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
 AND BPYEAR=2023  
  and S.ModeOfTypeId IN (1,2,3,4,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   group by CustomerCode
   --monthyear,MaterialCode,ModeofTypeCode,type

   ---BP LM
   select sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,sUm(I_QTY) I_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(O_QTY) O_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT
,CustomerCode
--,monthyear ,MaterialCode,ModeofTypeCode,type
from(

   select 
   sUm(O_QTY) O_QTY,sum(O_AMT) O_AMT,
sUm(P_QTY) P_QTY,sUm(P_AMT) as P_AMT,
sUm(S_QTY) S_QTY,sUm(S_AMT) S_AMT,
sUm(I_QTY) I_QTY,sUm(I_AMT) I_AMT,
sUm(ADJ_QTY) ADJ_QTY,sUm(ADJ_AMT) ADJ_AMT,
sUm(MPO_QTY) MPO_QTY,sUm(MPO_AMT) MPO_AMT,
   MonthYear,ModeofTypeCode,MaterialCode,CustomerCode,'SALES' as type from(
select S.MaterialCode,

 CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity) 
        ELSE 0 
    END AS O_QTY,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity) 
        ELSE 0 
    END AS P_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity) 
        ELSE 0 
    END AS S_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity) 
        ELSE 0 
    END AS I_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity) 
        ELSE 0 
    END AS ADJ_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity) 
        ELSE 0 
    END AS MPO_QTY 
	,

	CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity*Price) 
        ELSE 0 
    END AS O_AMT,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity*Price) 
        ELSE 0 
    END AS P_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity*Price) 
        ELSE 0 
    END AS S_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity*Price) 
        ELSE 0 
    END AS I_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity*Price) 
        ELSE 0 
    END AS ADJ_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity*Price) 
        ELSE 0 
    END AS MPO_AMT ,
	s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId
 ,'sales' as ModeofTypeCode
from SalesEntryArchival_BP s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
--left join ModeofType m on m.ModeOfTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'  
and  CustomerCode in 
--('20011538')
('20011846','20603208','20603407')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
 AND BPYEAR=2023  
  and S.ModeOfTypeId IN (1,2,3,4,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   group by CustomerCode
   --monthyear,MaterialCode,ModeofTypeCode,type

   --MonthlyLM
   select sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,sUm(I_QTY) I_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(O_QTY) O_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT
--,monthyear ,MaterialCode,ModeofTypeCode,CustomerCode,type
from(
SELECT  sUm(qty) O_QTY,sum(amount) O_AMT,0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT,
monthyear, 'AD' ModeofTypeCode,MaterialCode,CustomerCode,'ADJ' as type                                                     
from (   SELECT 
MaterialCode,CustomerCode   ,MonthYear         ,Qty 
  ,Amount                                    
   ,ROW_NUMBER() OVER(PARTITION BY  SH.CustomerCode ,SH.MaterialCode , SH.MonthYear 
   ORDER BY SH.ArchivalMonthYear DESC) AS ArchiveRank        
  FROM AdjustmentEntryArchive SH                                    
  WHERE  SH.CustomerCode in('20011846','20603208','20603407')
  and SH.ArchiveStatus='Archived'  AND ArchivalMonthYear=202309
  and   MonthYear >= '202304' and MonthYear <='202312'  
  
)X
WHERE ArchiveRank=1
group by MonthYear,MaterialCode,CustomerCode
union

	 SELECT             
    sum(s.Qty) O_QTY,
    sum(s.Qty * s.Price) as O_AMT,
	0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 I_QTY,0 MPO_AMT,
	s.Monthyear ,'SSD' ModeofTypeCode,s.MaterialCode,CustomerCode,'SSD' as type
   FROM SSDentry s     
   JOIN Material mat ON s.MaterialCode = mat.MaterialCode 
   WHERE  MonthYear between '202304' and '202403'  
  -- and S.MaterialCode='AW-UE150KEJ8'
  and (s.CustomerCode in('20011538'))
   group by s.Monthyear ,s.MaterialCode,CustomerCode
   union
   select 
   sUm(O_QTY) O_QTY,sum(O_AMT) O_AMT,
sUm(P_QTY) P_QTY,sUm(P_AMT) as P_AMT,
sUm(S_QTY) S_QTY,sUm(S_AMT) S_AMT,
sUm(I_QTY) I_QTY,sUm(I_AMT) I_AMT,
sUm(ADJ_QTY) ADJ_QTY,sUm(ADJ_AMT) ADJ_AMT,
sUm(MPO_QTY) MPO_QTY,sUm(MPO_AMT) MPO_AMT,
   MonthYear,ModeofTypeCode,MaterialCode,CustomerCode,'SALES' as type from(
select S.MaterialCode,

 CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity) 
        ELSE 0 
    END AS O_QTY,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity) 
        ELSE 0 
    END AS P_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity) 
        ELSE 0 
    END AS S_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity) 
        ELSE 0 
    END AS I_QTY, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity) 
        ELSE 0 
    END AS ADJ_QTY ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity) 
        ELSE 0 
    END AS MPO_QTY 
	,

	CASE 
        WHEN (ModeOfTypeId) = 1 THEN (Quantity*Price) 
        ELSE 0 
    END AS O_AMT,
    CASE 
        WHEN (ModeOfTypeId) =2 THEN (Quantity*Price) 
        ELSE 0 
    END AS P_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =3 THEN (Quantity*Price) 
        ELSE 0 
    END AS S_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =4 THEN (Quantity*Price) 
        ELSE 0 
    END AS I_AMT, 
	 CASE 
        WHEN (ModeOfTypeId) =10 THEN (Quantity*Price) 
        ELSE 0 
    END AS ADJ_AMT ,
	 CASE 
        WHEN (ModeOfTypeId) =12 THEN (Quantity*Price) 
        ELSE 0 
    END AS MPO_AMT ,
	s.CurrencyCode,(Quantity*Price) Amount , CustomerCode,MonthYear ,
(Price*ExchangeRate) USD_PRICE,(Quantity*(Price*ExchangeRate)) USD_AMT,
s.ModeOfTypeId
 ,'sales' as ModeofTypeCode
 ,ROW_NUMBER() OVER(PARTITION BY S.CustomerCode ,S.MaterialCode ,S.MonthYear,S.ModeOfTypeId,S.ProductCategoryId1 ORDER BY S.ArchivalMonthYear DESC) AS ArchiveRank
from SalesEntryArchival s
left join Currency c on s.CurrencyCode=c.CurrencyCode
JOIN Material mat ON S.MaterialCode = mat.MaterialCode
--left join ModeofType m on m.ModeOfTypeId=s.ModeOfTypeId
where MonthYear between '202304' and '202403'   AND ArchivalMonthYear=202309
and  CustomerCode in('20011538')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  AND S.SaleSubType= 'Monthly' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,2,3,4,10,12)
  )X
  WHERE  ArchiveRank=1
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   --group by monthyear,MaterialCode,ModeofTypeCode,CustomerCode,type










