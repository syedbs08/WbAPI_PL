
IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SalesEntry_1' AND object_id = OBJECT_ID('dbo.SalesEntry'))
BEGIN
	CREATE INDEX ix_SalesEntry_1 
	ON dbo.SalesEntry(MonthYear, CustomerId,MaterialCode,ModeOfTypeId);
END
GO