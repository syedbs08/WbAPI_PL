IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_Material_1' AND object_id = OBJECT_ID('dbo.Material'))
BEGIN
	CREATE INDEX ix_Material_1 
	ON dbo.Material(MaterialCode);
END
GO