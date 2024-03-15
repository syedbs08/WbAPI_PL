IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_COGEntryQtyPrice_1' AND object_id = OBJECT_ID('dbo.COGEntryQtyPrice'))
BEGIN
	CREATE INDEX ix_COGEntryQtyPrice_1 
	ON dbo.COGEntryQtyPrice(COGEntryId, MonthYear);
END
GO