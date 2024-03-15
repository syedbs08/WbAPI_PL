IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_AdjustmentEntryQtyPrice_1' AND object_id = OBJECT_ID('dbo.AdjustmentEntryQtyPrice'))
BEGIN
	CREATE INDEX ix_AdjustmentEntryQtyPrice_1 
	ON dbo.AdjustmentEntryQtyPrice(AdjustmentEntryId, MonthYear);
END
GO