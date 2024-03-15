

alter table SaleEntryHeader
drop column ProductCategoryCode1 , ProductCategoryCode2;
GO

alter table SaleEntryHeader
alter column ProductCategoryId1 nvarchar(20) null ;
GO


alter table SaleEntryHeader
alter column ProductCategoryId2 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId1 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId2 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId3 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId4 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId5 nvarchar(20) null ;
GO

alter table SalesEntry
alter column ProductCategoryId6 nvarchar(20) null ;
GO


EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId1', 'ProductCategoryCode1', 'COLUMN';
EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId2', 'ProductCategoryCode2', 'COLUMN';
EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId3', 'ProductCategoryCode3', 'COLUMN';
EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId4', 'ProductCategoryCode4', 'COLUMN';
EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId5', 'ProductCategoryCode5', 'COLUMN';
EXEC sp_rename 'dbo.SalesEntry.ProductCategoryId6', 'ProductCategoryCode6', 'COLUMN';

alter table SalesEntry 
add  ModeOfType nvarchar(20) null ;
GO

/*SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME='SalesEntryPriceQuantity';
*/
-- execute above script and get the FK's related to ModeOfType and Currency

ALTER TABLE SalesEntryPriceQuantity
DROP CONSTRAINT FK__SalesEntr__Curre__2E5BD364, 
FK__SalesEntr__Curre__2F4FF79D, 
FK__SalesEntr__Modeo__30441BD6,
FK__SalesEntr__Modeo__3138400F;
GO




alter table SalesEntryPriceQuantity
drop column ModeOfTypeId, CurrencyId;
GO


alter table SalesEntryPriceQuantity
add  CurrencyCode nvarchar(20) null ;
GO

alter table [SalesEntryPriceQuantity]
drop column [AttachmentId];
GO

alter table [SaleEntryHeader]
add [AttachmentId] [int] NULL;
GO

alter table [SalesEntry]
drop column [ModeOfType];
GO

alter table [SalesEntry]
add [ModeOfTypeId] [int] NULL;
GO

ALTER TABLE [dbo].[SalesEntryPriceQuantity]
ADD [OCstatus] VARCHAR(50) NULL;

ALTER TABLE [dbo].[SalesArchivalEntryPriceQuantity]
ADD [OCstatus] VARCHAR(50) NULL;