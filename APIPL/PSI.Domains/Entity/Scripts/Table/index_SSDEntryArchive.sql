IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_SSDEntryArchive_1' AND object_id = OBJECT_ID('dbo.SSDEntryArchive'))
BEGIN
	CREATE INDEX ix_SSDEntryArchive_1 
	ON dbo.SSDEntryArchive(MaterialCode,CustomerCode, MonthYear);
END
GO