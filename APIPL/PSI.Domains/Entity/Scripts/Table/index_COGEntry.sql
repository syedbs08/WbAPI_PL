IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_COGEntry_1' AND object_id = OBJECT_ID('dbo.COGEntry'))
BEGIN
	CREATE INDEX ix_COGEntry_1 
	ON dbo.COGEntry(CustomerCode, MaterialCode,SaleSubType);
END
GO