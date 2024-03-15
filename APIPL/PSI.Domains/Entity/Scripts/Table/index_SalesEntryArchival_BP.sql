
IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SalesEntryArchival_BP_1' AND object_id = OBJECT_ID('dbo.SalesEntryArchival_BP'))
BEGIN
	CREATE INDEX ix_SalesEntryArchival_BP_1 
	ON dbo.SalesEntryArchival_BP(MonthYear, CustomerId,MaterialCode,ModeOfTypeId,BPYear);
END
GO

