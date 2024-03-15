

alter PROCEDURE USP_ADD_SNS_Account_PLAN     
 -- Add the parameters for the stored procedure here    
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY, 
 @CurrentMonth int,
 @Type VARCHAR(10),          
 @CreatedBy nvarchar(max)       
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
 DECLARE @ResultTable  AS [dbo].[TVP_RESULT_TABLE]         
    -- Insert statements for procedure here    
 BEGIN TRY    
    
  DECLARE @CurrentMonthDate Varchar(10);    
  ---- Need to get Total Month count -- Current month +5      
  SET @CurrentMonthDate =CAST(CAST(@CurrentMonth as varchar(10))+'01' as date)    
    
  CREATE Table #tmpMonthData(MonthData INT)      
  DECLARE @StartMonth INT=0;      
  DECLARE @EndMonth INT=5;-- Need 6 Month Data including Current Month      
   WHILE @StartMonth<=@EndMonth      
   BEGIN      
    INSERT INTO #tmpMonthData(MonthData)      
    VALUES (CAST ( CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))      
    SET @StartMonth = @StartMonth+1      
   END;     
  
  Create table #tmpPlanData(        
   CustomerCode VARCHAR(200),      
  MaterialCode VARCHAR(200),        
  CurrentMonthYear INT,        
  LockMonthYear INT,        
  MonthYear INT,        
  ModeOfTypeID INT,        
  Quantity INT,        
  Amount INT,        
  SalesValue INT,        
  [Plan] VARCHAR(50),        
  SaleType  VARCHAR(50),        
  SaleSequenceType VARCHAR(4),        
  SalesSequenceTypeText  VARCHAR(4))        
    
    
  INSERT INTO #tmpPlanData(CustomerCode,MaterialCode,CurrentMonthYear,LockMonthYear,MonthYear,ModeOfTypeID,Quantity,Amount,SalesValue,    
  [Plan],SaleType,SaleSequenceType,SalesSequenceTypeText)    
    
  SELECT '',MaterialCode,0,0,MonthYear,2,Quantity,  
  0 AS Amount, 0 as SaleValues,    
  'SNS_Plan' AS [Plan],'Monthly','01' AS SequenceType,'P' as SaleSequenceTypeText   
 from TRNPricePlanning p  
 LEFT JOIN #tmpMonthData MD ON p.MonthYear= MD.MonthData   
 WHERE ModeofType in ('PURCHASE') and AccountCode 
 in ('00029375','20609235','20609998')  
  
 
 AND MD.MonthData is not null    
  
    
  UNION    
    
                
  SELECT '', MaterialCode, 0,0,MonthYear,    
  4,Quantity, 0 AS Amount, 0 as SaleValue,             
  'SNS_Plan' as  [Plan],'Monthly' ,'02' as SaleSequenceType  ,'S' AS SalesSequenceTypeText            
 from TRNPricePlanning p  
 LEFT JOIN #tmpMonthData MD ON p.MonthYear= MD.MonthData   
 WHERE ModeofType in ('INVENTORY') and AccountCode 
 in ('00029375','20609235','20609998')
 AND MD.MonthData is not null    
              
        UNION    
    
  SELECT CustomerCode, MaterialCode, s.MonthYear,0,p.MonthYear,  
  ModeOfTypeID,    
  p.Qty AS Quantity,              
  CAST( ROUND((Price*Qty),0) as INT) AS Amount, -- cast( ROUND((Price*Quantity),0) as INT) Amount (Because In Sale no Landed value(Amount) only Sale value,               
     0  as SaleValue,              
  'SNS_Plan' as  [Plan],SaleSubType ,'03' as SaleSequenceType  ,'I' AS SalesSequenceTypeText            
  FROM SNSEntry s inner join SNSEntryQtyPrice p on s.SNSEntryId=p.SNSEntryId  
   LEFT JOIN #tmpMonthData MD ON p.MonthYear= MD.MonthData   
   where  OACCode in ('00029375','20609235','20609998') and  MD.MonthData is not null AND   
  CustomerCode  in(SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST) And p.MonthYear IN (select MonthData from #tmpMonthData)  AND SaleSubType= @Type              
              
    
  -- INSERT DATA IN TRANSMISSION TABLE    
             
  INSERT INTO TransmissionData(CustomerCode,MaterialCode,CurrentMonthYear,LockMonthYear,MonthYear,ModeOfTypeID,              
  Qty,Amount,SaleValue,[Plan],SaleType,SaleSequenceType,SalesSequenceTypeText,CreatedBy,EDIStatus,Status)              
  SELECT CustomerCode,MaterialCode,CurrentMonthYear,LockMonthYear,MonthYear,ModeOfTypeID,              
  Quantity,Amount,SalesValue,[Plan],SaleType,SaleSequenceType,SalesSequenceTypeText, @CreatedBy,'Pending','Pending' FROM #tmpPlanData order by   ModeOfTypeID,MonthYear              
         
  Declare @TotalNumber INT        
  SET @TotalNumber=(SELECT COUNT(1) FROM #tmpPlanData)        
  --DROP TABLE #tmpData       
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                                      
  VALUES(200, ''+CAST( @TotalNumber as Varchar(50))+' Record for transmission executed successfully');               
    
      
    
 END TRY    
 BEGIN CATCH    
     
   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                                    
  VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));         
 END CATCH    
  -- DROP TEMP TABLE    
  DROP TABLE #tmpMonthData    
  DROP TABLE #tmpPlanData    
  SELECT  DISTINCT  [ResponseCode], [ResponseMessage] FROM @ResultTable       
    
END    
  