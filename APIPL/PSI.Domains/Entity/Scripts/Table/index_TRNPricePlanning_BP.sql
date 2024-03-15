


IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNPricePlanning_BP_2' AND object_id = OBJECT_ID('dbo.TRNPricePlanning_BP'))
BEGIN
	CREATE INDEX ix_TRNPricePlanning_BP_2
	ON dbo.TRNPricePlanning_BP(ModeofType,MaterialCode,AccountCode,MonthYear,BP_YEAR);
END
GO