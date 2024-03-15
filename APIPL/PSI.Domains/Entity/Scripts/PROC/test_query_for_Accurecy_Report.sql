---BP DIRECT
   select sUm(O_QTY+MPO_QTY+ADJ_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,
sum(O_AMT+ADJ_AMT+MPO_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
CustomerCode,monthyear
--, ,MaterialCode,ModeofTypeCode,type
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
   group by CustomerCode,monthyear
   --monthyear,MaterialCode,ModeofTypeCode,type

   ---Actual,LY
   ---Actual DIRECT
 ---Actual DIRECT
   select sUm(O_QTY+MPO_QTY+ADJ_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,
sum(O_AMT+ADJ_AMT+MPO_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT
,CustomerCode,monthyear,type
--, ,MaterialCode,ModeofTypeCode,type
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
and  CustomerCode in 
('20011538')
  and S.ModeOfTypeId IN (1,2,3,4,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   group by CustomerCode,monthyear,type
   --monthyear,MaterialCode,ModeofTypeCode,type


   ---N-0,N-1,N-2,N-3,N-4,N-5

      select sUm(MPO_QTY) +sUm(ADJ_QTY)+sUm(O_QTY) O_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(I_QTY) I_QTY,
sum(O_AMT)+sum(ADJ_AMT)+sum(MPO_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT

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


   ------SNS--
   --Actual--------------------
 WITH CTE_COG AS( SELECT  cogp.Price AS Price                
 ,cog.CustomerCode                
 ,cog.MaterialCode                
 ,cogp.MonthYear              
 ,cogp.ChargeType      
 ,ROW_NUMBER() over(PARTITION by cogp.ChargeType ,                             
 cog.SaleTypeId ,                             
 cog.CustomerCode ,                             
 cog.MaterialCode ,                             
 cog.SaleSubType ,                            
 cogp.MonthYear  ORDER BY cog.COGEntryId DESC)as ROWNUMBER      
FROM COGEntry AS cog                
LEFT JOIN COGEntryQtyPrice AS cogp ON cog.COGEntryId = cogp.COGEntryId                
WHERE cogp.MonthYear >= 202304   AND cogp.MonthYear <= 202403          
 AND cog.SaleSubType = 'Monthly'                
 AND SaleTypeId = 2            
 AND cog.CustomerCode ='20609235'  
 )
  SELECT Price               
 ,CustomerCode                
 ,MaterialCode                
 ,MonthYear              
 ,ChargeType   
 INTO #All_Prices_cog
  FROM CTE_COG WHERE ROWNUMBER=1;              
               
   SELECT  sum(cog.Price) AS Price                
 ,cog.CustomerCode                
 ,cog.MaterialCode                
 ,cog.MonthYear                
INTO #TEMP_FOB              
FROM #All_Prices_cog cog where cog.ChargeType='FOB'              
GROUP BY cog.CustomerCode                
 ,cog.MaterialCode                
 ,cog.MonthYear;               
               
              
 SELECT  sum(cog.Price) AS Price                
 ,cog.CustomerCode                
 ,cog.MaterialCode                
 ,cog.MonthYear                
INTO #All_Prices              
FROM #All_Prices_cog cog              
GROUP BY cog.CustomerCode                
 ,cog.MaterialCode                
 ,cog.MonthYear;  
select
sUm(O_QTY+MPO_QTY) O_QTY,sUm(P_QTY+MPO_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,
sum(O_AMT+MPO_AMT) O_AMT,
sum(P_AMT+MPO_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT
from
(
SELECT CustomerCode,MonthYear,
SUM(O_QTY) AS O_QTY,SUM(O_AMT) AS O_AMT,
0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
SUM(MPO_QTY) MPO_QTY,SUM(MPO_AMT) AS MPO_AMT
 FROM
(SELECT TP.AccountCode AS CustomerCode                                
    ,TP.MonthYear ,                             
	CASE 
        WHEN (ModeOfType) = 'ORDER' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS O_QTY,
	CASE 
        WHEN (ModeOfType) = 'ORDER' THEN COALESCE(TP.Quantity,0) * COALESCE((FOB.Price),0)
        ELSE 0 
    END AS O_AMT,
	CASE 
        WHEN (ModeOfType) = 'MPO' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS MPO_QTY,
	CASE 
        WHEN (ModeOfType) = 'MPO' THEN COALESCE(TP.Quantity,0) * COALESCE((FOB.Price),0)
        ELSE 0 
    END AS MPO_AMT
    ,TP.ModeOfType  
 FROM  trnpRicePlanning TP  
 LEFT JOIN #TEMP_FOB FOB ON TP.AccountCode = FOB.CustomerCode                
  AND FOB.MaterialCode = TP.MaterialCode  AND TP.MonthYear = FOB.MonthYear                                        
 WHERE 
 TP.MonthYear>=202304  AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
 and  TP.ModeOfType IN( 'ORDER','MPO')                                
 )X
  group by  CustomerCode          
    ,MonthYear            
 ,ModeOfType  
 union
SELECT CustomerCode,MonthYear,
0 O_QTY,0 as O_AMT,
 sUm(P_QTY) P_QTY, sUm(P_AMT) P_AMT,
0 S_QTY,0 S_AMT,
sUm(I_QTY)I_QTY,sUm(I_AMT)I_AMT  ,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT
FROM
(SELECT TP.AccountCode AS CustomerCode                                
    ,TP.MonthYear,                              
    --,(COALESCE(TP.Quantity,0)) AS QTY                                      
    --,(COALESCE(TP.Quantity,0) * COALESCE((COG.Price),0)) AS AMT    
	CASE 
        WHEN (ModeOfType) = 'PURCHASE' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS P_QTY,
CASE 
        WHEN (ModeOfType) = 'PURCHASE' THEN TP.Quantity * COG.Price              
   END AS P_AMT, 
		CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS I_QTY,
CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN    
    TP.Quantity * COG.Price                
   END AS I_AMT 
    ,TP.ModeOfType  
 FROM  trnpRicePlanning TP  
 LEFT JOIN #All_Prices COG ON TP.AccountCode = COG.CustomerCode                
  AND COG.MaterialCode = TP.MaterialCode  AND TP.MonthYear = COG.MonthYear                                        
 WHERE 
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
 and  TP.ModeOfType IN('PURCHASE','INVENTORY','ADJ')                                
 )X
  group by  CustomerCode          
    ,MonthYear            
 ,ModeOfType  
 union
SELECT TP.AccountCode AS CustomerCode                                
    ,TP.MonthYear ,                             
   0 O_QTY,0 as O_AMT,
 0 P_QTY,0 as P_AMT,
SUM( Quantity)S_QTY,
 sUm(Quantity*Price) AS   S_AMT,

		0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT
 FROM  TRNSalesPlanning TP  
 WHERE 
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
  group by  AccountCode          
    ,MonthYear            

 ) Y

 DROP TABLE #All_Prices
 DROP TABLE #All_Prices_cog
 DROP TABLE #TEMP_FOB