------MonthlyLY,Monthly,BPLY


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
sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT from
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
   INNER JOIN material MV ON TP.MaterialCode = MV.MaterialCode
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
        WHEN (ModeOfType) = 'PURCHASE' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS P_AMT, 
		CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS I_QTY,
CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS I_AMT 
    ,TP.ModeOfType  
 FROM  trnpRicePlanning TP 
   INNER JOIN material MV ON TP.MaterialCode = MV.MaterialCode
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
  INNER JOIN material MV ON TP.MaterialCode = MV.MaterialCode
 WHERE MV.isactive=1 and 
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
  group by  AccountCode          
    ,MonthYear            

 ) Y

 DROP TABLE #All_Prices
 DROP TABLE #All_Prices_cog
 DROP TABLE #TEMP_FOB
 --------------------------------BP,BPBP,MonthlyBP
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
 AND cog.SaleSubType = 'BP'                
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
sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,CustomerCode from(
 select
sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,CustomerCode from
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
 FROM  trnpRicePlanning_BP TP  
 INNER JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 LEFT JOIN #TEMP_FOB FOB ON TP.AccountCode = FOB.CustomerCode                
  AND FOB.MaterialCode = TP.MaterialCode  AND TP.MonthYear = FOB.MonthYear                                        
 WHERE mat.isactive=1 and BP_YEAR=2023 AND
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
        WHEN (ModeOfType) = 'PURCHASE' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS P_AMT, 
		CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS I_QTY,
CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS I_AMT 
    ,TP.ModeOfType  
 FROM  trnpRicePlanning_BP TP  
  INNER JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 LEFT JOIN #All_Prices COG ON TP.AccountCode = COG.CustomerCode 
 
  AND COG.MaterialCode = TP.MaterialCode  AND TP.MonthYear = COG.MonthYear                                        
 WHERE mat.isactive=1 and BP_YEAR=2023 AND
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
 FROM  TRNSalesPlanning_BP TP  
 INNER JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 WHERE mat.isactive=1 and BP_YEAR=2023 AND
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
  group by  AccountCode          
    ,MonthYear            

 ) Y
 group by CustomerCode

 union
 ----direct sale
 select sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,CustomerCode
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
INNER JOIN Material mat ON S.MaterialCode = mat.MaterialCode
--left join ModeofType m on m.ModeOfTypeId=s.ModeOfTypeId
where mat.isactive=1 and MonthYear between '202304' and '202403'  
and  CustomerCode in 
--('20011538')
('20609235')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
 AND BPYEAR=2023  
  and S.ModeOfTypeId IN (1,2,3,4,10,12))X
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   group by CustomerCode
   --monthyear,MaterialCode,ModeofTypeCode,type
   )z
   group by customercode

   
 DROP TABLE #All_Prices
 DROP TABLE #All_Prices_cog
 DROP TABLE #TEMP_FOB


 --SELECT sum(quantity) FROM trnpRicePlanning_BP WHERE BP_YEAR=2023 AND MonthYear>=202304 and MonthYear<=202403 and modeoftype='order'   and AccountCode='20609235'

 -----------------------------------MonthlyLM-------------------------------
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
 AND cog.SaleSubType = 'BP'                
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

     ;WITH CTE_ARCHIVE_SNS AS (                                                     
     SELECT                                                        
    TP.AccountCode AS AccountCode                                                        
                                                     
    ,TP.MaterialCode                                                      
    ,TP.MonthYear                                                       
    ,(COALESCE(TP.Quantity,0)) AS QTY                                                         
    ,(COALESCE(TP.Quantity,0) * COALESCE(TP.Price,0)) AS AMT                                              
    ,(COALESCE(TP.Price,0)) as Price                        
    ,TP.ModeOfType                                             
   , ROW_NUMBER() OVER(PARTITION BY TP.AccountCode ,TP.MaterialCode , TP.MonthYear,TP.ModeofType ORDER BY TP.CurrentMonthYear DESC) AS ArchiveRank                                                          
   FROM TRNPricePlanningArchival TP                                                                    
   INNER JOIN Material mat ON TP.MaterialCode = mat.MaterialCode                      
  WHERE TP.CurrentMonthYear=202309 AND  TP.MonthYear>=202304 AND TP.MonthYear<=202403  and  TP.ArchiveStatus='Archived'                                              
  AND  TP.AccountCode ='20609235'                                             
  and TP.[ModeofType] in('INVENTORY','MPO','ORDER','PURCHASE','ADJ')                                    
     )                                  
   SELECT  AccountCode                                                  
    ,MaterialCode                                                      
    ,MonthYear                                                       
  ,SUM(QTY) AS Quantity                                                            
    ,SUM(AMT) AS AMT                                            
 ,SUM(Price) AS Price                                            
    ,ModeOfType    
	INTO #TEMP_ALL_TRNPRICEPLANNING
   FROM CTE_ARCHIVE_SNS AS S                                           
   WHERE S.ArchiveRank = 1         
    group by AccountCode                                                  
    ,MaterialCode                                                      
    ,MonthYear        
 ,ModeOfType;    

  ;WITH CTE_ARCHIVE_TRNSalesPlanningArchival AS (                                  
   SELECT                                                      
    P.AccountCode                                                       
    ,P.MaterialCode                                                      
    ,p.MonthYear                                                       
    ,(COALESCE(p.Quantity,0)) AS S_QTY                                                              
    ,(COALESCE(p.Quantity,0) * COALESCE(P.Price,0)) AS S_AMT                                               
   ,  ROW_NUMBER() OVER(PARTITION BY P.MaterialCode ,P.AccountCode ,P.MonthYear ORDER BY p.ArchivalMonth DESC) AS ArchiveRank                                                   
   FROM TRNSalesPlanningArchival p                                                                   
   INNER JOIN Material mat ON p.MaterialCode = mat.MaterialCode                                                                  
   WHERE P.ArchivalMonth=202309 AND  p.MonthYear>=202304 AND p.MonthYear<=202403 and                                    
   p.AccountCode ='20609235'                                    
                             
   )                                                  
                                  
   SELECT             
    AccountCode                                                         
    ,MaterialCode                                                      
    ,MonthYear                                                       
    ,SUM(S_QTY)  AS QTY                                                             
    ,SUM(S_AMT)  AS AMT
	INTO #TEMP_SALEPLANNING  
   FROM CTE_ARCHIVE_TRNSalesPlanningArchival AS S                                                       
   WHERE S.ArchiveRank = 1         
   GROUP BY           
    AccountCode                                                         
    ,MaterialCode                                                      
    ,MonthYear       ;  
 select
sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,CustomerCode from(
 select
sUm(O_QTY) O_QTY,sUm(P_QTY) P_QTY,sUm(S_QTY) S_QTY,sUm(I_QTY) I_QTY,sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,CustomerCode from
(
SELECT CustomerCode,MonthYear,
SUM(O_QTY) AS O_QTY,SUM(O_AMT) AS O_AMT,
0 P_QTY,0 as P_AMT,
0 S_QTY,0 S_AMT,
0 I_QTY,0 I_AMT,
SUM(ADJ_QTY) ADJ_QTY,SUM(ADJ_AMT) AS ADJ_AMT,
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
    END AS MPO_AMT,
	CASE 
        WHEN (ModeOfType) = 'ADJ' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS ADJ_QTY,
	CASE 
        WHEN (ModeOfType) = 'ADJ' THEN COALESCE(TP.Quantity,0) * COALESCE((FOB.Price),0)
        ELSE 0 
    END AS ADJ_AMT
    ,TP.ModeOfType  
 FROM  #TEMP_ALL_TRNPRICEPLANNING TP  
 JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 LEFT JOIN #TEMP_FOB FOB ON TP.AccountCode = FOB.CustomerCode                
  AND FOB.MaterialCode = TP.MaterialCode  AND TP.MonthYear = FOB.MonthYear                                        
 WHERE
 TP.MonthYear>=202304  AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
 and  TP.ModeOfType IN( 'ORDER','MPO','ADJ')                                
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
	CASE 
        WHEN (ModeOfType) = 'PURCHASE' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS P_QTY,
CASE 
        WHEN (ModeOfType) = 'PURCHASE' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS P_AMT, 
		CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN COALESCE(TP.Quantity,0)
        ELSE 0 
    END AS I_QTY,
CASE 
        WHEN (ModeOfType) = 'INVENTORY' THEN CASE   
   WHEN COALESCE(COG.Price, 0) = 0                
    THEN TP.Quantity * TP.Price                
   ELSE TP.Quantity * COG.Price   END             
   END AS I_AMT 
    ,TP.ModeOfType  
 FROM  #TEMP_ALL_TRNPRICEPLANNING TP  
  JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 LEFT JOIN #All_Prices COG ON TP.AccountCode = COG.CustomerCode 
 
  AND COG.MaterialCode = TP.MaterialCode  AND TP.MonthYear = COG.MonthYear                                        
 WHERE
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
 and  TP.ModeOfType IN('PURCHASE','INVENTORY')                                
 )X
  group by  CustomerCode          
    ,MonthYear            
 ,ModeOfType  
 union
SELECT TP.AccountCode AS CustomerCode                                
    ,TP.MonthYear ,                             
   0 O_QTY,0 as O_AMT,
 0 P_QTY,0 as P_AMT,
SUM( QTY)S_QTY,
 sUm(AMT) AS   S_AMT,

		0 I_QTY,0 I_AMT,
0 ADJ_QTY,0 ADJ_AMT,
0 MPO_QTY,0 MPO_AMT
 FROM  #TEMP_SALEPLANNING TP  
  JOIN Material mat ON TP.MaterialCode = mat.MaterialCode
 WHERE
 TP.MonthYear>=202304 AND TP.MonthYear <= 202403  
 and tp.AccountCode='20609235'
  group by  AccountCode          
    ,MonthYear            

 ) Y
 group by CustomerCode

 union
 ----direct sale
select sUm(MPO_QTY) MPO_QTY,sUm(ADJ_QTY) ADJ_QTY,sUm(I_QTY) I_QTY,sUm(S_QTY) S_QTY,sUm(P_QTY) P_QTY,sUm(O_QTY) O_QTY,
sum(O_AMT) O_AMT,
sum(P_AMT) P_AMT,
sum(S_AMT) S_AMT,
sum(I_AMT) I_AMT,
sum(ADJ_AMT) ADJ_AMT,
sum(MPO_AMT) MPO_AMT,
--,monthyear ,MaterialCode,ModeofTypeCode,
CustomerCode
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
  and (s.CustomerCode in('20609235'))
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
and  CustomerCode in('20609235')
--and S.MaterialCode='NI-100DXWTA'
--AND S.OCstatus = 'Y' 
  AND S.SaleSubType= 'Monthly' --and MonthYear between '202304' and '202404'   
  and S.ModeOfTypeId IN (1,2,3,4,10,12)
  )X
  WHERE  ArchiveRank=1
  group by ModeofTypeCode,MonthYear,MaterialCode,CustomerCode,ModeOfTypeId
  )Xxx
  --WHERE monthyear=202304
   group by 
   --monthyear,MaterialCode,ModeofTypeCode,
   CustomerCode

   )z
   group by customercode

   
 DROP TABLE #All_Prices
 DROP TABLE #All_Prices_cog
 DROP TABLE #TEMP_FOB
 DROP TABLE #TEMP_ALL_TRNPRICEPLANNING
 DROP TABLE #TEMP_SALEPLANNING

 --SELECT sum(quantity) FROM trnpRicePlanning_BP WHERE BP_YEAR=2023 AND MonthYear>=202304 and MonthYear<=202403 and modeoftype='order'   and AccountCode='20609235'

 ----------------------

