/****** Object:  UserDefinedFunction [dbo].[UDF_GetPSQuantityValueForConsolidation]    Script Date: 8/21/2023 11:50:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Function [dbo].[UDF_GetPSQuantityValueForConsolidation]
(
   @Type varchar(50),
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
   
  )
   RETURNS    INT
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID
	DECLARE @Result INT=0

	 SELECT @Result = SUM(SP.Quantity)    
	 FROM SaleEntryHeader SH    
	  JOIN SalesEntry SE ON SH.SaleEntryHeaderId = SE.SaleEntryHeaderId    
	  JOIN SalesEntryPriceQuantity SP ON SP.SalesEntryId = SE.SalesEntryId    
	 WHERE SP.OCstatus='Y' AND SH.SaleSubType =@Type AND SE.ModeOfTypeId   in (1,12,10)
			AND SP.MonthYear = @MonthYear AND sh.CustomerCode = @CustomerCode 
			AND SE.MaterialCode =  @MaterialCode

		--SET @Result =(select sum(Quantity) from VW_DIRECT_SALE_TRANSMISSION where SaleSubType=@Type AND ModeOfTypeId in (1,12,10) AND 
		--MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	RETURN @Result
END

