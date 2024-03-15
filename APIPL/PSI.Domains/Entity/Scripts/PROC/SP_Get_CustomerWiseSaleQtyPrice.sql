        
        
-- =============================================          
-- Author:      <Author, , Name>          
-- Create Date: <Create Date, , >          
-- Description: <Description, , >          
-- =============================================          
alter PROCEDURE [dbo].[SP_Get_CustomerWiseSaleQtyPrice]          
(          
@accountCode nvarchar(100),        
@currentMonth int,      
@lockMonth int,      
@resultMonth int,      
@lastForecastMonth int,      
@tvpCustomerCodeList [dbo].[TVP_CODE_LIST] READONLY,        
@tvpMaterialCodeList [dbo].[TVP_CODE_LIST] READONLY        
)          
AS          
BEGIN          
    -- SET NOCOUNT ON added to prevent extra result sets from          
    -- interfering with SELEaCT statements.          
    SET NOCOUNT ON          
        
 --DECLARE @resultMonth int, @currentMonth int, @lockMonth int, @lastForecastMonth int;       
       
 --SET @currentMonth = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));        
 --SET @resultMonth = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));        
 --SET @lockMonth = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));        
 --SET @lastForecastMonth = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));        
        
 SELECT NULL  AS SNSEntryId        
  ,NULL  AS SNSEntryQtyPriceId        
   ,[MonthYear]        
    ,[CustomerCode]        
    ,[MaterialCode]        
    ,[Quantity]        
    ,[Amount]        
    ,[AccountCode]        
    FROM [dbo].[TRNSalesPlanning]        
    where [AccountCode]=@accountCode AND [MonthYear] = @resultMonth        
    and [CustomerCode] in (select Code from @tvpCustomerCodeList)        
    and [MaterialCode] in (select Code from @tvpMaterialCodeList)        
        
 UNION         
 SELECT SE.SNSEntryId,         
 SQ.SNSEntryQtyPriceId,         
 SQ.MonthYear,         
 SE.CustomerCode,         
 SE.MaterialCode,        
 SQ.Qty AS Quantity,         
 SQ.Price AS Amount,         
 SE.OACCode AS [AccountCode] FROM [dbo].[SNSEntry] SE        
 INNER JOIN [dbo].[SNSEntryQtyPrice] SQ        
 ON SE.SNSEntryId = SQ.SNSEntryId        
 where SE.OACCode=@accountCode    
-- AND SE.MonthYear >= @currentMonth AND SE.MonthYear <= @lastForecastMonth        
 --AND SE.MonthYear = @currentMonth  
 AND SQ.MonthYear >= @currentMonth AND SQ.MonthYear <= @lastForecastMonth        
 and SE.[CustomerCode] in (select Code from @tvpCustomerCodeList)        
 and SE.[MaterialCode] in (select Code from @tvpMaterialCodeList);        
             
END 