create view VW_SalesEntryMaterial  
as  
select m.ProductCategoryId2 as mg2,ProductCategoryId3,s.*from SalesEntry  s  
inner join Material m on s.MaterialCode=m.MaterialCode  
go


alter proc [dbo].[SP_OcIndicationMonthConfirm]                                            
                                            
 @CompanyId varchar(max) =NULL,                                                
@CountryId varchar(max) =NULL,                                                
@CustomerId varchar(max) =NULL,                                            
@ProductCategoryId1 varchar(max) =NULL,                                                
@ProductCategoryId2 varchar(max) =NULL ,                                        
@MonthYear varchar(200)=NULL ,          
@CustomerTypeId varchar(max) =NULL          
                                            
as begin                                            
                                     
with CTE_tbl as                                           
( select  se.MonthYear, se.ocIndicationMonthAttachmentIds,                              
se.Remarks,se.SaleTypeId, se.OcIndicationMonthStatus,                             
(case when se.ModeOfTypeId=1 then  se.Quantity end) as OrderQunatity,                                        
(case when se.ModeOfTypeId=12 then  se.Quantity end) as SNSQunatity,0 as TotalQunatity,                                        
(case when se.ModeOfTypeId=1 then  se.Price end) as OrderPrice,                                        
(case when se.ModeOfTypeId=12 then  se.Price end) as SNSPrice,                                        
(case when se.ModeOfTypeId=12 then  se.Price end) as TotalPrice,                                        
se.SalesEntryId,                                    
se.Reason,                                    
se.CustomerId,                                    
m.CompanyId,                                    
c.CountryId,                                        
c.CustomerCode,C.IsCollabo,                                    
c.CustomerName,                                    
m.MaterialCode,                                    
se.ProductCategoryId1 ,                                    
m.ProductCategoryId3,                                  
p1.ProductCategoryCode+'-'+p1.ProductCategoryName as Mg,                                    
p2.ProductCategoryCode+'-'+p2.ProductCategoryName as Mg1,se.IsSNS                                 
,ROW_NUMBER() over(PARTITION BY m.MaterialCode,se.CustomerId,se.MonthYear ORDER BY se.SalesEntryId  DESC ) as rownumber                                  
from                                        
--SaleEntryHeader h  left join 
SalesEntry se                                  
--on se.SaleEntryHeaderId=se.SaleEntryHeaderId                                     
--inner join SalesEntryPriceQuantity OP                                          
--on se.SalesEntryId=se.SalesEntryId                                  
join Customer c on se.CustomerId=c.CustomerId                                        
join  Material m on se.MaterialId=m.MaterialId                                        
Left join  ProductCategory p1 on se.ProductCategoryId1=p1.ProductCategoryId                                        
Left join  ProductCategory p2 on m.ProductCategoryId3=p2.ProductCategoryId                                              
 where                                        
 se.ModeofTypeId in(1)  and se.Quantity>0 ) select * FROM CTE_tbl  where rownumber=1  and                              
 SaleTypeId=1 and                          
 (@MonthYear is NULL or (MonthYear=@MonthYear)) and                                        
 (@CompanyId is NULL or CompanyId in (SELECT value FROM STRING_SPLIT(@CompanyId, ','))) and                                        
 ( @CountryId is NULL or CountryId in (SELECT value FROM STRING_SPLIT(@CountryId, ','))) and            
   (@CustomerTypeId is NULL or IsCollabo=@CustomerTypeId) and           
  (@CustomerId is NULL or CustomerId in (SELECT value FROM STRING_SPLIT(@CustomerId, ','))) and                                         
   (@ProductCategoryId1 is NULL or ProductCategoryId1 in (SELECT value FROM STRING_SPLIT(@ProductCategoryId1, ',')))                                         
 and  (@ProductCategoryId2 is NULL or ProductCategoryId3 in (SELECT value FROM STRING_SPLIT(@ProductCategoryId2, ',')))                                        
          
                                        
                                        
end 
go

      
CREATE view [dbo].[DirectSaleView]          
as          
select se.SalesEntryId,se.CurrentMonthYear,  
se.MonthYear,se.Quantity,se.Price,se.ModeOfTypeId,  
se.CustomerId,      
m.CompanyId,      
c.CountryId,          
c.CustomerCode,      
c.CustomerName,      
m.MaterialCode,      
se.ProductCategoryId1,      
se.ProductCategoryId2 ,          
p1.ProductCategoryName as Mg,      
p2.ProductCategoryName as Mg1    
         
from 
--SaleEntryHeader h          
--inner join 
SalesEntry se          
--on se.SaleEntryHeaderId=se.SaleEntryHeaderId      
--inner join SalesEntryPriceQuantity q on se.SalesEntryId=se.SalesEntryId    
join Customer c on se.CustomerId=c.CustomerId          
join  Material m on se.MaterialId=m.MaterialId          
Left join  ProductCategory p1 on se.ProductCategoryId1=p1.ProductCategoryId          
Left join  ProductCategory p2 on se.ProductCategoryId1=p2.ProductCategoryId   
go

    
                                     
alter PROCEDURE [dbo].[Sp_Direct_SNS_Archive] (      
 @CurrentMonth CHAR(6) = NULL      
 ,@CreatedBy NVARCHAR(max) = NULL      
 ,@Global_Current_Month CHAR(6) = NULL      
 ,@Lock_Month CHAR(6) = NULL      
 ,@SalesType NVARCHAR(50) = NULL      
 )      
AS      
BEGIN      
 SET NOCOUNT ON      
      
 DECLARE @error TABLE (      
  error NVARCHAR(max)      
  ,Id VARCHAR(max)      
  ,SaleType VARCHAR(50)      
  );      
 --Direct Sale                            
 --DECLARE @SaleEntryHeaderIds TABLE (Id INT);      
 DECLARE @SalesEntryIds TABLE (Id INT);      
 --DECLARE @SalesArchivalEntryId TABLE (Id INT);      
 DECLARE @DirectSaleIds VARCHAR(max);      
 --SNS                            
 DECLARE @SNSEntryIds TABLE (Id INT);      
 DECLARE @SNSIds VARCHAR(max);      
      
 BEGIN TRY      
  BEGIN TRANSACTION      
      
  --Direct Sale start                            
  INSERT INTO @SalesEntryIds      
  SELECT SalesEntryId      
  FROM SalesEntry      
  WHERE CurrentMonthYear = @CurrentMonth and SaleSubType=@SalesType;      
      
UPDATE SalesEntryArchival SET ArchiveStatus='' WHERE CurrentMonthYear = @CurrentMonth    
and SaleSubType=@SalesType;    
    
    
  SELECT @DirectSaleIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')      
  FROM @SalesEntryIds;      
      
  
  --if data is exist is table then first delete and insert                                 
  IF (      
    SELECT count(*)      
    FROM SalesEntryId      
    WHERE SalesEntryId IN (      
      SELECT id      
      FROM @SalesEntryIds      
      )      
    ) > 0      
  BEGIN      
  
   DELETE      
   FROM SalesEntryArchival      
   WHERE SalesEntryId IN (      
     SELECT id      
     FROM @SalesEntryIds      
     );      
      
       
   
      
  INSERT INTO dbo.SalesEntryArchival (      
     [SalesEntryId]
           ,[MaterialId]
           ,[MaterialCode]
           ,[CustomerCode]
           ,[CustomerId]
           ,[CurrentMonthYear]
           ,[LockMonthYear]
           ,[SaleTypeId]
           ,[SaleSubType]
           ,[ProductCategoryId1]
           ,[ProductCategoryId2]
           ,[ModeOfTypeId]
           ,[MonthYear]
           ,[Price]
           ,[Quantity]
           ,[ProductCategoryCode1]
           ,[ProductCategoryCode2]
           ,[ProductCategoryCode3]
           ,[ProductCategoryCode4]
           ,[ProductCategoryCode5]
           ,[ProductCategoryCode6]
           ,[OCmonthYear]
           ,[OCstatus]
           ,[O_LockMonthConfirmedStatus]
           ,[O_LockMonthConfirmedBy]
           ,[O_LockMonthConfirmedDate]
           ,[AttachmentId]
           ,[OrderIndicationConfirmedBySaleTeam]
           ,[OrderIndicationConfirmedBySaleTeamDate]
           ,[OrderIndicationConfirmedByMarketingTeam]
           ,[OrderIndicationConfirmedByMarketingTeamDate]
           ,[O_LockMonthConfirmedBy1]
           ,[O_LockMonthConfirmedDate1]
           ,[Reason]
           ,[IsSNS]
           ,[IsPO]
           ,[TermId]
           ,[Remarks]
           ,[CurrencyCode]
           ,[OcIndicationMonthAttachmentIds]
           ,[OcIndicationMonthStatus]
           ,[ArchiveDate]
           ,[ArchiveBy]
           ,[ArchiveStatus]
           ,[ArchivalMonthYear]
           ,[CreatedDate]
           ,[CreatedBy]
           ,[UpdateDate]
           ,[UpdateBy])      
        
  SELECT DISTINCT  [SalesEntryId]
           ,[MaterialId]
           ,[MaterialCode]
           ,[CustomerCode]
           ,[CustomerId]
           ,[CurrentMonthYear]
           ,[LockMonthYear]
           ,[SaleTypeId]
           ,[SaleSubType]
           ,[ProductCategoryId1]
           ,[ProductCategoryId2]
           ,[ModeOfTypeId]
           ,[MonthYear]
           ,[Price]
           ,[Quantity]
           ,[ProductCategoryCode1]
           ,[ProductCategoryCode2]
           ,[ProductCategoryCode3]
           ,[ProductCategoryCode4]
           ,[ProductCategoryCode5]
           ,[ProductCategoryCode6]
           ,[OCmonthYear]
           ,[OCstatus]
           ,[O_LockMonthConfirmedStatus]
           ,[O_LockMonthConfirmedBy]
           ,[O_LockMonthConfirmedDate]
           ,[AttachmentId]
           ,[OrderIndicationConfirmedBySaleTeam]
           ,[OrderIndicationConfirmedBySaleTeamDate]
           ,[OrderIndicationConfirmedByMarketingTeam]
           ,[OrderIndicationConfirmedByMarketingTeamDate]
           ,[O_LockMonthConfirmedBy1]
           ,[O_LockMonthConfirmedDate1]
           ,[Reason]
           ,[IsSNS]
           ,[IsPO]
           ,[TermId]
           ,[Remarks]
           ,[CurrencyCode]
           ,[OcIndicationMonthAttachmentIds]
           ,[OcIndicationMonthStatus]
           ,GETDATE()
           ,@CreatedBy
           ,'Archived'
           ,@CurrentMonth   
           ,[CreatedDate]
           ,[CreatedBy]
           ,[UpdateDate]
           ,[UpdateBy]    
  FROM SalesEntry      
  WHERE SalesEntryId IN (      
    SELECT id      
    FROM @SalesEntryIds      
    );      
      
    end                     
  --Direct Sale end                            
  --SNS Start     
  if(@SalesType='Monthly')  
  begin  
    
   delete from TRNPricePlanningArchival where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                        
   insert into TRNPricePlanningArchival    
   (AccountCode,    
   MonthYear,    
   MaterialCode,    
   ModeofType,    
   Type,    
   Quantity,    
   CreatedDate,    
   CreatedBy,    
   UpdatedDate,    
   UpdatedBy,    
    Price,    
   CurrentMonthYear,    
   ArchivalDate,    
   ArchiveStatus    
   )    
   select AccountCode    
   ,MonthYear    
   ,MaterialCode    
   ,ModeofType    
   ,Type    
   ,Quantity    
   ,CreatedDate    
   ,CreatedBy    
   ,UpdatedDate    
   ,UpdatedBy    
   ,Price    
   ,@CurrentMonth    
   ,GETDATE()    
   ,'Archived'    
   from TRNPricePlanning;    
    
  delete TRNSalesPlanningArchival where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                     
 insert into TRNSalesPlanningArchival    
 (    
 MonthYear,    
 CustomerCode,    
 MaterialCode,    
 Quantity,    
 Amount,    
 AccountCode,    
 CreatedDate,    
 CreatedBy,    
 UpdatedDate,    
 UpdatedBy,    
 ArchivalDate,    
 Price,    
 ArchiveStatus    
 )    
 select  MonthYear,    
 CustomerCode,    
 MaterialCode,    
 Quantity,    
 Amount,    
 AccountCode,    
 CreatedDate,    
 CreatedBy,    
 UpdatedDate,    
 UpdatedBy,    
 getdate(),    
 Price,    
 'Archived'    
 from TRNSalesPlanning where MonthYear=@CurrentMonth    
  end  
  else   
  begin  
  
    
   delete from TRNPricePlanningArchival_BP where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                        
   insert into TRNPricePlanningArchival_BP   
   (AccountCode,    
   MonthYear,    
   MaterialCode,    
   ModeofType,    
   Type,    
   Quantity,    
   CreatedDate,    
   CreatedBy,    
   UpdatedDate,    
   UpdatedBy,    
    Price,    
   ArchivalDate,    
   ArchiveStatus    
   )    
   select AccountCode    
   ,MonthYear    
   ,MaterialCode    
   ,ModeofType    
   ,Type    
   ,Quantity    
   ,CreatedDate    
   ,CreatedBy    
   ,UpdatedDate    
   ,UpdatedBy    
   ,Price    
   ,GETDATE()    
   ,'Archived'    
   from TRNPricePlanning_BP;    
    
  delete TRNSalesPlanningArchival_BP where ArchiveStatus='Archived' and MonthYear=@CurrentMonth;                     
 insert into TRNSalesPlanningArchival_BP    
 (    
 MonthYear,    
 CustomerCode,    
 MaterialCode,    
 Quantity,    
 Amount,    
 AccountCode,    
 CreatedDate,    
 CreatedBy,    
 UpdatedDate,    
 UpdatedBy,    
 ArchivalDate,    
 Price,    
 ArchiveStatus    
 )    
 select  MonthYear,    
 CustomerCode,    
 MaterialCode,    
 Quantity,    
 Amount,    
 AccountCode,    
 CreatedDate,    
 CreatedBy,    
 UpdatedDate,    
 UpdatedBy,    
 getdate(),    
 Price,    
 'Archived'    
 from TRNSalesPlanning_BP where MonthYear=@CurrentMonth   
  end  
  --sns end    
                             
  SELECT @SNSIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')      
  FROM @SNSEntryIds;      
      
  COMMIT;      
 END TRY      
      
 BEGIN CATCH      
  ROLLBACK;      
      
  INSERT INTO @error (      
   error      
   ,id      
   )      
  VALUES (      
   ERROR_MESSAGE()      
   ,@SNSIds      
   );      
 END CATCH;      
      
 IF (      
   SELECT count(*)      
   FROM @error      
   ) = 0      
 BEGIN      
  INSERT INTO @error (      
   id      
   ,error      
   ,SaleType      
   )      
  VALUES (      
   @DirectSaleIds      
   ,NULL      
   ,'Direct'      
   );      
      
  INSERT INTO @error (      
   id      
   ,error      
   ,SaleType      
   )      
  VALUES (      
   @SNSIds      
   ,NULL      
   ,'SNS'      
   );      
      
  SELECT *      
  FROM @error      
 END      
 ELSE      
 BEGIN      
  SELECT *      
  FROM @error      
 END      
END 

go

  
  
  
Create VIEW [dbo].[VW_DIRECT_SALE]  
AS  
WITH TEMP (  
 SalesEntryId  
 ,CustomerId  
 ,ProductCategoryId1  
 ,ProductCategoryId2  
 ,CurrentMonthYear  
 ,LockMonthYear  
 ,MaterialId  
 ,OCmonthYear  
 ,MonthYear  
 ,Price  
 ,Quantity  
 ,ModeOfTypeId  
 ,SaleSubType  
 ,CurrencyCode  
 )  
AS (  SELECT
   SE.SalesEntryId
  ,SE.CustomerId  
  ,SE.ProductCategoryId1  
  ,SE.ProductCategoryId2  
  ,SE.CurrentMonthYear  
  ,SE.LockMonthYear  
  ,SE.MaterialId  
  ,SE.OCmonthYear  
  ,SE.MonthYear  
  ,SE.Price  
  ,SE.Quantity  
  ,SE.ModeOfTypeId  
  ,SE.SaleSubType  
  ,SE.CurrencyCode  
 FROM SalesEntry SE 
 where SE.OCstatus='Y'  
 )  
SELECT 
 T.SalesEntryId  
 ,C.CustomerCode  
 ,T.CurrentMonthYear  
 ,T.LockMonthYear  
 ,M.MaterialCode  
 ,T.OCmonthYear  
 ,T.MonthYear  
 ,T.Price  
 ,T.Quantity  
 ,T.ModeOfTypeId  
 ,T.SaleSubType  
 ,MT.ModeofTypeCode  
 ,MT.ModeofTypeName  
 ,CurrencyCode  
FROM TEMP T  
INNER JOIN Customer C ON T.CustomerID = C.CustomerID  
INNER JOIN Material M ON M.MaterialId = T.MaterialId  
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId  
 --select * from Customer    

 go

   --exec SP_DirectSales_Report 32,51,null,'Monthly'
 ALTER PROC [dbo].[SP_DirectSales_Report] (    
 @CustomerId INT  ,
 @ProductCategoryId INT,
 @ProductSubCategoryId INT=NULL,
 @SaleSubType VARCHAR(20)
 )  
 AS BEGIN  
 CREATE TABLE #TEMPDIRECT  
 (  
 Consignee varchar(30),  
 Item_Code varchar(30),  
 [Group] varchar(100),  
 [SubGroup] varchar(100),  
 MonthYear varchar(10),  
 OrderQty int,  
 PurchaseQty int,  
 SaleQty int,  
 InventoryQty int,  
 MpoQty int,  
 AdjQty int,  
 OrderAmount decimal(18,2),  
 PurchaseAmount decimal(18,2),  
 SaleAmount decimal(18,2),  
 InventoryAmount decimal(18,2),  
 MpoAmount decimal(18,2),  
 AdjAmount decimal(18,2)  
 );  
  
  WITH OrderData                
 AS (  
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as OrderQty  
 ,Price*Quantity as OrderAmount   
 from   
 SalesEntry  where ModeOfTypeId=1 
 and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId
 ),  
 PurchaseData  
 as (  
   
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as PurchaseQty  
 ,Price*Quantity as PurchaseAmount   
 from   
 SalesEntry  where ModeOfTypeId=2 
 and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId 
 )  
 ,  
 SaleData  
 as (  
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as SaleQty  
 ,Price*Quantity as SaleAmount   
 from   
 SalesEntry  where ModeOfTypeId=3 
 and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId 
 )  
 ,  
 InventoryData  
 as (  
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as InventoryQty  
 ,Price*Quantity as InventoryAmount   
 from   
 SalesEntry  where ModeOfTypeId=4 
 and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId
 ),  
  ADJData  
 as (  
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as ADJQty  
 ,Price*Quantity as ADJAmount   
 from   
 SalesEntry  where ModeOfTypeId=10 
 and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId
 )  
 ,  
  MPOData  
 as (  
 select CustomerCode,MaterialCode,MonthYear  
 ,Quantity as MPOQty  
 ,Price*Quantity as MPOAmount   
 from   
 SalesEntry  where ModeOfTypeId=12 
  and CustomerId=@CustomerId and  ProductCategoryId1=@ProductCategoryId
 and SaleSubType=@SaleSubType and 
 @ProductSubCategoryId IS NULL or  ProductCategoryId2=@ProductSubCategoryId
 )  
 INSERT INTO  #TEMPDIRECT  
 (  
 Consignee ,  
 Item_Code ,  
 [Group] ,  
 [SubGroup],  
 MonthYear ,  
 OrderQty ,  
 PurchaseQty ,  
 SaleQty ,  
 InventoryQty ,  
 MpoQty ,  
 AdjQty ,  
 OrderAmount ,  
 PurchaseAmount ,  
 SaleAmount ,  
 InventoryAmount ,  
 MpoAmount ,  
 AdjAmount   
 )  
 SELECT   
  OD.CustomerCode ,  
 OD.MaterialCode ,  
M.ProductCategoryCode2+'-'+ M.ProductCategoryName2  AS  [Group],  
M.ProductCategoryCode3+'-'+ M.ProductCategoryName3 AS  [SubGroup],  
 OD.MonthYear ,  
 OrderQty ,  
 PurchaseQty ,  
 SaleQty ,  
 InventoryQty ,  
 MpoQty ,  
 AdjQty ,  
 OrderAmount ,  
 PurchaseAmount ,  
 SaleAmount ,  
 InventoryAmount ,  
 MpoAmount ,  
 AdjAmount   
  FROM OrderData OD    
  JOIN MaterialView M ON OD.MaterialCode=M.MaterialCode  
   JOIN PurchaseData PD ON OD.CustomerCode = PD.CustomerCode                
  AND OD.MaterialCode = PD.MaterialCode                
  AND OD.MonthYear = PD.MonthYear                
 JOIN SaleData SD ON OD.CustomerCode = SD.CustomerCode                
  AND OD.MaterialCode = SD.MaterialCode                
  AND OD.MonthYear = SD.MonthYear                
 JOIN InVentoryData ID ON OD.CustomerCode = ID.CustomerCode                
  AND OD.MaterialCode = ID.MaterialCode                
  AND OD.MonthYear = ID.MonthYear         
  JOIN ADJData ADJ ON OD.CustomerCode = ADJ.CustomerCode                
  AND OD.MaterialCode = ADJ.MaterialCode                
  AND OD.MonthYear = ADJ.MonthYear         
  JOIN MPOData MPO ON OD.CustomerCode = MPO.CustomerCode                
  AND OD.MaterialCode = MPO.MaterialCode                
  AND OD.MonthYear = MPO.MonthYear ;  
  SELECT *FROM #TEMPDIRECT;  
  
 END
 go