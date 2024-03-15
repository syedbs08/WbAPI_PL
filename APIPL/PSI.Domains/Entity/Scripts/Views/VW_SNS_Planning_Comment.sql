CREATE VIEW VW_SNS_Planning_Comment
AS
select PC.*, U.Name as CreatedByName from [dbo].[SNS_Planning_Comment] PC
LEFT JOIN Users U
ON PC.CreatedBy = U.UserId;