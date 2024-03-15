


IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_TRNPricePlanningArchival_2' AND object_id = OBJECT_ID('dbo.TRNPricePlanningArchival'))
BEGIN
	CREATE INDEX ix_TRNPricePlanningArchival_2
	ON dbo.TRNPricePlanningArchival(ModeofType,MaterialCode,AccountCode,MonthYear);
END
GO