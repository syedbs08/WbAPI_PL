IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNSalesPlanning_1' AND object_id = OBJECT_ID('dbo.TRNSalesPlanning'))
BEGIN
	CREATE INDEX ix_TRNSalesPlanning_1 
	ON dbo.TRNSalesPlanning(MaterialCode, CustomerCode,MonthYear);
END
GO