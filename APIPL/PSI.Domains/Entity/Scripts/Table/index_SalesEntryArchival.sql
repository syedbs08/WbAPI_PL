
IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SalesEntryArchival_1' AND object_id = OBJECT_ID('dbo.SalesEntryArchival'))
BEGIN
	CREATE INDEX ix_SalesEntryArchival_1 
	ON dbo.SalesEntryArchival(MonthYear, CustomerId,MaterialCode,ModeOfTypeId);
END
GO