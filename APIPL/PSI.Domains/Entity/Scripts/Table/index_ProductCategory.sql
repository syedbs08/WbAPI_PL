IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_ProductCategory_1' AND object_id = OBJECT_ID('dbo.ProductCategory'))
BEGIN
	CREATE INDEX ix_ProductCategory_1 
	ON dbo.ProductCategory(ProductCategoryId);
END
GO
