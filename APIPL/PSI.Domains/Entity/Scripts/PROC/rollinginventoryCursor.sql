SET NOCOUNT ON;
DECLARE  
@MonthYear int,@MaterialCode varchar(100),@AccountCode varchar(100);

DECLARE EMP_CURSOR CURSOR DYNAMIC FOR
SELECT MonthYear,MaterialCode,AccountCode FROM TRNPricePlanning where MonthYear>=202311 and MonthYear<=202405   
and AccountCode='20603421' and ModeofType='INVENTORY' ;
--and MaterialCode='EH-HV11-K685'  ;

OPEN EMP_CURSOR;
FETCH NEXT FROM EMP_CURSOR INTO @MonthYear,@MaterialCode,@AccountCode;

WHILE @@FETCH_STATUS = 0
BEGIN
   
    BEGIN
	 DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, CAST(@MonthYear AS VARCHAR(6)) + '01', 112);                        
                        
  DECLARE @resultMonthYear int= (                        
    SELECT CAST(FORMAT(DATEADD(month, - 1, @dtCurrentMonthYear), 'yyyyMM') AS INT)                        
    );    
	DECLARE @prvInvqty int=(select top 1 Quantity from TRNPricePlanning where MonthYear=@resultMonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='INVENTORY');

	DECLARE @purchaseqty int=(select top 1 Quantity from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='PURCHASE');

	DECLARE @mpoQty int=(select top 1 Quantity from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='MPO');

    DECLARE @adjQty int=(select top 1 Quantity from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='ADJ');

	DECLARE @saleQty int=(select top 1 Quantity from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='SALES');

	DECLARE  @currentInvtQty int= (ISNULL(@prvInvqty,0) + ISNULL(@purchaseqty,0) + ISNULL(@mpoQty,0) + ISNULL(@adjQty,0)) - ISNULL(@saleQty,0);


	DECLARE @prvInvPrice DECIMAL=(select top 1 Price from TRNPricePlanning where MonthYear=@resultMonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='INVENTORY');

	DECLARE @purchasePrice DECIMAL=(select top 1 Price from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='PURCHASE');

	DECLARE @mpoPrice DECIMAL=(select top 1 Price from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='MPO');

    DECLARE @adjPrice DECIMAL=(select top 1 Price from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='ADJ');

	DECLARE @salePrice DECIMAL=(select top 1 Price from TRNPricePlanning where MonthYear=@MonthYear and AccountCode=@AccountCode 
	and MaterialCode=@MaterialCode and  ModeofType='SALES');

	
	DECLARE  @currentInvtPrice DECIMAL= (ISNULL(@prvInvPrice,0) + ISNULL(@purchasePrice,0) + ISNULL(@mpoPrice,0) + ISNULL(@adjPrice,0)) - ISNULL(@salePrice,0);
	
	DECLARE  @curreivt int=(select  Quantity from TRNPricePlanning where @MonthYear=MonthYear and  MaterialCode=@MaterialCode 
 and AccountCode=@AccountCode and  ModeofType='INVENTORY');
 if(ISNULL(@curreivt,0)!=@currentInvtQty)
 begin
 --select @MonthYear,@MaterialCode,@AccountCode,@curreivt,@currentInvtQty
 UPDATE TRNPricePlanning SET Quantity = @currentInvtQty,Price=@currentInvtPrice,RollingInventoryISActive=0,UpdatedDate=GETDATE(),UpdatedBy='admin' WHERE CURRENT OF EMP_CURSOR;
 end		
        --
    END

    FETCH FROM EMP_CURSOR INTO @MonthYear,@MaterialCode,@AccountCode;
END

CLOSE EMP_CURSOR;
DEALLOCATE EMP_CURSOR;