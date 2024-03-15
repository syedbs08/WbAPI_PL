IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNSalesPlanning_BP_1' AND object_id = OBJECT_ID('dbo.TRNSalesPlanning_BP'))
BEGIN
	CREATE INDEX ix_TRNSalesPlanning_BP_1 
	ON dbo.TRNSalesPlanning_BP(MaterialCode, CustomerCode,MonthYear,BP_YEAR);
END
GO