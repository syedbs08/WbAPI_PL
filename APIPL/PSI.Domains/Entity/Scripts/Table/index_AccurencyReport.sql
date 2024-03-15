IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_AccurencyReport_1' AND object_id = OBJECT_ID('dbo.AccurencyReport'))
BEGIN
	CREATE INDEX ix_AccurencyReport_1 
	ON dbo.AccurencyReport(MonthYear,CustomerCode,MaterialCode,Period);
END
GO