DROP view IF EXISTS [dbo].[MaterialView] ;

/****** Object:  View [dbo].[MaterialView]    Script Date: 5/17/2023 6:02:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[MaterialView]      
as      
select m.MaterialId,m.MaterialCode,m.MaterialShortDescription,m.CompanyId,c.CompanyName,      
m.BarCode,m.SeaPortId,s.SeaPortName,m.AirPortId,a.AirPortName,sup.SupplierId,sup.SupplierName,      
m.ProductCategoryId1,prod1.ProductCategoryName as ProductCategoryName1, prod1.ProductCategoryCode as ProductCategoryCode1,      
m.ProductCategoryId2,prod2.ProductCategoryName as ProductCategoryName2, prod2.ProductCategoryCode as ProductCategoryCode2,     
m.ProductCategoryId3,prod3.ProductCategoryName as ProductCategoryName3, prod3.ProductCategoryCode as ProductCategoryCode3,     
m.ProductCategoryId4,prod4.ProductCategoryName as ProductCategoryName4, prod4.ProductCategoryCode as ProductCategoryCode4,     
m.ProductCategoryId5,prod5.ProductCategoryName as  ProductCategoryName5, prod5.ProductCategoryCode as ProductCategoryCode5,      
m.ProductCategoryId6,prod6.ProductCategoryName as ProductCategoryName6, prod6.ProductCategoryCode as ProductCategoryCode6,     
m.Weight,m.Volume, m.IsActive ,m.InSap
 ,m.CreatedBy,  
CONVERT(VARCHAR(10),m.UpdateDate,111) as UpdateDate,  
CONVERT(VARCHAR(10),m.CreatedDate,111) as CreatedDate,  
CONVERT(VARCHAR(10),m.UpdateDate,101) as UpdateDate1,  
CONVERT(VARCHAR(10),m.CreatedDate,101) as CreatedDate1  
,m.UpdateBy,STRING_AGG(mapping.CountryId, ',') AS CountryIds,      
STRING_AGG(country.CountryName, ',') AS CountryNames      
from Material m      
left join MaterialCountryMapping mapping on m.MaterialId=mapping.MaterialId      
left join Country country on mapping.CountryId=country.CountryId      
left join Company c on m.CompanyId=c.CompanyId      
left join ProductCategory prod1 on m.ProductCategoryId1=prod1.ProductCategoryId      
left join ProductCategory prod2 on m.ProductCategoryId2=prod2.ProductCategoryId      
left join ProductCategory prod3 on m.ProductCategoryId3=prod3.ProductCategoryId      
left join ProductCategory prod4 on m.ProductCategoryId4=prod4.ProductCategoryId      
left join ProductCategory prod5 on m.ProductCategoryId5=prod5.ProductCategoryId      
left join ProductCategory prod6 on m.ProductCategoryId6=prod6.ProductCategoryId      
left join SeaPort s on m.SeaPortId=s.SeaPortId      
left join AirPort a on m.AirPortId=a.AirPortId      
left join Supplier sup on m.SupplierId=sup.SupplierId      
      
group by m.MaterialId,m.MaterialCode,m.MaterialShortDescription,m.CompanyId,c.CompanyName,      
m.BarCode,m.SeaPortId,s.SeaPortName,m.AirPortId,a.AirPortName,sup.SupplierId,sup.SupplierName,      
m.ProductCategoryId1,prod1.ProductCategoryName,  prod1.ProductCategoryCode,     
m.ProductCategoryId2,prod2.ProductCategoryName , prod2.ProductCategoryCode,     
m.ProductCategoryId3,prod3.ProductCategoryName , prod3.ProductCategoryCode,     
m.ProductCategoryId4,prod4.ProductCategoryName,  prod4.ProductCategoryCode,    
m.ProductCategoryId5,prod5.ProductCategoryName , prod5.ProductCategoryCode,     
m.ProductCategoryId6,prod6.ProductCategoryName , prod6.ProductCategoryCode,     
m.InSap,m.Weight,m.Volume,m.IsActive,m.CreatedDate      
,m.CreatedBy,m.UpdateDate,m.UpdateBy 


GO