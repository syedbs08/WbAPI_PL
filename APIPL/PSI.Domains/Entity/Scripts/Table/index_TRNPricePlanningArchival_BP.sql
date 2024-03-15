


IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNPricePlanningArchival_BP_1' AND object_id = OBJECT_ID('dbo.TRNPricePlanningArchival_BP'))
BEGIN
	CREATE INDEX ix_TRNPricePlanningArchival_BP_1
	ON dbo.TRNPricePlanningArchival_BP(ModeofType,MaterialCode,AccountCode,MonthYear,BP_YEAR);
END
GO