IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNSalesPlanningArchival_BP_1' AND object_id = OBJECT_ID('dbo.TRNSalesPlanningArchival_BP'))
BEGIN
	CREATE INDEX ix_TRNSalesPlanningArchival_BP_1 
	ON dbo.TRNSalesPlanningArchival_BP(MaterialCode, CustomerCode,MonthYear,BP_YEAR);
END
GO