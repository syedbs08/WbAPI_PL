

IF NOT EXISTS (SELECT * FROM sys.indexes 
WHERE name='ix_Customer_2' AND object_id = OBJECT_ID('dbo.Customer'))
BEGIN
	CREATE INDEX ix_Customer_2 
	ON dbo.Customer(CustomerCode);
END
GO