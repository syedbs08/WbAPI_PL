IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SSDEntry_1' AND object_id = OBJECT_ID('dbo.SSDEntry'))
BEGIN
	CREATE INDEX ix_SSDEntry_1 
	ON dbo.SSDEntry(MaterialCode,CustomerCode, MonthYear);
END
GO