

IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_AdjustmentEntry_2' AND object_id = OBJECT_ID('dbo.AdjustmentEntry'))
BEGIN
	CREATE INDEX ix_AdjustmentEntry_2 
	ON dbo.AdjustmentEntry(MonthYear,MaterialCode, CustomerCode);
END
GO
