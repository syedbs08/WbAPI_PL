IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNSalesPlanningArchival_1' AND object_id = OBJECT_ID('dbo.TRNSalesPlanningArchival'))
BEGIN
	CREATE INDEX ix_TRNSalesPlanningArchival_1 
	ON dbo.TRNSalesPlanningArchival(MaterialCode, CustomerCode,MonthYear);
END
GO