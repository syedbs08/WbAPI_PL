                
alter PROCEDURE [dbo].[USP_Transmission_Process]                          
@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY,                           
@CurrentMonth INT,         
@ResultMonth INT,       
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
     -- Insert Data in Transmission data for file write           
        
  CREATE TABLE #TMP        
  (CustomerCode nvarchar(50), PlanTypeCode INT, PlanType Varchar(50), RN INT)        
        
  INSERT INTO #TMP(CustomerCode,PlanTypeCode,PlanType,RN)        
  SELECT TL.CustomerCode,TL.PlanTypeCode,TT.PlanTypeName, ROW_NUMBER() OVER(ORDER BY  TL.CustomerCode) from TransmissionList TL        
  INNER JOIN @TVP_CUSTOMERCODE_LIST CL on CL.CustomerCode= TL.CustomerCode        
  INNER JOIN [dbo].[TransmissionPlanType] TT on TT.PlanTypeCode=TL.PlanTypeCode        
  AND TL.SalesType=@Type AND TL.IsActive=1        
        
  DECLARE @ST INT=1;        
  DECLARE @TOTALCOUNT INT;        
  SET @TOTALCOUNT = (SELECT COUNT(1) FROM #TMP)        
  WHILE @ST<=@TOTALCOUNT        
   BEGIN        
          
    DECLARE @PlanTypeCode INT;   
 DECLARE @PlanTypeName nvarchar(20);   
    DECLARE @CustomerCode nvarchar(100);        
    SET @PlanTypeCode = (SELECT PlanTypeCode FROM #TMP WHERE RN=@ST)    
  SET @PlanTypeName = (SELECT PlanType FROM #TMP WHERE RN=@ST)        
    SET @CustomerCode = (SELECT CustomerCode FROM #TMP WHERE RN=@ST and PlanTypeCode=@PlanTypeCode)        
    --print @PlanTypeCode;        
    --print @CustomerCode        
    DECLARE @CustomerList  AS [dbo].[TVP_CUSTOMERCODE_LIST]  
	DELETE FROM @CustomerList; 
    INSERT INTO @CustomerList(CustomerCode)        
    Values(@CustomerCode)        
        
        
    IF(@PlanTypeCode=100)        
     BEGIN      
  --PLAN    
      EXEC [dbo].[USP_ADD_Direct_Sale_PLAN] @CustomerList, @CurrentMonth,@Type,@CreatedBy,@PlanTypeCode,@PlanTypeName        
    exec USP_ADD_SNS_Account_PLAN @CustomerList,@CurrentMonth,@Type,@CreatedBy ,@PlanTypeCode,@PlanTypeName     
 END        
    ELSE IF(@PlanTypeCode=101)        
     BEGIN     
  --DIS-RESULT    
      EXEC [dbo].[USP_Add_SalesData_Transmission]   @CustomerList, @ResultMonth,@Type,@CreatedBy,@PlanTypeCode,@PlanTypeName       
     END        
    ELSE IF(@PlanTypeCode=102)        
     BEGIN      
  --DIS-PLAN    
      EXEC  [dbo].[USP_Add_DIS_PLAN_Transmission]   @CustomerList, @Type,@CreatedBy,@PlanTypeCode,@PlanTypeName        
     END        
    ELSE IF(@PlanTypeCode=103)        
     BEGIN     
  --CONSOLI    
      EXEC dbo.USP_Consolidated_Process @Type,@CurrentMonth,@CreatedBy,@PlanTypeCode,@PlanTypeName     
     END        
    SET @ST=@ST+1        
   END        
        
        
  SELECT * FROM #TMP        
  DROP TABLE #TMP        
                   
 END TRY                          
 BEGIN CATCH                          
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                                                  
   VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));                           
 END CATCH                          
  SELECT  DISTINCT  [ResponseCode], [ResponseMessage] FROM @ResultTable                               
                           
END 