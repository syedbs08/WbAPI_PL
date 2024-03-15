


IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_trnpRicePlanning_2' AND object_id = OBJECT_ID('dbo.trnpRicePlanning'))
BEGIN
	CREATE INDEX ix_trnpRicePlanning_2
	ON dbo.trnpRicePlanning(ModeofType,MaterialCode,AccountCode,MonthYear);
END
GO