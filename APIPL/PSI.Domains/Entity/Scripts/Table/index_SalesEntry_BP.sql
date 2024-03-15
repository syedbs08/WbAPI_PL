
IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SalesEntry_BP_1' AND object_id = OBJECT_ID('dbo.SalesEntry_BP'))
BEGIN
	CREATE INDEX ix_SalesEntry_BP_1 
	ON dbo.SalesEntry_BP(MonthYear, CustomerId,MaterialCode,ModeOfTypeId,BPYear);
END
GO