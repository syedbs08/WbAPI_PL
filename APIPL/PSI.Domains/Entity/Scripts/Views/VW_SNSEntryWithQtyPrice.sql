CREATE VIEW [dbo].[VW_SNSEntryWithQtyPrice]
AS
select SE.CustomerId, SE.CustomerCode, CS.CustomerName, SE.MaterialId, 
SE.MaterialCode, SE.OACCode, SE.SNSEntryId,
SQP.SNSEntryQtyPriceId, CAST(SQP.MonthYear AS INT) AS MonthYear, SQP.Qty, SQP.Price from [dbo].[SNSEntry] SE
INNER JOIN [dbo].[SNSEntryQtyPrice] SQP
ON SE.SNSEntryId = SQP.SNSEntryId
INNER JOIN CUSTOMER CS
ON SE.CustomerId = CS.CustomerId;
GO