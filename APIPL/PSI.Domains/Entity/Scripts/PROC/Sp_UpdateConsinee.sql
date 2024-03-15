  
alter PROCEDURE Sp_UpdateConsinee    
@userId nvarchar(200),    
@accountCode nvarchar(100)=null,    
@currentMonth int ,
@lockMonth int ,
@resultMonth int ,
@forecasteMonth int
AS    
BEGIN    
 SET NOCOUNT ON;      
    
      
 EXEC SP_Insert_TRNPricePlanning @userId ,
 @currentMonth,@lockMonth, @resultMonth,@forecasteMonth
    
-- For sending Account code and Material code Table datatype  
-- Need to discuss this thing. But for now only testing  
  
Declare @tmp TVP_ACCOUNT_MATERIAL_CODE_LIST;  
Insert into @tmp(AccountCode,MaterialCode)  
values(@accountCode,'')  
  
-- end--  
  
 EXEC SP_Calculate_RollingInventory @userId, @tmp    
    
 select TRNPricePlanningId,AccountCode,MonthYear,MaterialCode,ModeOfType from TRNPricePlanning where MonthYear=@currentMonth    
    
END    