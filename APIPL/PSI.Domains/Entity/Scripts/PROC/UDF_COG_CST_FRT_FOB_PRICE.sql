/****** Object:  UserDefinedFunction [dbo].[UDF_COG_CST_FRT_FOB_PRICE]    Script Date: 8/22/2023 11:32:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Function [dbo].[UDF_COG_CST_FRT_FOB_PRICE]
(
  @ChargeType  Varchar(50),
  @SaleTypeId int,
  @SaleSubType Varchar(50),
  @MaterialCode Varchar(50),
  @CustomerCode varchar(50),
  @MonthYear INT
  )
   RETURNS    DECIMAL(18,2)
as
BEGIN
		DECLARE @Result DECIMAL(18,2)=0
		SET @Result=(SELECT cogp.Qty*cogp.Price FROM COGEntry cog 
LEFT JOIN COGEntryQtyPrice cogp ON cog.COGEntryId = cogp.COGEntryId
WHERE CustomerCode=@CustomerCode and MaterialCode=@MaterialCode
and cog.SaleSubType=@SaleSubType and  cogp.MonthYear=@MonthYear
and  cogp.ChargeType=@ChargeType and cog.SaleTypeId=@SaleTypeId)
		
		
		return @Result
END

