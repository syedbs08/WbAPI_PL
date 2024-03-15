                        
                        
CREATE PROC [dbo].[sp_ConsolidateReport] (              
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY                        
 ,@Mg VARCHAR(20)                        
 ,@MG1 VARCHAR(20)                        
 ,@SalesSubType VARCHAR(30)                        
 ,@ColumnType VARCHAR(50)                        
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY                        
 )                        
AS                        
BEGIN                        
    SET NOCOUNT ON;                        
                        
 DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_CONSOLIDATE_LIST];                        
 DECLARE @TVPCUSTOMERLIST AS [dbo].[TVP_CUSTOMER_LIST];                    
 DECLARE @MonthList AS [dbo].[TVP_MONTHYEAR_TYPE];                    
                    
 DECLARE @CustomerCodeCount AS INT;                        
 SET @CustomerCodeCount =0;                        
                        
 SELECT @CustomerCodeCount = COUNT([CustomerCode])                        
 FROM @TVP_CUSTOMERCODE_LIST                        
 WHERE [CustomerCode] > 0;                     
                    
 INSERT INTO @TVPCUSTOMERLIST(                    
 CustomerId                    
 ,CustomerName                    
 ,CustomerCode                    
 ,DepartmentName                    
 ,CountryId                    
 ,CountryName                    
 ,SalesOfficeName                    
 )                    
   SELECT                        
     cust.CustomerId                          
    ,cust.CustomerName                       
    ,cust.CustomerCode                       
    ,d.DepartmentName                          
    ,cust.CountryId                          
    ,c.CountryName                         
    ,s.SalesOfficeName                          
  FROM customer cust                            
  LEFT JOIN Department d ON cust.DepartmentId = d.DepartmentId                          
  LEFT JOIN Country c ON cust.CountryId = c.CountryId                          
  LEFT JOIN SalesOffice s ON cust.SalesOfficeId = s.SalesOfficeId                          
  WHERE (cust.CustomerCode IN ( SELECT [CustomerCode] FROM @TVP_CUSTOMERCODE_LIST ) OR @CustomerCodeCount = 0);                     
                      
                     
 PRINT N'before executing logic'+ convert (varchar,CURRENT_TIMESTAMP);                        
 CREATE TABLE #Child_SP_Result(                        
    DepartmentName [varchar](50) NULL                        
    ,CountryId [int] null                        
    ,CountryName [varchar](50) NULL                        
    ,SalesOfficeName [varchar](50) NULL                        
    ,SalesType [varchar](50) NULL                        
    ,Consignee [varchar](50) NULL                        
    ,CustomerCode [varchar](50) NULL                        
    ,MG [varchar](50) NULL                        
    ,MG1 [varchar](50) NULL                        
    ,MG2 [varchar](50) NULL                        
    ,ProductCategoryId2 [int] null                        
    ,ProductCategoryId3 [int] null                        
    ,MaterialCode [varchar](50) NULL                        
    ,Qty  [bigint] NULL                        
    ,Amount  [decimal](18, 2) NULL                        
    ,FRT_AMT [decimal](18, 2) NULL                        
    ,CST_AMT [decimal](18, 2) NULL                        
    ,FOB_AMT [decimal](18, 2) NULL                        
    ,COG_AMT [decimal](18, 2) NULL                        
    ,GP_AMT [decimal](18, 2) NULL                        
    ,GP_PER [decimal](18, 2) NULL                        
    ,MonthYear [int] NULL                        
    ,SaleSubType [varchar](50) NULL                        
   );                        
                        
                         
                        
 --Last Month                            
 IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'MonthlyLM')   
 BEGIN                        
                        
 INSERT INTO @MonthList( MonthYear,[Type])                    
 SELECT MonthYear,[Type]                    
 FROM @TVP_MonthYear_LIST                    
 WHERE [type] = 'MonthlyLM';                    
                    
    DELETE FROM #Child_SP_Result;                        
    INSERT INTO #Child_SP_Result                        
    EXEC SP_LM_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST ,@MonthList;                        
                      
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
   ,LM_QTY                        
   ,LM_AMT                        
   ,LMFrt_AMT                        
   ,LMCst_AMT                        
   ,LMFob_AMT                        
   ,LMCog_AMT                        
   ,LMGp_AMT                        
   ,LMGp_Percentage                        
   )                
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   ,C.MonthYear                        
   ,ISNULL(Qty , 0)                         
   ,ISNULL(Amount , 0)                         
   ,ISNULL(FRT_AMT , 0)                         
   ,ISNULL(CST_AMT , 0)                        
   ,ISNULL(FOB_AMT , 0)                         
   ,ISNULL(COG_AMT , 0)                        
   ,ISNULL(GP_AMT , 0)                     
   ,ISNULL(GP_PER , 0)                        
  FROM #Child_SP_Result c                     
  WHERE c.SaleSubType = @SalesSubType                         
                           
 END                        
                        
                    
 --Last Year                            
 IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'MonthlyLY' )                        
 BEGIN                        
 DELETE FROM @MonthList;                    
 INSERT INTO @MonthList( MonthYear,[Type])                    
 SELECT MonthYear,[Type]                    
 FROM @TVP_MonthYear_LIST                    
 WHERE [type] = 'MonthlyLY';                    
                        
 DELETE FROM #Child_SP_Result;                      
    INSERT INTO #Child_SP_Result                        
    EXEC SP_CM_LY_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST,@MonthList;                       
                         
  INSERT INTO @TVPCONSOLIDATELIST (                        
   Department                        
   ,CustomerCode                        
   ,Country                        
   ,SalesOffice                        
   ,SalesType     ,Consignee                        
   ,Group_Desc                        
   ,SubGroup                        
   ,[Type]                        
   ,MaterialCode                        
   ,MonthYear                        
   ,LY_QTY                        
   ,LY_AMT                        
   ,LYFrt_AMT                        
   ,LYCst_AMT                        
   ,LYFob_AMT                        
   ,LYCog_AMT                        
   ,LYGp_AMT                        
   ,LYGp_Percentage                        
   )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   --,C.MonthYear                
   ,CAST(            
        CAST(SUBSTRING(cast(C.MonthYear as varchar(6)) , 1, 4) AS INT) + 1 AS VARCHAR(4)) +             
        SUBSTRING(cast(C.MonthYear as varchar(6))  , 5, 2) AS MonthYear             
   ,ISNULL(Qty, 0)                         
   ,ISNULL(Amount, 0)                         
   ,ISNULL(FRT_AMT, 0)                         
   ,ISNULL(CST_AMT, 0)                         
   ,ISNULL(FOB_AMT, 0)                         
   ,ISNULL(COG_AMT, 0)                         
   ,ISNULL(GP_AMT, 0)                         
   ,ISNULL(GP_PER, 0)                         
  FROM #Child_SP_Result c                     
   WHERE c.SaleSubType = @SalesSubType                         
                        
                           
 END                        
                     
  IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'MonthlyBP')                        
 BEGIN          
                        
 DELETE FROM @MonthList;                    
 INSERT INTO @MonthList( MonthYear,[Type])                    
 SELECT MonthYear,[Type]                    
 FROM @TVP_MonthYear_LIST                    
 WHERE [type] = 'MonthlyBP';                    
                    
    DELETE FROM #Child_SP_Result;                        
    INSERT INTO #Child_SP_Result                        
    EXEC SP_BP_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST,@MonthList;                        
                        
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
   ,BP_QTY                        
   ,BP_AMT                        
   ,BPFrt_AMT                        
   ,BPCst_AMT                        
,BPFob_AMT                        
   ,BPCog_AMT                        
   ,BPGp_AMT                        
   ,BPGp_Percentage                        
   )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   ,C.MonthYear                        
   ,ISNULL(Qty, 0)                        
   ,ISNULL(Amount, 0)                        
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                  
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM   #Child_SP_Result c                       
  --WHERE c.SaleSubType = @SalesSubType                        
                           
 END                        
      
 IF EXISTS( SELECT COUNT(*) FROM @TVP_MonthYear_LIST WHERE [type] IN ('BP' ,'BPBP' ) )      
 BEGIN      
      
  DELETE FROM @MonthList;                  
  INSERT INTO @MonthList( MonthYear,[Type])                  
  SELECT DISTINCT MonthYear,'' AS  [Type]                 
  FROM @TVP_MonthYear_LIST                  
  WHERE [type] IN ('BP' ,'BPBP' );                  
        
 DELETE FROM #Child_SP_Result;                      
 INSERT INTO #Child_SP_Result                      
 EXEC SP_BP_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST,@MonthList;                       
        
      
 END      
                      
 --BPBP                            
 IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'BPBP' )                        
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
   ,BP_QTY                        
   ,BP_AMT                        
   ,BPFrt_AMT                        
   ,BPCst_AMT                        
   ,BPFob_AMT                        
   ,BPCog_AMT                        
   ,BPGp_AMT                        
   ,BPGp_Percentage                        
  )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   --,C.MonthYear             
     ,CAST(            
        CAST(SUBSTRING(cast(C.MonthYear as varchar(6)) , 1, 4) AS INT) + 1 AS VARCHAR(4)) +             
        SUBSTRING(cast(C.MonthYear as varchar(6))  , 5, 2) AS MonthYear             
   ,ISNULL(Qty, 0)                        
   ,ISNULL(Amount, 0)                        
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                        
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM  #Child_SP_Result c                        
  WHERE c.SaleSubType = @SalesSubType                        
                        
                           
 END     
  
  --BP                           
 IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'BP' )                        
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
   ,Qty                        
   ,Amount                        
   ,Frt_AMT                        
   ,Cst_AMT                        
   ,Fob_AMT                        
   ,Cog_AMT                        
   ,Gp_AMT                        
   ,Gp_Percentage                        
  )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   ,C.MonthYear           
   ,ISNULL(Qty, 0)                        
   ,ISNULL(Amount, 0)                        
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                        
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM  #Child_SP_Result c                        
  WHERE c.SaleSubType = @SalesSubType                        
                        
                           
 END    
                    
 IF EXISTS( SELECT COUNT(*) FROM @TVP_MonthYear_LIST WHERE [type] = 'BPLY' )                        
 BEGIN                        
         
      DELETE FROM @MonthList;                  
  INSERT INTO @MonthList( MonthYear,[Type])                  
  SELECT DISTINCT MonthYear,'' AS  [Type]                 
  FROM @TVP_MonthYear_LIST                  
  WHERE [type] IN ('BPLY' );                  
        
 DELETE FROM #Child_SP_Result;                      
 INSERT INTO #Child_SP_Result                      
 EXEC SP_BP_LY_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST,@MonthList;                       
       
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
   ,LY_QTY                        
   ,LY_AMT                        
   ,LYFrt_AMT                        
   ,LYCst_AMT                        
,LYFob_AMT                        
   ,LYCog_AMT                        
   ,LYGp_AMT                        
   ,LYGp_Percentage                        
   )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   --,C.MonthYear              
    ,CAST(            
        CAST(SUBSTRING(cast(C.MonthYear as varchar(6)) , 1, 4) AS INT) + 1 AS VARCHAR(4)) +             
        SUBSTRING(cast(C.MonthYear as varchar(6))  , 5, 2) AS MonthYear             
   ,ISNULL(Qty, 0)              
   ,ISNULL(Amount, 0)                        
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                        
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM  #Child_SP_Result c                     
  WHERE c.SaleSubType = @SalesSubType                          
                           
 END                        
                        
                     
       
IF EXISTS( SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'BPLM' )                        
 BEGIN            
      
  DELETE FROM @MonthList;                  
  INSERT INTO @MonthList( MonthYear,[Type])                  
  SELECT DISTINCT MonthYear,[Type]                 
  FROM @TVP_MonthYear_LIST                  
  WHERE [type] = 'BPLM';                  
        
 DELETE FROM #Child_SP_Result;                      
 INSERT INTO #Child_SP_Result                      
 EXEC SP_BP_LM_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType,@TVPCUSTOMERLIST,@MonthList;           
            
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
   ,LM_QTY                        
   ,LM_AMT                        
   ,LMFrt_AMT                        
   ,LMCst_AMT                        
   ,LMFob_AMT                        
   ,LMCog_AMT                        
   ,LMGp_AMT                        
   ,LMGp_Percentage                        
   )                        
 SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   ,C.MonthYear                        
   ,ISNULL(Qty, 0)                        
   ,ISNULL(Amount, 0)                        
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                        
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM #Child_SP_Result c                     
  WHERE c.SaleSubType = @SalesSubType                         
                        
 END                        
          
                    
                        
 IF EXISTS(SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'CM')                        
 BEGIN                        
              
 PRINT N' BEFORE executing logic for CM'+ convert (varchar,SYSDATETIMEOFFSET());                       
                     
  DELETE FROM @MonthList;                    
 INSERT INTO @MonthList( MonthYear,[Type])                    
 SELECT MonthYear,[Type]                    
 FROM @TVP_MonthYear_LIST                    
 WHERE [type] = 'CM';                    
                    
    DELETE FROM #Child_SP_Result;                        
    INSERT INTO #Child_SP_Result                        
    EXEC SP_CM_BP_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType ,@TVPCUSTOMERLIST,@MonthList;                        
                            
    PRINT N' AFTER 1 executing logic for CM'+ convert (varchar,SYSDATETIMEOFFSET());                        
                         
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
   ,Qty                        
   ,Amount                        
   ,Frt_AMT                        
   ,Cst_AMT                        
   ,Fob_AMT                        
   ,Cog_AMT                        
   ,Gp_AMT                        
   ,Gp_Percentage                        
   )                        
  SELECT DISTINCT DepartmentName AS Department                        
   ,CustomerCode                        
   ,CountryName AS Country                        
   ,SalesOfficeName AS SalesOffice                        
   ,SalesType                        
   ,Consignee                        
   ,MG AS GROUP_DESC                        
   ,MG1 AS SubGroup                        
   ,MG2 AS [Type]                        
   ,MaterialCode                        
   ,C.MonthYear                        
   ,ISNULL(Qty, 0)                        
   ,ISNULL(Amount, 0)       
   ,ISNULL(FRT_AMT, 0)                        
   ,ISNULL(CST_AMT, 0)                        
   ,ISNULL(FOB_AMT, 0)                        
   ,ISNULL(COG_AMT, 0)                        
   ,ISNULL(GP_AMT, 0)                        
   ,ISNULL(GP_PER, 0)                        
  FROM #Child_SP_Result c                         
  --WHERE c.SaleSubType = @SalesSubType                       
  PRINT N' AFTER 2 executing logic for CM'+convert (varchar,SYSDATETIMEOFFSET());                     END                        
 --ELSE IF EXISTS(SELECT 1 FROM @TVP_MonthYear_LIST WHERE [type] = 'BP')                       
 --BEGIN                        
                        
 --DELETE FROM @MonthList;                    
 --INSERT INTO @MonthList( MonthYear,[Type])                    
 --SELECT MonthYear,[Type]                    
 --FROM @TVP_MonthYear_LIST                    
 --WHERE [type] = 'BP';                    
                    
 --   DELETE FROM #Child_SP_Result;                        
 --   INSERT INTO #Child_SP_Result                        
 --   EXEC SP_BP_ConsolidatedReport @TVP_CUSTOMERCODE_LIST,@Mg,@MG1,@SalesSubType ,@TVPCUSTOMERLIST,@MonthList;                        
                        
 -- INSERT INTO @TVPCONSOLIDATELIST (                        
 --  Department                        
 --  ,CustomerCode                        
 --  ,Country                        
 --  ,SalesOffice                        
 --  ,SalesType                        
 --  ,Consignee                        
 --  ,Group_Desc                        
 --  ,SubGroup                        
 --  ,[Type]                        
 --  ,MaterialCode                        
 --  ,MonthYear                        
 --  ,Qty                        
 --  ,Amount                        
 --  ,Frt_AMT                        
 --  ,Cst_AMT                        
 --  ,Fob_AMT                        
 --  ,Cog_AMT                        
 --  ,Gp_AMT                        
 --  ,Gp_Percentage                        
 --  )                        
 -- SELECT DISTINCT DepartmentName AS Department                        
 --  ,CustomerCode                        
 --  ,CountryName AS Country                        
 --  ,SalesOfficeName AS SalesOffice                        
 --  ,SalesType                        
 --  ,Consignee                        
 --  ,MG AS GROUP_DESC                        
 --  ,MG1 AS SubGroup                        
 --  ,MG2 AS [Type]                        
 --  ,MaterialCode                        
 --  ,C.MonthYear                        
 --  ,ISNULL(Qty, 0)                        
 --  ,ISNULL(Amount, 0)                        
 --  ,ISNULL(FRT_AMT, 0)                        
 --  ,ISNULL(CST_AMT, 0)                        
 --  ,ISNULL(FOB_AMT, 0)                  
 --  ,ISNULL(COG_AMT, 0)                        
 --  ,ISNULL(GP_AMT, 0)                        
 --,ISNULL(GP_PER, 0)                        
 -- FROM   #Child_SP_Result c                       
 -- WHERE c.SaleSubType = @SalesSubType                    
                           
 --END                        
                        
 --DROP TABLE #Child_SP_Result;                        
                        
 SELECT TEMP.*                        
 FROM @TVPCONSOLIDATELIST as TEMP;                        
                        
                         
END 