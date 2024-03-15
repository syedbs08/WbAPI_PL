USE [psidevdb01]
GO
/****** Object:  UserDefinedTableType [dbo].[SNS_FOB_Price]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[SNS_FOB_Price] AS TABLE(
	[RowIndex] [int] NULL,
	[Plant] [nvarchar](50) NULL,
	[Vendor] [nvarchar](50) NULL,
	[Cust_Code] [nvarchar](50) NULL,
	[Inco_Term] [nvarchar](50) NULL,
	[Termid] [nvarchar](50) NULL,
	[MaterailCode] [nvarchar](50) NULL,
	[From_Dt] [datetime] NULL,
	[To_Dt] [datetime] NULL,
	[Price] [nvarchar](50) NULL,
	[Price_Unit] [int] NULL,
	[Curr] [nvarchar](50) NULL,
	[Uom] [nvarchar](50) NULL,
	[Port] [nvarchar](10) NULL,
	[ModeTypeOf] [nvarchar](10) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[SNS_Sales_Price]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[SNS_Sales_Price] AS TABLE(
	[RowIndex] [int] NULL,
	[Sales_Org] [nvarchar](10) NULL,
	[Dist_Chnl] [nvarchar](10) NULL,
	[Cust_Code] [nvarchar](10) NULL,
	[Ship_Mode] [nvarchar](10) NULL,
	[Inco_Term] [nvarchar](50) NULL,
	[Termid] [nvarchar](10) NULL,
	[MaterailCode] [nvarchar](50) NULL,
	[From_Dt] [datetime] NULL,
	[To_Dt] [datetime] NULL,
	[Price] [decimal](18, 2) NULL,
	[Price_Unit] [int] NULL,
	[Curr] [nvarchar](50) NULL,
	[Uom] [nvarchar](50) NULL,
	[ModeTypeOf] [nvarchar](10) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_ACCOUNT_CODE_MATERIAL_CODE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_ACCOUNT_CODE_MATERIAL_CODE_LIST] AS TABLE(
	[AccountCode] [nvarchar](max) NULL,
	[MaterialCode] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST] AS TABLE(
	[AccountCode] [nvarchar](max) NULL,
	[MaterialCode] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO] AS TABLE(
	[RowNo] [int] NOT NULL,
	[AccountCode] [nvarchar](max) NULL,
	[MaterialCode] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_Adjustment_ENTRIES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_Adjustment_ENTRIES] AS TABLE(
	[CustomerCode] [varchar](20) NULL,
	[MaterialCode] [varchar](20) NULL,
	[AttachmentID] [int] NULL,
	[RowNum] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_Adjustment_PRICE_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_Adjustment_PRICE_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [varchar](20) NULL,
	[Price] [varchar](200) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_Adjustment_QTY_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_Adjustment_QTY_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [varchar](20) NULL,
	[Qty] [varchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CODE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CODE_LIST] AS TABLE(
	[Code] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CODE_LIST_WITH_ROW_NO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CODE_LIST_WITH_ROW_NO] AS TABLE(
	[RowNo] [int] NOT NULL,
	[Code] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_COG_ENTRIES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_COG_ENTRIES] AS TABLE(
	[CustomerCode] [varchar](50) NULL,
	[CustomerName] [varchar](100) NULL,
	[MaterialCode] [varchar](50) NULL,
	[RowNum] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_COG_PRICE_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_COG_PRICE_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [varchar](10) NULL,
	[Price] [varchar](200) NULL,
	[ChargeType] [varchar](200) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_COG_QTY_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_COG_QTY_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [varchar](10) NULL,
	[Qty] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_COG_QTY_PRICE_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_COG_QTY_PRICE_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [varchar](10) NULL,
	[Price] [varchar](200) NULL,
	[ChargeType] [varchar](50) NULL,
	[Qty] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CONSOLIDATE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CONSOLIDATE_LIST] AS TABLE(
	[Department] [varchar](50) NULL,
	[CustomerCode] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[SalesOffice] [varchar](50) NULL,
	[SalesType] [varchar](50) NULL,
	[Consignee] [varchar](50) NULL,
	[Group_Desc] [varchar](50) NULL,
	[SubGroup] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[Qty] [int] NULL,
	[Amount] [bigint] NULL,
	[Frt_AMT] [decimal](18, 2) NULL,
	[Cst_AMT] [decimal](18, 2) NULL,
	[Fob_AMT] [decimal](18, 2) NULL,
	[Cog_AMT] [decimal](18, 2) NULL,
	[Gp_AMT] [decimal](18, 2) NULL,
	[Gp_Percentage] [decimal](18, 2) NULL,
	[BP_QTY] [int] NULL,
	[BP_AMT] [bigint] NULL,
	[BPFrt_AMT] [decimal](18, 2) NULL,
	[BPCst_AMT] [decimal](18, 2) NULL,
	[BPFob_AMT] [decimal](18, 2) NULL,
	[BPCog_AMT] [decimal](18, 2) NULL,
	[BPGp_AMT] [decimal](18, 2) NULL,
	[BPGp_Percentage] [decimal](18, 2) NULL,
	[LM_QTY] [int] NULL,
	[LM_AMT] [bigint] NULL,
	[LMFrt_AMT] [decimal](18, 2) NULL,
	[LMCst_AMT] [decimal](18, 2) NULL,
	[LMFob_AMT] [decimal](18, 2) NULL,
	[LMCog_AMT] [decimal](18, 2) NULL,
	[LMGp_AMT] [decimal](18, 2) NULL,
	[LMGp_Percentage] [decimal](18, 2) NULL,
	[LY_Qty] [int] NULL,
	[LY_AMT] [bigint] NULL,
	[LYFrt_AMT] [decimal](18, 2) NULL,
	[LYCst_AMT] [decimal](18, 2) NULL,
	[LYFob_AMT] [decimal](18, 2) NULL,
	[LYCog_AMT] [decimal](18, 2) NULL,
	[LYGp_AMT] [decimal](18, 2) NULL,
	[LYGp_Percentage] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY] AS TABLE(
	[CustomerId] [int] NULL,
	[CustomerCode] [nvarchar](10) NULL,
	[CountryId] [int] NULL,
	[CountryCode] [nvarchar](10) NULL,
	[CurrencyId] [int] NULL,
	[CurrencyCode] [nvarchar](10) NULL,
	[ExchangeRate] [decimal](18, 4) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CUSTOMERCODE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CUSTOMERCODE_LIST] AS TABLE(
	[CustomerCode] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_CUSTOMERCODE_LIST_FOR_TRANSMISSION]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_CUSTOMERCODE_LIST_FOR_TRANSMISSION] AS TABLE(
	[CustomerCode] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_MODE_OF_TYPE]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_MODE_OF_TYPE] AS TABLE(
	[RowNo] [int] NULL,
	[ModeofTypeId] [int] NULL,
	[ModeofTypeName] [nvarchar](100) NULL,
	[ModeofTypeCode] [nvarchar](10) NULL,
	[IsACtive] [bit] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_MONTHYEAR_TYPE]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_MONTHYEAR_TYPE] AS TABLE(
	[MONTHYEAR] [varchar](6) NULL,
	[TYPE] [varchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_NONCONSOLIDATE_LIST]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_NONCONSOLIDATE_LIST] AS TABLE(
	[Department] [varchar](50) NULL,
	[CustomerCode] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[SalesOffice] [varchar](50) NULL,
	[SalesType] [varchar](50) NULL,
	[Consignee] [varchar](50) NULL,
	[Group_Desc] [varchar](50) NULL,
	[SubGroup] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[O_QTY] [int] NULL,
	[P_QTY] [int] NULL,
	[S_QTY] [int] NULL,
	[I_QTY] [int] NULL,
	[TOT_O_QTY] [int] NULL,
	[MPO_QTY] [int] NULL,
	[ADJ_QTY] [int] NULL,
	[O_AMT] [decimal](18, 2) NULL,
	[P_AMT] [decimal](18, 2) NULL,
	[S_AMT] [decimal](18, 2) NULL,
	[I_AMT] [decimal](18, 2) NULL,
	[MPO_AMT] [decimal](18, 2) NULL,
	[ADJ_AMT] [decimal](18, 2) NULL,
	[TOT_O_AMT] [decimal](18, 2) NULL,
	[NEXT_MON_SALES] [int] NULL,
	[NEXT_MON_SALES_AMT] [decimal](18, 2) NULL,
	[BP_O_QTY] [int] NULL,
	[BP_P_QTY] [int] NULL,
	[BP_S_QTY] [int] NULL,
	[BP_I_QTY] [int] NULL,
	[BP_O_AMT] [decimal](18, 2) NULL,
	[BP_P_AMT] [decimal](18, 2) NULL,
	[BP_S_AMT] [decimal](18, 2) NULL,
	[BP_I_AMT] [decimal](18, 2) NULL,
	[LY_O_QTY] [int] NULL,
	[LY_P_QTY] [int] NULL,
	[LY_S_QTY] [int] NULL,
	[LY_I_QTY] [int] NULL,
	[LY_O_AMT] [decimal](18, 2) NULL,
	[LY_P_AMT] [decimal](18, 2) NULL,
	[LY_S_AMT] [decimal](18, 2) NULL,
	[LY_I_AMT] [decimal](18, 2) NULL,
	[LM_O_QTY] [int] NULL,
	[LM_P_QTY] [int] NULL,
	[LM_S_QTY] [int] NULL,
	[LM_I_QTY] [int] NULL,
	[LM_O_AMT] [decimal](18, 2) NULL,
	[LM_P_AMT] [decimal](18, 2) NULL,
	[LM_S_AMT] [decimal](18, 2) NULL,
	[LM_I_AMT] [decimal](18, 2) NULL,
	[Age30] [int] NULL,
	[Age60] [int] NULL,
	[Age90] [int] NULL,
	[Age120] [int] NULL,
	[Age150] [int] NULL,
	[Age180] [int] NULL,
	[Age180greatherthan] [int] NULL,
	[Age30Amt] [decimal](18, 2) NULL,
	[Age60Amt] [decimal](18, 2) NULL,
	[Age90Amt] [decimal](18, 2) NULL,
	[Age120Amt] [decimal](18, 2) NULL,
	[Age150Amt] [decimal](18, 2) NULL,
	[Age180Amt] [decimal](18, 2) NULL,
	[Age180greatherthanAmt] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_PRICE_PLANNING]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_PRICE_PLANNING] AS TABLE(
	[TRNPricePlanningId] [int] NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_RESULT_TABLE]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_RESULT_TABLE] AS TABLE(
	[RowNo] [int] NULL DEFAULT ((0)),
	[ResponseCode] [nvarchar](10) NULL DEFAULT ('0'),
	[ResponseMessage] [nvarchar](max) NULL DEFAULT ('')
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM] AS TABLE(
	[ItemCode] [nvarchar](50) NULL,
	[TypeCode] [nvarchar](50) NULL,
	[DuplicateCount] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_HEADERS]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_HEADERS] AS TABLE(
	[RowNo] [int] NULL,
	[RowIndex] [int] NULL,
	[UploadFlag] [nvarchar](5) NULL,
	[Class1] [nvarchar](20) NULL,
	[Class2] [nvarchar](20) NULL,
	[Class3] [nvarchar](20) NULL,
	[Class4] [nvarchar](20) NULL,
	[Class5] [nvarchar](20) NULL,
	[Class6] [nvarchar](20) NULL,
	[Class7] [nvarchar](20) NULL,
	[Class8] [nvarchar](20) NULL,
	[ItemCode] [nvarchar](50) NULL,
	[ItemCodeId] [int] NULL,
	[ModelNumber] [nvarchar](50) NULL,
	[TypeCodeId] [int] NULL,
	[TypeCode] [nvarchar](50) NULL,
	[Comments] [nvarchar](50) NULL,
	[Currency] [nvarchar](50) NULL,
	[SalesTypeId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_MATERIAL_QTY_PRICES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_MATERIAL_QTY_PRICES] AS TABLE(
	[RowIndex] [int] NULL,
	[RowNo] [int] NULL,
	[PriceQtyRowNo] [int] NULL,
	[PriceMonthName] [nvarchar](20) NULL,
	[Price] [decimal](18, 6) NULL,
	[Qty] [int] NULL,
	[Currency] [nvarchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_PRICES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_PRICES] AS TABLE(
	[RowIndex] [int] NULL,
	[PriceMonthName] [nvarchar](50) NULL,
	[Price] [decimal](18, 6) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_QTY_PRICES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_QTY_PRICES] AS TABLE(
	[RowIndex] [int] NULL,
	[RowNo] [int] NULL,
	[PriceMonthName] [nvarchar](20) NULL,
	[Price] [decimal](18, 6) NULL,
	[Qty] [int] NULL,
	[Currency] [nvarchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_QUANTITIES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_QUANTITIES] AS TABLE(
	[RowIndex] [int] NULL,
	[QtyMonthName] [nvarchar](50) NULL,
	[Qty] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_ENTRY_ROWS]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_ENTRY_ROWS] AS TABLE(
	[RowIndex] [int] NULL,
	[UploadFlag] [nvarchar](5) NULL,
	[Class1] [nvarchar](20) NULL,
	[Class2] [nvarchar](20) NULL,
	[Class3] [nvarchar](20) NULL,
	[Class4] [nvarchar](20) NULL,
	[Class5] [nvarchar](20) NULL,
	[Class6] [nvarchar](20) NULL,
	[Class7] [nvarchar](20) NULL,
	[Class8] [nvarchar](20) NULL,
	[ItemCode] [nvarchar](50) NULL,
	[ModelNumber] [nvarchar](50) NULL,
	[TypeCode] [nvarchar](50) NULL,
	[Comments] [nvarchar](50) NULL,
	[Currency] [nvarchar](50) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALES_PLANNING]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALES_PLANNING] AS TABLE(
	[TRNSalesPlanningId] [int] NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SALESENTRY_PRICE_QTY_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SALESENTRY_PRICE_QTY_INFO] AS TABLE(
	[SalesEntryPriceQuantityId] [int] NOT NULL,
	[SalesEntryId] [int] NULL,
	[SaleEntryHeaderId] [int] NULL,
	[MonthYear] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[MaterialId] [int] NULL,
	[OCmonthYear] [varchar](200) NULL,
	[OCstatus] [varchar](50) NULL,
	[ModeOfTypeId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SNS_ENTRIES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SNS_ENTRIES] AS TABLE(
	[CustomerCode] [nvarchar](20) NULL,
	[CustomerName] [nvarchar](200) NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[CategoryID] [int] NULL,
	[Category] [nvarchar](200) NULL,
	[AttachmentID] [int] NULL,
	[RowNum] [int] NULL,
	[SaleTypeId] [int] NULL,
	[ModeofTypeId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SNS_ENTRY_QTY_PRICES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SNS_ENTRY_QTY_PRICES] AS TABLE(
	[SNSEntryId] [int] NOT NULL,
	[SNSEntryQtyPriceId] [int] NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [nvarchar](20) NULL,
	[SaleSubType] [nvarchar](20) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SNS_PRICE_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SNS_PRICE_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [nvarchar](20) NULL,
	[Price] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SNS_QTY_INFO]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SNS_QTY_INFO] AS TABLE(
	[RowNum] [int] NULL,
	[MonthYear] [nvarchar](20) NULL,
	[Qty] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SSD_ENTRIES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SSD_ENTRIES] AS TABLE(
	[RowNo] [int] NULL,
	[RowIndex] [int] NULL,
	[ModeofTypeId] [int] NULL,
	[CustomerId] [int] NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[MaterialId] [int] NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[AttachmentId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SSD_ENTRY_DUPLICATE_ITEM]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SSD_ENTRY_DUPLICATE_ITEM] AS TABLE(
	[MaterialCode] [nvarchar](20) NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[DuplicateCount] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[TVP_SSD_ENTRY_QTY_PRICES]    Script Date: 7/17/2023 9:10:24 PM ******/
CREATE TYPE [dbo].[TVP_SSD_ENTRY_QTY_PRICES] AS TABLE(
	[RowNo] [int] NULL,
	[RowIndex] [int] NULL,
	[ColIndex] [int] NULL,
	[MonthYear] [int] NULL,
	[Qty] [int] NULL,
	[Price] [decimal](18, 2) NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_AGING]    Script Date: 7/17/2023 9:10:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
CREATE FUNCTION [dbo].[UDF_AGING] (
	@MonthYear INT
	,@AccountCode VARCHAR(50)
	,@MaterialCode VARCHAR(50)
	,@Aging_Slot INT --this is a number between 0 to 6 where 0 <= 30,1<=60,2<=90,3<=120,4<=150,5<=180 and 6>=180
	)
RETURNS INT
AS
BEGIN
	DECLARE @AN INT = 0
	DECLARE @ATOT INT = 0
	DECLARE @A7 INT = 0
	DECLARE @LV_PSI_INVENTORY_QTY INT = 0
	DECLARE @REM_INVENTORY_QTY INT = 0
	DECLARE @PUR_QTY int = 0
	DECLARE @PSI_PURCHASE_QTY INT = 0
	DECLARE @LV_DATE VARCHAR(20);
	DECLARE @LV_YYYYMM VARCHAR(10);

	SET @LV_DATE = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE);
	SET @LV_PSI_INVENTORY_QTY = (
			SELECT sum(Quantity)
			FROM TRNPricePlanning
			WHERE ModeofType IN ('INVENTORY')
				AND MaterialCode = @MaterialCode
				AND AccountCode = @AccountCode
				AND MonthYear = @MonthYear
			)
	SET @REM_INVENTORY_QTY = @REM_INVENTORY_QTY;
 DECLARE @Number INT = 0;
    DECLARE @Result TABLE (Number INT);

    WHILE @Number <= @Aging_Slot
    BEGIN
        INSERT INTO @Result (Number) VALUES (@Number);
        SET @Number = @Number + 1;

		SET @LV_YYYYMM = (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, -@Number, @LV_DATE) AS DATE), 112) AS INT) );
		SET @PSI_PURCHASE_QTY = (
				SELECT sum(Quantity)
				FROM TRNPricePlanning
				WHERE ModeofType IN (
						'MPO'
						,'PURCHASE'
						)
					AND MaterialCode = @MaterialCode
					AND AccountCode = @AccountCode
					AND MonthYear = @LV_YYYYMM
				);

		IF (@PSI_PURCHASE_QTY <= 0)
		BEGIN
			SET @PUR_QTY = 0;
		END
		ELSE
		BEGIN
			SET @PUR_QTY = @PSI_PURCHASE_QTY;
		END

		IF (@PUR_QTY <= @REM_INVENTORY_QTY)
		BEGIN
			SET @AN = @PUR_QTY;
			SET @REM_INVENTORY_QTY = @REM_INVENTORY_QTY - @PUR_QTY;
		END
		ELSE
		BEGIN
			SET @AN = @REM_INVENTORY_QTY;
			SET @REM_INVENTORY_QTY = 0;
		END


    END;
	return @AN;
end
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_DashMonths]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_DashMonths]  (  
@startDate INT, @ENDate INT, @MaterialID INT
)
RETURNS @Mytable TABLE
(
   
    -- define other columns
MaterialID INT,
StrMonth VARCHAR(2),
strYear  VARCHAR(4)
)
AS
BEGIN
 
Declare @stDate Date;
Declare @EndDate Date


   

 set @stDate=(select Cast(CONCAT(@startDate,'01') as date))
 --select @stDate
if (@ENDate=999999)
BEGIN
set @EndDate=(select DATEADD(m, 48,CAST(GETDATE() as date)))


END
ELSE
BEGIN
 set @EndDate=(select Cast(CONCAT(@ENDate,'01') as date))
END


;with months (date)
AS
(
    SELECT @stDate
    UNION ALL
    SELECT DATEADD(month, 1, date)
    from months
    where DATEADD(month, 1, date) < @EndDate
)

INSERT INTO @Mytable(MaterialID,StrMonth,strYear)
select     @MaterialID,
           [MonthNumber]  =   FORMAT(date,'MM'),  
           [MonthYear]    = DATEPART(yy, date)
from months
option (maxrecursion 0);
   
  RETURN;
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetPSQuantityValueForConsolidation]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[UDF_GetPSQuantityValueForConsolidation]
(
  @SaleEntryHeaderID  INT,
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
  )
   RETURNS    INT
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID

		
			DECLARE @Result INT=0
		DECLARE @ResultOrderQty INT=0
		DECLARE @ResultMPOQty INT=0
		DECLARE @ResultADJQty INT=0
		


		SET @ResultOrderQty =(select Top 1 Quantity from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=1 AND 
		MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

		SET @ResultMPOQty =(select Top 1 Quantity from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=12 AND 
		MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

		SET @ResultADJQty =(select Top 1 Quantity from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=10 AND 
		MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
		

		SET @Result = @ResultOrderQty+@ResultMPOQty+@ResultADJQty;
		return @Result
END

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetPSQuantityValueForSNSConsolidation]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Function [dbo].[UDF_GetPSQuantityValueForSNSConsolidation]
(

   @MaterialCode Varchar(50),
   @AccountCode varchar(50),
   @MonthYear INT
  )
   RETURNS    INT
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID

		
			DECLARE @Result INT=0
		SET @Result =(select SUM (Quantity) from TRNPricePlanning 
		WHERE ModeofType IN ('MPO','PURCHASE') AND 
		MonthYear=@MonthYear AND AccountCode=@AccountCode AND MaterialCode=@MaterialCode)
		
		return @Result
END

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetPSValueForConsolidation]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[UDF_GetPSValueForConsolidation]
(
  @SaleEntryHeaderID  INT,
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
  )
   REturns   DECIMAL(18,2)
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID
	DECLARE @Result DECIMAL(18,2)=0
		    DECLARE @ResultOrderPrice DECIMAL(18,2)=0
			DECLARE @ResultMPOPrice DECIMAL(18,2)=0
			DECLARE @ResultADJPrice DECIMAL(18,2)=0
	
	

	SET @ResultOrderPrice =(select Top 1 (price*Quantity) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=1 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultMPOPrice =(select Top 1  (price*Quantity) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=12 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultADJPrice =(select Top 1  (price*Quantity) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=10 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
		

	SET @Result = @ResultOrderPrice+@ResultMPOPrice+@ResultADJPrice;
	return @Result
END


GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetPSValueValueForSNSConsolidation]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Function [dbo].[UDF_GetPSValueValueForSNSConsolidation]
(
	@CustomerCode Varchar(50),
   @MaterialCode Varchar(50),
   @AccountCode varchar(50),
   @MonthYear INT,
   @SaleSubType varchar(50)
  )
   RETURNS    DECIMAL(18,2)
as
BEGIN


		
			DECLARE @Result INT=0
			DECLARE @ResultQty INT=0
			DECLARE @ResultPrice INT=0
		SET @ResultQty =(select SUM(Quantity) from TRNPricePlanning 
		WHERE ModeofType IN ('MPO','PURCHASE') AND 
		MonthYear=@MonthYear AND AccountCode=@AccountCode AND MaterialCode=@MaterialCode)
		
		SET @ResultPrice =(select SUM(Price) from TRNPricePlanning 
		WHERE ModeofType IN ('MPO','PURCHASE') AND 
		MonthYear=@MonthYear AND AccountCode=@AccountCode AND MaterialCode=@MaterialCode)

		set @Result=@ResultQty*@ResultPrice;

		return @Result
END

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetSalveValue]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[UDF_GetSalveValue]
(
  @SaleEntryHeaderID  INT,
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
  )
   REturns   DECIMAL(18,2)
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID

		    DECLARE @Result DECIMAL(18,2)=0
		
	--		DECLARE @SaleEntryID INT=0;
	--		 DECLARE @ResultMonth INT

	--		SET @ResultMonth=( select ConfigValue from GlobalConfig where ConfigKey='Result_Month' and ConfigType='Direct And SNS')

	--		SET @SaleEntryID =(select top 1 SalesEntryId from SalesEntry where SaleEntryHeaderId=136 and MaterialId=14 and ModeOfTypeId=3)

	--		--select top 1 SalesEntryId from SalesEntry where SaleEntryHeaderId=136 and MaterialId=14 and ModeOfTypeId=3
	---- GEt Sale price of Item with respect of sale entryid from SalesEntryPriceQuantity
	--	--IF(@MonthYear=@ResultMonth)
	--	--	BEGIN
	--	--		SET @Result= (SELECT TOP 1 Price from SalesEntryPriceQuantity where SalesEntryId=@SaleEntryID AND MonthYear=@MonthYear)
	--	--	END

	--			SET @Result= (SELECT TOP 1 Price from SalesEntryPriceQuantity where SalesEntryId=@SaleEntryID AND MonthYear=@MonthYear)

	SET @Result =(select Top 1 price from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=3 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
		
	return @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE Function [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale]
(
  @SaleEntryHeaderID  INT,
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
  )
   REturns   DECIMAL(18,2)
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID
	DECLARE @Result DECIMAL(18,2)=0
		    DECLARE @ResultOrderPrice DECIMAL(18,2)=0
			DECLARE @ResultMPOPrice DECIMAL(18,2)=0
			DECLARE @ResultADJPrice DECIMAL(18,2)=0
	
	

	SET @ResultOrderPrice =(select Top 1 price from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=1 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultMPOPrice =(select Top 1  price from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=12 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultADJPrice =(select Top 1  price from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=10 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
		

	SET @Result = @ResultOrderPrice+@ResultMPOPrice+@ResultADJPrice;
	return @Result
END


GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale_Archival]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale_Archival]
(
   @SaleEntryHeaderID  INT,
   @MaterialCode Varchar(50),
   @CustomerCode varchar(50),
   @MonthYear INT
  )
   REturns   DECIMAL(18,2)
as
BEGIN
	-- Fist Get SaleEntryid with respect of Mode type ID
	DECLARE @Result DECIMAL(18,2)=0
		    DECLARE @ResultOrderPrice DECIMAL(18,2)=0
			DECLARE @ResultMPOPrice DECIMAL(18,2)=0
			DECLARE @ResultADJPrice DECIMAL(18,2)=0
	
	

	SET @ResultOrderPrice =(select Top 1 price from VW_DIRECT_SALE_ARCHIVAL where SaleEntryArchivalHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=1 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultMPOPrice =(select Top 1  price from VW_DIRECT_SALE_ARCHIVAL where SaleEntryArchivalHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=12 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)

	SET @ResultADJPrice =(select Top 1  price from VW_DIRECT_SALE_ARCHIVAL where SaleEntryArchivalHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=10 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
		

	SET @Result = @ResultOrderPrice+@ResultMPOPrice+@ResultADJPrice;
	return @Result
END


GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GetUSDByAmount]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[UDF_GetUSDByAmount] (
	
	@Amount DECIMAL(18, 2)
	,@CurrencyCode NVARCHAR(5)
	)
RETURNS DECIMAL(18, 2)
AS
BEGIN
	DECLARE @TotalAmount DECIMAL(18, 2)

	IF (@CurrencyCode = 'USD')
	BEGIN
		SET @TotalAmount = @Amount
	END
	ELSE
	BEGIN
		DECLARE @USDPrice DECIMAL(18, 2)

		SET @USDPrice = @Amount * (
				SELECT TOP 1 ExchangeRate
				FROM Currency
				WHERE CurrencyCode = @CurrencyCode
				)
		SET @TotalAmount = @Amount * @USDPrice
	END

	RETURN @TotalAmount
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_Next_Month_Sale_Price_DirectSale]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_Next_Month_Sale_Price_DirectSale] (
	 @MonthYear INT
	,@SaleEntryHeaderId INT
	,@CustomerCode Varchar(50)
	,@MaterialCode Varchar(50)
	)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	DECLARE @NextThreeMonthPriceResult int
	DECLARE @CurrentMonthPriceResult int
	DECLARE @NextThree_DATE VARCHAR(20);
	DECLARE @NextThree_YYYYMM VARCHAR(20);
	SET @NextThree_DATE = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE);
	
	SET @NextThree_YYYYMM = (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3, @NextThree_DATE) AS DATE), 112) AS INT) );
	
	set @NextThreeMonthPriceResult=(select sum(Price) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=3 AND 
				MonthYear<=@MonthYear and MonthYear>=@NextThree_YYYYMM  AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
 
    set @CurrentMonthPriceResult=(select sum(Price) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=4 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
	
	set @Result=(@NextThreeMonthPriceResult*30)/@CurrentMonthPriceResult;
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_Next_Month_Sale_Price_SNS]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_Next_Month_Sale_Price_SNS] (
	 @MonthYear INT
	,@SNSEntryId INT
	,@CustomerCode Varchar(50)
	,@MaterialCode Varchar(50)
	,@OACCode Varchar(50)
	)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	DECLARE @NextThreeMonthPriceResult int
	DECLARE @CurrentMonthPriceResult int
	DECLARE @NextThree_DATE VARCHAR(20);
	DECLARE @NextThree_YYYYMM VARCHAR(20);
	SET @NextThree_DATE = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE);
	
	SET @NextThree_YYYYMM = (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3, @NextThree_DATE) AS DATE), 112) AS INT) );
	
	set @NextThreeMonthPriceResult=(select sum(Qty) from VW_SNS where SNSEntryId=@SNSEntryId  AND 
				MonthYear<=@MonthYear and MonthYear>=@NextThree_YYYYMM  AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
 
    set @CurrentMonthPriceResult=(select Quantity from TRNPricePlanning where AccountCode=@OACCode  AND 
				MonthYear=@MonthYear AND ModeofType='INVENTORY' AND MaterialCode=@MaterialCode)
	
	set @Result=(@NextThreeMonthPriceResult*30)/@CurrentMonthPriceResult;
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_Next_Month_Sale_Qty_DirectSale]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_Next_Month_Sale_Qty_DirectSale] (
	 @MonthYear INT
	,@SaleEntryHeaderId INT
	,@CustomerCode Varchar(50)
	,@MaterialCode Varchar(50)
	)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	DECLARE @NextThreeMonthQtyResult int
	DECLARE @CurrentMonthQtyResult int
	DECLARE @NextThree_DATE VARCHAR(20);
	DECLARE @NextThree_YYYYMM VARCHAR(20);
	SET @NextThree_DATE = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE);
	
	SET @NextThree_YYYYMM = (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3, @NextThree_DATE) AS DATE), 112) AS INT) );
	
	set @NextThreeMonthQtyResult=(select sum(Quantity) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=3 AND 
				MonthYear<=@MonthYear and MonthYear>=@NextThree_YYYYMM  AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
 
    set @CurrentMonthQtyResult=(select sum(Quantity) from VW_DIRECT_SALE where SaleEntryHeaderId=@SaleEntryHeaderID AND ModeOfTypeId=4 AND 
				MonthYear=@MonthYear AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
	
	set @Result=(@NextThreeMonthQtyResult*30)/@CurrentMonthQtyResult;
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_Next_Month_Sale_QTY_SNS]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_Next_Month_Sale_QTY_SNS] (
	 @MonthYear INT
	,@SNSEntryId INT
	,@CustomerCode Varchar(50)
	,@MaterialCode Varchar(50)
	,@OACCode Varchar(50)
	)
RETURNS int
AS
BEGIN
	DECLARE @Result int
	DECLARE @NextThreeMonthQtyResult int
	DECLARE @CurrentMonthQtyResult int
	DECLARE @NextThree_DATE VARCHAR(20);
	DECLARE @NextThree_YYYYMM VARCHAR(20);
	SET @NextThree_DATE = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE);
	
	SET @NextThree_YYYYMM = (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, 3, @NextThree_DATE) AS DATE), 112) AS INT) );
	
	set @NextThreeMonthQtyResult=(select sum(Qty) from VW_SNS where SNSEntryId=@SNSEntryId  AND 
				MonthYear<=@MonthYear and MonthYear>=@NextThree_YYYYMM  AND CustomerCode=@CustomerCode AND MaterialCode=@MaterialCode)
 
    set @CurrentMonthQtyResult=(select Quantity from TRNPricePlanning where AccountCode=@OACCode  AND 
				MonthYear=@MonthYear AND ModeofType='INVENTORY' AND MaterialCode=@MaterialCode)
	
	set @Result=(@NextThreeMonthQtyResult*30)/@CurrentMonthQtyResult;
	RETURN @Result
END
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_USDAmount]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UDF_USDAmount] (
	@Quantity INT
	,@Price DECIMAL(12, 4)
	,@CurrencyCode NVARCHAR(5)
	)
RETURNS DECIMAL(12, 4)
AS
BEGIN
	DECLARE @TotalAmount DECIMAL(12, 4)

	IF (@CurrencyCode = 'USD')
	BEGIN
		SET @TotalAmount = @Quantity * @Price
	END
	ELSE
	BEGIN
		DECLARE @USDPrice DECIMAL(12, 4)

		SET @USDPrice = @Price * (
				SELECT TOP 1 ExchangeRate
				FROM Currency
				WHERE CurrencyCode = @CurrencyCode
				)
		SET @TotalAmount = @Quantity * @USDPrice
	END

	RETURN @TotalAmount
END
GO
/****** Object:  UserDefinedFunction [dbo].[YearMonthRange]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[YearMonthRange] (
	@StartDate DATETIME
	,@EndDate DATETIME
	)
RETURNS @Results TABLE (
	ID INT IDENTITY(1, 1)
	,YearValue INT
	,MonthValue NVARCHAR(2)
	,YearMonth NVARCHAR(6)
	)
AS
BEGIN
	IF @StartDate IS NULL
		OR @EndDate IS NULL
	BEGIN
		/*GET THE CURRENT CALENDAR YEAR*/
		SELECT @StartDate = DATEFROMPARTS(year(getdate()), 1, 1)
			,@EndDate = DATEFROMPARTS(year(getdate()), 12, 31)
	END

	WHILE @StartDate < @EndDate
	BEGIN
		INSERT INTO @Results (
			YearValue
			,MonthValue
			,YearMonth
			)
		SELECT DATEPART(year, @StartDate)
			,FORMAT(@StartDate, 'MM')
			,Convert(VARCHAR, DATEPART(year, @StartDate)) + Convert(VARCHAR(2), FORMAT(@StartDate, 'MM'))

		SET @StartDate = DATEADD(month, 1, @StartDate)
	END

	RETURN
END
GO
/****** Object:  View [dbo].[CustomerView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[CustomerView]
AS
SELECT CustDid.SalesOrganizationCode
	,cust.CustomerId
	,cust.CustomerCode
	,cust.CustomerName
	,cust.CustomerShortName
	,cust.EmailId
	,cust.RegionId
	,r.RegionName
	,r.RegionCode
	,cust.DepartmentId
	,d.DepartmentName
	,d.DepartmentCode
	,cust.CountryId
	,c.CountryName
	,C.CountryCode
	,cust.SalesOfficeId
	,s.SalesOfficeName
	,s.SalesOfficeCode
	,cust.PersonInChargeId
	,'' AS PersonInChargeName
	,cust.IsBP
	,cust.IsPSI
	,cust.IsActive
	,cust.IsCollabo
	,CONVERT(VARCHAR(10), cust.UpdateDate, 111) AS UpdateDate
	,CONVERT(VARCHAR(10), cust.CreatedDate, 111) AS CreatedDate
	,CONVERT(VARCHAR(10), cust.UpdateDate, 101) AS UpdateDate1
	,CONVERT(VARCHAR(10), cust.CreatedDate, 101) AS CreatedDate1
	,cust.CreatedBy
	,cust.UpdateBy
	,STRING_AGG(saletype.SaleTypeName, ',') AS SalesTypeNames
	,STRING_AGG(CustDid.SaleTypeId, ',') AS SalesTypeIds
	,CustDid.AccountId
	,AC.AccountCode
FROM customer cust
LEFT JOIN CustomerDID CustDid ON cust.CustomerId = CustDid.CustomerId
LEFT JOIN SaleType saletype ON CustDid.SaleTypeId = saletype.SaleTypeId
LEFT JOIN region r ON cust.RegionId = r.RegionId
LEFT JOIN Department d ON cust.DepartmentId = d.DepartmentId
LEFT JOIN Country c ON cust.CountryId = c.CountryId
LEFT JOIN SalesOffice s ON cust.SalesOfficeId = s.SalesOfficeId
LEFT JOIN Account AC ON CustDid.AccountId = AC.AccountId
--left join customer personincharge on cust.PersonInChargeId=personincharge.CustomerId          
GROUP BY CustDid.SalesOrganizationCode
	,cust.CustomerId
	,cust.CustomerCode
	,cust.CustomerName
	,cust.CustomerShortName
	,cust.EmailId
	,cust.RegionId
	,r.RegionName
	,r.RegionCode
	,cust.DepartmentId
	,d.DepartmentName
	,d.DepartmentCode
	,cust.CountryId
	,c.CountryName
	,C.CountryCode
	,cust.SalesOfficeId
	,s.SalesOfficeName
    ,s.SalesOfficeCode
	,cust.PersonInChargeId
	,cust.IsBP
	,cust.IsPSI
	,cust.IsActive
	,cust.IsCollabo
	,CONVERT(VARCHAR(10), cust.UpdateDate, 111)
	,CONVERT(VARCHAR(10), cust.UpdateDate, 101)
	,CONVERT(VARCHAR(10), cust.CreatedDate, 111)
	,CONVERT(VARCHAR(10), cust.CreatedDate, 101)
	,cust.CreatedBy
	,cust.UpdateBy
	,CustDid.AccountId
	,AC.AccountCode
GO
/****** Object:  View [dbo].[MaterialView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[MaterialView]        
as        
select m.MaterialId,m.MaterialCode,m.MaterialShortDescription,m.CompanyId,c.CompanyName,        
m.BarCode,m.SeaPortId,s.SeaPortName,m.AirPortId,a.AirPortName,sup.SupplierId,sup.SupplierName,        
m.ProductCategoryId1,prod1.ProductCategoryCode+'-'+prod1.ProductCategoryName as ProductCategoryName1, prod1.ProductCategoryCode as ProductCategoryCode1,        
m.ProductCategoryId2,prod2.ProductCategoryCode+'-'+prod2.ProductCategoryName as ProductCategoryName2, prod2.ProductCategoryCode as ProductCategoryCode2,       
m.ProductCategoryId3,prod3.ProductCategoryCode+'-'+prod3.ProductCategoryName as ProductCategoryName3, prod3.ProductCategoryCode as ProductCategoryCode3,       
m.ProductCategoryId4,prod4.ProductCategoryCode+'-'+prod4.ProductCategoryName as ProductCategoryName4, prod4.ProductCategoryCode as ProductCategoryCode4,       
m.ProductCategoryId5,prod5.ProductCategoryCode+'-'+prod5.ProductCategoryName as  ProductCategoryName5, prod5.ProductCategoryCode as ProductCategoryCode5,        
m.ProductCategoryId6,prod6.ProductCategoryCode+'-'+prod6.ProductCategoryName as ProductCategoryName6, prod6.ProductCategoryCode as ProductCategoryCode6,       
m.Weight,m.Volume, m.IsActive ,m.InSap  
 ,m.CreatedBy,    
CONVERT(VARCHAR(10),m.UpdateDate,111) as UpdateDate,    
CONVERT(VARCHAR(10),m.CreatedDate,111) as CreatedDate,    
CONVERT(VARCHAR(10),m.UpdateDate,101) as UpdateDate1,    
CONVERT(VARCHAR(10),m.CreatedDate,101) as CreatedDate1    
,m.UpdateBy,STRING_AGG(mapping.CountryId, ',') AS CountryIds,        
STRING_AGG(country.CountryName, ',') AS CountryNames        
from Material m        
left join MaterialCountryMapping mapping on m.MaterialId=mapping.MaterialId        
left join Country country on mapping.CountryId=country.CountryId        
left join Company c on m.CompanyId=c.CompanyId        
left join ProductCategory prod1 on m.ProductCategoryId1=prod1.ProductCategoryId        
left join ProductCategory prod2 on m.ProductCategoryId2=prod2.ProductCategoryId        
left join ProductCategory prod3 on m.ProductCategoryId3=prod3.ProductCategoryId        
left join ProductCategory prod4 on m.ProductCategoryId4=prod4.ProductCategoryId        
left join ProductCategory prod5 on m.ProductCategoryId5=prod5.ProductCategoryId        
left join ProductCategory prod6 on m.ProductCategoryId6=prod6.ProductCategoryId        
left join SeaPort s on m.SeaPortId=s.SeaPortId        
left join AirPort a on m.AirPortId=a.AirPortId        
left join Supplier sup on m.SupplierId=sup.SupplierId        
        
group by m.MaterialId,m.MaterialCode,m.MaterialShortDescription,m.CompanyId,c.CompanyName,        
m.BarCode,m.SeaPortId,s.SeaPortName,m.AirPortId,a.AirPortName,sup.SupplierId,sup.SupplierName,        
m.ProductCategoryId1,prod1.ProductCategoryName,  prod1.ProductCategoryCode,       
m.ProductCategoryId2,prod2.ProductCategoryName , prod2.ProductCategoryCode,       
m.ProductCategoryId3,prod3.ProductCategoryName , prod3.ProductCategoryCode,       
m.ProductCategoryId4,prod4.ProductCategoryName,  prod4.ProductCategoryCode,      
m.ProductCategoryId5,prod5.ProductCategoryName , prod5.ProductCategoryCode,       
m.ProductCategoryId6,prod6.ProductCategoryName , prod6.ProductCategoryCode,       
m.InSap,m.Weight,m.Volume,m.IsActive,m.CreatedDate        
,m.CreatedBy,m.UpdateDate,m.UpdateBy   
  
  
GO
/****** Object:  View [dbo].[VW_CM_BP_NonConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE VIEW [dbo].[VW_CM_BP_NonConsolidatedReport]  
AS  
SELECT DISTINCT DepartmentName  
 ,CountryId  
 ,CountryName  
 ,SalesOfficeName AS SalesOfficeName  
 ,SalesType  
 ,c.CustomerCode + '-' + CustomerName AS Consignee  
 ,c.CustomerCode  
 ,m.ProductCategoryName1 AS MG  
 ,m.ProductCategoryName2 AS MG1  
 ,m.ProductCategoryName3 AS MG2  
 ,m.ProductCategoryCode1  
 ,m.ProductCategoryCode2  
 ,m.MaterialCode  
 ,TEMP.MonthYear  
 ,TEMP.SaleSubType  
 ,Currency  
 ,SUM(O_QTY) as O_QTY    
 ,SUM(P_QTY) as P_QTY    
 ,SUM(S_QTY) as S_QTY    
 ,SUM(I_QTY) as I_QTY   
 ,SUM(MPO_QTY) as MPO_QTY    
 ,SUM(ADJ_QTY) as ADJ_QTY   
 ,SUM(TOT_O_QTY) as TOT_O_QTY   
 ,(SUM(O_QTY) * SUM(O_Price)) AS O_AMT    
 ,(SUM(P_QTY) * SUM(P_Price)) AS P_AMT    
 ,(SUM(S_QTY) * SUM(S_Price)) AS S_AMT    
 ,(SUM(I_QTY) * SUM(I_Price)) AS I_AMT   
 ,(SUM(MPO_QTY) * SUM(MPO_Price)) AS MPO_AMT    
 ,(SUM(ADJ_QTY) * SUM(ADJ_Price)) AS ADJ_AMT    
 ,(SUM(TOT_O_QTY) * SUM(TOT_O_Price)) AS TOT_O_AMT    
 ,SUM(NEXT_MON_SALES_Qty) AS NEXT_MON_SALES  
 ,(SUM(NEXT_MON_SALES_Qty) * SUM(NEXT_MON_SALES_Price)) AS NEXT_MON_SALES_AMT    
FROM (  
 SELECT DISTINCT CustomerCode  
  ,MaterialCode  
  ,P.MonthYear  
  ,SaleSubType  
  ,'Agent' AS SalesType  
  ,P.CurrencyCode AS Currency  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 1  
     THEN [dbo].[UDF_GetPSQuantityValueForConsolidation](h.SaleEntryHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))  
    ELSE 0  
    END) AS TOT_O_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 10  
     THEN P.Quantity  
    ELSE 0  
    END) AS ADJ_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 12  
     THEN P.Quantity  
    ELSE 0  
    END) AS MPO_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 1  
     THEN P.Quantity  
    ELSE 0  
    END) AS O_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 2  
     THEN p.Quantity  
    ELSE 0  
    END) AS P_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 3  
     THEN p.Quantity  
    ELSE 0  
    END) AS S_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 4  
     THEN p.Quantity  
    ELSE 0  
    END) AS I_QTY  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 1  
     THEN [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale](h.SaleEntryHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))  
    ELSE 0  
    END) AS TOT_O_PRICE  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 1  
     THEN P.Price  
    ELSE 0  
    END) AS O_PRICE  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 2  
     THEN p.Price  
    ELSE 0  
    END) AS P_Price  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 3  
     THEN p.Price  
    ELSE 0  
    END) AS S_Price  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 4  
     THEN p.Price  
    ELSE 0  
    END) AS I_Price  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 10  
     THEN p.Price  
    ELSE 0  
    END) AS ADJ_Price  
  ,SUM(CASE   
    WHEN ModeOfTypeId = 12  
     THEN p.Price  
    ELSE 0  
    END) AS MPO_Price  
  ,max(ISNULL([dbo].[UDF_Next_Month_Sale_Qty_DirectSale](p.MonthYear,h.SaleEntryHeaderId,CustomerCode,MaterialCode),0)) as NEXT_MON_SALES_Qty  
  ,max(ISNULL([dbo].[UDF_Next_Month_Sale_Price_DirectSale](p.MonthYear,h.SaleEntryHeaderId,CustomerCode,MaterialCode),0)) as NEXT_MON_SALES_Price  
 FROM SaleEntryHeader h  
 INNER JOIN SalesEntry s ON h.SaleEntryHeaderId = s.SaleEntryHeaderId  
 INNER JOIN SalesEntryPriceQuantity p ON s.SalesEntryId = p.SalesEntryId  
 WHERE ModeOfTypeId IN (  
   1  
   ,2  
   ,3  
   ,4  
   ,10  
   ,12  
   )  
  AND P.OCstatus = 'Y'  
 GROUP BY CustomerCode  
  ,MaterialCode  
  ,P.MonthYear  
  ,SaleSubType  
  ,CurrencyCode  
   
 UNION  
   
 SELECT DISTINCT CustomerCode  
  ,sns.MaterialCode  
  ,sns.MonthYear  
  ,SaleSubType  
  ,'SNS' AS SalesType  
  ,'USD' AS Currency  
  ,SUM(CASE   
    WHEN ModeofType = 'ORDER'  
     THEN SNS.Quantity  
    ELSE 0  
    END)  
  +  
  SUM(CASE   
    WHEN ModeofType = 'MPO'  
     THEN SNS.Quantity  
    ELSE 0  
    END)AS TOT_O_QTY  
  ,0 as ADJ_QTY  
  ,SUM(CASE   
    WHEN ModeofType = 'MPO'  
     THEN SNS.Quantity  
    ELSE 0  
    END) AS MPO_QTY  
  ,SUM(CASE   
    WHEN ModeofType = 'ORDER'  
     THEN SNS.Quantity  
    ELSE 0  
    END) AS O_QTY  
  ,SUM(CASE   
    WHEN ModeofType = 'PURCHASE'  
     THEN SNS.Quantity  
    ELSE 0  
    END) AS P_QTY  
  ,MAX(SNS.SaleQty) as S_QTY  
  ,SUM(CASE   
    WHEN ModeofType = 'INVENTORY'  
     THEN SNS.Quantity  
    ELSE 0  
    END) AS I_QTY  
   ,SUM(CASE   
    WHEN ModeofType = 'MPO'  
     THEN SNS.Price  
    ELSE 0  
    END)   
  +SUM(CASE   
    WHEN ModeofType = 'ORDER'  
     THEN SNS.Price  
    ELSE 0  
    END) AS TOT_O_Price  
  ,SUM(CASE   
    WHEN ModeofType = 'ORDER'  
     THEN SNS.Price  
    ELSE 0  
    END) AS O_Price  
  ,SUM(CASE   
    WHEN ModeofType = 'PURCHASE'  
     THEN SNS.Price  
    ELSE 0  
    END) AS P_Price  
  ,MAX(SNS.SalePrice) as S_Price  
  ,SUM(CASE   
    WHEN ModeofType = 'INVENTORY'  
     THEN SNS.Price  
    ELSE 0  
    END) AS I_Price  
  ,0 AS ADJ_PRICE  
  ,SUM(CASE   
    WHEN ModeofType = 'MPO'  
     THEN SNS.Price  
    ELSE 0  
    END) AS MPO_Price,  
  max(NEXT_MON_SALES_Qty) as NEXT_MON_SALES_Qty,  
  max(NEXT_MON_SALES_Price) as NEXT_MON_SALES_Price  
   
 FROM (  
  SELECT DISTINCT s.CustomerCode  
   ,trn.MaterialCode  
   ,trn.MonthYear  
   ,'Monthly' AS SaleSubType  
   ,'SNS' AS SalesType  
   ,trn.Quantity  
   ,p.Qty AS SaleQty  
   ,p.FinalPrice AS SalePrice  
   ,0 as Price  
   ,trn.ModeofType  
   ,ISNULL([dbo].[UDF_Next_Month_Sale_QTY_SNS](p.MonthYear,s.SNSEntryId,CustomerCode,s.MaterialCode,OACCode),0) as NEXT_MON_SALES_Qty  
   ,ISNULL([dbo].[UDF_Next_Month_Sale_Price_SNS](p.MonthYear,s.SNSEntryId,CustomerCode,s.MaterialCode,OACCode),0) as NEXT_MON_SALES_Price  
  FROM SNSEntry s   
  INNER JOIN  SNSEntryQtyPrice p on s.SNSEntryId=p.SNSEntryId  
  INNER JOIN TRNPricePlanning trn ON s.MaterialCode = trn.MaterialCode  
   AND S.OACCode = trn.AccountCode  
   AND s.MonthYear = trn.MonthYear  
  ) SNS  
 GROUP BY CustomerCode  
  ,MaterialCode  
  ,MonthYear  
  ,SaleSubType  
  
 ) TEMP  
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode  
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode  
GROUP BY   
  DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName     
 ,SalesType    
 ,CustomerName     
 ,c.CustomerCode    
 ,m.ProductCategoryName1     
 ,m.ProductCategoryName2    
 ,m.ProductCategoryName3     
 ,m.ProductCategoryCode1    
 ,m.ProductCategoryCode2    
 ,m.MaterialCode    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType    
 ,Currency    
GO
/****** Object:  View [dbo].[UserProfileView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserProfileView] 
AS
SELECT
udm.Id as userDeparmentMappId,
udm.UserId,
 dept.DepartmentId,
 dept.DepartmentCode,
 dept.DepartmentName,
 pt.ProductCategoryId as ProductId,
 pt.ProductCategoryCode as ProductCode,
 pt.ProductCategoryName as ProductName,
 udm.CreatedDate,
 udm.CreatedBy,
 udm.UpdateDate,
 udm.UpdateBy,
 CN.CountryId,
 CN.CountryCode,
 CN.CountryName
FROM
    userDepartmentMapping AS udm
LEFT JOIN department AS dept
    ON udm.DepartmentId = dept.DepartmentId
	cross apply STRING_SPLIT (dept.CountryId, ',') CS
	JOIN Country CN on CS.value=CN.CountryId
LEFT JOIN UserProductMapping upm on upm.UserId=udm.UserId
LEFT JOIN ProductCategory pt on pt.ProductCategoryId=upm.ProductId
GO
/****** Object:  View [dbo].[LockPSIView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[LockPSIView]   
as  
select LockPSIId,l.UserId,OPSI_Upload AS OPSI,COG_Upload as COG,O_LockMonthConfirm  
 ,OC_IndicationMonth,BP_Upload_DirectSale,BP_Upload_SNS  
 ,BP_COG_Upload,ADJ_Upload AS ADJ,SSD_Upload AS SSD,SNS_Sales_Upload AS SNS  
 ,Forecast_Projection,u.Name,STRING_AGG(p.CountryId,',') as CountryIds,SNS_Planning   
 from LockPSI l  
inner join   
 Users u on l.UserId=u.UserId  
 left join UserProfileView p on u.UserId=p.UserId  
 group by LockPSIId,l.UserId,OPSI_Upload,COG_Upload,O_LockMonthConfirm  
 ,OC_IndicationMonth,BP_Upload_DirectSale,BP_Upload_SNS  
 ,BP_COG_Upload,ADJ_Upload,SSD_Upload,SNS_Sales_Upload  
 ,Forecast_Projection,u.Name ,SNS_Planning 
  
GO
/****** Object:  View [dbo].[VW_LM_NonConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_LM_NonConsolidatedReport]
AS
SELECT DISTINCT DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName AS SalesOfficeName
	,SalesType
	,c.CustomerCode + '-' + CustomerName AS Consignee
	,c.CustomerCode
	,m.ProductCategoryName1 AS MG
	,m.ProductCategoryName2 AS MG1
	,m.ProductCategoryName3 AS MG2
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,TEMP.MonthYear
	,TEMP.SaleSubType
	,Currency
	,SUM(O_QTY) as O_QTY
	,SUM(P_QTY) as P_QTY
	,SUM(S_QTY) as S_QTY
	,SUM(I_QTY) as I_QTY
	,(SUM(O_QTY) * SUM(O_Price)) AS O_AMT
	,(SUM(P_QTY) * SUM(P_Price)) AS P_AMT
	,(SUM(S_QTY) * SUM(S_Price)) AS S_AMT
	,(SUM(I_QTY) * SUM(I_Price)) AS I_AMT
FROM (
	SELECT DISTINCT CustomerCode
		,MaterialCode
		,P.MonthYear
		,SaleSubType
		,'Agent' AS SalesType
		,P.CurrencyCode AS Currency
		,SUM(CASE 
				WHEN ModeOfTypeId = 1
					THEN [dbo].[UDF_GetPSQuantityValueForConsolidation](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))
				ELSE 0
				END) AS O_QTY
		,SUM(CASE 
				WHEN ModeOfTypeId = 2
					THEN p.Quantity
				ELSE 0
				END) AS P_QTY
		,SUM(CASE 
				WHEN ModeOfTypeId = 3
					THEN p.Quantity
				ELSE 0
				END) AS S_QTY
		,SUM(CASE 
				WHEN ModeOfTypeId = 4
					THEN p.Quantity
				ELSE 0
				END) AS I_QTY
		,SUM(CASE 
				WHEN ModeOfTypeId = 1
					THEN [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))
				ELSE 0
				END) AS O_Price
		,SUM(CASE 
				WHEN ModeOfTypeId = 2
					THEN p.Price
				ELSE 0
				END) AS P_Price
		,SUM(CASE 
				WHEN ModeOfTypeId = 3
					THEN p.Price
				ELSE 0
				END) AS S_Price
		,SUM(CASE 
				WHEN ModeOfTypeId = 4
					THEN p.Price
				ELSE 0
				END) AS I_Price
	FROM SaleEntryArchivalHeader h
	INNER JOIN SalesArchivalEntry s ON h.SaleEntryArchivalHeaderId = s.SaleEntryArchivalHeaderId
	INNER JOIN SalesArchivalEntryPriceQuantity p ON s.SalesArchivalEntryId = p.SalesArchivalEntryId
	WHERE ModeOfTypeId IN (
			1
			,2
			,3
			,4
			,10
			,12
			)
		AND P.OCstatus = 'Y'
	GROUP BY CustomerCode
		,MaterialCode
		,P.MonthYear
		,SaleSubType
		,CurrencyCode
	
	UNION
	
	SELECT DISTINCT CustomerCode
		,sns.MaterialCode
		,sns.MonthYear
		,SaleSubType
		,'SNS' AS SalesType
		,Currency
		,SUM(CASE 
				WHEN ModeofType = 'ORDER'
					THEN SNS.Quantity
				ELSE 0
				END) AS O_QTY
		,SUM(CASE 
				WHEN ModeofType = 'PURCHASE'
					THEN SNS.Quantity
				ELSE 0
				END) AS P_QTY
		,MAX(SalesQty) AS S_QTY
		,SUM(CASE 
				WHEN ModeofType = 'INVENTORY'
					THEN SNS.Quantity
				ELSE 0
				END) AS I_QTY
		,SUM(CASE 
				WHEN ModeofType = 'ORDER'
					THEN SNS.Price
				ELSE 0
				END) AS O_Price
		,SUM(CASE 
				WHEN ModeofType = 'PURCHASE'
					THEN SNS.Price
				ELSE 0
				END) AS P_Price
		,MAX(SalesPrice) AS S_Price
		,SUM(CASE 
				WHEN ModeofType = 'INVENTORY'
					THEN SNS.Price
				ELSE 0
				END) AS I_Price
	FROM (
		SELECT DISTINCT s.CustomerCode
			,s.MaterialCode
			,s.MonthYear
			,'Monthly' AS SaleSubType
			,'SNS' AS SalesType
			,trn.Quantity
			,trn.Price
			,s.Quantity AS SalesQty
			,Amount AS SalesPrice
			,ModeofType
			,'USD' AS Currency
		FROM TRNSalesPlanning s
		LEFT JOIN TRNPricePlanning trn ON s.MaterialCode = trn.MaterialCode
			AND s.AccountCode = trn.AccountCode
			AND s.MonthYear = trn.MonthYear
			--where (trn.ModeofType in ('ORDER','PURCHASE','INVENTORY') or    
		) SNS
	GROUP BY CustomerCode
		,MaterialCode
		,MonthYear
		,SaleSubType
		,Currency
	) TEMP
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode
group  by 
	 DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName 
	,SalesType
	,CustomerName 
	,c.CustomerCode
	,m.ProductCategoryName1 
	,m.ProductCategoryName2
	,m.ProductCategoryName3 
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,TEMP.MonthYear
	,TEMP.SaleSubType
	,Currency

GO
/****** Object:  View [dbo].[VW_AGEING_NonConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_AGEING_NonConsolidatedReport]
AS
SELECT DISTINCT DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName AS SalesOfficeName
	,c.CustomerCode + '-' + CustomerName AS Consignee
	,c.CustomerCode
	,m.ProductCategoryName1 AS MG
	,m.ProductCategoryName2 AS MG1
	,m.ProductCategoryName3 AS MG2
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,trn.MonthYear
	,'Monthly' AS SaleSubType
	,'SNS' AS SalesType
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 0) AS Age30
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 1) AS Age60
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age90
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age120
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age150
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age180
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age180greatherthan
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 0) AS Age30Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 1) AS Age60Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age90Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age120Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age150Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age180Amt
	,[dbo].[UDF_AGING](trn.MonthYear, trn.AccountCode, trn.MaterialCode, 2) AS Age180greatherthanAmt
	,ModeofType
	,'USD' AS Currency
FROM SNSEntry s
INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId
INNER JOIN TRNPricePlanning trn ON s.MaterialCode = trn.MaterialCode
	AND s.OACCode = trn.AccountCode
	AND p.MonthYear = trn.MonthYear
INNER JOIN CustomerView c ON s.CustomerCode = c.CustomerCode
INNER JOIN MaterialView m ON s.MaterialCode = m.MaterialCode
WHERE trn.ModeofType IN (
		'MPO'
		,'PURCHASE'
		,'INVENTORY'
		)
GO
/****** Object:  View [dbo].[VW_CM_BP_ConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_CM_BP_ConsolidatedReport]
AS
SELECT DISTINCT DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName AS SalesOfficeName
	,SalesType
	,c.CustomerCode + '-' + CustomerName AS Consignee
	,c.CustomerCode
	,m.ProductCategoryName1 AS MG
	,m.ProductCategoryName2 AS MG1
	,m.ProductCategoryName3 AS MG2
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,sum(TEMP.Qty) AS Qty
	,(CAST(ROUND((sum(TEMP.Price) * sum(TEMP.Qty)), 0) AS BIGINT)) AS Amount
	,TEMP.MonthYear
	,TEMP.SaleSubType
	,SUM(CASE 
			WHEN ChargeType = 'FRT'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS FRT_AMT
	,SUM(CASE 
			WHEN ChargeType = 'CST'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS CST_AMT
	,SUM(CASE 
			WHEN ChargeType = 'FOB'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS FOB_AMT
	,(
		SUM(CASE 
				WHEN ChargeType = 'FRT'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END) + SUM(CASE 
				WHEN ChargeType = 'CST'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END) + SUM(CASE 
				WHEN ChargeType = 'FOB'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END)
		) AS COG_AMT
	,
	--GP_AMT=Sales Amt-COG Amt        
	(
		MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (
			SUM(CASE 
					WHEN ChargeType = 'FRT'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END) + SUM(CASE 
					WHEN ChargeType = 'CST'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END) + SUM(CASE 
					WHEN ChargeType = 'FOB'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END)
			)
		) AS GP_AMT
	,
	--GP%=GP AMT/Sales AMT         
	(
		CASE 
			WHEN (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT))) != 0
				THEN (
						(
							MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (
								SUM(CASE 
										WHEN ChargeType = 'FRT'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END) + SUM(CASE 
										WHEN ChargeType = 'CST'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END) + SUM(CASE 
										WHEN ChargeType = 'FOB'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END)
								)
							) * 100
						) / (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)))
			ELSE 0
			END
		) AS GP_Percentage
FROM (
	--sns data              
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,Qty
		,FinalPrice as price
		,'SNS' AS SalesType
		,SaleSubType
	FROM SNSEntry s
	INNER JOIN SNSEntryQtyPrice p ON s.SNSEntryId = p.SNSEntryId
	
	UNION
	
	--adj data              
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,Qty
		,price
		,'Agent' AS SalesType
		,'Monthly' AS SaleSubType
	FROM AdjustmentEntry s
	INNER JOIN AdjustmentEntryQtyPrice p ON s.AdjustmentEntryId = p.AdjustmentEntryId
	
	UNION
	
	--ssd data              
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,Qty
		,price
		,'Agent' AS SalesType
		,'Monthly' AS SaleSubType
	FROM SSDentry s
	INNER JOIN SSDentryQtyPrice p ON s.SSDEntryId = p.SSDEntryId
	
	UNION
	
	--Direct data              
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,[dbo].[UDF_GetPSQuantityValueForConsolidation](h.SaleEntryHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Quantity
		,[dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale](h.SaleEntryHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Price
		,'Agent' AS SalesType
		,SaleSubType
	FROM SaleEntryHeader h
	INNER JOIN SalesEntry s ON h.SaleEntryHeaderId = s.SaleEntryHeaderId
	INNER JOIN SalesEntryPriceQuantity p ON s.SalesEntryId = p.SalesEntryId
	WHERE s.ModeOfTypeId = 1
		AND p.OCstatus = 'Y'
	) TEMP
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode
LEFT JOIN COGEntry cog ON TEMP.CustomerCode = cog.CustomerCode
	AND cog.SaleSubType = TEMP.SaleSubType
LEFT JOIN COGEntryQtyPrice cogp ON cog.COGEntryId = cogp.COGEntryId
GROUP BY DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName
	,SalesType
	,c.CustomerCode + '-' + CustomerName
	,c.CustomerCode
	,m.ProductCategoryName1
	,m.ProductCategoryName2
	,m.ProductCategoryName3
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,cogp.COGEntryId
	,cogp.MonthYear
	,TEMP.MonthYear
	,TEMP.SaleSubType
GO
/****** Object:  View [dbo].[VW_LY_ConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_LY_ConsolidatedReport]    
AS    
SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,SalesType    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode1    
 ,m.ProductCategoryCode2    
 ,m.MaterialCode    
 ,SUM(TEMP.Qty) AS Qty    
 ,(CAST(ROUND((SUM(TEMP.Price) * SUM(TEMP.Qty)), 0) AS BIGINT)) AS Amount    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType    
 ,SUM(CASE     
   WHEN ChargeType = 'FRT'    
    THEN COGP.Qty * COGP.Price    
   ELSE 0    
   END) AS FRT_AMT    
 ,SUM(CASE     
   WHEN ChargeType = 'CST'    
    THEN COGP.Qty * COGP.Price    
   ELSE 0    
   END) AS CST_AMT    
 ,SUM(CASE     
   WHEN ChargeType = 'FOB'    
    THEN COGP.Qty * COGP.Price    
   ELSE 0    
   END) AS FOB_AMT    
 ,(    
  SUM(CASE     
    WHEN ChargeType = 'FRT'    
     THEN COGP.Qty * COGP.Price    
    ELSE 0    
    END) + SUM(CASE     
    WHEN ChargeType = 'CST'    
     THEN COGP.Qty * COGP.Price    
    ELSE 0    
    END) + SUM(CASE     
    WHEN ChargeType = 'FOB'    
     THEN COGP.Qty * COGP.Price    
    ELSE 0    
    END)    
  ) AS COG_AMT    
 ,    
 --GP_AMT=Sales Amt-COG Amt        
 (    
  MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (    
   SUM(CASE     
     WHEN ChargeType = 'FRT'    
      THEN COGP.Qty * COGP.Price    
     ELSE 0    
     END) + SUM(CASE     
     WHEN ChargeType = 'CST'    
      THEN COGP.Qty * COGP.Price    
     ELSE 0    
     END) + SUM(CASE     
     WHEN ChargeType = 'FOB'    
      THEN COGP.Qty * COGP.Price    
     ELSE 0    
     END)    
   )    
  ) AS GP_AMT    
 ,    
 --GP%=GP AMT/Sales AMT         
 (    
  CASE     
   WHEN (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT))) != 0    
    THEN (    
      (    
       MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (    
        SUM(CASE     
          WHEN ChargeType = 'FRT'    
           THEN COGP.Qty * COGP.Price    
          ELSE 0    
          END) + SUM(CASE     
          WHEN ChargeType = 'CST'    
           THEN COGP.Qty * COGP.Price    
          ELSE 0    
          END) + SUM(CASE     
          WHEN ChargeType = 'FOB'    
           THEN COGP.Qty * COGP.Price    
          ELSE 0    
          END)    
        )    
       ) * 100    
      ) / (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)))    
   ELSE 0    
   END    
  ) AS GP_Percentage    
FROM (    
 --sns data              
 SELECT p.Monthyear    
  ,CustomerCode    
  ,MaterialCode    
  ,Qty    
  ,P.FinalPrice AS price    
  ,'SNS' AS SalesType    
  ,SaleSubType    
 FROM SNSEntryArchive s    
 INNER JOIN SNSEntryQtyPriceArchive p ON s.SNSEntryId = p.SNSEntryId    
 WHERE S.ArchiveStatus='Archived'    
 UNION    
     
 --adj data              
 SELECT p.Monthyear    
  ,CustomerCode    
  ,MaterialCode    
  ,Qty    
  ,price    
  ,'Agent' AS SalesType    
  ,'Monthly' AS SaleSubType    
 FROM AdjustmentEntryArchive s    
 INNER JOIN AdjustmentEntryQtyPriceArchive p ON s.AdjustmentEntryId = p.AdjustmentEntryId    
     
 UNION    
     
 --ssd data              
 SELECT p.Monthyear    
  ,CustomerCode    
  ,MaterialCode    
  ,Qty    
  ,price    
  ,'Agent' AS SalesType    
  ,'Monthly' AS SaleSubType    
 FROM SSDEntryArchive s    
 INNER JOIN SSDEntryQtyPriceArchive p ON s.SSDEntryArchiveId = p.SSDEntryArchiveId    
     
 UNION    
     
 --Direct data              
 SELECT p.Monthyear    
  ,CustomerCode    
  ,MaterialCode    
  ,[dbo].[UDF_GetPSQuantityValueForConsolidation](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Quantity    
  ,[dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale_Archival](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Price    
  ,'Agent' AS SalesType    
  ,SaleSubType    
 FROM SaleEntryArchivalHeader h    
 INNER JOIN SalesArchivalEntry s ON h.SaleEntryArchivalHeaderId = s.SaleEntryArchivalHeaderId    
 INNER JOIN SalesArchivalEntryPriceQuantity p ON s.SalesArchivalEntryId = p.SalesArchivalEntryId    
 WHERE s.ModeOfTypeId = 1 AND H.ArchiveStatus='Archived'   
 ) TEMP    
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode    
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode    
LEFT JOIN COGEntryArchive cog ON TEMP.CustomerCode = cog.CustomerCode    
 AND cog.SaleSubType = TEMP.SaleSubType    
LEFT JOIN COGEntryQtyPriceArchive COGP ON cog.COGEntryId = COGP.COGEntryId    
GROUP BY DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName    
 ,SalesType    
 ,c.CustomerCode + '-' + CustomerName    
 ,c.CustomerCode    
 ,m.ProductCategoryName1    
 ,m.ProductCategoryName2    
 ,m.ProductCategoryName3    
 ,m.ProductCategoryCode1    
 ,m.ProductCategoryCode2    
 ,m.MaterialCode    
 ,COGP.COGEntryId    
 ,COGP.MonthYear    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType 
GO
/****** Object:  View [dbo].[VW_SNS_DETAILS_BP]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_SNS_DETAILS_BP]
AS
SELECT
	SE.CustomerCode
	,SE.MaterialCode
	,QP.MonthYear
	,SE.OACCode
	,SE.SaleSubType
	,CS.AccountCode
	,C.CountryCode
	,CS.SalesOfficeCode
	,CS.RegionCode
	,CS.DepartmentCode	
	,MV.ProductCategoryCode1 AS MGGroup
	,MV.ProductCategoryCode2 AS MG1
	,MV.ProductCategoryCode3 AS MG2
	,MV.ProductCategoryCode4 AS MG3
	,MV.ProductCategoryCode5 AS MG4
	,MV.ProductCategoryCode6 AS MG5
	,QP.Qty
	,QP.FinalPrice AS Price
FROM SNSEntry SE
INNER JOIN SNSEntryQtyPrice QP ON SE.SNSEntryId = QP.SNSEntryId
INNER JOIN CustomerView CS ON SE.CustomerCode = CS.CustomerCode
INNER JOIN Country C ON C.CountryId = CS.CountryId
INNER JOIN MaterialView MV ON SE.MaterialCode = MV.MaterialCode
	AND SE.SaleSubType = 'BP'
GO
/****** Object:  View [dbo].[VW_LY_NonConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_LY_NonConsolidatedReport]    
AS    
SELECT DISTINCT DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName AS SalesOfficeName    
 ,SalesType    
 ,c.CustomerCode + '-' + CustomerName AS Consignee    
 ,c.CustomerCode    
 ,m.ProductCategoryName1 AS MG    
 ,m.ProductCategoryName2 AS MG1    
 ,m.ProductCategoryName3 AS MG2    
 ,m.ProductCategoryCode1    
 ,m.ProductCategoryCode2    
 ,m.MaterialCode    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType    
 ,Currency    
,SUM(O_QTY) as O_QTY    
 ,SUM(P_QTY) as P_QTY    
 ,SUM(S_QTY) as S_QTY    
 ,SUM(I_QTY) as I_QTY    
 ,(SUM(O_QTY) * SUM(O_Price)) AS O_AMT    
 ,(SUM(P_QTY) * SUM(P_Price)) AS P_AMT    
 ,(SUM(S_QTY) * SUM(S_Price)) AS S_AMT    
 ,(SUM(I_QTY) * SUM(I_Price)) AS I_AMT   
FROM (    
 SELECT DISTINCT CustomerCode    
  ,MaterialCode    
  ,P.MonthYear    
  ,SaleSubType    
  ,'Agent' AS SalesType    
  ,P.CurrencyCode AS Currency    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 1    
     THEN [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale_Archival](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))    
    ELSE 0    
    END) AS O_QTY    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 2    
     THEN p.Quantity    
    ELSE 0    
    END) AS P_QTY    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 3    
     THEN p.Quantity    
    ELSE 0    
    END) AS S_QTY    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 4    
     THEN p.Quantity    
    ELSE 0    
    END) AS I_QTY    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 1    
     THEN [dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT))    
    ELSE 0    
    END) AS O_Price    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 2    
     THEN p.Price    
    ELSE 0    
    END) AS P_Price    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 3    
     THEN p.Price    
    ELSE 0    
    END) AS S_Price    
  ,SUM(CASE     
    WHEN ModeOfTypeId = 4    
     THEN p.Price    
    ELSE 0    
    END) AS I_Price    
 FROM SaleEntryArchivalHeader h    
 INNER JOIN SalesArchivalEntry s ON h.SaleEntryArchivalHeaderId = s.SaleEntryArchivalHeaderId    
 INNER JOIN SalesArchivalEntryPriceQuantity p ON s.SalesArchivalEntryId = p.SalesArchivalEntryId    
 WHERE ModeOfTypeId IN (    
   1    
   ,2    
   ,3    
   ,4    
   ,10    
   ,12    
   )    
  AND P.OCstatus = 'Y' 
  AND H.ArchiveStatus='Archived'
 GROUP BY CustomerCode    
  ,MaterialCode    
  ,P.MonthYear    
  ,SaleSubType    
  ,CurrencyCode    
     
 UNION    
     
 SELECT DISTINCT CustomerCode    
  ,sns.MaterialCode    
  ,sns.MonthYear    
  ,SaleSubType    
  ,'SNS' AS SalesType    
  ,Currency    
  ,SUM(CASE     
    WHEN ModeofType = 'ORDER'    
     THEN SNS.Quantity    
    ELSE 0    
    END) AS O_QTY    
  ,SUM(CASE     
    WHEN ModeofType = 'PURCHASE'    
     THEN SNS.Quantity    
    ELSE 0    
    END) AS P_QTY    
  ,MAX(SalesQty) AS S_QTY    
  ,SUM(CASE     
    WHEN ModeofType = 'INVENTORY'    
     THEN SNS.Quantity    
    ELSE 0    
    END) AS I_QTY    
 ,SUM(CASE 
				WHEN ModeofType = 'ORDER'
					THEN SNS.Price
				ELSE 0
				END) AS O_Price
		,SUM(CASE 
				WHEN ModeofType = 'PURCHASE'
					THEN SNS.Price
				ELSE 0
				END) AS P_Price
		,MAX(SalesPrice) AS S_Price
		,SUM(CASE 
				WHEN ModeofType = 'INVENTORY'
					THEN SNS.Price
				ELSE 0
				END) AS I_Price   
 FROM (    
  SELECT DISTINCT s.CustomerCode    
   ,s.MaterialCode    
   ,s.MonthYear    
   ,SaleSubType    
   ,'SNS' AS SalesType    
   ,trn.Quantity 
   ,trn.Price 
   ,p.Qty AS SalesQty    
   ,p.FinalPrice AS SalesPrice    
   ,ModeofType    
   ,P.Currency    
  FROM SNSEntryArchive s    
  INNER JOIN SNSEntryQtyPriceArchive P ON s.SNSEntryId = p.SNSEntryId    
  LEFT JOIN TRNPricePlanning trn ON s.MaterialCode = trn.MaterialCode    
   AND s.OACCode = trn.AccountCode    
   AND s.MonthYear = trn.MonthYear 
   AND S.ArchiveStatus='Archived'
   --where (trn.ModeofType in ('ORDER','PURCHASE','INVENTORY') or        
  ) SNS    
 GROUP BY CustomerCode    
  ,MaterialCode    
  ,MonthYear    
  ,SaleSubType    
  ,Currency    
 ) TEMP    
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode    
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode   
group  by     
  DepartmentName    
 ,CountryId    
 ,CountryName    
 ,SalesOfficeName     
 ,SalesType    
 ,CustomerName     
 ,c.CustomerCode    
 ,m.ProductCategoryName1     
 ,m.ProductCategoryName2    
 ,m.ProductCategoryName3     
 ,m.ProductCategoryCode1    
 ,m.ProductCategoryCode2    
 ,m.MaterialCode    
 ,TEMP.MonthYear    
 ,TEMP.SaleSubType    
 ,Currency 
GO
/****** Object:  View [dbo].[VW_LM_ConsolidatedReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_LM_ConsolidatedReport]
AS
SELECT DISTINCT DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName AS SalesOfficeName
	,SalesType
	,c.CustomerCode + '-' + CustomerName AS Consignee
	,c.CustomerCode
	,m.ProductCategoryName1 AS MG
	,m.ProductCategoryName2 AS MG1
	,m.ProductCategoryName3 AS MG2
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,SUM(TEMP.Qty) AS Qty
	,(CAST(ROUND((SUM(TEMP.Price) * SUM(TEMP.Qty)), 0) AS BIGINT)) AS Amount
	,TEMP.MonthYear
	,TEMP.SaleSubType
	,SUM(CASE 
			WHEN ChargeType = 'FRT'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS FRT_AMT
	,SUM(CASE 
			WHEN ChargeType = 'CST'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS CST_AMT
	,SUM(CASE 
			WHEN ChargeType = 'FOB'
				THEN cogp.Qty * cogp.Price
			ELSE 0
			END) AS FOB_AMT
	,(
		SUM(CASE 
				WHEN ChargeType = 'FRT'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END) + SUM(CASE 
				WHEN ChargeType = 'CST'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END) + SUM(CASE 
				WHEN ChargeType = 'FOB'
					THEN cogp.Qty * cogp.Price
				ELSE 0
				END)
		) AS COG_AMT
	,
	--GP_AMT=Sales Amt-COG Amt      
	(
		MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (
			SUM(CASE 
					WHEN ChargeType = 'FRT'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END) + SUM(CASE 
					WHEN ChargeType = 'CST'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END) + SUM(CASE 
					WHEN ChargeType = 'FOB'
						THEN cogp.Qty * cogp.Price
					ELSE 0
					END)
			)
		) AS GP_AMT
	,
	--GP%=GP AMT/Sales AMT       
	(
		CASE 
			WHEN (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT))) != 0
				THEN (
						(
							MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)) - (
								SUM(CASE 
										WHEN ChargeType = 'FRT'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END) + SUM(CASE 
										WHEN ChargeType = 'CST'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END) + SUM(CASE 
										WHEN ChargeType = 'FOB'
											THEN cogp.Qty * cogp.Price
										ELSE 0
										END)
								)
							) * 100
						) / (MAX(CAST(ROUND((TEMP.Price * TEMP.Qty), 0) AS BIGINT)))
			ELSE 0
			END
		) AS GP_Percentage
FROM (
	--sns data            
	SELECT Monthyear
		,CustomerCode
		,MaterialCode
		,Quantity AS Qty
		,Price
		,'SNS' AS SalesType
		,'Monthly' AS SaleSubType
	FROM TRNSalesPlanning s
	
	UNION
	
	--adj data            
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,Qty
		,price
		,'Agent' AS SalesType
		,'Monthly' AS SaleSubType
	FROM AdjustmentEntryArchive s
	INNER JOIN AdjustmentEntryQtyPriceArchive p ON s.AdjustmentEntryId = p.AdjustmentEntryId
	
	UNION
	
	--ssd data            
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,Qty
		,price
		,'Agent' AS SalesType
		,'Monthly' AS SaleSubType
	FROM SSDEntryArchive s
	INNER JOIN SSDEntryQtyPriceArchive p ON s.SSDEntryArchiveId = p.SSDEntryArchiveId
	
	UNION
	
	--Direct data            
	SELECT p.Monthyear
		,CustomerCode
		,MaterialCode
		,[dbo].[UDF_GetPSQuantityValueForConsolidation](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Quantity
		,[dbo].[UDF_GetSumPrice_O_MPO_ADJ_DirectSale](h.SaleEntryArchivalHeaderId, s.MaterialCode, h.CustomerCode, cast(p.MonthYear AS INT)) AS Price
		,'Agent' AS SalesType
		,SaleSubType
	FROM SaleEntryArchivalHeader h
	INNER JOIN SalesArchivalEntry s ON h.SaleEntryArchivalHeaderId = s.SaleEntryArchivalHeaderId
	INNER JOIN SalesArchivalEntryPriceQuantity p ON s.SalesArchivalEntryId = p.SalesArchivalEntryId
	WHERE s.ModeOfTypeId = 1
	) TEMP
INNER JOIN CustomerView c ON TEMP.CustomerCode = c.CustomerCode
INNER JOIN MaterialView m ON TEMP.MaterialCode = m.MaterialCode
LEFT JOIN COGEntryArchive cog ON TEMP.CustomerCode = cog.CustomerCode
	AND cog.SaleSubType = TEMP.SaleSubType
LEFT JOIN COGEntryQtyPriceArchive cogp ON cog.COGEntryId = cogp.COGEntryId
GROUP BY DepartmentName
	,CountryId
	,CountryName
	,SalesOfficeName
	,SalesType
	,c.CustomerCode + '-' + CustomerName
	,c.CustomerCode
	,m.ProductCategoryName1
	,m.ProductCategoryName2
	,m.ProductCategoryName3
	,m.ProductCategoryCode1
	,m.ProductCategoryCode2
	,m.MaterialCode
	,cogp.COGEntryId
	,cogp.MonthYear
	,TEMP.MonthYear
	,TEMP.SaleSubType
GO
/****** Object:  View [dbo].[DirectSaleView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE view [dbo].[DirectSaleView]        
as        
select se.SalesEntryId,q.SalesEntryPriceQuantityId,h.CurrentMonthYear,
q.MonthYear,q.Quantity,q.Price,se.ModeOfTypeId,
h.CustomerId,    
m.CompanyId,    
c.CountryId,        
c.CustomerCode,    
c.CustomerName,    
m.MaterialCode,    
h.ProductCategoryId1,    
h.ProductCategoryId2 ,        
p1.ProductCategoryName as Mg,    
p2.ProductCategoryName as Mg1  
       
from SaleEntryHeader h        
inner join SalesEntry se        
on h.SaleEntryHeaderId=se.SaleEntryHeaderId    
inner join SalesEntryPriceQuantity q on se.SalesEntryId=q.SalesEntryId  
join Customer c on h.CustomerId=c.CustomerId        
join  Material m on se.MaterialId=m.MaterialId        
Left join  ProductCategory p1 on h.ProductCategoryId1=p1.ProductCategoryId        
Left join  ProductCategory p2 on h.ProductCategoryId1=p2.ProductCategoryId 
GO
/****** Object:  View [dbo].[DS_RESULT_VIEW]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create VIEW [dbo].[DS_RESULT_VIEW]
As

WITH TEMP (CustomerId, ProductCategoryId1, ProductCategoryId2,CurrentMonthYear, LockMonthYear, MaterialId,OCmonthYear,MonthYear,Price,Quantity) 
    AS 
    (
        SELECT SH.CustomerId,SH.ProductCategoryId1,SH.ProductCategoryId2,SH.CurrentMonthYear,SH.LockMonthYear ,
		SE.MaterialId,SE.OCmonthYear
		,SP.MonthYear,SP.Price,SP.Quantity
		FROM SaleEntryHeader SH 
		INNER JOIN SalesEntry SE ON SH.SaleEntryHeaderId = SE.SaleEntryHeaderId
		INNER JOIN SalesEntryPriceQuantity  SP ON SP.SalesEntryId= SE.SalesEntryId
    )

select C.CustomerCode, T.CurrentMonthYear ,T.LockMonthYear,

M.MaterialCode, T.OCmonthYear , T.MonthYear ,T.Price ,T.Quantity  from TEMP T
INNER JOIN Customer C on T.CustomerID=C.CustomerID
INNER JOIN Material M on M.MaterialId=T.MaterialId



--select * from Customer
GO
/****** Object:  View [dbo].[SNS_Entries_View]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[SNS_Entries_View]
AS
SELECT DISTINCT SE.SNSEntryId
	,SE.CustomerId
	,SE.CustomerCode
	,CS.CustomerName
	,SE.MaterialId
	,SE.MaterialCode
	,SE.CategoryId
	,'' AS CategoryCode
	,SE.AttachmentID
	,SE.MonthYear
	,SE.OACCode
	,SE.SaleSubType
	,AccountId
	,C.CountryId
	,PC.ProductCategoryId
	,PC.ProductCategoryCode
	,PC.ProductCategoryName
FROM SNSEntry SE
INNER JOIN Customer CS ON SE.CustomerId = CS.CustomerId
INNER JOIN CustomerDID CD ON CD.CustomerId = CS.CustomerId
INNER JOIN Country C ON C.CountryId = CS.CountryId
INNER JOIN ProductCategory PC ON PC.ProductCategoryCode = CAST(SE.CategoryId AS VARCHAR)
	AND PC.ProductCategoryName = SE.Category
GO
/****** Object:  View [dbo].[TransmissionListView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[TransmissionListView]  
as   
  
select t.TransmissionListId,c.CustomerName  
,c.CustomerCode,p.PlanTypeCode,p.PlanTypeName,t.SalesType from TransmissionList t   
left join Customer c on t.CustomerCode=c.CustomerCode  
left join TransmissionPlanType p   
on t.PlanTypeCode=p.PlanTypeCode  
where t.IsActive=1  
GO
/****** Object:  View [dbo].[TransmitDataView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view  [dbo].[TransmitDataView]
as
select distinct PlanTypeCode,PlanTypeName,c.CustomerName,t.Customercode,[status],EDIStatus,t.SaleType
from transmissiondata t inner join Customer c
on t.Customercode=c.Customercode
where [status]='pending'
and t.Customercode not in ('')
GO
/****** Object:  View [dbo].[UserdepartmentCountryView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[UserdepartmentCountryView]
as
select UserId,'' as UserName, DepartmentName,udm.DepartmentId,CountryId from userDepartmentMapping AS udm  
LEFT JOIN department AS dept  
    ON udm.DepartmentId = dept.DepartmentId 

	
GO
/****** Object:  View [dbo].[UserProductMappingView]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[UserProductMappingView]
AS
SELECT
upm.Id as userProductMappId,
upm.UserId,
 prd.ProductId,
 prd.ProductCode,
 prd.ProductName,
 prd.CreatedDate,
 prd.CreatedBy,
 prd.UpdateDate,
 prd.UpdateBy
FROM
    UserProductMapping AS upm
LEFT JOIN Product AS prd
    ON upm.ProductId = prd.ProductId
GO
/****** Object:  View [dbo].[VM_GetCustomerSNSDetailsQtyPRice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[VM_GetCustomerSNSDetailsQtyPRice]
as
select  a.SNSEntryId, a.CustomerId, a.CustomerCode,a.CustomerName, a.MaterialId, a.MaterialCode, a.CategoryId,'' as CategoryCode, a.AttachmentID, a.OACCode , 
a.SaleSubType , a.SaleTypeId,a.AccountId, a.CountryId, Sp.Qty,sp.MonthYear,Sp.FinalPrice
from (
select Distinct SE.SNSEntryId, SE.CustomerId, SE.CustomerCode,CS.CustomerName, SE.MaterialId, SE.MaterialCode, SE.CategoryId,'' as CategoryCode, SE.AttachmentID,SE. MonthYear, SE.OACCode , 
SE.SaleSubType , CD.SaleTypeId,AccountId, C.CountryId
--,

--PC.ProductCategoryId, PC.ProductCategoryCode,PC.ProductCategoryName 
from SNSEntry SE
INNER JOIN Customer CS on SE.CustomerId = CS.CustomerId
INNER JOIN CustomerDID CD on CD.CustomerId = CS.CustomerId
Inner join Country C ON C.CountryId= CS.CountryId) a 
--INNER JOIN ProductCategory PC on PC.ProductCategoryCode = CAST( SE.CategoryId as varchar)
inner join SNSEntryQtyPrice SP on SP.SNSEntryId = a.SNSEntryId


GO
/****** Object:  View [dbo].[VW_ATTACHMENT]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[VW_ATTACHMENT]
AS
SELECT A.Id, DocumentName, A.IsActive, VirtualFileName,
DocumentPath, FileTypeId, FileTypeName,
CreatedBy, CreatedDate,
A.FolderName,
DocumentMonth,
B.DisplayName
FROM     dbo.Attachments A
JOIN DocumentTypes B
ON A.FolderName=B.FolderName
GO
/****** Object:  View [dbo].[VW_COG_ENTRY_DETAILS]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_COG_ENTRY_DETAILS]
AS
SELECT CustomerCode
	,MaterialCode
	,Price
	,ChargeType
	,SaleSubType
FROM COGEntry A
INNER JOIN COGEntryQtyPrice B ON B.COGEntryId = A.COGEntryId
GO
/****** Object:  View [dbo].[VW_DASHMASTER]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_DASHMASTER]  
AS  
 SELECT DM.DashMaterialId, MaterialCode,  
  DM.CustomerCode,SalesCompany,DM.SupplierCode, SUP.SupplierName,
        DM.ReasonId,TransPortMode,DM.CreatedBy,  
  DM.CreatedDate,UpdatedBy,UpdatedDate,  
     RegistrationDateTime,RegistrationUserCode,  
  RecordChangeDateTime,RecordChangeUserCode,  
  DM.IsActive, StartMonth, EndMonth,  
     RG.ReasonName,  CUST.CustomerName  
  
FROM DashMaterial DM   
LEFT JOIN Reason RG ON DM.ReasonId=RG.ReasonCode 
left join supplier SUP ON DM.SupplierCode=SUP.SupplierCode
LEFT JOIN Customer CUST ON DM.CustomerCode=CUST.CustomerCode  
GO
/****** Object:  View [dbo].[VW_DASHMASTERBP]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE VIEW [dbo].[VW_DASHMASTERBP]  
AS  
SELECT DashMaterialBPId  
      ,UserId  
      ,RecordType  
      ,RenewalMark  
      ,A.CustomerCode ,c.CompanyCode 
      ,ModelCreationDate  
      ,ModelNo  
      ,FinancialYear  
      ,ModelType  
      ,SaleStartDate  
      ,FactoryCode  
      ,A.SupplierCode  
      ,MaterialDescription  
      ,MaterialVolume  
      ,TermCode,   RG.ReasonName   
      ,CurrencyCode  
      ,Model1StartDate  
      ,Model1EndDate  
      ,Model1Price  
      ,Model2StartDate  
      ,Model2EndDate  
      ,Model2Price  
      ,ModelDiscontinueDate  
      ,PreviousItemCode  
      ,A.CreatedDate  
      ,A.CreatedBy  
      ,UpdatedDate  
      ,UpdatedBy  
   ,B.CustomerName  
   ,S.SupplierName  
  FROM dbo.DashMaterialBP A  
  left join material m on a.ModelNo=m.MaterialCode
  left join company c on m.companyid=c.companyid
  LEFT JOIN Reason RG ON A.ModelType=RG.ReasonCode
  LEFT JOIN Customer B  
  ON A.CustomerCode=B.CustomerCode  
  LEFT JOIN Supplier S  
  ON A.SupplierCode=S.SupplierCode  
  
GO
/****** Object:  View [dbo].[VW_DashMasterMonthWise]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_DashMasterMonthWise]
AS 

----Select * from DashMaterial
 with MonthlyCte(      DashMaterialId,
						MaterialCode,
						SalesCompany,
						CustomerCode,
						TransPortMode,
						IsActive, 
						StartDate,
						EndDate,
						SupplierCode,
						CreatedBy,
						CreatedDate,
						UpdatedBy,
						UpdatedDate
						)
AS (
			 SELECT  
			            DashMaterialId,
			            MaterialCode,
						SalesCompany,
						CustomerCode,
						TransPortMode,
						IsActive, 
						 CAST(LEFT(CAST(StartMonth AS varchar),4)+'-' +RIGHT(CAST(StartMonth AS varchar),2) +'-01' AS DATE)AS StartDate,
						CASE WHEN EndMonth=999999 THEN CONVERT(date, GETDATE()) ELSE 
                        CAST(LEFT(CAST(EndMonth AS varchar),4)+'-'+RIGHT(CAST(EndMonth AS varchar),2) +'-01' AS DATE)END AS EndDate,
						SupplierCode,
						CreatedBy,
						CreatedDate,
						UpdatedBy,
						UpdatedDate
              FROM DashMaterial ORD
              UNION  ALL
              SELECT     A.DashMaterialId,
			              A.MaterialCode,
						  A.SalesCompany,
						  A.CustomerCode,
						  A.TransPortMode,
						  A.IsActive,
						  DATEADD(MONTH,1,A.StartDate) AS StartDate,
						  A.EndDate,
						  A.SupplierCode,
						  A.CreatedBy,
						  A.CreatedDate,
						  A.UpdatedBy,
						  A.UpdatedDate
			  FROM	MonthlyCte A join DashMaterial ORD
			  ON A.MaterialCode=ORD.MaterialCode 
              WHERE StartDate <= EndDate AND  A.DashMaterialId=ORD.DashMaterialId )

SELECT  DashMaterialId,
        MaterialCode,
		SalesCompany,
		CustomerName,
		TransPortMode,
		A.IsActive, 
		   LEFT(CONVERT(varchar, StartDate,112),6)AS Months,
		SupplierCode,
		A.CreatedBy,
		A.CreatedDate,
		UpdatedBy,
		UpdatedDate	   
		
    FROM MonthlyCte  A
	LEFT JOIN Customer C on A.CustomerCode=C.CustomerCode	
GO
/****** Object:  View [dbo].[VW_DIRECT_SALE]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_DIRECT_SALE]
AS
WITH TEMP (
	SaleEntryHeaderId
	,SalesEntryId
	,CustomerId
	,ProductCategoryId1
	,ProductCategoryId2
	,CurrentMonthYear
	,LockMonthYear
	,MaterialId
	,OCmonthYear
	,MonthYear
	,Price
	,Quantity
	,ModeOfTypeId
	,SaleSubType
	,CurrencyCode
	)
AS (
	SELECT SH.SaleEntryHeaderId
		,SP.SalesEntryId
		,SH.CustomerId
		,SH.ProductCategoryId1
		,SH.ProductCategoryId2
		,SH.CurrentMonthYear
		,SH.LockMonthYear
		,SE.MaterialId
		,SE.OCmonthYear
		,SP.MonthYear
		,SP.Price
		,SP.Quantity
		,SE.ModeOfTypeId
		,SH.SaleSubType
		,SP.CurrencyCode
	FROM SaleEntryHeader SH
	INNER JOIN SalesEntry SE ON SH.SaleEntryHeaderId = SE.SaleEntryHeaderId
	INNER JOIN SalesEntryPriceQuantity SP ON SP.SalesEntryId = SE.SalesEntryId
	)
SELECT T.SaleEntryHeaderId
	,T.SalesEntryId
	,C.CustomerCode
	,T.CurrentMonthYear
	,T.LockMonthYear
	,M.MaterialCode
	,T.OCmonthYear
	,T.MonthYear
	,T.Price
	,T.Quantity
	,T.ModeOfTypeId
	,T.SaleSubType
	,MT.ModeofTypeCode
	,MT.ModeofTypeName
	,CurrencyCode
FROM TEMP T
INNER JOIN Customer C ON T.CustomerID = C.CustomerID
INNER JOIN Material M ON M.MaterialId = T.MaterialId
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId
	--select * from Customer  
GO
/****** Object:  View [dbo].[VW_DIRECT_SALE_ARCHIVAL]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[VW_DIRECT_SALE_ARCHIVAL]
AS

	SELECT DISTINCT SH.SaleEntryArchivalHeaderId
		,SH.CustomerCode
		,SE.MaterialCode
		,SP.Price
		,SP.Quantity
		,SP.MonthYear
		,ModeOfTypeId
	FROM SaleEntryArchivalHeader SH
	INNER JOIN SalesArchivalEntry SE ON SH.SaleEntryArchivalHeaderId = SE.SaleEntryArchivalHeaderId
	INNER JOIN SalesArchivalEntryPriceQuantity SP ON SP.SalesArchivalEntryId = SE.SalesArchivalEntryId

GO
/****** Object:  View [dbo].[VW_DIRECT_SALE_ARCHIVE_MONTHLY]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE VIEW [dbo].[VW_DIRECT_SALE_ARCHIVE_MONTHLY]  
AS  
WITH TEMP (  
 SaleEntryHeaderId  
 ,SalesEntryId  
 ,CustomerId  
 ,ProductCategoryId1  
 ,ProductCategoryId2  
 ,CurrentMonthYear  
 ,LockMonthYear  
 ,MaterialId  
 ,OCmonthYear  
 ,MonthYear  
 ,Price  
 ,Quantity  
 ,ModeOfTypeId  
 ,SaleSubType  
 ,CurrencyCode
 ,ArchivalMonthYear
 )  
AS (  
 SELECT SH.SaleEntryArchivalHeaderId  
  ,SP.SalesArchivalEntryId  
  ,SH.CustomerId  
  ,SH.ProductCategoryId1  
  ,SH.ProductCategoryId2  
  ,SH.CurrentMonthYear  
  ,SH.LockMonthYear  
  ,SE.MaterialId  
  ,SE.OCmonthYear  
  ,SP.MonthYear  
  ,SP.Price  
  ,SP.Quantity  
  ,SE.ModeOfTypeId  
  ,SH.SaleSubType  
  ,SP.CurrencyCode 
  ,SH.ArchivalMonthYear
 FROM SaleEntryArchivalHeader  SH
INNER JOIN SalesArchivalEntry SE ON SE.SaleEntryArchivalHeaderId = SH.SaleEntryArchivalHeaderId
INNER JOIN SalesArchivalEntryPriceQuantity SP ON SE.SalesArchivalEntryId = Sp.SalesArchivalEntryId
WHERE  SH.ArchiveStatus='Archived'
 AND SE.ModeOfTypeId IN (  
   1  
   ,2  
   ,3  
   ,4  
   ,10  
   ,12  
  
   )  
  AND SH.SaleSubType = 'MONTHLY'  
 )  
SELECT T.SaleEntryHeaderId  
 ,T.SalesEntryId  
 ,C.CustomerCode  
 ,T.CurrentMonthYear  
 ,T.LockMonthYear  
 ,M.MaterialCode  
 ,T.OCmonthYear  
 ,T.MonthYear  
 ,T.Price  
 ,T.Quantity  
 ,T.ModeOfTypeId  
 ,T.SaleSubType  
 ,MT.ModeofTypeCode  
 ,MT.ModeofTypeName  
 ,CurrencyCode  
FROM TEMP T  
INNER JOIN Customer C ON T.CustomerID = C.CustomerID  
INNER JOIN Material M ON M.MaterialId = T.MaterialId  
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId  
       
GO
/****** Object:  View [dbo].[VW_DIRECT_SALE_BP]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VW_DIRECT_SALE_BP]
AS
WITH TEMP (
	SaleEntryHeaderId
	,SalesEntryId
	,CustomerId
	,ProductCategoryId1
	,ProductCategoryId2
	,CurrentMonthYear
	,LockMonthYear
	,MaterialId
	,OCmonthYear
	,MonthYear
	,Price
	,Quantity
	,ModeOfTypeId
	,SaleSubType
	,CurrencyCode
	)
AS (
	SELECT SH.SaleEntryHeaderId
		,SP.SalesEntryId
		,SH.CustomerId
		,SH.ProductCategoryId1
		,SH.ProductCategoryId2
		,SH.CurrentMonthYear
		,SH.LockMonthYear
		,SE.MaterialId
		,SE.OCmonthYear
		,SP.MonthYear
		,SP.Price
		,SP.Quantity
		,SE.ModeOfTypeId
		,SH.SaleSubType
		,SP.CurrencyCode
	FROM SaleEntryHeader SH
	INNER JOIN SalesEntry SE ON SH.SaleEntryHeaderId = SE.SaleEntryHeaderId
	INNER JOIN SalesEntryPriceQuantity SP ON SP.SalesEntryId = SE.SalesEntryId
	WHERE SE.ModeOfTypeId IN (
			1
			,2
			,3
			,4
			,10
			,12

			)
		AND SH.SaleSubType = 'BP'
	)
SELECT T.SaleEntryHeaderId
	,T.SalesEntryId
	,C.CustomerCode
	,T.CurrentMonthYear
	,T.LockMonthYear
	,M.MaterialCode
	,T.OCmonthYear
	,T.MonthYear
	,T.Price
	,T.Quantity
	,T.ModeOfTypeId
	,T.SaleSubType
	,MT.ModeofTypeCode
	,MT.ModeofTypeName
	,CurrencyCode
FROM TEMP T
INNER JOIN Customer C ON T.CustomerID = C.CustomerID
INNER JOIN Material M ON M.MaterialId = T.MaterialId
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId
	    
GO
/****** Object:  View [dbo].[VW_DIRECT_SALE_MONTHLY]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE VIEW [dbo].[VW_DIRECT_SALE_MONTHLY]  
AS  
  WITH TEMP (  
 SaleEntryHeaderId  
 ,SalesEntryId  
 ,CustomerId  
 ,ProductCategoryId1  
 ,ProductCategoryId2  
 ,CurrentMonthYear  
 ,LockMonthYear  
 ,MaterialId  
 ,OCmonthYear  
 ,MonthYear  
 ,Price  
 ,Quantity  
 ,ModeOfTypeId  
 ,SaleSubType  
 ,CurrencyCode  
 )  
AS (  
 SELECT SH.SaleEntryHeaderId  
  ,SP.SalesEntryId  
  ,SH.CustomerId  
  ,SH.ProductCategoryId1  
  ,SH.ProductCategoryId2  
  ,SH.CurrentMonthYear  
  ,SH.LockMonthYear  
  ,SE.MaterialId  
  ,SE.OCmonthYear  
  ,SP.MonthYear  
  ,SP.Price  
  ,SP.Quantity  
  ,SE.ModeOfTypeId  
  ,SH.SaleSubType  
  ,SP.CurrencyCode  
 FROM SaleEntryHeader SH  
 INNER JOIN SalesEntry SE ON SH.SaleEntryHeaderId = SE.SaleEntryHeaderId  
 INNER JOIN SalesEntryPriceQuantity SP ON SP.SalesEntryId = SE.SalesEntryId  
 WHERE SE.ModeOfTypeId IN (  
   1  
   ,2  
   ,3  
   ,4  
   ,10  
   ,12  
  
   )  
  AND SH.SaleSubType = 'MONTHLY'  
 )  
SELECT T.SaleEntryHeaderId  
 ,T.SalesEntryId  
 ,C.CustomerCode  
 ,T.CurrentMonthYear  
 ,T.LockMonthYear  
 ,M.MaterialCode  
 ,T.OCmonthYear  
 ,T.MonthYear  
 ,T.Price  
 ,T.Quantity  
 ,T.ModeOfTypeId  
 ,T.SaleSubType  
 ,MT.ModeofTypeCode  
 ,MT.ModeofTypeName  
 ,CurrencyCode  
FROM TEMP T  
INNER JOIN Customer C ON T.CustomerID = C.CustomerID  
INNER JOIN Material M ON M.MaterialId = T.MaterialId  
INNER JOIN ModeofType MT ON MT.ModeofTypeId = T.ModeOfTypeId  
       
GO
/****** Object:  View [dbo].[VW_SNS]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE VIEW [dbo].[VW_SNS]  
AS  
  
 SELECT DISTINCT S.SNSEntryId  
  ,S.CustomerCode  
  ,S.MaterialCode  
  ,P.Price  
  ,P.Qty  
  ,P.MonthYear  
  ,ModeOfTypeId 
  ,OACCode
 FROM SNSEntry S  
 INNER JOIN SNSEntryQtyPrice P ON S.SNSEntryId=P.SNSEntryId  
  
GO
/****** Object:  View [dbo].[VW_SNS_Planning_Comment]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_SNS_Planning_Comment]
AS
select PC.*, U.Name as CreatedByName from [dbo].[SNS_Planning_Comment] PC
LEFT JOIN Users U
ON PC.CreatedBy = U.UserId;
GO
/****** Object:  View [dbo].[VW_SNSEntryWithQtyPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
/****** Object:  StoredProcedure [dbo].[SP_ADD_CONSOLIDATED_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ADD_CONSOLIDATED_TRANSMISSION]
	-- Add the parameters for the stored procedure here          
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@Type VARCHAR(20)
	,@CurrentMonth INT
	,@CreatedBy VARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                      
	-- interfering with SELECT statements.                      
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here                                
	BEGIN TRY
		-- Insert statements for procedure here                      
		DECLARE @CurrentMonthDate VARCHAR(10);

		---- Need to get Total Month count -- Current month +5                            
		SET @CurrentMonthDate = CAST(CAST(@CurrentMonth AS VARCHAR(10)) + '01' AS DATE)

		CREATE TABLE #ConsoleTMPMonthData (MonthData INT)

		DECLARE @StartMonth INT = 0;
		DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                          

		WHILE @StartMonth <= @EndMonth
		BEGIN
			INSERT INTO #ConsoleTMPMonthData (MonthData)
			VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))

			SET @StartMonth = @StartMonth + 1
		END;

		-- Check if the temporary table exists            
		IF OBJECT_ID('tempdb.dbo.#ConsoleTMP') IS NOT NULL
		BEGIN
			-- Drop the temporary table            
			DROP TABLE #ConsoleTMP;
		END

		CREATE TABLE #ConsoleTMP (
			CustomerCode VARCHAR(50)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,MaterialCode VARCHAR(50)
			,OCmonthYear INT
			,MonthYear INT
			,ModeOfTypeId INT
			,ModeOfTypeText VARCHAR(20)
			,TotalAmount INT
			,TotalQuantity INT
			,PLanName VARCHAR(20)
			,SaleSequenceType VARCHAR(2)
			,DataOrderBy INT
			);
			
			-- SELECT Customer which is TransmissionList -- Collabo                      

		WITH CTECollabo (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		AS (
			-- PURCHASE DATA                    
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'P' AS ModeText
				,[dbo].[UDF_GetPSQuantityValueForConsolidation](SaleEntryHeaderId, MaterialCode, TL.CustomerCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueForConsolidation](SaleEntryHeaderId, MaterialCode, TL.CustomerCode, MonthYear), 0) AS INT) AS TotalAmount
				,'Consoli' AS PlanName
				,'01' AS SaleSequenceType
				,1
			FROM TransmissionList TL
			INNER JOIN [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode = TL.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (2)
				AND VD.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			-- SALE DATA                    
			
			UNION
			
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'S' AS ModeText
				,[dbo].[UDF_GetPSQuantityValueForConsolidation](SaleEntryHeaderId, MaterialCode, TL.CustomerCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueForConsolidation](SaleEntryHeaderId, MaterialCode, TL.CustomerCode, MonthYear), 0) AS INT) AS TotalAmount
				,'Consoli' AS PlanName
				,'02' AS SaleSequenceType
				,2
			FROM TransmissionList TL
			INNER JOIN [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode = TL.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (3)
				AND VD.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			-- INVENTORY DATA                    
			
			UNION
			
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'I' AS ModeText
				,0
				,0
				,'Consoli' AS PlanName
				,'03' AS SaleSequenceType
				,3
			FROM TransmissionList TL
			INNER JOIN [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode = TL.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (4)
				AND VD.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			)
		INSERT INTO #ConsoleTMP (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalAmount
			,TotalQuantity
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		SELECT CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
		FROM CTECollabo;

			-- SELECT Customer which is not in TransmissionList -- NON Collabo      
		WITH CTENonCollabo (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		AS (
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'P' AS ModeText
				,[dbo].[UDF_GetPSQuantityValueForConsolidation](SaleEntryHeaderId, MaterialCode, VD.CustomerCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueForConsolidation](SaleEntryHeaderId, MaterialCode, VD.CustomerCode, MonthYear), 0) AS INT) AS TotalAmount
				,'Consoli' AS PlanName
				,'01' AS SaleSequenceType
				,4
			FROM [dbo].[VW_DIRECT_SALE] VD
			INNER JOIN Customer c ON VD.CustomerCode = c.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE c.IsCollabo = 0
				AND VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (2)
			
			UNION
			
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'S' AS ModeText
				,[dbo].[UDF_GetPSQuantityValueForConsolidation](SaleEntryHeaderId, MaterialCode, VD.CustomerCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueForConsolidation](SaleEntryHeaderId, MaterialCode, VD.CustomerCode, MonthYear), 0) AS INT) AS TotalAmount
				,'Consoli' AS PlanName
				,'02' AS SaleSequenceType
				,5
			FROM [dbo].[VW_DIRECT_SALE] VD
			INNER JOIN Customer c ON VD.CustomerCode = c.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE IsCollabo = 0
				AND VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (3)
			
			UNION
			
			SELECT VD.CustomerCode
				,VD.CurrentMonthYear
				,VD.LockMonthYear
				,VD.MaterialCode
				,VD.OCmonthYear
				,VD.MonthYear
				,VD.ModeOfTypeId
				,'I' AS ModeText
				,0
				,0
				,'Consoli' AS PlanName
				,'03' AS SaleSequenceType
				,6
			FROM [dbo].[VW_DIRECT_SALE] VD
			INNER JOIN Customer c ON VD.CustomerCode = c.CustomerCode
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = VD.MonthYear
			WHERE IsCollabo = 0
				AND VD.SaleSubType = @Type
				AND VD.ModeOfTypeId IN (4)
			)
		INSERT INTO #ConsoleTMP (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalAmount
			,TotalQuantity
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		SELECT CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
		FROM CTENonCollabo;

        -- ADJUSTMENT-- 
		WITH CTEAdjustment (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		AS (
			SELECT AE.CustomerCode
				,0
				,0
				,AE.MaterialCode
				,0
				,AP.MonthYear
				,2
				,'P'
				,AP.Qty
				,ROUND(AP.Price, 0) AS Price
				,'Consoli'
				,'01' AS SaleSequenceType
				,7
			FROM [dbo].[AdjustmentEntry] AE
			INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear
			WHERE AE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			
			UNION
			
			SELECT AE.CustomerCode
				,0
				,0
				,AE.MaterialCode
				,0
				,AP.MonthYear
				,3
				,'S'
				,AP.Qty
				,ROUND(AP.Price, 0) AS Price
				,'Consoli'
				,'02' AS SaleSequenceType
				,8
			FROM [dbo].[AdjustmentEntry] AE
			INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear
			WHERE AE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			
			UNION
			
			SELECT AE.CustomerCode
				,0
				,0
				,AE.MaterialCode
				,0
				,AP.MonthYear
				,4
				,'I'
				,'0'
				,'0'
				,'Consoli'
				,'03' AS SaleSequenceType
				,9
			FROM [dbo].[AdjustmentEntry] AE
			INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP ON AE.AdjustmentEntryId = AP.AdjustmentEntryId
			INNER JOIN #ConsoleTMPMonthData TD ON TD.MonthData = AP.MonthYear
			WHERE AE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			)
		INSERT INTO #ConsoleTMP (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalAmount
			,TotalQuantity
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		SELECT CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
		FROM CTEAdjustment
			;

		---SSD--	
		WITH CTESSD (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		AS (
			SELECT SE.CustomerCode
				,0
				,0
				,SE.MaterialCode
				,0
				,SP.MonthYear
				,2
				,'P'
				,SP.Qty
				,ROUND((SP.Price * SP.Qty), 0)
				,'Consoli' AS PlanName
				,'01' AS SaleSequenceType
				,10
			FROM [dbo].[SSDEntryQtyPrice] SP
			INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SP.SSDEntryID
			INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData
			WHERE SE.ModeOfTypeId = 1
				AND SE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			
			UNION
			
			SELECT SE.CustomerCode
				,0
				,0
				,SE.MaterialCode
				,0
				,SP.MonthYear
				,2
				,'S'
				,SP.Qty
				,ROUND((SP.Price * SP.Qty), 0)
				,'Consoli' AS PlanName
				,'02' AS SaleSequenceType
				,11
			FROM [dbo].[SSDEntryQtyPrice] SP
			INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SP.SSDEntryID
			INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData
			WHERE SE.ModeOfTypeId = 1
				AND SE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			
			UNION
			
			SELECT SE.CustomerCode
				,0
				,0
				,SE.MaterialCode
				,0
				,SP.MonthYear
				,2
				,'I'
				,0
				,0
				,'Consoli' AS PlanName
				,'03' AS SaleSequenceType
				,12
			FROM [dbo].[SSDEntryQtyPrice] SP
			INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID = SP.SSDEntryID
			INNER JOIN #ConsoleTMPMonthData TD ON SP.MonthYear = TD.MonthData
			WHERE SE.ModeOfTypeId = 1
				AND SE.CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
			)
		INSERT INTO #ConsoleTMP (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalAmount
			,TotalQuantity
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		SELECT CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
		FROM CTESSD

		--SNS DATA      
		CREATE TABLE #AccountTable (
			AccountCode VARCHAR(50)
			,CustomerCode VARCHAR(50)
			,
			)

		INSERT INTO #AccountTable (
			AccountCode
			,CustomerCode
			)
		SELECT AccountCode
			,CustomerCode
		FROM CustomerView
		WHERE CustomerCode IN (
				SELECT CustomerCode
				FROM @TVP_CUSTOMERCODE_LIST
				);;

		WITH CTESNS (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,MonthYear
			,OCmonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		AS (
			SELECT CustomerCode
				,0
				,0
				,MaterialCode
				,MonthYear
				,0
				,2
				,'P'
				,[dbo].[UDF_GetPSQuantityValueForSNSConsolidation](MaterialCode, a.AccountCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueValueForSNSConsolidation](a.CustomerCode, MaterialCode, a.AccountCode, MonthYear, @Type), 0) AS INT) AS TotalAmount
				,'Consoli' AS PLanName
				,'01' AS SequenceType
				,13
			FROM TRNPricePlanning p
			LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData
			LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode
			WHERE ModeofType IN ('PURCHASE')
				AND a.AccountCode IS NOT NULL
				AND MD.MonthData IS NOT NULL
			
			UNION
			
			SELECT CustomerCode
				,0
				,0
				,MaterialCode
				,MonthYear
				,0
				,2
				,'S'
				,[dbo].[UDF_GetPSQuantityValueForSNSConsolidation](MaterialCode, a.AccountCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueValueForSNSConsolidation](a.CustomerCode, MaterialCode, a.AccountCode, MonthYear, @Type), 0) AS INT) AS TotalAmount
				,'Consoli' AS PLanName
				,'02' AS SequenceType
				,14
			FROM TRNPricePlanning p
			LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData
			LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode
			WHERE ModeofType IN ('SALES')
				AND a.AccountCode IS NOT NULL
				AND MD.MonthData IS NOT NULL
			
			UNION
			
			SELECT CustomerCode
				,0
				,0
				,MaterialCode
				,MonthYear
				,0
				,2
				,'I'
				,[dbo].[UDF_GetPSQuantityValueForSNSConsolidation](MaterialCode, a.AccountCode, MonthYear) AS TotalQuantity
				,CAST(ROUND([dbo].[UDF_GetPSValueValueForSNSConsolidation](a.CustomerCode, MaterialCode, a.AccountCode, MonthYear, @Type), 0) AS INT) AS TotalAmount
				,'Consoli' AS PLanName
				,'03' AS SequenceType
				,15
			FROM TRNPricePlanning p
			LEFT JOIN #ConsoleTMPMonthData MD ON p.MonthYear = MD.MonthData
			LEFT JOIN #AccountTable a ON p.AccountCode = a.AccountCode
			WHERE ModeofType IN ('INVENTORY')
				AND a.AccountCode IS NOT NULL
				AND MD.MonthData IS NOT NULL
			)
		INSERT INTO #ConsoleTMP (
			CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalAmount
			,TotalQuantity
			,PLanName
			,SaleSequenceType
			,DataOrderBy
			)
		SELECT CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCmonthYear
			,MonthYear
			,ModeOfTypeId
			,ModeOfTypeText
			,TotalQuantity
			,TotalAmount
			,PLanName
			,SaleSequenceType
			,DataOrderBy
		FROM CTESNS

		--Insert Data in Transmission data for file write                                
		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,[Status]
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,COALESCE(TotalQuantity, 0)
			,COALESCE(TotalAmount, 0)
			,COALESCE(TotalAmount, 0)
			,PLanName
			,@Type
			,SaleSequenceType
			,ModeOfTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM #ConsoleTMP
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		DECLARE @TotalNumber INT

		SET @TotalNumber = (
				SELECT COUNT(1)
				FROM #ConsoleTMP
				)

		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	DROP TABLE #ConsoleTMP

	DROP TABLE #AccountTable

	DROP TABLE #ConsoleTMPMonthData

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_DIS_PLAN_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADD_DIS_PLAN_TRANSMISSION] 
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets FROM                      
	-- interfering with SELECT statements.                      
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here                      
	BEGIN TRY
		DECLARE @CurrentMonth VARCHAR(10);
		DECLARE @CurrentMonthDate VARCHAR(10);

		SET @CurrentMonth = (
				SELECT ConfigValue
				FROM GlobalConfig
				WHERE ConfigKey = 'Current_Month'
				);
		---- Need to get Total Month count -- Current month +5                  
		SET @CurrentMonthDate = CAST(@CurrentMonth + '01' AS DATE)

		--DECLARE @tmpMonthData Table(MonthData INT)                
		CREATE TABLE #tmpMonthData (MonthData INT)

		DECLARE @StartMonth INT = 0;
		DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                

		WHILE @StartMonth <= @EndMonth
		BEGIN
			INSERT INTO #tmpMonthData (MonthData)
			VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))

			SET @StartMonth = @StartMonth + 1
		END;

		CREATE TABLE #tmpData (
			SaleEntryHeaderId INT
			,SalesEntryId INT
			,MaterialCode VARCHAR(200)
			,CustomerCode VARCHAR(200)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,OcMonthYear INT
			,MonthYear INT
			,ModeOfTypeID INT
			,Quantity INT
			,Amount INT
			,SalesValue INT
			,[Plan] VARCHAR(50)
			,SaleType VARCHAR(50)
			,SaleSequenceType VARCHAR(4)
			,SalesSequenceTypeText VARCHAR(4)
			)

		INSERT INTO #tmpData (
			SaleEntryHeaderId
			,SalesEntryId
			,MaterialCode
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			)
		SELECT SaleEntryHeaderId
			,SalesEntryId
			,MaterialCode
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,cast(ROUND((Price * Quantity), 0) AS INT) Amount
			,Cast(ROUND(Quantity * ([dbo].[UDF_GetSalveValue](SaleEntryHeaderId, MaterialCode, CustomerCode, MonthYear)), 0) AS INT) AS SalesValue
			,'DIS-PLAN' AS [Plan]
			,SaleSubType
			,'01' AS SaleSequenceType
			,'P' AS SalesSequenceTypeText
		FROM VW_DIRECT_SALE
		WHERE ModeOfTypeId = 2
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND MonthYear IN (
				SELECT MonthData
				FROM #tmpMonthData
				)
			AND SaleSubType = @Type
		
		UNION
		
		SELECT SaleEntryHeaderId
			,SalesEntryId
			,MaterialCode
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,0 AS Amount
			,Cast(ROUND((Quantity * Price), 0) AS INT) AS SaleValue
			,'DIS-PLAN' AS [Plan]
			,SaleSubType
			,'02' AS SaleSequenceType
			,'S' AS SalesSequenceTypeText
		FROM VW_DIRECT_SALE
		WHERE ModeOfTypeId = 3
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND MonthYear IN (
				SELECT MonthData
				FROM #tmpMonthData
				)
			AND SaleSubType = @Type
		
		UNION
		
		SELECT SaleEntryHeaderId
			,SalesEntryId
			,MaterialCode
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,cast(ROUND((Price * Quantity), 0) AS INT) Amount
			,Cast(ROUND(Quantity * ([dbo].[UDF_GetSalveValue](SaleEntryHeaderId, MaterialCode, CustomerCode, MonthYear)), 0) AS INT) AS SaleValue
			,'DIS-PLAN' AS [Plan]
			,SaleSubType
			,'03' AS SaleSequenceType
			,'I' AS SalesSequenceTypeText
		FROM VW_DIRECT_SALE
		WHERE ModeOfTypeId = 4
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND MonthYear IN (
				SELECT MonthData
				FROM #tmpMonthData
				)
			AND SaleSubType = @Type

		-- Insert Data in Transmission data for file write                      
		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,STATUS
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM #tmpData
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		DECLARE @TotalNumber INT

		SET @TotalNumber = (
				SELECT COUNT(1)
				FROM #tmpData
				)

		--DROP TABLE #tmpData               
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	-- DROP TEMP TABLE              
	DROP TABLE #tmpMonthData

	DROP TABLE #tmpData

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
	--SELECT * from TransmissionPlanType  
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_DIS_RESULT_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ADD_DIS_RESULT_TRANSMISSION] 
	 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@ResultMonth INT
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                          
	-- interfering with SELECT statements.                          
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here                          
	BEGIN TRY
		WITH CTE (
			SaleEntryHeaderId
			,SalesEntryId
			,MaterialCode
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			)
		AS (
			SELECT SaleEntryHeaderId
				,SalesEntryId
				,MaterialCode
				,CustomerCode
				,CurrentMonthYear
				,LockMonthYear
				,OcMonthYear
				,MonthYear
				,ModeOfTypeID
				,Quantity
				,cast(ROUND((Price * Quantity), 0) AS INT) Amount
				,Cast(ROUND(Quantity * ([dbo].[UDF_GetSalveValue](SaleEntryHeaderId, MaterialCode, CustomerCode, MonthYear)), 0) AS INT) AS SalesValue
				,'DirectSale-DIS-RESULT' AS [Plan]
				,SaleSubType
				,'01' AS SaleSequenceType
				,'P' AS SalesSequenceTypeText
			FROM VW_DIRECT_SALE
			WHERE ModeOfTypeId = 2
				AND CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
				AND MonthYear = @ResultMonth
				AND SaleSubType = @Type
			
			UNION
			
			SELECT SaleEntryHeaderId
				,SalesEntryId
				,MaterialCode
				,CustomerCode
				,CurrentMonthYear
				,LockMonthYear
				,OcMonthYear
				,MonthYear
				,ModeOfTypeID
				,Quantity
				,0 AS Amount
				,Cast(ROUND((Quantity * Price), 0) AS INT) AS SaleValue
				,'DirectSale-DIS-RESULT' AS [Plan]
				,SaleSubType
				,'02' AS SaleSequenceType
				,'S' AS SalesSequenceTypeText
			FROM VW_DIRECT_SALE
			WHERE ModeOfTypeId = 3
				AND CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
				AND MonthYear = @ResultMonth
				AND SaleSubType = @Type
			
			UNION
			
			SELECT SaleEntryHeaderId
				,SalesEntryId
				,MaterialCode
				,CustomerCode
				,CurrentMonthYear
				,LockMonthYear
				,OcMonthYear
				,MonthYear
				,ModeOfTypeID
				,Quantity
				,cast(ROUND((Price * Quantity), 0) AS INT) Amount
				,Cast(ROUND(Quantity * ([dbo].[UDF_GetSalveValue](SaleEntryHeaderId, MaterialCode, CustomerCode, MonthYear)), 0) AS INT) AS SaleValue
				,'DirectSale-DIS-RESULT' AS [Plan]
				,SaleSubType
				,'03' AS SaleSequenceType
				,'I' AS SalesSequenceTypeText
			FROM VW_DIRECT_SALE
			WHERE ModeOfTypeId = 4
				AND CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
				AND MonthYear = @ResultMonth
				AND SaleSubType = @Type
			)
		-- Insert Data in Transmission data for file write                          
		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,STATUS
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM CTE
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'Tansmission Executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_PLAN_FOR_DIRECTSALE_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADD_PLAN_FOR_DIRECTSALE_TRANSMISSION]
	-- Add the parameters for the stored procedure here              
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from              
	-- interfering with SELECT statements.              
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here              
	BEGIN TRY
		DECLARE @CurrentMonth VARCHAR(10);
		DECLARE @CurrentMonthDate VARCHAR(10);

		SET @CurrentMonth = (
				SELECT ConfigValue
				FROM GlobalConfig
				WHERE ConfigKey = 'Result_Month'
				);
		---- Need to get Total Month count -- Current month +5                      
		SET @CurrentMonthDate = CAST(@CurrentMonth + '01' AS DATE)

		CREATE TABLE #tmpMonthData (MonthData INT)

		DECLARE @StartMonth INT = 0;
		DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                

		WHILE @StartMonth <= @EndMonth
		BEGIN
			INSERT INTO #tmpMonthData (MonthData)
			VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))

			SET @StartMonth = @StartMonth + 1
		END;

		CREATE TABLE #tmpPurchaseData (
			SaleEntryHeaderId INT
			,CustomerCode VARCHAR(50)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,MaterialCode VARCHAR(50)
			,OCMonthYear INT
			,MonthYear INT
			,Price DECIMAL(18, 2)
			,Quantity INT
			,ModeOfTypeId INT
			,SaleSubType VARCHAR(20)
			)

		INSERT INTO #tmpPurchaseData (
			SaleEntryHeaderId
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCMonthYear
			,MonthYear
			,Price
			,Quantity
			,ModeOfTypeId
			,SaleSubType
			)
		SELECT VD.SaleEntryHeaderId
			,VD.CustomerCode
			,VD.CurrentMonthYear
			,VD.LockMonthYear
			,VD.MaterialCode
			,VD.OCMonthYear
			,CONVERT(VARCHAR(6), DATEADD(MONTH, 1, CAST(VD.MonthYear + '01' AS DATE)), 112) AS MonthYear
			,VD.Price
			,VD.Quantity
			,VD.ModeOfTypeId
			,VD.SaleSubType
		FROM [dbo].[VW_DIRECT_SALE] VD
		LEFT JOIN #tmpMonthData MD ON VD.MonthYear = MD.MonthData
		WHERE ModeOfTypeId = 1
			AND CustomerCode IN (
				SELECT CustomerCode
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND SaleSubType = @Type
			AND MD.MonthData IS NOT NULL

		CREATE TABLE #tmpPlanData (
			CustomerCode VARCHAR(200)
			,MaterialCode VARCHAR(200)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,OcMonthYear INT
			,MonthYear INT
			,ModeOfTypeID INT
			,Quantity INT
			,Amount INT
			,SalesValue INT
			,[Plan] VARCHAR(50)
			,SaleType VARCHAR(50)
			,SaleSequenceType VARCHAR(4)
			,SalesSequenceTypeText VARCHAR(4)
			)

		INSERT INTO #tmpPlanData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,OcMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			)
		SELECT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,OCMonthYear
			,MonthYear
			,ModeOfTypeId
			,Quantity
			,CAST(ROUND((Price * Quantity), 0) AS INT) AS Amount
			,CAST(ROUND((Price * Quantity), 0) AS INT) AS SaleValues
			,'DIRECT_SALE_PLN' AS [Plan]
			,SaleSubType
			,'01' AS SequenceType
			,'P' AS SaleSequenceTypeText
		FROM #tmpPurchaseData
		
		UNION
		SELECT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,OCMonthYear
			,MonthYear
			,ModeOfTypeId
			,Quantity
			,0 AS Amount--(Because In Sale no Landed value(Amount) only Sale value,              
			,CAST(ROUND((Price * Quantity), 0) AS INT) AS SaleValues
			,'DIRECT_SALE_PLN' AS [Plan]
			,SaleSubType
			,'02' AS SequenceType
			,'S' AS SaleSequenceTypeText
		FROM #tmpPurchaseData
		
		UNION
		
		SELECT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,OCMonthYear
			,MonthYear
			,ModeOfTypeId
			,0 AS Quantity
			,0 AS Amount--(Because In Sale no Landed value(Amount) only Sale value,              
			,0 AS SaleValues
			,'DIRECT_SALE_PLN' AS [Plan]
			,SaleSubType
			,'03' AS SequenceType
			,'I' AS SaleSequenceTypeText
		FROM #tmpPurchaseData
            
		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,STATUS
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM #tmpPlanData
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		DECLARE @TotalNumber INT

		SET @TotalNumber = (
				SELECT COUNT(1)
				FROM #tmpPlanData
				)
		               
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	-- DROP TEMP TABLE              
	DROP TABLE #tmpMonthData

	DROP TABLE #tmpPurchaseData

	-- DROP TABLE #tmpPlanData              
	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_PLAN_FOR_SNS_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_ADD_PLAN_FOR_SNS_TRANSMISSION]
	-- Add the parameters for the stored procedure here                    
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@CurrentMonth INT
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                    
	-- interfering with SELECT statements.                    
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]
	DECLARE @AccountCodeTable AS [dbo].[TVP_CODE_LIST]

	-- Insert statements for procedure here                    
	BEGIN TRY
		INSERT INTO @AccountCodeTable (Code)
		SELECT AccountCode
		FROM CustomerView
		WHERE CustomerCode IN (
				SELECT CustomerCode
				FROM @TVP_CUSTOMERCODE_LIST
				);

		DECLARE @CurrentMonthDate VARCHAR(10);

		---- Need to get Total Month count -- Current month +5                      
		SET @CurrentMonthDate = CAST(CAST(@CurrentMonth AS VARCHAR(10)) + '01' AS DATE)

		CREATE TABLE #tmpMonthData (MonthData INT)

		DECLARE @StartMonth INT = 0;
		DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month                      

		WHILE @StartMonth <= @EndMonth
		BEGIN
			INSERT INTO #tmpMonthData (MonthData)
			VALUES (CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT))

			SET @StartMonth = @StartMonth + 1
		END;

		CREATE TABLE #tmpPlanData (
			CustomerCode VARCHAR(200)
			,MaterialCode VARCHAR(200)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,MonthYear INT
			,ModeOfTypeID INT
			,Quantity INT
			,Amount INT
			,SalesValue INT
			,[Plan] VARCHAR(50)
			,SaleType VARCHAR(50)
			,SaleSequenceType VARCHAR(4)
			,SalesSequenceTypeText VARCHAR(4)
			)

		INSERT INTO #tmpPlanData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			)
		SELECT OACCode AS CustomerCode
			,S.MaterialCode
			,0
			,0
			,P.MonthYear
			,2
			,Quantity
			,Quantity*Price AS Amount
			,0 AS SaleValues
			,'SNS_Plan' AS [Plan]
			,'Monthly'
			,'01' AS SequenceType
			,'P' AS SaleSequenceTypeText
		FROM SNSEntry S
		INNER JOIN TRNPricePlanning p ON S.MaterialCode = P.MaterialCode
			AND S.OACCode = P.AccountCode
		LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData
		LEFT JOIN @AccountCodeTable a ON p.AccountCode = a.Code
		WHERE ModeofType IN ('PURCHASE')
			AND a.Code IS NOT NULL
			AND MD.MonthData IS NOT NULL
		
		UNION
		
		SELECT OACCode as CustomerCode
			,MaterialCode
			,0
			,0
			,P.MonthYear
			,2
			,sum(P.Qty) AS Quantity
			,sum(P.Qty)*sum(p.Price) AS Amount
			,0 AS SaleValues
			,'SNS_Plan' AS [Plan]
			,'Monthly'
			,'02' AS SequenceType
			,'S' AS SaleSequenceTypeText
		FROM SNSEntry S
		INNER JOIN SNSEntryQtyPrice P ON S.SNSEntryId = P.SNSEntryId
		LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData
		LEFT JOIN @AccountCodeTable a ON S.OACCode = a.Code
		WHERE a.Code IS NOT NULL
			AND MD.MonthData IS NOT NULL
		GROUP BY CustomerCode
			,MaterialCode
			,P.MonthYear
		
		UNION
		
		SELECT OACCode AS CustomerCode
			,P.MaterialCode
			,0
			,0
			,P.MonthYear
			,4
			,Quantity
			,Quantity*Price AS Amount
			,0 AS SaleValue
			,'SNS_Plan' AS [Plan]
			,'Monthly'
			,'03' AS SaleSequenceType
			,'I' AS SalesSequenceTypeText
		FROM SNSEntry S
		INNER JOIN TRNPricePlanning p ON S.MaterialCode = P.MaterialCode
			AND S.OACCode = P.AccountCode
		LEFT JOIN #tmpMonthData MD ON p.MonthYear = MD.MonthData
		LEFT JOIN @AccountCodeTable a ON p.AccountCode = a.Code
		WHERE ModeofType IN ('INVENTORY')
			AND a.Code IS NOT NULL
			AND MD.MonthData IS NOT NULL

		-- INSERT DATA IN TRANSMISSION TABLE                    
		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,STATUS
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Amount
			,SalesValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM #tmpPlanData
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		DECLARE @TotalNumber INT

		SET @TotalNumber = (
				SELECT COUNT(1)
				FROM #tmpPlanData
				)

		--DROP TABLE #tmpData                       
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	-- DROP TEMP TABLE                    
	DROP TABLE #tmpMonthData

	DROP TABLE #tmpPlanData

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[SP_ADD_ZERO_PLAN_TRANSMISSION]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ADD_ZERO_PLAN_TRANSMISSION]
	-- Add the parameters for the stored procedure here        
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@CurrentMonth INT
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
	,@PlanTypeCode INT
	,@PlanTypeName VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from        
	-- interfering with SELECT statements.        
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here        
	BEGIN TRY
		DECLARE @CurrentMonthDate VARCHAR(10);

		--SET @CurrentMonth = ( SELECT ConfigValue FROM GlobalConfig where ConfigKey='Current_Month');          
		---- Need to get Total Month count -- Current month +5            
		SET @CurrentMonthDate = CAST(CAST(@CurrentMonth AS VARCHAR(10)) + '01' AS DATE)

		--select @CurrentMonthDate        
		CREATE TABLE #tmpMonthData (
			MonthData INT
			,RN INT
			)

		DECLARE @StartMonth INT = 0;
		DECLARE @EndMonth INT = 5;-- Need 6 Month Data including Current Month          

		WHILE @StartMonth <= @EndMonth
		BEGIN
			INSERT INTO #tmpMonthData (
				MonthData
				,RN
				)
			VALUES (
				CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) AS DATE), 112) AS INT)
				,@StartMonth + 1
				)

			SET @StartMonth = @StartMonth + 1
		END;

		CREATE TABLE #tmpZeroData (
			SaleEntryHeaderId INT
			,CustomerCode VARCHAR(50)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,MaterialCode VARCHAR(50)
			,OCMonthYear INT
			,MonthYear INT
			,Price DECIMAL(18, 2)
			,Quantity INT
			,ModeOfTypeId INT
			,SaleSubType VARCHAR(20)
			,SaleValue DECIMAL(18, 2)
			,[Plan] VARCHAR(20)
			,SaleSequenceType VARCHAR(10)
			,SalesSequenceTypeText VARCHAR(2)
			)

		CREATE TABLE #tmpPurchaseData (
			SaleEntryHeaderId INT
			,CustomerCode VARCHAR(50)
			,CurrentMonthYear INT
			,LockMonthYear INT
			,MaterialCode VARCHAR(50)
			,OCMonthYear INT
			,MonthYear INT
			,Price DECIMAL(18, 2)
			,Quantity INT
			,ModeOfTypeId INT
			,SaleSubType VARCHAR(20)
			)

		INSERT INTO #tmpPurchaseData (
			SaleEntryHeaderId
			,CustomerCode
			,CurrentMonthYear
			,LockMonthYear
			,MaterialCode
			,OCMonthYear
			,MonthYear
			,Price
			,Quantity
			,ModeOfTypeId
			,SaleSubType
			)
		SELECT VD.SaleEntryHeaderId
			,VD.CustomerCode
			,VD.CurrentMonthYear
			,VD.LockMonthYear
			,VD.MaterialCode
			,VD.OCMonthYear
			,VD.MonthYear
			,VD.Price
			,VD.Quantity
			,VD.ModeOfTypeId
			,VD.SaleSubType
		FROM [dbo].[VW_DIRECT_SALE] VD
		WHERE ModeOfTypeId = 1
			AND VD.MonthYear IN (
				SELECT MonthData
				FROM #tmpMonthData
				)
			AND CustomerCode IN (
				SELECT CustomerCode
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND SaleSubType = @Type

		-- WHILE LOOP      
		DECLARE @ST INT = 1;
		DECLARE @LT INT = 6;

		WHILE @ST <= @LT
		BEGIN
			DECLARE @MonthYear INT;
			DECLARE @PrevMonthYear INT;
			DECLARE @NextMonth INT;

			SET @MonthYear = (
					SELECT MonthData
					FROM #tmpMonthData
					WHERE RN = @ST
					)

			DECLARE @MonthYearFormat VARCHAR(10)

			SET @MonthYearFormat = CAST(CAST(@MonthYear AS VARCHAR(10)) + '01' AS DATE)
			SET @PrevMonthYear = CAST(CONVERT(NVARCHAR(6), CAST(DATEADD(MONTH, - 1, @MonthYearFormat) AS DATE), 112) AS INT);

			-- ALL Data of SELECTED Month      
			-- ADD P Data      
			INSERT INTO #tmpZeroData (
				SaleEntryHeaderId
				,CustomerCode
				,CurrentMonthYear
				,LockMonthYear
				,MaterialCode
				,OCMonthYear
				,MonthYear
				,Price
				,Quantity
				,ModeOfTypeId
				,SaleSubType
				,SaleValue
				,[Plan]
				,SaleSequenceType
				,SalesSequenceTypeText
				)
			SELECT A1.SaleEntryHeaderId
				,A1.CustomerCode
				,A1.CurrentMonthYear
				,A1.LockMonthYear
				,A1.MaterialCode
				,A1.OCMonthYear
				,@MonthYear
				,0
				,0
				,A1.ModeOfTypeId
				,A1.SaleSubType
				,0
				,'ZeroPlan'
				,01
				,'P'
			FROM (
				SELECT VD.SaleEntryHeaderId
					,VD.CustomerCode
					,VD.CurrentMonthYear
					,VD.LockMonthYear
					,VD.MaterialCode
					,VD.OCMonthYear
					,VD.MonthYear
					,VD.Price
					,VD.Quantity
					,VD.ModeOfTypeId
					,VD.SaleSubType
				FROM [dbo].[VW_DIRECT_SALE] VD
				WHERE ModeOfTypeId = 1
					AND VD.MonthYear IN (@PrevMonthYear)
					AND CustomerCode IN (
						SELECT CustomerCode
						FROM @TVP_CUSTOMERCODE_LIST
						)
					AND SaleSubType = @Type
				) A1
			LEFT JOIN (
				SELECT *
				FROM (
					SELECT *
					FROM #tmpPurchaseData
					WHERE MonthYear = @MonthYear
					) A2
				) A3 ON A3.MaterialCode = A1.MaterialCode
			WHERE A3.MaterialCode IS NULL
			
			UNION
			
			SELECT A1.SaleEntryHeaderId
				,A1.CustomerCode
				,A1.CurrentMonthYear
				,A1.LockMonthYear
				,A1.MaterialCode
				,A1.OCMonthYear
				,@MonthYear
				,0
				,0
				,A1.ModeOfTypeId
				,A1.SaleSubType
				,0
				,'ZeroPlan'
				,02
				,'S'
			FROM (
				SELECT VD.SaleEntryHeaderId
					,VD.CustomerCode
					,VD.CurrentMonthYear
					,VD.LockMonthYear
					,VD.MaterialCode
					,VD.OCMonthYear
					,VD.MonthYear
					,VD.Price
					,VD.Quantity
					,VD.ModeOfTypeId
					,VD.SaleSubType
				FROM [dbo].[VW_DIRECT_SALE] VD
				WHERE ModeOfTypeId = 2
					AND VD.MonthYear IN (@PrevMonthYear)
					AND CustomerCode IN (
						SELECT CustomerCode
						FROM @TVP_CUSTOMERCODE_LIST
						)
					AND SaleSubType = @Type
				) A1
			LEFT JOIN (
				SELECT *
				FROM (
					SELECT VD.SaleEntryHeaderId
						,VD.CustomerCode
						,VD.CurrentMonthYear
						,VD.LockMonthYear
						,VD.MaterialCode
						,VD.OCMonthYear
						,VD.MonthYear
						,VD.Price
						,VD.Quantity
						,VD.ModeOfTypeId
						,VD.SaleSubType
					FROM [dbo].[VW_DIRECT_SALE] VD
					WHERE ModeOfTypeId = 2
						AND VD.MonthYear IN (@MonthYear)
						AND CustomerCode IN (
							SELECT CustomerCode
							FROM @TVP_CUSTOMERCODE_LIST
							)
						AND SaleSubType = @Type
					) A2
				) A3 ON A3.MaterialCode = A1.MaterialCode
			WHERE A3.MaterialCode IS NULL
			
			UNION
			
			SELECT A1.SaleEntryHeaderId
				,A1.CustomerCode
				,A1.CurrentMonthYear
				,A1.LockMonthYear
				,A1.MaterialCode
				,A1.OCMonthYear
				,@MonthYear
				,0
				,0
				,A1.ModeOfTypeId
				,A1.SaleSubType
				,0
				,'ZeroPlan'
				,02
				,'I'
			FROM (
				SELECT VD.SaleEntryHeaderId
					,VD.CustomerCode
					,VD.CurrentMonthYear
					,VD.LockMonthYear
					,VD.MaterialCode
					,VD.OCMonthYear
					,VD.MonthYear
					,VD.Price
					,VD.Quantity
					,VD.ModeOfTypeId
					,VD.SaleSubType
				FROM [dbo].[VW_DIRECT_SALE] VD
				WHERE ModeOfTypeId = 3
					AND VD.MonthYear IN (@PrevMonthYear)
					AND CustomerCode IN (
						SELECT CustomerCode
						FROM @TVP_CUSTOMERCODE_LIST
						)
					AND SaleSubType = @Type
				) A1
			LEFT JOIN (
				SELECT *
				FROM (
					SELECT VD.SaleEntryHeaderId
						,VD.CustomerCode
						,VD.CurrentMonthYear
						,VD.LockMonthYear
						,VD.MaterialCode
						,VD.OCMonthYear
						,VD.MonthYear
						,VD.Price
						,VD.Quantity
						,VD.ModeOfTypeId
						,VD.SaleSubType
					FROM [dbo].[VW_DIRECT_SALE] VD
					WHERE ModeOfTypeId = 3
						AND VD.MonthYear IN (@MonthYear)
						AND CustomerCode IN (
							SELECT CustomerCode
							FROM @TVP_CUSTOMERCODE_LIST
							)
						AND SaleSubType = @Type
					) A2
				) A3 ON A3.MaterialCode = A1.MaterialCode
			WHERE A3.MaterialCode IS NULL

			SET @ST = @ST + 1;
		END

		INSERT INTO TransmissionData (
			CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Qty
			,Amount
			,SaleValue
			,[Plan]
			,SaleType
			,SaleSequenceType
			,SalesSequenceTypeText
			,CreatedBy
			,EDIStatus
			,STATUS
			,PlanTypeCode
			,PlanTypeName
			)
		SELECT DISTINCT CustomerCode
			,MaterialCode
			,CurrentMonthYear
			,LockMonthYear
			,MonthYear
			,ModeOfTypeID
			,Quantity
			,Price
			,SaleValue
			,[Plan]
			,SaleSubType
			,SaleSequenceType
			,SalesSequenceTypeText
			,@CreatedBy
			,'Pending'
			,'Pending'
			,@PlanTypeCode
			,@PlanTypeName
		FROM #tmpZeroData
		ORDER BY MaterialCode
			,ModeOfTypeID
			,MonthYear

		DECLARE @TotalNumber INT

		SET @TotalNumber = (
				SELECT COUNT(1)
				FROM #tmpZeroData
				)

		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			200
			,'' + CAST(@TotalNumber AS VARCHAR(50)) + ' Record for transmission executed successfully'
			);
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	-- DROP TEMP TABLE        
	DROP TABLE #tmpPurchaseData

	DROP TABLE #tmpMonthData

	DROP TABLE #tmpZeroData

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[SP_AdjustmentSearch]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_AdjustmentSearch] @CountryId VARCHAR(max) = NULL
	,@CustomerId VARCHAR(max) = NULL
	,@ProductCategoryId1 VARCHAR(max) = NULL
	,@ProductCategoryId2 VARCHAR(max) = NULL
AS
BEGIN
	SELECT m.ProductCategoryId1
		,m.ProductCategoryId2
		,c.CustomerId
		,c.CountryId
		,c.CustomerCode + '-' + c.CustomerName AS CustomerName
		,e.MaterialCode
		,p.MonthYear
		,p.Price
		,p.Qty
	FROM AdjustmentEntry e
	INNER JOIN AdjustmentEntryQtyPrice p ON e.AdjustmentEntryId = p.AdjustmentEntryId
	LEFT JOIN Customer c ON e.CustomerCode = c.CustomerCode
	LEFT JOIN Material m ON e.MaterialCode = m.MaterialCode
	WHERE (
			@CountryId IS NULL
			OR CountryId IN (
				SELECT value
				FROM STRING_SPLIT(@CountryId, ',')
				)
			)
		AND (
			@CustomerId IS NULL
			OR c.CustomerId IN (
				SELECT value
				FROM STRING_SPLIT(@CustomerId, ',')
				)
			)
		AND (
			@ProductCategoryId1 IS NULL
			OR ProductCategoryId1 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId1, ',')
				)
			)
		AND (
			@ProductCategoryId2 IS NULL
			OR ProductCategoryId2 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId2, ',')
				)
			)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Archive_Sales_Entries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Archive_Sales_Entries] (
	@customerId INT
	,@productCategoryId INT
	,@productSubCategoryId INT
	,@saleSubType VARCHAR(50)
	,@currentMonthYear CHAR(6)
	,@nextMonthYear CHAR(6)
	,@userId NVARCHAR(100)
	,@tvpSalesEntries dbo.TVP_SALES_ENTRY_HEADERS READONLY
	,@tvpSalesQtyPrices dbo.TVP_SALES_ENTRY_QTY_PRICES READONLY
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;

	BEGIN TRY
		--BEGIN TRANSACTION;  
		--PRINT @currentMonthYear;  
		--PRINT @nextMonthYear;  
		DECLARE @IsArchived VARCHAR(1) = '0';
		DECLARE @SaleEntryHeaderId INT = NULL;
		DECLARE @PrevSaleEntryHeaderId INT = NULL;
		DECLARE @IsPrevIdFoundInArchival VARCHAR(1) = '0';

		SET @SaleEntryHeaderId = (
				SELECT TOP 1 SaleEntryHeaderId
				FROM dbo.SaleEntryHeader
				WHERE CustomerId = @customerId
					AND SaleTypeId = 1
					AND SaleSubType = @saleSubType
					AND ProductCategoryId1 = @productCategoryId
					AND ProductCategoryId2 = @productSubCategoryId
				ORDER BY SaleEntryHeaderId DESC
				);
		SET @PrevSaleEntryHeaderId = (
				SELECT TOP 1 SaleEntryHeaderId
				FROM dbo.SaleEntryHeader
				WHERE CustomerId = @customerId
					AND SaleTypeId = 1
					AND SaleSubType = @saleSubType
					AND ProductCategoryId1 = @productCategoryId
					AND ProductCategoryId2 = @productSubCategoryId
					AND CurrentMonthYear < @currentMonthYear
				ORDER BY SaleEntryHeaderId DESC
				);

		IF @PrevSaleEntryHeaderId IS NULL
		BEGIN
			SET @IsPrevIdFoundInArchival = '1';
			SET @PrevSaleEntryHeaderId = (
					SELECT TOP 1 SaleEntryArchivalHeaderId
					FROM dbo.[SaleEntryArchivalHeader]
					WHERE CustomerId = @customerId
						AND SaleTypeId = 1
						AND SaleSubType = @saleSubType
						AND ProductCategoryId1 = @productCategoryId
						AND ProductCategoryId2 = @productSubCategoryId
						AND CurrentMonthYear < @currentMonthYear
					ORDER BY SaleEntryArchivalHeaderId DESC
					);
		END

		--PRINT '@PrevSaleEntryHeaderId';  
		--PRINT @PrevSaleEntryHeaderId;  
		IF @SaleEntryHeaderId IS NOT NULL
		BEGIN
			DECLARE @SalesEntryId INT = NULL;

			SET @SalesEntryId = (
					SELECT TOP 1 SE.SalesEntryId
					FROM [dbo].[SalesEntry] SE
					INNER JOIN @tvpSalesEntries TSE ON SE.SaleEntryHeaderId = @SaleEntryHeaderId
						AND SE.MaterialId = TSE.ItemCodeId
						AND SE.ModeOfTypeId = TSE.TypeCodeId
					);

			IF @SalesEntryId IS NOT NULL
			BEGIN
				SET @IsArchived = '1';

				DECLARE @tvpSalesEntry TABLE (SalesEntryId INT NOT NULL);
				DECLARE @tvpPrevSalesEntry TABLE (SalesEntryId INT NOT NULL);

				INSERT INTO @tvpSalesEntry
				SELECT SalesEntryId
				FROM SalesEntry
				WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

				IF @PrevSaleEntryHeaderId IS NOT NULL
				BEGIN
					IF @IsPrevIdFoundInArchival = '0'
					BEGIN
						INSERT INTO @tvpPrevSalesEntry
						SELECT SalesEntryId
						FROM SalesEntry
						WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;
					END
					ELSE
					BEGIN
						INSERT INTO @tvpPrevSalesEntry
						SELECT SalesArchivalEntryId
						FROM [SalesArchivalEntry]
						WHERE SaleEntryArchivalHeaderId = @PrevSaleEntryHeaderId;
					END
				END

				INSERT INTO dbo.[SaleEntryArchivalHeader] (
					SaleEntryArchivalHeaderId
					,[CustomerId]
					,[SaleTypeId]
					,[ProductCategoryId1]
					,[ProductCategoryId2]
					,[CurrentMonthYear]
					,[LockMonthYear]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdateDate]
					,[UpdateBy]
					,[AttachmentId]
					,[SaleSubType]
					)
				SELECT SaleEntryHeaderId
					,[CustomerId]
					,[SaleTypeId]
					,[ProductCategoryId1]
					,[ProductCategoryId2]
					,[CurrentMonthYear]
					,[LockMonthYear]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdateDate]
					,[UpdateBy]
					,[AttachmentId]
					,[SaleSubType]
				FROM dbo.SaleEntryHeader
				WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

				INSERT INTO dbo.[SalesArchivalEntry] (
					SalesArchivalEntryId
					,SaleEntryArchivalHeaderId
					,[MaterialId]
					,[ProductCategoryCode1]
					,[ProductCategoryCode2]
					,[ProductCategoryCode3]
					,[ProductCategoryCode4]
					,[ProductCategoryCode5]
					,[ProductCategoryCode6]
					,[OCmonthYear]
					,[OCstatus]
					,[FileInfoId]
					,[O_LockMonthConfirmedStatus]
					,[O_LockMonthConfirmedBy]
					,[O_LockMonthConfirmedDate]
					,[ModeOfTypeId]
					)
				SELECT DISTINCT SalesEntryId
					,SaleEntryHeaderId
					,[MaterialId]
					,[ProductCategoryCode1]
					,[ProductCategoryCode2]
					,[ProductCategoryCode3]
					,[ProductCategoryCode4]
					,[ProductCategoryCode5]
					,[ProductCategoryCode6]
					,[OCmonthYear]
					,[OCstatus]
					,[FileInfoId]
					,[O_LockMonthConfirmedStatus]
					,[O_LockMonthConfirmedBy]
					,[O_LockMonthConfirmedDate]
					,[ModeOfTypeId]
				FROM SalesEntry
				WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

				INSERT INTO [dbo].[SalesArchivalEntryPriceQuantity] (
					[SalesArchivalEntryPriceQuantityId]
					,[SalesArchivalEntryId]
					,[MonthYear]
					,[Price]
					,[Quantity]
					,[OrderIndicationConfirmedBySaleTeam]
					,[OrderIndicationConfirmedBySaleTeamDate]
					,[OrderIndicationConfirmedByMarketingTeam]
					,[OrderIndicationConfirmedByMarketingTeamDate]
					,[O_LockMonthConfirmedBy]
					,[O_LockMonthConfirmedDate]
					,[Reason]
					,[IsSNS]
					,[IsPO]
					,[TermId]
					,[Remarks]
					,[CurrencyCode]
					,[OcIndicationMonthAttachmentIds]
					,[OcIndicationMonthStatus]
					,[OCstatus]
					)
				SELECT [SalesEntryPriceQuantityId]
					,[SalesEntryId]
					,[MonthYear]
					,[Price]
					,[Quantity]
					,[OrderIndicationConfirmedBySaleTeam]
					,[OrderIndicationConfirmedBySaleTeamDate]
					,[OrderIndicationConfirmedByMarketingTeam]
					,[OrderIndicationConfirmedByMarketingTeamDate]
					,[O_LockMonthConfirmedBy]
					,[O_LockMonthConfirmedDate]
					,[Reason]
					,[IsSNS]
					,[IsPO]
					,[TermId]
					,[Remarks]
					,[CurrencyCode]
					,[OcIndicationMonthAttachmentIds]
					,[OcIndicationMonthStatus]
					,[OCstatus]
				FROM SalesEntryPriceQuantity
				WHERE SalesEntryId IN (
						SELECT SalesEntryId
						FROM @tvpSalesEntry
						);

				DECLARE @IsCurrentOrLockMonthDataExists INT;

				IF @IsPrevIdFoundInArchival = '0'
				BEGIN
					SET @IsCurrentOrLockMonthDataExists = (
							SELECT TOP 1 1
							FROM SalesEntryPriceQuantity
							WHERE SalesEntryId IN (
									SELECT SalesEntryId
									FROM @tvpPrevSalesEntry
									)
								AND (
									MonthYear = @currentMonthYear
									OR MonthYear = @nextMonthYear
									)
							);
				END
				ELSE
				BEGIN
					SET @IsCurrentOrLockMonthDataExists = (
							SELECT TOP 1 1
							FROM [SalesArchivalEntryPriceQuantity]
							WHERE [SalesArchivalEntryId] IN (
									SELECT SalesEntryId
									FROM @tvpPrevSalesEntry
									)
								AND (
									MonthYear = @currentMonthYear
									OR MonthYear = @nextMonthYear
									)
							);
				END

				--PRINT '@IsCurrentOrLockMonthDataExists';  
				--PRINT  @IsCurrentOrLockMonthDataExists;  
				IF @IsCurrentOrLockMonthDataExists = 1
				BEGIN
					INSERT INTO @ResultTable
					VALUES (
						0
						,201
						,CONVERT(VARCHAR(12), @PrevSaleEntryHeaderId)
						);

					IF @SaleEntryHeaderId != @PrevSaleEntryHeaderId
					BEGIN
						DELETE
						FROM SalesEntryPriceQuantity
						WHERE SalesEntryId IN (
								SELECT SalesEntryId
								FROM SalesEntry
								WHERE SaleEntryHeaderId = @SaleEntryHeaderId
								);

						DELETE
						FROM SalesEntry
						WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

						DELETE
						FROM SaleEntryHeader
						WHERE SaleEntryHeaderId = @SaleEntryHeaderId;
					END
					ELSE
					BEGIN
						DELETE
						FROM SalesEntryPriceQuantity
						WHERE SalesEntryId IN (
								SELECT SalesEntryId
								FROM @tvpSalesEntry
								)
							--added this condition(anu)
							--AND (MonthYear != @currentMonthYear AND MonthYear != @nextMonthYear);
							AND (MonthYear > @nextMonthYear);
					END
				END
				ELSE
				BEGIN
					INSERT INTO @ResultTable
					VALUES (
						0
						,201
						,'0'
						);

					DELETE
					FROM SalesEntryPriceQuantity
					WHERE SalesEntryId IN (
							SELECT SalesEntryId
							FROM SalesEntry
							WHERE SaleEntryHeaderId = @SaleEntryHeaderId
							);

					DELETE
					FROM SalesEntry
					WHERE SaleEntryHeaderId = @SaleEntryHeaderId;

					DELETE
					FROM SaleEntryHeader
					WHERE SaleEntryHeaderId = @SaleEntryHeaderId;
				END
			END
		END

		/*IF @@TRANCOUNT > 0  
   COMMIT;*/
		INSERT INTO @ResultTable
		VALUES (
			0
			,200
			,@IsArchived
			);
	END TRY

	BEGIN CATCH
		/*IF @@TRANCOUNT > 0  
                ROLLBACK;*/
		INSERT INTO @ResultTable
		VALUES (
			0
			,500
			,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()
			);
	END CATCH;

	SELECT DISTINCT RowNo
		,ResponseCode
		,ResponseMessage
	FROM @ResultTable;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Archive_Sales_Entries_old]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Archive_Sales_Entries_old] (    
 @customerId INT    
 ,@productCategoryId INT    
 ,@productSubCategoryId INT    
 ,@saleSubType VARCHAR(50)    
 ,@currentMonthYear CHAR(6)    
 ,@nextMonthYear CHAR(6)    
 ,@userId NVARCHAR(100)    
 ,@tvpSalesEntries dbo.TVP_SALES_ENTRY_HEADERS READONLY    
 ,@tvpSalesQtyPrices dbo.TVP_SALES_ENTRY_QTY_PRICES READONLY    
 )    
AS    
BEGIN    
 SET NOCOUNT ON;    
    
 DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;    
    
 BEGIN TRY    
  --BEGIN TRANSACTION;      
  --PRINT @currentMonthYear;      
  --PRINT @nextMonthYear;      
  DECLARE @IsArchived VARCHAR(1) = '0';    
  DECLARE @SaleEntryHeaderId INT = NULL;    
  DECLARE @PrevSaleEntryHeaderId INT = NULL;    
  DECLARE @IsPrevIdFoundInArchival VARCHAR(1) = '0';    
    
  SET @SaleEntryHeaderId = (    
    SELECT TOP 1 SaleEntryHeaderId    
    FROM dbo.SaleEntryHeader    
    WHERE CustomerId = @customerId    
     AND SaleTypeId = 1    
     AND SaleSubType = @saleSubType    
     AND ProductCategoryId1 = @productCategoryId    
     AND ProductCategoryId2 = @productSubCategoryId    
    ORDER BY SaleEntryHeaderId DESC    
    );    
  SET @PrevSaleEntryHeaderId = (    
    SELECT TOP 1 SaleEntryHeaderId    
    FROM dbo.SaleEntryHeader    
    WHERE CustomerId = @customerId    
     AND SaleTypeId = 1    
     AND SaleSubType = @saleSubType    
     AND ProductCategoryId1 = @productCategoryId    
     AND ProductCategoryId2 = @productSubCategoryId    
     AND CurrentMonthYear < @currentMonthYear    
    ORDER BY SaleEntryHeaderId DESC    
    );    
    
  IF @PrevSaleEntryHeaderId IS NULL    
  BEGIN    
   SET @IsPrevIdFoundInArchival = '1';    
   SET @PrevSaleEntryHeaderId = (    
     SELECT TOP 1 SaleEntryArchivalHeaderId    
     FROM dbo.[SaleEntryArchivalHeader]    
     WHERE CustomerId = @customerId    
      AND SaleTypeId = 1    
      AND SaleSubType = @saleSubType    
      AND ProductCategoryId1 = @productCategoryId    
      AND ProductCategoryId2 = @productSubCategoryId    
      AND CurrentMonthYear < @currentMonthYear    
     ORDER BY SaleEntryArchivalHeaderId DESC    
     );    
  END    
    
  --PRINT '@PrevSaleEntryHeaderId';      
  --PRINT @PrevSaleEntryHeaderId;      
  IF @SaleEntryHeaderId IS NOT NULL    
  BEGIN    
   DECLARE @SalesEntryId INT = NULL;    
    
   SET @SalesEntryId = (    
     SELECT TOP 1 SE.SalesEntryId    
     FROM [dbo].[SalesEntry] SE    
     INNER JOIN @tvpSalesEntries TSE ON SE.SaleEntryHeaderId = @SaleEntryHeaderId    
      AND SE.MaterialId = TSE.ItemCodeId    
      AND SE.ModeOfTypeId = TSE.TypeCodeId    
     );    
    
   IF @SalesEntryId IS NOT NULL    
   BEGIN    
    SET @IsArchived = '1';    
    
    DECLARE @tvpSalesEntry TABLE (SalesEntryId INT NOT NULL);    
    DECLARE @tvpPrevSalesEntry TABLE (SalesEntryId INT NOT NULL);    
    
    INSERT INTO @tvpSalesEntry    
    SELECT SalesEntryId    
    FROM SalesEntry    
    WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    
    IF @PrevSaleEntryHeaderId IS NOT NULL    
    BEGIN    
     IF @IsPrevIdFoundInArchival = '0'    
     BEGIN    
      INSERT INTO @tvpPrevSalesEntry    
      SELECT SalesEntryId    
      FROM SalesEntry    
      WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;    
     END    
     ELSE    
     BEGIN    
      INSERT INTO @tvpPrevSalesEntry    
      SELECT SalesArchivalEntryId    
      FROM [SalesArchivalEntry]    
      WHERE SaleEntryArchivalHeaderId = @PrevSaleEntryHeaderId;    
     END    
    END    
    
    INSERT INTO dbo.[SaleEntryArchivalHeader] (    
     SaleEntryArchivalHeaderId    
     ,[CustomerId]    
     ,[SaleTypeId]    
     ,[ProductCategoryId1]    
     ,[ProductCategoryId2]    
     ,[CurrentMonthYear]    
     ,[LockMonthYear]    
     ,[CreatedDate]    
     ,[CreatedBy]    
     ,[UpdateDate]    
     ,[UpdateBy]    
     ,[AttachmentId]    
     ,[SaleSubType]    
     )    
    SELECT SaleEntryHeaderId    
     ,[CustomerId]    
     ,[SaleTypeId]    
     ,[ProductCategoryId1]    
     ,[ProductCategoryId2]    
     ,[CurrentMonthYear]    
  ,[LockMonthYear]    
     ,[CreatedDate]    
     ,[CreatedBy]    
     ,[UpdateDate]    
     ,[UpdateBy]    
     ,[AttachmentId]    
     ,[SaleSubType]    
    FROM dbo.SaleEntryHeader    
    WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    
    INSERT INTO dbo.[SalesArchivalEntry] (    
     SalesArchivalEntryId    
     ,SaleEntryArchivalHeaderId    
     ,[MaterialId]    
     ,[ProductCategoryCode1]    
     ,[ProductCategoryCode2]    
     ,[ProductCategoryCode3]    
     ,[ProductCategoryCode4]    
     ,[ProductCategoryCode5]    
     ,[ProductCategoryCode6]    
     ,[OCmonthYear]    
     ,[OCstatus]    
     ,[FileInfoId]    
     ,[O_LockMonthConfirmedStatus]    
     ,[O_LockMonthConfirmedBy]    
     ,[O_LockMonthConfirmedDate]    
     ,[ModeOfTypeId]    
     )    
    SELECT DISTINCT SalesEntryId    
     ,SaleEntryHeaderId    
     ,[MaterialId]    
     ,[ProductCategoryCode1]    
     ,[ProductCategoryCode2]    
     ,[ProductCategoryCode3]    
     ,[ProductCategoryCode4]    
     ,[ProductCategoryCode5]    
     ,[ProductCategoryCode6]    
     ,[OCmonthYear]    
     ,[OCstatus]    
     ,[FileInfoId]    
     ,[O_LockMonthConfirmedStatus]    
     ,[O_LockMonthConfirmedBy]    
     ,[O_LockMonthConfirmedDate]    
     ,[ModeOfTypeId]    
    FROM SalesEntry    
    WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    
    INSERT INTO [dbo].[SalesArchivalEntryPriceQuantity] (    
     [SalesArchivalEntryPriceQuantityId]    
     ,[SalesArchivalEntryId]    
     ,[MonthYear]    
     ,[Price]    
     ,[Quantity]    
     ,[OrderIndicationConfirmedBySaleTeam]    
     ,[OrderIndicationConfirmedBySaleTeamDate]    
     ,[OrderIndicationConfirmedByMarketingTeam]    
     ,[OrderIndicationConfirmedByMarketingTeamDate]    
     ,[O_LockMonthConfirmedBy]    
     ,[O_LockMonthConfirmedDate]    
     ,[Reason]    
     ,[IsSNS]    
     ,[IsPO]    
     ,[TermId]    
     ,[Remarks]    
     ,[CurrencyCode]    
     ,[OcIndicationMonthAttachmentIds]    
     ,[OcIndicationMonthStatus]    
     ,[OCstatus]    
     )    
    SELECT [SalesEntryPriceQuantityId]    
     ,[SalesEntryId]    
     ,[MonthYear]    
     ,[Price]    
     ,[Quantity]    
     ,[OrderIndicationConfirmedBySaleTeam]    
     ,[OrderIndicationConfirmedBySaleTeamDate]    
     ,[OrderIndicationConfirmedByMarketingTeam]    
     ,[OrderIndicationConfirmedByMarketingTeamDate]    
     ,[O_LockMonthConfirmedBy]    
     ,[O_LockMonthConfirmedDate]    
     ,[Reason]    
     ,[IsSNS]    
     ,[IsPO]    
     ,[TermId]    
     ,[Remarks]    
     ,[CurrencyCode]    
     ,[OcIndicationMonthAttachmentIds]    
     ,[OcIndicationMonthStatus]    
     ,[OCstatus]    
    FROM SalesEntryPriceQuantity    
    WHERE SalesEntryId IN (    
      SELECT SalesEntryId    
      FROM @tvpSalesEntry    
      );    
    
    DECLARE @IsCurrentOrLockMonthDataExists INT;    
    
    IF @IsPrevIdFoundInArchival = '0'    
    BEGIN    
     SET @IsCurrentOrLockMonthDataExists = (    
       SELECT TOP 1 1    
       FROM SalesEntryPriceQuantity    
       WHERE SalesEntryId IN (    
         SELECT SalesEntryId    
         FROM @tvpPrevSalesEntry    
         )    
        AND (    
         MonthYear = @currentMonthYear    
         OR MonthYear = @nextMonthYear    
         )    
       );    
    END    
    ELSE    
    BEGIN    
     SET @IsCurrentOrLockMonthDataExists = (    
       SELECT TOP 1 1    
       FROM [SalesArchivalEntryPriceQuantity]    
       WHERE [SalesArchivalEntryId] IN (    
         SELECT SalesEntryId    
         FROM @tvpPrevSalesEntry    
         )    
        AND (    
         MonthYear = @currentMonthYear    
         OR MonthYear = @nextMonthYear    
         )    
       );    
    END    
    
    --PRINT '@IsCurrentOrLockMonthDataExists';      
    --PRINT  @IsCurrentOrLockMonthDataExists;      
    IF @IsCurrentOrLockMonthDataExists = 1    
    BEGIN    
     INSERT INTO @ResultTable    
     VALUES (    
      0    
      ,201    
      ,CONVERT(VARCHAR(12), @PrevSaleEntryHeaderId)    
      );    
    
     IF @SaleEntryHeaderId != @PrevSaleEntryHeaderId    
     BEGIN    
      DELETE    
      FROM SalesEntryPriceQuantity    
      WHERE SalesEntryId IN (    
        SELECT SalesEntryId    
        FROM SalesEntry    
        WHERE SaleEntryHeaderId = @SaleEntryHeaderId    
        );    
    
      DELETE    
      FROM SalesEntry    
      WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    
      DELETE    
      FROM SaleEntryHeader    
      WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
     END    
     ELSE    
     BEGIN    
      DELETE    
      FROM SalesEntryPriceQuantity    
      WHERE SalesEntryId IN (    
        SELECT SalesEntryId    
        FROM @tvpSalesEntry    
        )    
       --added this condition(anu)    
       --AND (MonthYear != @currentMonthYear AND MonthYear != @nextMonthYear);    
       AND (MonthYear > @nextMonthYear);    
     END    
    END    
    ELSE    
    BEGIN    
     INSERT INTO @ResultTable    
     VALUES (    
      0    
      ,201    
      ,'0'    
      );    
    
     DELETE    
     FROM SalesEntryPriceQuantity    
     WHERE SalesEntryId IN (    
       SELECT SalesEntryId    
       FROM SalesEntry    
       WHERE SaleEntryHeaderId = @SaleEntryHeaderId    
       );    
    
     DELETE    
     FROM SalesEntry    
     WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    
     DELETE    
     FROM SaleEntryHeader    
     WHERE SaleEntryHeaderId = @SaleEntryHeaderId;    
    END    
   END    
  END    
    
  /*IF @@TRANCOUNT > 0      
   COMMIT;*/    
  INSERT INTO @ResultTable    
  VALUES (    
   0    
   ,200    
   ,@IsArchived    
   );    
 END TRY    
    
 BEGIN CATCH    
  /*IF @@TRANCOUNT > 0      
                ROLLBACK;*/    
  INSERT INTO @ResultTable    
  VALUES (    
   0    
   ,500    
   ,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()    
   );    
 END CATCH;    
    
 SELECT DISTINCT RowNo    
  ,ResponseCode    
  ,ResponseMessage    
 FROM @ResultTable;    
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BI_BP_AGENT_OPSI]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec [dbo].[SP_BI_BP_AGENT_OPSI]
CREATE PROC [dbo].[SP_BI_BP_AGENT_OPSI]
AS
BEGIN
	DECLARE @BPYear VARCHAR(4)
		,@StartDate DATE
		,@EndDate DATE

	SELECT @BPYear = ConfigValue
	FROM GlobalConfig
	WHERE ConfigKey = 'BP_Year'

	--PRINT @BPYear
	SET @StartDate = CAST(@BPYear + '04' + '01' AS DATE)
	SET @EndDate = DATEADD(MONTH, 12, @StartDate);

	WITH OrderData
	AS (
		SELECT 1000 AS Company
			,A.CustomerCode AS PSI_CONS_CODE
			,B.SalesOfficeCode
			,B.RegionCode
			,B.DepartmentCode
			,B.CountryCode
			,MV.ProductCategoryCode1 AS MGGroup
			,MV.ProductCategoryCode2 AS MG1
			,MV.ProductCategoryCode3 AS MG2
			,MV.ProductCategoryCode4 AS MG3
			,MV.ProductCategoryCode5 AS MG4
			,MV.ProductCategoryCode6 AS MG5
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS BP_O_QTY
			,A.Quantity * A.Price AS BP_O_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_O_AMT_USD
		FROM VW_DIRECT_SALE_BP A
		INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode
		INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'O'
		)
		
		,PurchaseData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS BP_P_QTY
			,A.Quantity * A.Price AS BP_P_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_P_AMT_USD
		FROM VW_DIRECT_SALE_BP A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'P'
		)
		,SalesData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS BP_S_QTY
			,A.Quantity * A.Price AS BP_S_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_S_AMT_USD
		FROM VW_DIRECT_SALE_BP A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'S'
		)
		,InVentoryData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS BP_I_QTY
			,A.Quantity * A.Price AS BP_I_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_I_AMT_USD
		FROM VW_DIRECT_SALE_BP A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'I'
		)
	--select * from InVentoryData
	SELECT Company
		,OD.PSI_CONS_CODE
		,OD.SalesOfficeCode AS SalesOffice
		,OD.RegionCode AS Region
		,OD.DepartmentCode AS Department
		,OD.CountryCode AS Country
		,OD.MaterialCode AS PSI_ITEM_CODE
		,OD.MonthYear AS PSI_YYYYMM
		,OD.MGGroup
		,OD.MG1
		,OD.MG2
		,OD.MG3
		,OD.MG4
		,OD.MG5
		,OD.BP_O_QTY
		,OD.BP_O_AMT
		,OD.BP_O_AMT_USD
		,PD.BP_P_QTY
		,PD.BP_P_AMT
		,PD.BP_P_AMT_USD
		,SD.BP_S_QTY
		,SD.BP_S_AMT
		,SD.BP_S_AMT_USD
		,ID.BP_I_QTY
		,ID.BP_I_AMT
		,ID.BP_I_AMT_USD
	FROM OrderData OD
	INNER JOIN PurchaseData PD ON OD.PSI_CONS_CODE = PD.CustomerCode
		AND OD.MaterialCode = PD.MaterialCode
		AND OD.MonthYear = PD.MonthYear
	INNER JOIN SalesData SD ON OD.PSI_CONS_CODE = SD.CustomerCode
		AND OD.MaterialCode = SD.MaterialCode
		AND OD.MonthYear = SD.MonthYear
	INNER JOIN InVentoryData ID ON OD.PSI_CONS_CODE = ID.CustomerCode
		AND OD.MaterialCode = ID.MaterialCode
		AND OD.MonthYear = ID.MonthYear
	WHERE OD.MonthYear IN (
			SELECT YearMonth
			FROM dbo.YearMonthRange(@StartDate, @EndDate)
			)
	ORDER BY OD.PSI_CONS_CODE
		,OD.MaterialCode
		,OD.MonthYear
		--- Union SNS Data
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BI_BP_AGENT_SNS]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BI_BP_AGENT_SNS]
AS
BEGIN
	DECLARE @BPYear VARCHAR(4)
		,@StartDate DATE
		,@EndDate DATE

	SELECT @BPYear = ConfigValue
	FROM GlobalConfig
	WHERE ConfigKey = 'BP_Year'

	--PRINT @BPYear
	SET @StartDate = CAST(@BPYear + '04' + '01' AS DATE)
	SET @EndDate = DATEADD(MONTH, 12, @StartDate);

	WITH BPData
	AS (
		SELECT SUM(A.Quantity) AS BP_QTY
			,SUM(A.Quantity * A.Price) AS BP_AMT
			,A.CustomerCode
			,A.MonthYear
			,A.MaterialCode
		FROM VW_DIRECT_SALE_BP A
		WHERE A.ModeofTypeCode IN (
				'O'
				,'MPO'
				,'ADJ'
				)
		GROUP BY A.CustomerCode
			,A.MonthYear
			,A.MaterialCode
		)
		,COGPriceData
	AS (
		SELECT SUM(Price) AS COGPrice
			,CustomerCode
			,MaterialCode
		FROM VW_COG_ENTRY_DETAILS
		WHERE SaleSubType = 'BP'
			AND CHARGETYPE IN (
				'FRT'
				,'CST'
				,'FOB'
				)
		GROUP BY CustomerCode
			,MaterialCode
		)
		,SaleAmount
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.Quantity * A.Price AS BP_S_AMT
		FROM VW_DIRECT_SALE_BP A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'S'
		)
	SELECT 1000 AS Company
		,A.CustomerCode AS PSI_CONS_CODE
		,B.SalesOfficeCode
		,B.RegionCode
		,B.DepartmentCode
		,B.CountryCode
		,MV.ProductCategoryCode1 AS MGGroup
		,MV.ProductCategoryCode2 AS MG1
		,MV.ProductCategoryCode3 AS MG2
		,MV.ProductCategoryCode4 AS MG3
		,MV.ProductCategoryCode5 AS MG4
		,MV.ProductCategoryCode6 AS MG5
		,A.MaterialCode
		,A.MonthYear
		,A.BP_QTY
		,A.BP_AMT
		,'Direct_Sales' AS SALES_TYPE
		,(A.BP_QTY * ISNULL(COG.COGPrice, 0)) AS BP_COST_AMT
		,ISNULL((A.BP_QTY * ISNULL(COG.COGPrice, 0)) / nullif(SAMT.BP_S_AMT, 0), 0) AS BP_GPAMT
	FROM BPData A
	INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode
	INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode
	LEFT JOIN COGPriceData COG ON A.CustomerCode = COG.CustomerCode
		AND A.MaterialCode = COG.MaterialCode
	LEFT JOIN SaleAmount SAMT ON A.CustomerCode = SAMT.CustomerCode
		AND A.MaterialCode = SAMT.MaterialCode
		AND A.MonthYear = SAMT.MonthYear
	WHERE A.MonthYear IN (
			SELECT YearMonth
			FROM dbo.YearMonthRange(@StartDate, @EndDate)
			)
	
	UNION
	
	SELECT 1000 AS Company
		,A.CustomerCode AS PSI_CONS_CODE
		,B.SalesOfficeCode
		,B.RegionCode
		,B.DepartmentCode
		,B.CountryCode
		,MV.ProductCategoryCode1 AS MGGroup
		,MV.ProductCategoryCode2 AS MG1
		,MV.ProductCategoryCode3 AS MG2
		,MV.ProductCategoryCode4 AS MG3
		,MV.ProductCategoryCode5 AS MG4
		,MV.ProductCategoryCode6 AS MG5
		,A.MaterialCode
		,A.MonthYear
		,A.Qty BP_QTY
		,A.Qty * A.Price AS BP_AMT
		,'STOCK-SALES' AS SALES_TYPE
		,(A.Qty * ISNULL(COG.COGPrice, 0)) AS BP_COST_AMT
		,ISNULL((A.Qty * ISNULL(COG.COGPrice, 0)) / nullif(SAMT.BP_S_AMT, 0), 0) AS BP_GPAMT
	FROM VW_SNS_DETAILS_BP A
	INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode
	INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode
	LEFT JOIN COGPriceData COG ON A.CustomerCode = COG.CustomerCode
		AND A.MaterialCode = COG.MaterialCode
	LEFT JOIN SaleAmount SAMT ON A.CustomerCode = SAMT.CustomerCode
		AND A.MaterialCode = SAMT.MaterialCode
		AND A.MonthYear = SAMT.MonthYear
	WHERE A.MonthYear IN (
			SELECT YearMonth
			FROM dbo.YearMonthRange(@StartDate, @EndDate)
			)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_BI_FORECAST_AGENT_OPSI]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_BI_FORECAST_AGENT_OPSI]
AS
BEGIN
	DECLARE @PSIYear VARCHAR(4)
		,@StartDate DATE
		,@EndDate DATE
		,@PrevStartDate DATE
		,@PrevEndDate DATE

	SELECT @PSIYear = ConfigValue
	FROM GlobalConfig
	WHERE ConfigKey = 'PSI_YEAR'

	--PRINT @PSIYear
	SET @StartDate = CAST(@PSIYear + '04' + '01' AS DATE)
	SET @EndDate = DATEADD(MONTH, 12, @StartDate);

	-- PREV YEAR
	DECLARE @PrevYear VARCHAR(4)
	SET @PrevYear = CAST( CAST(@PSIYear AS INT)-1 AS VARCHAR)
	SET @PrevStartDate= CAST(@PrevYear + '04' + '01' AS DATE)
	SET @PrevEndDate=DATEADD(MONTH, 12, @PrevStartDate);


	CREATE TABLE #TMPCURRENTYEAR
	(
		Company VArCHAR(200),
		SalesOffice VArCHAR(200),
		Region VArCHAR(200),
		Country VArCHAR(200),
		Department VArCHAR(200),
		MGGroup VArCHAR(200),
		MG1 VArCHAR(200),
		MG2 VArCHAR(200),
		MG3 VArCHAR(200),
		MG4 VArCHAR(200),
		MG5 VArCHAR(200),
		SALES_TYPE VARCHAR(200),
		PSI_CONS_CODE VArCHAR(200),
		PSI_YYYYMM VArCHAR(200),
		PSI_ITEM_CODE VArCHAR(200),
		O_QTY INT,
		O_AMT DECIMAL(18,2),
		O_AMT_USD  DECIMAL(18,2),
		P_QTY INT,
		P_AMT DECIMAL(18,2),
		P_AMT_USD  DECIMAL(18,2),

		S_QTY INT,
		S_AMT DECIMAL(18,2),
		S_AMT_USD  DECIMAL(18,2),
		I_QTY INT,
		I_AMT DECIMAL(18,2),
		I_AMT_USD  DECIMAL(18,2),
		PSI_COST_AMT   DECIMAL(18,2)
	)
	;
	CREATE TABLE #TMPLASTYEAR
	(
		Company VArCHAR(200),
		SalesOffice VArCHAR(200),
		Region VArCHAR(200),
		Country VArCHAR(200),
		Department VArCHAR(200),
		MGGroup VArCHAR(200),
		MG1 VArCHAR(200),
		MG2 VArCHAR(200),
		MG3 VArCHAR(200),
		MG4 VArCHAR(200),
		MG5 VArCHAR(200),
		SALES_TYPE VARCHAR(200),
		PSI_CONS_CODE VArCHAR(200),
		PSI_YYYYMM VArCHAR(200),
		PSI_ITEM_CODE VArCHAR(200),
		LY_O_QTY INT,
		LY_O_AMT DECIMAL(18,2),
		
		LY_P_QTY INT,
		LY_P_AMT DECIMAL(18,2),
		
		LY_S_QTY INT,
		LY_S_AMT DECIMAL(18,2),
		
		LY_I_QTY INT,
		LY_I_AMT DECIMAL(18,2),

		LY_O_AMT_USD DECIMAL(18,2),
		LY_P_AMT_USD  DECIMAL(18,2),
		LY_S_AMT_USD  DECIMAL(18,2),
		LY_I_AMT_USD  DECIMAL(18,2),

		NXT_SALE_AMT DECIMAL(18,2),
		NXT_SALE_AMT_USD DECIMAL(18,2),

		
	)
	;

	WITH OrderData
	AS (
		SELECT 1000 AS Company
			,A.CustomerCode AS PSI_CONS_CODE
			,B.SalesOfficeCode
			,B.RegionCode
			,B.DepartmentCode
			,B.CountryCode
			,MV.ProductCategoryCode1 AS MGGroup
			,MV.ProductCategoryCode2 AS MG1
			,MV.ProductCategoryCode3 AS MG2
			,MV.ProductCategoryCode4 AS MG3
			,MV.ProductCategoryCode5 AS MG4
			,MV.ProductCategoryCode6 AS MG5
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS O_QTY
			,A.Quantity * A.Price AS O_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS O_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode
		INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'O'
		)
		,PurchaseData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS P_QTY
			,A.Quantity * A.Price AS P_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS P_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'P'
		)
		,SalesData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS S_QTY
			,A.Quantity * A.Price AS S_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS S_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'S'
		)
		,InVentoryData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS I_QTY
			,A.Quantity * A.Price AS I_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS I_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@StartDate, @EndDate)
				)
			AND A.ModeofTypeCode = 'I'
		)
	--select * from InVentoryData
	INSERT INTO #TMPCURRENTYEAR
	SELECT Company
		
		,OD.SalesOfficeCode AS SalesOffice
		,OD.RegionCode AS Region
		,OD.CountryCode AS Country
		,OD.DepartmentCode AS Department
		
		,OD.MGGroup
		,OD.MG1
		,OD.MG2
		,OD.MG3
		,OD.MG4
		,OD.MG5
		,'RE-EXPORT' AS SALES_TYPE
		
		,OD.PSI_CONS_CODE
		,OD.MonthYear AS PSI_YYYYMM
		,OD.MaterialCode AS PSI_ITEM_CODE
		,OD.O_QTY
		,OD.O_AMT
		,OD.O_AMT_USD
		,PD.P_QTY
		,PD.P_AMT
		,PD.P_AMT_USD
		,SD.S_QTY
		,SD.S_AMT
		,SD.S_AMT_USD
		,ID.I_QTY
		,ID.I_AMT
		,ID.I_AMT_USD
		,0
	FROM OrderData OD
	JOIN PurchaseData PD ON OD.PSI_CONS_CODE = PD.CustomerCode
		AND OD.MaterialCode = PD.MaterialCode
		AND OD.MonthYear = PD.MonthYear
	JOIN SalesData SD ON OD.PSI_CONS_CODE = SD.CustomerCode
		AND OD.MaterialCode = SD.MaterialCode
		AND OD.MonthYear = SD.MonthYear
	JOIN InVentoryData ID ON OD.PSI_CONS_CODE = ID.CustomerCode
		AND OD.MaterialCode = ID.MaterialCode
		AND OD.MonthYear = ID.MonthYear
	WHERE OD.MonthYear IN (
			SELECT YearMonth
			FROM dbo.YearMonthRange(@StartDate, @EndDate)
			)
	ORDER BY OD.PSI_CONS_CODE
		,OD.MaterialCode
		,OD.MonthYear
		--- Union SNS Data



	;WITH OrderDataPREV
	AS (
		SELECT 1000 AS Company
			,A.CustomerCode AS PSI_CONS_CODE
			,B.SalesOfficeCode
			,B.RegionCode
			,B.DepartmentCode
			,B.CountryCode
			,MV.ProductCategoryCode1 AS MGGroup
			,MV.ProductCategoryCode2 AS MG1
			,MV.ProductCategoryCode3 AS MG2
			,MV.ProductCategoryCode4 AS MG3
			,MV.ProductCategoryCode5 AS MG4
			,MV.ProductCategoryCode6 AS MG5
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS O_QTY
			,A.Quantity * A.Price AS O_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS O_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode
		INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)
				)
			AND A.ModeofTypeCode = 'O'
		)
		,PurchaseData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS P_QTY
			,A.Quantity * A.Price AS P_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS P_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)
				)
			AND A.ModeofTypeCode = 'P'
		)
		,SalesData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS S_QTY
			,A.Quantity * A.Price AS S_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS S_AMT_USD
		FROM VW_DIRECT_SALE_MONTHLY A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)
				)
			AND A.ModeofTypeCode = 'S'
		)
		,InVentoryData
	AS (
		SELECT A.CustomerCode
			,A.MaterialCode
			,A.MonthYear
			,A.ModeofTypeCode
			,A.Quantity AS I_QTY
			,A.Quantity * A.Price AS I_AMT
			,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS I_AMT_USD
		FROM VW_DIRECT_SALE_BP A
		WHERE MonthYear IN (
				SELECT YearMonth
				FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)
				)
			AND A.ModeofTypeCode = 'I'
		)
	--select * from InVentoryData
	INSERT INTO #TMPLASTYEAR
	SELECT Company
		
		,OD.SalesOfficeCode AS SalesOffice
		,OD.RegionCode AS Region
		,OD.CountryCode AS Country
		,OD.DepartmentCode AS Department
		
		,OD.MGGroup
		,OD.MG1
		,OD.MG2
		,OD.MG3
		,OD.MG4
		,OD.MG5
		,'RE-EXPORT' AS SALES_TYPE
		
		,OD.PSI_CONS_CODE
		,OD.MonthYear AS PSI_YYYYMM
		,OD.MaterialCode AS PSI_ITEM_CODE
		,OD.O_QTY
		,OD.O_AMT
	
		,PD.P_QTY
		,PD.P_AMT
		
		,SD.S_QTY
		,SD.S_AMT
		
		,ID.I_QTY
		,ID.I_AMT
		,OD.O_AMT_USD
		,PD.P_AMT_USD
		,SD.S_AMT_USD
		,ID.I_AMT_USD
		,0
		,0
	FROM OrderDataPREV OD
	JOIN PurchaseData PD ON OD.PSI_CONS_CODE = PD.CustomerCode
		AND OD.MaterialCode = PD.MaterialCode
		AND OD.MonthYear = PD.MonthYear
	JOIN SalesData SD ON OD.PSI_CONS_CODE = SD.CustomerCode
		AND OD.MaterialCode = SD.MaterialCode
		AND OD.MonthYear = SD.MonthYear
	JOIN InVentoryData ID ON OD.PSI_CONS_CODE = ID.CustomerCode
		AND OD.MaterialCode = ID.MaterialCode
		AND OD.MonthYear = ID.MonthYear
	WHERE OD.MonthYear IN (
			SELECT YearMonth
			FROM dbo.YearMonthRange(@StartDate, @EndDate)
			)
	ORDER BY OD.PSI_CONS_CODE
		,OD.MaterialCode
		,OD.MonthYear


		--SELECT * FROM #TMPCURRENTYEAR
		--SELECT * FROM #TMPLASTYEAR

		-- MERGE BOTH CHANGES

		SELECT CY.*, LY.LY_O_QTY, LY.LY_O_AMT, LY.LY_P_QTY,LY.LY_P_AMT,LY.LY_S_QTY,LY.LY_S_AMT, LY.LY_I_QTY,LY.LY_I_AMT,
		LY.LY_O_AMT_USD,LY.LY_P_AMT_USD,LY.LY_S_AMT_USD,LY.LY_I_AMT_USD,
		LY.NXT_SALE_AMT ,LY.NXT_SALE_AMT_USD 
		FROM #TMPCURRENTYEAR CY
		--INNER JOIN #TMPLASTYEAR LY ON CY.Company= LY.Company
		LEFT JOIN #TMPLASTYEAR LY ON CY.Company= LY.Company
		AND CY.MGGroup= LY.MGGroup
		AND CY.MG1=LY.MG1
		AND Cy.MG2=LY.MG2
		AND CY.MG3= LY.MG3
		AND CY.MG4= LY.MG4
		AND CY.MG5= LY.MG5
		AND CY.SALES_TYPE= LY.SALES_TYPE
		AND CY.PSI_CONS_CODE= LY.PSI_CONS_CODE
		AND CY.PSI_YYYYMM = LY.PSI_YYYYMM
		AND CY.PSI_ITEM_CODE = LY.PSI_ITEM_CODE



		DROP TABLE #TMPCURRENTYEAR
		DROP TABLE #TMPLASTYEAR


END
GO
/****** Object:  StoredProcedure [dbo].[SP_BI_Forecast_AGENT_SNS_SALES]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[SP_BI_Forecast_AGENT_SNS_SALES]   
AS  
BEGIN  
 DECLARE @PSIYear VARCHAR(4)  
  ,@StartDate DATE  
  ,@EndDate DATE  
  ,@PrevStartDate DATE  
  ,@PrevEndDate DATE  
  
 SELECT @PSIYear = ConfigValue  
 FROM GlobalConfig  
 WHERE ConfigKey = 'PSI_YEAR'  
  
 --PRINT @PSIYear  
 SET @StartDate = CAST(@PSIYear + '04' + '01' AS DATE)  
 SET @EndDate = DATEADD(MONTH, 12, @StartDate);  
   -- PREV YEAR  
 DECLARE @PrevYear VARCHAR(4)  
 SET @PrevYear = CAST( CAST(@PSIYear AS INT)-1 AS VARCHAR)  
 SET @PrevStartDate= CAST(@PrevYear + '04' + '01' AS DATE)  
 SET @PrevEndDate=DATEADD(MONTH, 12, @PrevStartDate);  
  
  
 CREATE TABLE #TMPCURRENTYEAR  
 (  
  Company VArCHAR(200),  
  SalesOffice VArCHAR(200),  
  Region VArCHAR(200),  
  Country VArCHAR(200),  
  Department VArCHAR(200),  
  MGGroup VArCHAR(200),  
  MG1 VArCHAR(200),  
  MG2 VArCHAR(200),  
  MG3 VArCHAR(200),  
  MG4 VArCHAR(200),  
  MG5 VArCHAR(200),  
  SALES_TYPE VARCHAR(200),
  PSI_ITEM_CODE VArCHAR(200),  
  PSI_CONS_CODE VArCHAR(200),  
  PSI_YYYYMM VArCHAR(200),  
 
  CURRENT_PLAN_QTY INT,  
  CURRENT_PLANAMT DECIMAL(18,2),  
  CURRENT_COSTAMT  DECIMAL(18,2),  
  CURRENT_GPAMT  DECIMAL(18,2)
  
 )  
 ;  
 CREATE TABLE #TMPLASTYEAR  
 (  
  Company VArCHAR(200),  
  SalesOffice VArCHAR(200),  
  Region VArCHAR(200),  
  Country VArCHAR(200),  
  Department VArCHAR(200),  
  MGGroup VArCHAR(200),  
  MG1 VArCHAR(200),  
  MG2 VArCHAR(200),  
  MG3 VArCHAR(200),  
  MG4 VArCHAR(200),  
  MG5 VArCHAR(200),  
   SALES_TYPE VARCHAR(200),
  PSI_ITEM_CODE VArCHAR(200),  
  PSI_CONS_CODE VArCHAR(200),  
  PSI_YYYYMM VArCHAR(200),  
 
  LY_PLAN_QTY INT,  
  LY_PLANAMT DECIMAL(18,2),  
  LY_COSTAMT  DECIMAL(18,2),  
  LY_GPAMT  DECIMAL(18,2)
  
    
 )  
 ;  
  
--- CURRENT YEARS
    
 WITH MonthlyData  
 AS (  
  SELECT SUM(A.Quantity) AS CURRENT_PLAN_QTY  
   ,SUM(A.Quantity * A.Price) AS CURRENT_PLAN_AMT  
   ,A.CustomerCode  
   ,A.MonthYear  
   ,A.MaterialCode  
  FROM VW_DIRECT_SALE_MONTHLY A  
  WHERE A.ModeofTypeCode IN (  
    'O'  
    ,'MPO'  
    ,'ADJ'  
    )  
  GROUP BY A.CustomerCode  
   ,A.MonthYear  
   ,A.MaterialCode  
  )  
  ,COGPriceData  
 AS (  
  SELECT SUM(Price) AS COGPrice  
   ,CustomerCode  
   ,MaterialCode  
  FROM VW_COG_ENTRY_DETAILS  
  WHERE SaleSubType = 'MONTHLY'  
   AND CHARGETYPE IN (  
    'FRT'  
    ,'CST'  
    ,'FOB'  
    )  
  GROUP BY CustomerCode  
   ,MaterialCode  
  )  
  ,SaleAmount  
 AS (  
  SELECT A.CustomerCode  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.Quantity * A.Price AS MONTHLY_S_AMT  
  FROM VW_DIRECT_SALE_MONTHLY A  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@StartDate, @EndDate)  
    )  
   AND A.ModeofTypeCode = 'S'  
  )  

INSERT INTO #TMPCURRENTYEAR
(
Company, 
  SalesOffice, 
  Region, 
  Country, 
  Department, 
  MGGroup, 
  MG1, 
  MG2, 
  MG3, 
  MG4, 
  MG5, 
  SALES_TYPE,
  PSI_ITEM_CODE, 
  PSI_CONS_CODE, 
  PSI_YYYYMM, 
 
  CURRENT_PLAN_QTY, 
  CURRENT_PLANAMT,  
  CURRENT_COSTAMT,  
  CURRENT_GPAMT)
 SELECT 1000 AS Company  
  ,A.CustomerCode AS PSI_CONS_CODE  
  ,B.SalesOfficeCode  
  ,B.RegionCode  
  ,B.DepartmentCode  
  ,B.CountryCode  
  ,MV.ProductCategoryCode1 AS MGGroup  
  ,MV.ProductCategoryCode2 AS MG1  
  ,MV.ProductCategoryCode3 AS MG2  
  ,MV.ProductCategoryCode4 AS MG3  
  ,MV.ProductCategoryCode5 AS MG4  
  ,MV.ProductCategoryCode6 AS MG5  
  ,'Direct_Sales' AS SALES_TYPE  
  ,A.MaterialCode  
  ,A.MonthYear  
  ,A.CURRENT_PLAN_QTY  
  ,A.CURRENT_PLAN_AMT  
 
  ,(A.CURRENT_PLAN_QTY * ISNULL(COG.COGPrice, 0)) AS CURRENT_COST_AMT  
  ,ISNULL((A.CURRENT_PLAN_QTY * ISNULL(COG.COGPrice, 0)) / nullif(SAMT.MONTHLY_S_AMT, 0), 0) AS CURRENT_GPAMT  
 FROM MonthlyData A  
 INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode  
 INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode  
 LEFT JOIN COGPriceData COG ON A.CustomerCode = COG.CustomerCode  
  AND A.MaterialCode = COG.MaterialCode  
 LEFT JOIN SaleAmount SAMT ON A.CustomerCode = SAMT.CustomerCode  
  AND A.MaterialCode = SAMT.MaterialCode  
  AND A.MonthYear = SAMT.MonthYear  
 WHERE A.MonthYear IN (  
   SELECT YearMonth  
   FROM dbo.YearMonthRange(@StartDate, @EndDate)  
   )  
   
--SELECT * FROM #TMPCURRENTYEAR
   -- END CURRENT YEAR
   -- PREV YEAR
   
 ;WITH MonthlyDataPREV  
 AS (  
  SELECT SUM(A.Quantity) AS LY_PLAN_QTY  
   ,SUM(A.Quantity * A.Price) AS LY_PLAN_AMT  
   ,A.CustomerCode  
   ,A.MonthYear  
   ,A.MaterialCode  
  FROM VW_DIRECT_SALE_MONTHLY A  
  WHERE A.ModeofTypeCode IN (  
    'O'  
    ,'MPO'  
    ,'ADJ'  
    )  
  GROUP BY A.CustomerCode  
   ,A.MonthYear  
   ,A.MaterialCode  
  )  
  ,COGPriceData  
 AS (  
  SELECT SUM(Price) AS COGPrice  
   ,CustomerCode  
   ,MaterialCode  
  FROM VW_COG_ENTRY_DETAILS  
  WHERE SaleSubType = 'MONTHLY'  
   AND CHARGETYPE IN (  
    'FRT'  
    ,'CST'  
    ,'FOB'  
    )  
  GROUP BY CustomerCode  
   ,MaterialCode  
  )  
  ,SaleAmount  
 AS (  
  SELECT A.CustomerCode  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.Quantity * A.Price AS MONTHLY_S_AMT  
  FROM VW_DIRECT_SALE_MONTHLY A  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)  
    )  
   AND A.ModeofTypeCode = 'S'  
  )  

  --SELECT * FROM MonthlyDataPREV

INSERT INTO #TMPLASTYEAR
(
Company, 
  SalesOffice, 
  Region, 
  Country, 
  Department, 
  MGGroup, 
  MG1, 
  MG2, 
  MG3, 
  MG4, 
  MG5, 
  SALES_TYPE,
  PSI_ITEM_CODE, 
  PSI_CONS_CODE, 
  PSI_YYYYMM, 
 
  LY_PLAN_QTY ,  
  LY_PLANAMT ,  
  LY_COSTAMT ,  
  LY_GPAMT )
 SELECT 1000 AS Company  
  ,A.CustomerCode AS PSI_CONS_CODE  
  ,B.SalesOfficeCode  
  ,B.RegionCode  
  ,B.DepartmentCode  
  ,B.CountryCode  
  ,MV.ProductCategoryCode1 AS MGGroup  
  ,MV.ProductCategoryCode2 AS MG1  
  ,MV.ProductCategoryCode3 AS MG2  
  ,MV.ProductCategoryCode4 AS MG3  
  ,MV.ProductCategoryCode5 AS MG4  
  ,MV.ProductCategoryCode6 AS MG5  
  ,'Direct_Sales' AS SALES_TYPE  
  ,A.MaterialCode  
  ,A.MonthYear  
  ,A.LY_PLAN_QTY  
  ,A.LY_PLAN_AMT  
 
  ,(A.LY_PLAN_QTY * ISNULL(COG.COGPrice, 0)) AS CURRENT_COST_AMT  
  ,ISNULL((A.LY_PLAN_QTY * ISNULL(COG.COGPrice, 0)) / nullif(SAMT.MONTHLY_S_AMT, 0), 0) AS CURRENT_GPAMT  
 FROM MonthlyDataPREV A  
 INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode  
 INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode  
 LEFT JOIN COGPriceData COG ON A.CustomerCode = COG.CustomerCode  
  AND A.MaterialCode = COG.MaterialCode  
 LEFT JOIN SaleAmount SAMT ON A.CustomerCode = SAMT.CustomerCode  
  AND A.MaterialCode = SAMT.MaterialCode  
  AND A.MonthYear = SAMT.MonthYear  
 WHERE A.MonthYear IN (  
   SELECT YearMonth  
   FROM dbo.YearMonthRange(@PrevStartDate, @PrevEndDate)  
   )  


 --UNION  
   
 --SELECT 1000 AS Company  
 -- ,A.CustomerCode AS PSI_CONS_CODE  
 -- ,B.SalesOfficeCode  
 -- ,B.RegionCode  
 -- ,B.DepartmentCode  
 -- ,B.CountryCode  
 -- ,MV.ProductCategoryCode1 AS MGGroup  
 -- ,MV.ProductCategoryCode2 AS MG1  
 -- ,MV.ProductCategoryCode3 AS MG2  
 -- ,MV.ProductCategoryCode4 AS MG3  
 -- ,MV.ProductCategoryCode5 AS MG4  
 -- ,MV.ProductCategoryCode6 AS MG5  
 -- ,A.MaterialCode  
 -- ,A.MonthYear  
 -- ,A.Qty CURRENT_QTY  
 -- ,A.Qty * A.Price AS CURRENT_AMT  
 -- ,'STOCK-SALES' AS SALES_TYPE  
 -- ,(A.Qty * ISNULL(COG.COGPrice, 0)) AS CURRENT_COST_AMT  
 -- ,ISNULL((A.Qty * ISNULL(COG.COGPrice, 0)) / nullif(SAMT.CURRENT_S_AMT, 0), 0) AS _GPAMT  
 --FROM VW_SNS_DETAILS_BP A  
 --INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode  
 --INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode  
 --LEFT JOIN COGPriceData COG ON A.CustomerCode = COG.CustomerCode  
 -- AND A.MaterialCode = COG.MaterialCode  
 --LEFT JOIN SaleAmount SAMT ON A.CustomerCode = SAMT.CustomerCode  
 -- AND A.MaterialCode = SAMT.MaterialCode  
 -- AND A.MonthYear = SAMT.MonthYear  
 --WHERE A.MonthYear IN (  
 --  SELECT YearMonth  
 --  FROM dbo.YearMonthRange(@StartDate, @EndDate)  
 --  )  


 
  SELECT CY.*, LY.LY_PLAN_QTY, LY.LY_PLANAMT, LY.LY_COSTAMT, LY_GPAMT   
  FROM #TMPCURRENTYEAR CY  
  --INNER JOIN #TMPLASTYEAR LY ON CY.Company= LY.Company  
  LEFT JOIN #TMPLASTYEAR LY ON CY.Company= LY.Company  
  AND CY.MGGroup= LY.MGGroup  
  AND CY.MG1=LY.MG1  
  AND Cy.MG2=LY.MG2  
  AND CY.MG3= LY.MG3  
  AND CY.MG4= LY.MG4  
  AND CY.MG5= LY.MG5  
  AND CY.SALES_TYPE= LY.SALES_TYPE  
  AND CY.PSI_CONS_CODE= LY.PSI_CONS_CODE  
  AND CY.PSI_YYYYMM = LY.PSI_YYYYMM  
  AND CY.PSI_ITEM_CODE = LY.PSI_ITEM_CODE  


  DROP TABLE #TMPCURRENTYEAR  
  DROP TABLE #TMPLASTYEAR  
  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_BI_LM_Agent_OPSI]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_BI_LM_Agent_OPSI]  
AS  
BEGIN  
 DECLARE @BPYear VARCHAR(4)  
  ,@StartDate DATE  
  ,@EndDate DATE  
  
 SELECT @BPYear = ConfigValue  
 FROM GlobalConfig  
 WHERE ConfigKey = 'BP_Year'  
  
 --PRINT @BPYear  
 SET @StartDate = CAST(@BPYear + '04' + '01' AS DATE)  
 SET @EndDate = DATEADD(MONTH, 12, @StartDate);  
  
 WITH OrderData  
 AS (  
  SELECT 1000 AS Company  
   ,A.CustomerCode AS PSI_CONS_CODE  
   ,B.SalesOfficeCode  
   ,B.RegionCode  
   ,B.DepartmentCode  
   ,B.CountryCode  
   ,MV.ProductCategoryCode1 AS MGGroup  
   ,MV.ProductCategoryCode2 AS MG1  
   ,MV.ProductCategoryCode3 AS MG2  
   ,MV.ProductCategoryCode4 AS MG3  
   ,MV.ProductCategoryCode5 AS MG4  
   ,MV.ProductCategoryCode6 AS MG5  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.ModeofTypeCode  
   ,A.Quantity AS BP_O_QTY  
   ,A.Quantity * A.Price AS BP_O_AMT  
   ,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_O_AMT_USD  
  FROM VW_DIRECT_SALE_BP A  
  INNER JOIN CustomerView B ON A.CustomerCode = B.CustomerCode  
  INNER JOIN MaterialView MV ON A.MaterialCode = MV.MaterialCode  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@StartDate, @EndDate)  
    )  
   AND A.ModeofTypeCode = 'O'  
  )  
    
  ,PurchaseData  
 AS (  
  SELECT A.CustomerCode  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.ModeofTypeCode  
   ,A.Quantity AS BP_P_QTY  
   ,A.Quantity * A.Price AS BP_P_AMT  
   ,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_P_AMT_USD  
  FROM VW_DIRECT_SALE_BP A  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@StartDate, @EndDate)  
    )  
   AND A.ModeofTypeCode = 'P'  
  )  
  ,SalesData  
 AS (  
  SELECT A.CustomerCode  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.ModeofTypeCode  
   ,A.Quantity AS BP_S_QTY  
   ,A.Quantity * A.Price AS BP_S_AMT  
   ,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_S_AMT_USD  
  FROM VW_DIRECT_SALE_BP A  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@StartDate, @EndDate)  
    )  
   AND A.ModeofTypeCode = 'S'  
  )  
  ,InVentoryData  
 AS (  
  SELECT A.CustomerCode  
   ,A.MaterialCode  
   ,A.MonthYear  
   ,A.ModeofTypeCode  
   ,A.Quantity AS BP_I_QTY  
   ,A.Quantity * A.Price AS BP_I_AMT  
   ,dbo.UDF_USDAmount(A.Quantity, A.Price, A.CurrencyCode) AS BP_I_AMT_USD  
  FROM VW_DIRECT_SALE_BP A  
  WHERE MonthYear IN (  
    SELECT YearMonth  
    FROM dbo.YearMonthRange(@StartDate, @EndDate)  
    )  
   AND A.ModeofTypeCode = 'I'  
  )  
 --select * from InVentoryData  
 SELECT Company  
  ,OD.PSI_CONS_CODE  
  ,OD.SalesOfficeCode AS SalesOffice  
  ,OD.RegionCode AS Region  
  ,OD.DepartmentCode AS Department  
  ,OD.CountryCode AS Country  
  ,OD.MaterialCode AS PSI_ITEM_CODE  
  ,OD.MonthYear AS PSI_YYYYMM  
  ,OD.MGGroup  
  ,OD.MG1  
  ,OD.MG2  
  ,OD.MG3  
  ,OD.MG4  
  ,OD.MG5  
  ,OD.BP_O_QTY  
  ,OD.BP_O_AMT  
  ,OD.BP_O_AMT_USD  
  ,PD.BP_P_QTY  
  ,PD.BP_P_AMT  
  ,PD.BP_P_AMT_USD  
  ,SD.BP_S_QTY  
  ,SD.BP_S_AMT  
  ,SD.BP_S_AMT_USD  
  ,ID.BP_I_QTY  
  ,ID.BP_I_AMT  
  ,ID.BP_I_AMT_USD  
 FROM OrderData OD  
 INNER JOIN PurchaseData PD ON OD.PSI_CONS_CODE = PD.CustomerCode  
  AND OD.MaterialCode = PD.MaterialCode  
  AND OD.MonthYear = PD.MonthYear  
 INNER JOIN SalesData SD ON OD.PSI_CONS_CODE = SD.CustomerCode  
  AND OD.MaterialCode = SD.MaterialCode  
  AND OD.MonthYear = SD.MonthYear  
 INNER JOIN InVentoryData ID ON OD.PSI_CONS_CODE = ID.CustomerCode  
  AND OD.MaterialCode = ID.MaterialCode  
  AND OD.MonthYear = ID.MonthYear  
 WHERE OD.MonthYear IN (  
   SELECT YearMonth  
   FROM dbo.YearMonthRange(@StartDate, @EndDate)  
   )  
 ORDER BY OD.PSI_CONS_CODE  
  ,OD.MaterialCode  
  ,OD.MonthYear  
  --- Union SNS Data  
END  

GO
/****** Object:  StoredProcedure [dbo].[SP_Calculate_RollingInventory]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
-- =============================================          
-- Author:      <Author, , Name>          
-- Create Date: <Create Date, , >          
-- Description: <Description, , >          
-- =============================================          
CREATE PROCEDURE [dbo].[SP_Calculate_RollingInventory] (  
 @userId NVARCHAR(100)  
 ,@tvpAccontMaterialCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST] READONLY  
 )  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELEaCT statements.          
 SET NOCOUNT ON  
  
 -- Insert statements for procedure here          
 BEGIN TRY  
  BEGIN TRANSACTION  
  
  DECLARE @resultMonthYear INT  
   ,@currentMonthYear INT  
   ,@lockMonthYear INT  
   ,@lastForecastMonthYear INT  
   ,@accountMaterialCount INT  
   ,@materialCount INT;  
  
  --SET @currentMonthYear = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));        
  --SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));        
  --SET @lockMonth = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));        
  --SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));        
  SELECT @currentMonthYear = CAST(ConfigValue AS INT)  
  FROM [dbo].[GlobalConfig]  
  WHERE ConfigKey = 'Current_Month'  
   AND ConfigType = 'Direct And SNS';  
  
  DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, CAST(@currentMonthYear AS VARCHAR(6)) + '01', 112);  
  
  SET @resultMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, - 1, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  SET @lockMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  SET @lastForecastMonthYear = (  
    SELECT CAST(FORMAT(DATEADD(month, 6, @dtCurrentMonthYear), 'yyyyMM') AS INT)  
    );  
  
  --PRINT '@currentMonthYear';      
  --PRINT @currentMonthYear;      
  --PRINT '@currentMonthYear';      
  --PRINT @currentMonthYear;      
  --PRINT '@resultMonthYear';      
  --PRINT @resultMonthYear;      
  --PRINT '@lockMonthYear';      
  --PRINT @lockMonthYear;      
  --PRINT '@lastForecastMonthYear';      
  --PRINT @lastForecastMonthYear;      
  DECLARE @tvpSNSEntryQtyPrices AS [dbo].[TVP_SNS_ENTRY_QTY_PRICES];  
  DECLARE @tvpPricePlannings AS [dbo].[TVP_PRICE_PLANNING];  
  --DECLARE @tvpAccounMaterialPricePlannings  AS [dbo].[TVP_PRICE_PLANNING];        
  DECLARE @tvpAccontMaterialCodeListWithRowNo [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO];  
  DECLARE @tvpAccountMaterialDistCodeList [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST];  
  
  --select * from @tvpAccontMaterialCodeListWithRowNo      
  IF NOT EXISTS (  
    SELECT TOP 1 1  
    FROM @tvpAccontMaterialCodeList  
    )  
  BEGIN  
   INSERT INTO @tvpAccountMaterialDistCodeList  
   SELECT DISTINCT [AccountCode]  
    ,MaterialCode  
   FROM [dbo].[TRNPricePlanning];  
  
   INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
    [AccountCode]  
    ,[MaterialCode]  
    ,RowNo  
    )  
   SELECT DISTINCT [AccountCode]  
    ,[MaterialCode]  
    ,ROW_NUMBER() OVER (  
     ORDER BY [AccountCode]  
      ,[MaterialCode] ASC  
     ) AS RowNo  
   FROM @tvpAccountMaterialDistCodeList;  
  END  
  ELSE  
  BEGIN  
   IF EXISTS (  
     SELECT TOP 1 1  
     FROM @tvpAccontMaterialCodeList  
     WHERE AccountCode IS NOT NULL  
      AND AccountCode != ''  
      AND (  
       MaterialCode IS NULL  
       OR MaterialCode = ''  
       )  
     )  
   BEGIN  
    --PRINT 'MaterialCode IS EMPTY';      
    INSERT INTO @tvpAccountMaterialDistCodeList  
    SELECT DISTINCT [AccountCode]  
     ,MaterialCode  
    FROM [dbo].[TRNPricePlanning]  
    WHERE [AccountCode] IN (  
      SELECT DISTINCT [AccountCode]  
      FROM @tvpAccontMaterialCodeList  
      WHERE AccountCode IS NOT NULL  
       AND AccountCode != ''  
      );  
  
    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
     [AccountCode]  
     ,[MaterialCode]  
     ,RowNo  
     )  
    SELECT DISTINCT [AccountCode]  
     ,[MaterialCode]  
     ,ROW_NUMBER() OVER (  
      ORDER BY [AccountCode]  
       ,[MaterialCode] ASC  
      ) AS RowNo  
    FROM @tvpAccountMaterialDistCodeList;  
   END  
   ELSE  
   BEGIN  
    --PRINT 'MaterialCode IS NOT EMPTY';      
    INSERT INTO @tvpAccontMaterialCodeListWithRowNo (  
     [AccountCode]  
     ,[MaterialCode]  
     ,RowNo  
     )  
    SELECT [AccountCode]  
     ,[MaterialCode]  
     ,ROW_NUMBER() OVER (  
      ORDER BY [AccountCode]  
       ,[MaterialCode] ASC  
      ) AS RowNo  
    FROM @tvpAccontMaterialCodeList;  
   END  
  END  
  
  /*SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;      
        
 IF NOT EXISTS( SELECT TOP 1 1 FROM @tvpAccontMaterialCodeListWithRowNo)        
 BEGIN        
  INSERT INTO @tvpMaterialDistCodeList        
  SELECT distinct MaterialCode        
  FROM [dbo].[TRNPricePlanning];        
        
  INSERT INTO @tvpAccontMaterialCodeListWithRowNo(Code, RowNo)        
  SELECT distinct Code, ROW_NUMBER() OVER(ORDER BY Code ASC) AS RowNo        
  FROM @tvpMaterialDistCodeList;        
 END        
 ELSE        
 BEGIN        
  INSERT INTO @tvpAccontMaterialCodeListWithRowNo(Code, RowNo)        
  SELECT Code, ROW_NUMBER() OVER(ORDER BY Code ASC) AS RowNo        
  FROM @tvpAccontMaterialCodeListWithRowNo;        
 END        
  */  
  INSERT INTO @tvpSNSEntryQtyPrices  
  SELECT SE.SNSEntryId  
   ,SQ.SNSEntryQtyPriceId  
   ,SQ.MonthYear  
   ,SE.CustomerCode  
   ,SE.MaterialCode  
   ,SQ.Qty AS Quantity  
   ,SQ.Price AS Amount  
   ,SE.OACCode AS [AccountCode]
   ,SaleSubType
  FROM [dbo].[SNSEntry] SE  
  INNER JOIN [dbo].[SNSEntryQtyPrice] SQ ON SE.SNSEntryId = SQ.SNSEntryId  
  WHERE SE.MonthYear >= @currentMonthYear
   AND SE.MonthYear <= @lastForecastMonthYear  
   AND SQ.MonthYear >= @currentMonthYear  
   AND SQ.MonthYear <= @lastForecastMonthYear  
   AND SE.[OACCode] IN (  
    SELECT [AccountCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    )  
   AND SE.[MaterialCode] IN (  
    SELECT [MaterialCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  --SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;        
  --SELECT * FROM @tvpAccontMaterialCodeListWithRowNo;        
  --SELECT * FROM @tvpSNSEntryQtyPrices;        
  INSERT INTO @tvpPricePlannings  
  SELECT [TRNPricePlanningId]  
   ,[AccountCode]  
   ,[MonthYear]  
   ,[MaterialCode]  
   ,[ModeofType]  
   ,[Type]  
   ,[Quantity] 
   ,Price
  FROM [dbo].[TRNPricePlanning]  
  WHERE MonthYear >= @resultMonthYear  
   AND [AccountCode] IN (  
    SELECT [AccountCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    )  
   AND [MaterialCode] IN (  
    SELECT [MaterialCode]  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  SET @accountMaterialCount = (  
    SELECT COUNT(1)  
    FROM @tvpAccontMaterialCodeListWithRowNo  
    );  
  
  --SET @materialCount = (SELECT COUNT(1) from @tvpAccontMaterialCodeListWithRowNo);        
  DECLARE @accountMaterialIndex INT = 1;  
  DECLARE @activeAccountCode NVARCHAR(50) = '';  
  DECLARE @activeMaterialCode NVARCHAR(50) = '';  
  
  --PRINT '@accountMaterialCount';      
  --PRINT @accountMaterialCount;          
  --print '@materialCount';      
  --print @materialCount;          
  WHILE (@accountMaterialIndex <= @accountMaterialCount)  
  BEGIN  
   SELECT @activeAccountCode = AccountCode  
    ,@activeMaterialCode = MaterialCode  
   FROM @tvpAccontMaterialCodeListWithRowNo  
   WHERE RowNo = @accountMaterialIndex;  
  
   --PRINT '@activeAccountCode';      
   --PRINT @activeAccountCode;      
   --PRINT '@activeMaterialCode';      
   --PRINT @activeMaterialCode      
   --DECLARE @materialIndex int = 1;        
   --WHILE (@materialIndex <= @materialCount)        
   --BEGIN        
   --SET @activeMaterialCode = (SELECT CODE FROM @tvpAccontMaterialCodeListWithRowNo WHERE RowNo = @materialIndex);        
   --insert into @tvpAccounMaterialPricePlannings        
   --SELECT * FROM @tvpPricePlannings        
   --WHERE AccountCode = @activeAccountCode AND MaterialCode = @activeMaterialCode;        
   --CHECK IF RESULT MONTH GIT IS EQUAL TO CURRENT MONTH PURCHASE        
   DECLARE @activeMonthYear INT = @resultMonthYear;  
   DECLARE @monthIndex INT = 0;  
  
   WHILE @activeMonthYear <= @lastForecastMonthYear  
   BEGIN  
    DECLARE @activeNextMonthYear INT = 0;  
    DECLARE @activePrevMonthYear INT = 0;  
    --PRINT '@activeMonthYear';        
    --PRINT @activeMonthYear;        
    DECLARE @activeMonth DATE = CONVERT(DATETIME, CONCAT (  
       CAST(@activeMonthYear AS VARCHAR(6))  
       ,'01'  
       ), 112);  
  
    --PRINT '@activeMonth';        
    --PRINT @activeMonth;        
    SET @activeNextMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
    SET @activePrevMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, - 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
  
    --PRINT '@activeNextMonthYear';        
    --PRINT @activeNextMonthYear;        
    --PRINT '@activePrevMonthYear';        
    --PRINT @activePrevMonthYear;        
    IF @monthIndex != 0  
    BEGIN  
     --INSERT/UPDATE SALES START        
     DECLARE @totalQty INT = 0;  
  
     SET @totalQty = (  
       SELECT SUM([Quantity])  
       FROM @tvpSNSEntryQtyPrices  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
       );  
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND ModeOfType = 'SALES'  
        AND Type = 'S&S'  
       )  
     BEGIN  
      UPDATE @tvpPricePlannings  
      SET [Quantity] = ISNULL(@totalQty, 0)  
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND ModeOfType = 'SALES'  
       AND Type = 'S&S';  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity] 
	   ,Price
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'SALES'  
       ,'S&S'  
       ,ISNULL(@totalQty, 0) 
	   ,0;
	   
     END  
  
     --INSERT/UPDATE SALES END        
     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE START        
     DECLARE @activeCurrentMonthOrderQty INT = 0;  
     DECLARE @activeNextMonthPurchaseQty INT = 0; 
	 DECLARE @activeCurrentMonthOrderPrice decimal = 0;  
     DECLARE @activeNextMonthPurchasePrice decimal = 0; 
  
     SET @activeCurrentMonthOrderQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'ORDER'  
       );  

	   SET @activeCurrentMonthOrderPrice = (  
       SELECT [Price]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'ORDER'  
       ); 
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeNextMonthYear  
        AND [ModeofType] = 'PURCHASE'  
        AND Type = 'S&S'  
       )  
     BEGIN  
      SET @activeNextMonthPurchaseQty = (  
        SELECT [Quantity]  
        FROM @tvpPricePlannings  
        WHERE AccountCode = @activeAccountCode  
         AND MaterialCode = @activeMaterialCode  
         AND MonthYear = @activeNextMonthYear  
         AND [ModeofType] = 'PURCHASE'  
         AND Type = 'S&S'  
        ); 

		SET @activeNextMonthPurchasePrice = (  
        SELECT [Price]  
        FROM @tvpPricePlannings  
        WHERE AccountCode = @activeAccountCode  
         AND MaterialCode = @activeMaterialCode  
         AND MonthYear = @activeNextMonthYear  
         AND [ModeofType] = 'PURCHASE'  
         AND Type = 'S&S'  
        ); 
  
      IF @activeCurrentMonthOrderQty != @activeNextMonthPurchaseQty  
      BEGIN  
       UPDATE @tvpPricePlannings  
       SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)
	   ,Price=ISNULL(@activeCurrentMonthOrderPrice, 0)
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeNextMonthYear  
        AND [ModeofType] = 'PURCHASE'  
        AND Type = 'S&S';  
      END  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]
	   ,Price
       )  
      SELECT @activeAccountCode  
       ,@activeNextMonthYear  
       ,@activeMaterialCode  
       ,'PURCHASE'  
       ,'S&S'  
       ,ISNULL(@activeCurrentMonthOrderQty, 0)
	   ,ISNULL(@activeCurrentMonthOrderPrice, 0);  
     END  
  
     --CURRENT MONTH ORDER == NEXT MONTH PURCHASE END        
     --CURRENT MONTH ORDER == CURRENT MONTH GIT START      
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'GIT Arrivals'  
       )  
     BEGIN  
      UPDATE @tvpPricePlannings  
      SET [Quantity] = ISNULL(@activeCurrentMonthOrderQty, 0)
	  ,[Price] = ISNULL(@activeCurrentMonthOrderPrice, 0)
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND [ModeofType] = 'GIT Arrivals';  
     END  
     ELSE  
     BEGIN  
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity]  
	   ,Price
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'GIT Arrivals'  
       ,NULL  
       ,ISNULL(@activeCurrentMonthOrderQty, 0)
	   ,ISNULL(@activeCurrentMonthOrderQty, 0);  
     END  
  
     --CURRENT MONTH ORDER == CURRENT MONTH GIT START      
     --CALCULATE INVENTORY        
     --PRINT '@CALCULATE INVENTORY';        
     --PRINT '@activeMonthYear';        
     --PRINT @activeMonthYear;        
     --PRINT '@activePrevMonthYear';        
     --PRINT @activePrevMonthYear;        
     DECLARE @activePrevMonthInventoryQty INT = 0;  
     DECLARE @activeCurrentMonthPurchaseQty INT = 0;  
     DECLARE @activeCurrentMonthMpoQty INT = 0;  
     DECLARE @activeCurrentSalesQty INT = 0;  
     DECLARE @activeCurrentInventoryQty INT = 0; 
	 
	 DECLARE @activePrevMonthInventoryPrice decimal = 0;  
     DECLARE @activeCurrentMonthPurchasePrice decimal = 0;  
     DECLARE @activeCurrentMonthMpoPrice decimal = 0;  
     DECLARE @activeCurrentSalesPrice decimal = 0;  
     DECLARE @activeCurrentInventoryPrice decimal = 0; 
  
     SET @activePrevMonthInventoryQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activePrevMonthYear  
        AND [ModeofType] = 'INVENTORY'  
       ); 
	   
	   SET @activePrevMonthInventoryPrice = (  
       SELECT [Price]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activePrevMonthYear  
        AND [ModeofType] = 'INVENTORY'  
       );
     SET @activeCurrentMonthPurchaseQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'PURCHASE'  
       ); 
	   
	    SET @activeCurrentMonthPurchasePrice = (  
       SELECT Price  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'PURCHASE'  
       ); 

     SET @activeCurrentMonthMpoQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'MPO'  
       ); 
	   
	    SET @activeCurrentMonthMpoPrice = (  
       SELECT [Price]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'MPO'  
       ); 

     SET @activeCurrentSalesQty = (  
       SELECT [Quantity]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'SALES'  
       );  

	    SET @activeCurrentSalesPrice = (  
       SELECT [Price]  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'SALES'  
       );  
     SET @activeCurrentInventoryQty = ISNULL(@activePrevMonthInventoryQty, 0) + ISNULL(@activeCurrentMonthPurchaseQty, 0) + ISNULL(@activeCurrentMonthMpoQty, 0) - ISNULL(@activeCurrentSalesQty, 0);  
  
     SET @activeCurrentInventoryPrice = ISNULL(@activePrevMonthInventoryPrice, 0) + ISNULL(@activeCurrentMonthPurchasePrice, 0) + ISNULL(@activeCurrentMonthMpoPrice, 0) - ISNULL(@activeCurrentSalesPrice, 0);  
  
     IF EXISTS (  
       SELECT TOP 1 1  
       FROM @tvpPricePlannings  
       WHERE AccountCode = @activeAccountCode  
        AND MaterialCode = @activeMaterialCode  
        AND MonthYear = @activeMonthYear  
        AND [ModeofType] = 'INVENTORY'  
       )  
     BEGIN  
      --PRINT '@update INVENTORY';        
      UPDATE @tvpPricePlannings  
      SET [Quantity] = @activeCurrentInventoryQty 
	  ,Price=@activeCurrentInventoryPrice 
      WHERE AccountCode = @activeAccountCode  
       AND MaterialCode = @activeMaterialCode  
       AND MonthYear = @activeMonthYear  
       AND [ModeofType] = 'INVENTORY';  
     END  
     ELSE  
     BEGIN  
      --PRINT '@insert INVENTORY';        
      INSERT INTO @tvpPricePlannings (  
       [AccountCode]  
       ,[MonthYear]  
       ,[MaterialCode]  
       ,[ModeofType]  
       ,[Type]  
       ,[Quantity] 
	   ,Price
       )  
      SELECT @activeAccountCode  
       ,@activeMonthYear  
       ,@activeMaterialCode  
       ,'INVENTORY'  
       ,NULL  
       ,@activeCurrentInventoryQty  
	   ,@activeCurrentInventoryPrice;  
     END  
    END  
  
    --PRINT '@monthIndex';        
    --PRINT @monthIndex;        
    SET @monthIndex = @monthIndex + 1;  
    --PRINT @monthIndex;        
    SET @activeMonthYear = (  
      SELECT CAST(FORMAT(DATEADD(month, 1, @activeMonth), 'yyyyMM') AS INT)  
      );  
     --PRINT '@activeMonthYear';        
     --PRINT @activeMonthYear;        
     --END        
     --SET @materialIndex = @materialIndex + 1;        
   END  
  
   SET @accountMaterialIndex = @accountMaterialIndex + 1;  
  END  
  
  --INSERT OR UPDATE        
  --PRINT 'MERGE STATEMENT';        
  --SELECT * FROM @tvpPricePlannings;        
  MERGE [dbo].[TRNPricePlanning] AS Target  
  USING @tvpPricePlannings AS Source  
   ON Source.[AccountCode] = Target.[AccountCode]  
    AND Source.[MonthYear] = Target.[MonthYear]  
    AND Source.[MaterialCode] = Target.[MaterialCode]  
    AND Source.[ModeofType] = Target.[ModeofType]  
    -- For Insert        
  WHEN NOT MATCHED BY Target  
   THEN  
    INSERT (  
     [AccountCode]  
     ,[MonthYear]  
     ,[MaterialCode]  
     ,[ModeofType]  
     ,[Type]  
     ,[Quantity]  
     ,[CreatedDate]  
     ,[CreatedBy]  
     ,[UpdatedDate]  
     ,[UpdatedBy] 
	 ,Price
     )  
    VALUES (  
     Source.[AccountCode]  
     ,Source.[MonthYear]  
     ,Source.[MaterialCode]  
     ,Source.[ModeofType]  
     ,Source.[Type]  
     ,Source.[Quantity]  
     ,GETDATE()  
     ,@userId  
     ,GETDATE()  
     ,@userId 
	 ,Source.[Price] 
     )  
     -- For Updates        
  WHEN MATCHED  
   THEN  
    UPDATE  
    SET Target.[Quantity] = Source.[Quantity] 
	 ,Target.[Price] = Source.[Price] 
     ,Target.[UpdatedDate] = GETDATE()  
     ,Target.[UpdatedBy] = @userId;  
  
  COMMIT;  
 END TRY  
  
 BEGIN CATCH  
  ROLLBACK;  
 END CATCH  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_COGSearch]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[SP_COGSearch] @CountryId VARCHAR(max) = NULL
	,@CustomerId VARCHAR(max) = NULL
	,@ProductCategoryId1 VARCHAR(max) = NULL
	,@ProductCategoryId2 VARCHAR(max) = NULL
	,@SalesTypeId INT NULL
	,@SalesSubType VARCHAR(20) NULL
AS
BEGIN
	SELECT c.CustomerId
		,c.CountryId
		,c.CustomerCode + '-' + c.CustomerName AS CustomerName
		,e.MaterialCode
		,p.MonthYear
		,cast(p.Price AS VARCHAR(100)) Price
		,cast(p.Qty AS VARCHAR(10)) Qty
		,ChargeType
		,SaleSubType
		,s.SaleTypeName
	FROM COGEntry e
	INNER JOIN SaleType S ON e.SaleTypeId = s.SaleTypeId
	INNER JOIN COGEntryQtyPrice p ON e.COGEntryId = p.COGEntryId
	LEFT JOIN Customer c ON e.CustomerCode = c.CustomerCode
	LEFT JOIN Material m ON e.MaterialCode = m.MaterialCode
	WHERE (
			@CountryId IS NULL
			OR @CountryId = 'NULL'
			OR CountryId IN (
				SELECT value
				FROM STRING_SPLIT(@CountryId, ',')
				)
			)
		AND (
			@CustomerId IS NULL
			OR @CustomerId = 'NULL'
			OR c.CustomerId IN (
				SELECT value
				FROM STRING_SPLIT(@CustomerId, ',')
				)
			)
		AND (
			@ProductCategoryId1 IS NULL
			OR @ProductCategoryId1 = 'NULL'
			OR ProductCategoryId1 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId1, ',')
				)
			)
		AND (
			@ProductCategoryId2 IS NULL
			OR @ProductCategoryId2 = 'NULL'
			OR ProductCategoryId2 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId2, ',')
				)
			)
		AND (
			@SalesTypeId IS NULL
			OR e.SaleTypeId = @SalesTypeId
			)
		AND (
			@SalesSubType IS NULL
			OR @SalesSubType = 'NULL'
			OR SaleSubType = @SalesSubType
			)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ConsolidateReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ConsolidateReport] (
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@Mg VARCHAR(20)
	,@MG1 VARCHAR(20)
	,@SalesSubType VARCHAR(30)
	,@ColumnType VARCHAR(50)
	,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY
	)
AS
BEGIN
	DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_CONSOLIDATE_LIST];

	--Last Month    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyLM'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LM_QTY
			,LM_AMT
			,LMFrt_AMT
			,LMCst_AMT
			,LMFob_AMT
			,LMCog_AMT
			,LMGp_AMT
			,LMGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_LM_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyLM'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPLM'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LM_QTY
			,LM_AMT
			,LMFrt_AMT
			,LMCst_AMT
			,LMFob_AMT
			,LMCog_AMT
			,LMGp_AMT
			,LMGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_LY_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPLM'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	--Last Year    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyLY'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LY_QTY
			,LY_AMT
			,LYFrt_AMT
			,LYCst_AMT
			,LYFob_AMT
			,LYCog_AMT
			,LYGp_AMT
			,LYGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_LY_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyLY'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPLY'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LY_QTY
			,LY_AMT
			,LYFrt_AMT
			,LYCst_AMT
			,LYFob_AMT
			,LYCog_AMT
			,LYGp_AMT
			,LYGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_LY_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPLY'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	--BPBP    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPBP'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,BP_QTY
			,BP_AMT
			,BPFrt_AMT
			,BPCst_AMT
			,BPFob_AMT
			,BPCog_AMT
			,BPGp_AMT
			,BPGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_LY_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPBP'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyBP'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,BP_QTY
			,BP_AMT
			,BPFrt_AMT
			,BPCst_AMT
			,BPFob_AMT
			,BPCog_AMT
			,BPGp_AMT
			,BPGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_CM_BP_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyBP'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'CM'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,Qty
			,Amount
			,Frt_AMT
			,Cst_AMT
			,Fob_AMT
			,Cog_AMT
			,Gp_AMT
			,Gp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_CM_BP_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'CM'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END
	ELSE IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BP'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,Qty
			,Amount
			,Frt_AMT
			,Cst_AMT
			,Fob_AMT
			,Cog_AMT
			,Gp_AMT
			,Gp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_Percentage
		FROM VW_CM_BP_ConsolidatedReport c
		INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BP'
			AND CustomerCode IN (
				SELECT [CustomerCode]
				FROM @TVP_CUSTOMERCODE_LIST
				)
			AND ProductCategoryCode1 = @Mg
			AND ProductCategoryCode2 = @MG1
			AND c.SaleSubType = @SalesSubType
	END

	SELECT *
	FROM @TVPCONSOLIDATELIST;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DashMasterMonthly]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Exec [dbo].[SP_DashMasterMonthly] null,null,null,null,0
CREATE PROCEDURE [dbo].[SP_DashMasterMonthly]
	-- Add the parameters for the stored procedure here
	@MaterialCode VARCHAR(25) = NULL
	,@SalesCompanyCode VARCHAR(25) = NULL
	,@SupplierCode VARCHAR(25) = NULL
	,@CustomerName VARCHAR(200) = NULL
	,@Status BIT = NULL
	,@TotalCount INT = 1000
AS
BEGIN
	SET NOCOUNT ON;

	IF @Status IS NOT NULL
		AND (
			@MaterialCode IS NULL
			OR @SalesCompanyCode IS NULL
			OR @SupplierCode IS NULL
			OR @CustomerName IS NULL
			)
	BEGIN
		SELECT TOP (@TotalCount) MaterialCode
			,CustomerCode
			,SalesCompany
			,SupplierCode
			,ReasonId
			,ReasonName
			,TransPortMode
			,DM.CustomerName
			,DM.IsActive
			,CONCAT (
				A.strYear
				,A.StrMonth
				) AS Months
			,DM.CreatedBy
			,DM.CreatedDate
			,DM.UpdatedBy
			,DM.UpdatedDate
		FROM VW_DASHMASTER AS DM
		CROSS APPLY dbo.UDF_DashMonths(DM.StartMonth, EndMonth, DashMaterialId) A
		WHERE DM.IsActive = COALESCE(@Status, DM.IsActive)
	END
	ELSE IF @MaterialCode IS NOT NULL
		OR @SalesCompanyCode IS NOT NULL
		OR @SupplierCode IS NOT NULL
		OR @CustomerName IS NOT NULL
	BEGIN
		SELECT MaterialCode
			,CustomerCode
			,SalesCompany
			,SupplierCode
			,ReasonId
			,ReasonName
			,TransPortMode
			,DM.CustomerName
			,DM.IsActive
			,CONCAT (
				A.strYear
				,A.StrMonth
				) AS Months
			,DM.CreatedBy
			,DM.CreatedDate
			,DM.UpdatedBy
			,DM.UpdatedDate
		FROM VW_DASHMASTER AS DM
		CROSS APPLY dbo.UDF_DashMonths(DM.StartMonth, EndMonth, DashMaterialId) a
		WHERE DM.MaterialCode = COALESCE(@MaterialCode, DM.MaterialCode)
			AND DM.SalesCompany = COALESCE(@SalesCompanyCode, DM.SalesCompany)
			AND DM.SupplierCode = COALESCE(@SupplierCode, DM.SupplierCode)
			AND DM.CustomerName LIKE '%' + COALESCE(@CustomerName, DM.CustomerName) + '%'
			AND DM.IsActive = COALESCE(@Status, DM.IsActive)
	END
	ELSE
	BEGIN
		SELECT TOP (@TotalCount) MaterialCode
			,CustomerCode
			,SalesCompany
			,SupplierCode
			,ReasonId
			,ReasonName
			,TransPortMode
			,DM.CustomerName
			,DM.IsActive
			,CONCAT (
				A.strYear
				,A.StrMonth
				) AS Months
			,DM.CreatedBy
			,DM.CreatedDate
			,DM.UpdatedBy
			,DM.UpdatedDate
		FROM VW_DASHMASTER AS DM
		CROSS APPLY dbo.UDF_DashMonths(DM.StartMonth, EndMonth, DashMaterialId) A
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Direct_SNS_Archive]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec Sp_ArchiveDirectSale                                
CREATE PROCEDURE [dbo].[Sp_Direct_SNS_Archive] (
	@CurrentMonth CHAR(6) = NULL
	,@CreatedBy NVARCHAR(max) = NULL
	,@Global_Current_Month CHAR(6) = NULL
	,@Lock_Month CHAR(6) = NULL
	,@SalesType NVARCHAR(50) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @error TABLE (
		error NVARCHAR(max)
		,Id VARCHAR(max)
		,SaleType VARCHAR(50)
		);
	--Direct Sale                      
	DECLARE @SaleEntryHeaderIds TABLE (Id INT);
	DECLARE @SalesEntryIds TABLE (Id INT);
	DECLARE @SalesArchivalEntryId TABLE (Id INT);
	DECLARE @DirectSaleIds VARCHAR(max);
	--SNS                      
	DECLARE @SNSEntryIds TABLE (Id INT);
	DECLARE @SNSIds VARCHAR(max);

	BEGIN TRY
		BEGIN TRANSACTION

		--Direct Sale start                      
		INSERT INTO @SaleEntryHeaderIds
		SELECT SaleEntryHeaderId
		FROM SaleEntryHeader
		WHERE CurrentMonthYear = @CurrentMonth;

		SELECT @DirectSaleIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')
		FROM @SaleEntryHeaderIds;

		INSERT INTO @SalesEntryIds
		SELECT SalesEntryId
		FROM SalesEntry
		WHERE SaleEntryHeaderId IN (
				SELECT id
				FROM @SaleEntryHeaderIds
				);

		--if data is exist is table then first delete and insert                           
		IF (
				SELECT count(*)
				FROM SaleEntryArchivalHeader
				WHERE SaleEntryArchivalHeaderId IN (
						SELECT id
						FROM @SaleEntryHeaderIds
						)
				) > 0
		BEGIN
			INSERT INTO @SalesArchivalEntryId
			SELECT SalesArchivalEntryId
			FROM SalesArchivalEntry
			WHERE SaleEntryArchivalHeaderId IN (
					SELECT id
					FROM @SaleEntryHeaderIds
					);

			DELETE
			FROM SalesArchivalEntryPriceQuantity
			WHERE SalesArchivalEntryId IN (
					SELECT id
					FROM @SalesArchivalEntryId
					);

			DELETE
			FROM SalesArchivalEntry
			WHERE SaleEntryArchivalHeaderId IN (
					SELECT id
					FROM @SaleEntryHeaderIds
					);

			DELETE
			FROM SaleEntryArchivalHeader
			WHERE SaleEntryArchivalHeaderId IN (
					SELECT id
					FROM @SaleEntryHeaderIds
					);
		END

		INSERT INTO dbo.[SaleEntryArchivalHeader] (
			SaleEntryArchivalHeaderId
			,ArchivalMonthYear
			,ArchiveBy
			,ArchiveDate
			,ArchiveStatus
			,[CustomerId]
			,[SaleTypeId]
			,[ProductCategoryId1]
			,[ProductCategoryId2]
			,[CurrentMonthYear]
			,[LockMonthYear]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdateDate]
			,[UpdateBy]
			,[AttachmentId]
			,[SaleSubType]
			)
		SELECT SaleEntryHeaderId
			,@CurrentMonth
			,@CreatedBy
			,GETDATE()
			,'Archived'
			,[CustomerId]
			,[SaleTypeId]
			,[ProductCategoryId1]
			,[ProductCategoryId2]
			,[CurrentMonthYear]
			,[LockMonthYear]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdateDate]
			,[UpdateBy]
			,[AttachmentId]
			,[SaleSubType]
		FROM dbo.SaleEntryHeader
		WHERE SaleEntryHeaderId IN (
				SELECT id
				FROM @SaleEntryHeaderIds
				);

		INSERT INTO dbo.[SalesArchivalEntry] (
			SalesArchivalEntryId
			,SaleEntryArchivalHeaderId
			,ArchiveDate
			,[MaterialId]
			,[ProductCategoryCode1]
			,[ProductCategoryCode2]
			,[ProductCategoryCode3]
			,[ProductCategoryCode4]
			,[ProductCategoryCode5]
			,[ProductCategoryCode6]
			,[OCmonthYear]
			,[OCstatus]
			,[FileInfoId]
			,[O_LockMonthConfirmedStatus]
			,[O_LockMonthConfirmedBy]
			,[O_LockMonthConfirmedDate]
			,[ModeOfTypeId]
			)
		SELECT DISTINCT SalesEntryId
			,SaleEntryHeaderId
			,GETDATE()
			,[MaterialId]
			,[ProductCategoryCode1]
			,[ProductCategoryCode2]
			,[ProductCategoryCode3]
			,[ProductCategoryCode4]
			,[ProductCategoryCode5]
			,[ProductCategoryCode6]
			,[OCmonthYear]
			,[OCstatus]
			,[FileInfoId]
			,[O_LockMonthConfirmedStatus]
			,[O_LockMonthConfirmedBy]
			,[O_LockMonthConfirmedDate]
			,[ModeOfTypeId]
		FROM SalesEntry
		WHERE SaleEntryHeaderId IN (
				SELECT id
				FROM @SaleEntryHeaderIds
				);

		INSERT INTO [dbo].[SalesArchivalEntryPriceQuantity] (
			[SalesArchivalEntryPriceQuantityId]
			,[SalesArchivalEntryId]
			,ArchiveDate
			,[MonthYear]
			,[Price]
			,[Quantity]
			,[OrderIndicationConfirmedBySaleTeam]
			,[OrderIndicationConfirmedBySaleTeamDate]
			,[OrderIndicationConfirmedByMarketingTeam]
			,[OrderIndicationConfirmedByMarketingTeamDate]
			,[O_LockMonthConfirmedBy]
			,[O_LockMonthConfirmedDate]
			,[Reason]
			,[IsSNS]
			,[IsPO]
			,[TermId]
			,[Remarks]
			,[CurrencyCode]
			,[OcIndicationMonthAttachmentIds]
			,[OcIndicationMonthStatus]
			,[OCstatus]
			)
		SELECT [SalesEntryPriceQuantityId]
			,[SalesEntryId]
			,getdate()
			,[MonthYear]
			,[Price]
			,[Quantity]
			,[OrderIndicationConfirmedBySaleTeam]
			,[OrderIndicationConfirmedBySaleTeamDate]
			,[OrderIndicationConfirmedByMarketingTeam]
			,[OrderIndicationConfirmedByMarketingTeamDate]
			,[O_LockMonthConfirmedBy]
			,[O_LockMonthConfirmedDate]
			,[Reason]
			,[IsSNS]
			,[IsPO]
			,[TermId]
			,[Remarks]
			,[CurrencyCode]
			,[OcIndicationMonthAttachmentIds]
			,[OcIndicationMonthStatus]
			,[OCstatus]
		FROM SalesEntryPriceQuantity
		WHERE SalesEntryId IN (
				SELECT id
				FROM @SalesEntryIds
				);

		--DELETE FROM SalesEntryPriceQuantity                              
		--where SalesEntryId in                              
		--(select id FROM @SalesEntryIds);                              
		--DELETE FROM SalesEntry                              
		--where SaleEntryHeaderId in                               
		--(select id FROM @SaleEntryHeaderIds);                              
		--DELETE FROM SaleEntryHeader                              
		--where SaleEntryHeaderId in                              
		--(select id FROM @SaleEntryHeaderIds);                          
		--Direct Sale end                      
		--SNS Start                      
		INSERT INTO @SNSEntryIds
		SELECT SNSEntryId
		FROM SNSEntry
		WHERE MonthYear = @CurrentMonth
			AND SaleSubType = @SalesType;

		IF (
				SELECT count(*)
				FROM SNSEntryArchive
				WHERE SNSEntryId IN (
						SELECT id
						FROM @SalesEntryIds
						)
				) > 0
		BEGIN
			DELETE
			FROM SNSEntryQtyPriceArchive
			WHERE SNSEntryId IN (
					SELECT id
					FROM @SNSEntryIds
					);

			DELETE
			FROM SNSEntryArchive
			WHERE SNSEntryId IN (
					SELECT id
					FROM @SNSEntryIds
					);
		END

		INSERT INTO [dbo].[SNSEntryArchive] (
			[SNSEntryID]
			,[SaleTypeId]
			,[CustomerId]
			,[CustomerCode]
			,[MaterialId]
			,[MaterialCode]
			,[CategoryId]
			,Category
			,[AttachmentId]
			,[MonthYear]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,[ModeofTypeId]
			,ArchiveDate
			,ArchiveBy
			,ArchiveStatus
			,OACCode
			,SaleSubType
			,ArchivalMonthYear
			)
		SELECT [SNSEntryID]
			,[SaleTypeId]
			,[CustomerId]
			,[CustomerCode]
			,[MaterialId]
			,[MaterialCode]
			,[CategoryId]
			,Category
			,[AttachmentId]
			,[MonthYear]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,[ModeofTypeId]
			,GETDATE()
			,@CreatedBy
			,'Archived'
			,OACCode
			,SaleSubType
			,@CurrentMonth
		FROM SNSEntry
		WHERE SNSEntryId IN (
				SELECT id
				FROM @SNSEntryIds
				);

		INSERT INTO [dbo].[SNSEntryQtyPriceArchive] (
			[SNSEntryQtyPriceId]
			,[SNSEntryId]
			,[MonthYear]
			,[Qty]
			,[Price]
			,[TotalAmount]
			,[Currency]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,ArchiveDate
			,ArchiveBy
			,ArchiveStatus
			)
		SELECT [SNSEntryQtyPriceId]
			,[SNSEntryId]
			,[MonthYear]
			,[Qty]
			,[Price]
			,[TotalAmount]
			,[Currency]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,GETDATE()
			,@CreatedBy
			,'Archived'
		FROM SNSEntryQtyPrice
		WHERE SNSEntryId IN (
				SELECT id
				FROM @SNSEntryIds
				);

		--DELETE FROM SNSEntryQtyPrice                          
		--where SNSEntryId in                          
		--(select id FROM @SNSEntryIds);                          
		--DELETE FROM SNSEntry                         
		--where SNSEntryId in                           
		--(select id FROM @SNSEntryIds);                       
		SELECT @SNSIds = STRING_AGG(CONVERT(VARCHAR(10), Id), ',')
		FROM @SNSEntryIds;

		--SNS end                      
		IF (@SalesType = 'Monthly')
		BEGIN
			UPDATE GlobalConfig
			SET ConfigValue = @Global_Current_Month
			WHERE ConfigKey = 'Current_Month'
				AND ConfigType = 'Direct And SNS';

			UPDATE GlobalConfig
			SET ConfigValue = @CurrentMonth
			WHERE ConfigKey = 'Result_Month'
				AND ConfigType = 'Direct And SNS';

			UPDATE GlobalConfig
			SET ConfigValue = @Lock_Month
			WHERE ConfigKey = 'Lock_Month'
				AND ConfigType = 'Direct And SNS';
		END
		ELSE
		BEGIN
			UPDATE GlobalConfig
			SET ConfigValue = ConfigValue + 1
			WHERE ConfigKey = 'BP_Year';
		END

		COMMIT;
	END TRY

	BEGIN CATCH
		ROLLBACK;

		INSERT INTO @error (
			error
			,id
			)
		VALUES (
			ERROR_MESSAGE()
			,@SNSIds
			);
	END CATCH;

	IF (
			SELECT count(*)
			FROM @error
			) = 0
	BEGIN
		INSERT INTO @error (
			id
			,error
			,SaleType
			)
		VALUES (
			@DirectSaleIds
			,NULL
			,'Direct'
			);

		INSERT INTO @error (
			id
			,error
			,SaleType
			)
		VALUES (
			@SNSIds
			,NULL
			,'SNS'
			);

		SELECT *
		FROM @error
	END
	ELSE
	BEGIN
		SELECT *
		FROM @error
	END
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_Customer_Country_Currency]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Get_Customer_Country_Currency] (@customerId INT)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT CS.CustomerId
		,CS.CustomerCode
		,CN.CountryId
		,CN.CountryCode
		,CN.CurrencyId
		,CR.CurrencyCode
		,CR.ExchangeRate
	FROM Customer CS
	INNER JOIN Country CN ON CS.CountryId = CN.CountryId
	LEFT JOIN Currency CR ON CN.CurrencyId = CR.CurrencyId
	WHERE CS.CustomerId = @customerId
		AND CS.IsActive = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Get_CustomerWiseSaleQtyPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
              
              
-- =============================================                
-- Author:      <Author, , Name>                
-- Create Date: <Create Date, , >                
-- Description: <Description, , >                
-- =============================================                
CREATE PROCEDURE [dbo].[SP_Get_CustomerWiseSaleQtyPrice]                
(                
@accountCode nvarchar(100),              
@currentMonth int,            
@lockMonth int,            
@resultMonth int,            
@lastForecastMonth int,            
@tvpCustomerCodeList [dbo].[TVP_CODE_LIST] READONLY,              
@tvpMaterialCodeList [dbo].[TVP_CODE_LIST] READONLY              
)                
AS                
BEGIN                
    -- SET NOCOUNT ON added to prevent extra result sets from                
    -- interfering with SELEaCT statements.                
    SET NOCOUNT ON                
              
 --DECLARE @resultMonth int, @currentMonth int, @lockMonth int, @lastForecastMonth int;             
             
 --SET @currentMonth = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));              
 --SET @resultMonth = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));              
 --SET @lockMonth = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));              
 --SET @lastForecastMonth = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));              
              
 SELECT NULL  AS SNSEntryId              
  ,NULL  AS SNSEntryQtyPriceId              
   ,[MonthYear]              
    ,[CustomerCode]              
    ,[MaterialCode]              
    ,[Quantity]              
    ,[Amount]              
    ,[AccountCode]              
    FROM [dbo].[TRNSalesPlanning]              
    where [AccountCode]=@accountCode AND     
 [MonthYear] = @resultMonth      
    and [CustomerCode] in (select Code from @tvpCustomerCodeList)              
    and [MaterialCode] in (select Code from @tvpMaterialCodeList)              
              
 UNION               
 SELECT SE.SNSEntryId,               
 SQ.SNSEntryQtyPriceId,               
 SQ.MonthYear,               
 SE.CustomerCode,               
 SE.MaterialCode,              
 SQ.Qty AS Quantity,               
 SQ.Price AS Amount,               
 SE.OACCode AS [AccountCode] FROM [dbo].[SNSEntry] SE              
 INNER JOIN [dbo].[SNSEntryQtyPrice] SQ              
 ON SE.SNSEntryId = SQ.SNSEntryId              
 where SE.OACCode=@accountCode          
-- AND SE.MonthYear >= @currentMonth AND SE.MonthYear <= @lastForecastMonth              
 --AND SE.MonthYear = @currentMonth        
 AND SQ.MonthYear >= @currentMonth AND SQ.MonthYear <= @lastForecastMonth              
 and SE.[CustomerCode] in (select Code from @tvpCustomerCodeList)              
 and SE.[MaterialCode] in (select Code from @tvpMaterialCodeList);              
                   
END 
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_Direct_SNS_Archive]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec Sp_Get_Direct_SNS_Archive '202305','34,36' ,'63'   
CREATE PROC [dbo].[Sp_Get_Direct_SNS_Archive] (
	@month CHAR(6) = NULL
	,@DirectSaleIds NVARCHAR(max) = NULL
	,@SNSIds NVARCHAR(max) = NULL
	)
AS
BEGIN
	--Direct sale start  
	WITH CTE_Direct_tbl
	AS (
		SELECT m.MaterialCode
			,h.CurrentMonthYear
			,'' OAC
			,(
				CASE 
					WHEN se.ModeOfTypeId = 1
						THEN sum(q.Quantity)
					END
				) AS OrderQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 2
						THEN sum(q.Quantity)
					END
				) AS PurchaseQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 4
						THEN sum(q.Quantity)
					END
				) AS InventoryQty
			,ROW_NUMBER() OVER (
				PARTITION BY m.MaterialCode
				,h.CurrentMonthYear ORDER BY m.MaterialCode
				) AS rownumber
		FROM SaleEntryArchivalHeader h
		INNER JOIN SalesArchivalEntry se ON h.SaleEntryArchivalHeaderId = se.SaleEntryArchivalHeaderId
		INNER JOIN SalesArchivalEntryPriceQuantity q ON se.SalesArchivalEntryId = q.SalesArchivalEntryId
		LEFT JOIN Material m ON se.MaterialId = m.MaterialId
		WHERE h.SaleTypeId = 1
			AND se.ModeOfTypeId IN (
				1
				,2
				,4
				)
			AND h.CurrentMonthYear = @month
			AND h.ArchiveStatus = 'Archive Data'
			AND h.SaleEntryArchivalHeaderId IN (
				SELECT value
				FROM STRING_SPLIT(@DirectSaleIds, ',')
				)
		GROUP BY m.MaterialCode
			,h.CurrentMonthYear
			,se.ModeOfTypeId
		)
		,
		--Direct Sale End  
		--SNS Start  
	CTE_SNS_tbl
	AS (
		SELECT m.MaterialCode
			,se.MonthYear
			,se.OACCode AS OAC
			,(
				CASE 
					WHEN se.ModeOfTypeId = 1
						THEN sum(q.Qty)
					END
				) AS OrderQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 2
						THEN sum(q.Qty)
					END
				) AS PurchaseQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 4
						THEN sum(q.Qty)
					END
				) AS InventoryQty
			,ROW_NUMBER() OVER (
				PARTITION BY m.MaterialCode
				,se.MonthYear ORDER BY m.MaterialCode
				) AS rownumber
		FROM SNSEntryArchive se
		INNER JOIN SNSEntryQtyPriceArchive q ON se.SNSEntryId = q.SNSEntryId
		LEFT JOIN Material m ON se.MaterialId = m.MaterialId
		WHERE se.SaleTypeId = 2
			AND se.ModeOfTypeId IN (
				1
				,2
				,3
				,4
				)
			AND se.MonthYear = @month
			AND se.ArchiveStatus = 'Archive Data'
			AND se.SNSEntryId IN (
				SELECT value
				FROM STRING_SPLIT(@SNSIds, ',')
				)
		GROUP BY m.MaterialCode
			,se.MonthYear
			,se.ModeOfTypeId
			,se.OACCode
		)
	SELECT MaterialCode
		,CurrentMonthYear
		,OAC
		,sum(OrderQty) AS OrderQty
		,Sum(PurchaseQty) AS PurchaseQty
		,sum(InventoryQty) AS InventoryQty
	FROM (
		SELECT *
		FROM CTE_Direct_tbl 
		) AS a
	GROUP BY MaterialCode
		,CurrentMonthYear
		,OAC
	
	UNION ALL
	
	SELECT MaterialCode
		,CAST(MonthYear AS CHAR) AS CurrentMonthYear
		,OAC
		,sum(OrderQty) AS OrderQty
		,Sum(PurchaseQty) AS PurchaseQty
		,sum(InventoryQty) AS InventoryQty
	FROM (
		SELECT *
		FROM CTE_SNS_tbl 
		) AS a
	GROUP BY MaterialCode
		,MonthYear
		,OAC
		--SNS End  
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_Get_DirectSale_Archive]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec Sp_Get_DirectSale_Archive '202305'
CREATE PROC [dbo].[Sp_Get_DirectSale_Archive] (
	@month CHAR(6) = NULL
	,@SaleEntryArchivalHeaderIds NVARCHAR(max) = NULL
	)
AS
BEGIN
		;

	WITH CTE_tbl
	AS (
		SELECT m.MaterialCode
			,h.CurrentMonthYear
			,'' OAC
			,(
				CASE 
					WHEN se.ModeOfTypeId = 1
						THEN sum(q.Quantity)
					END
				) AS OrderQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 2
						THEN sum(q.Quantity)
					END
				) AS PurchaseQty
			,(
				CASE 
					WHEN se.ModeOfTypeId = 4
						THEN sum(q.Quantity)
					END
				) AS InventoryQty
			,ROW_NUMBER() OVER (
				PARTITION BY m.MaterialCode
				,h.CurrentMonthYear ORDER BY m.MaterialCode
				) AS rownumber
		FROM SaleEntryArchivalHeader h
		INNER JOIN SalesArchivalEntry se ON h.SaleEntryArchivalHeaderId = se.SaleEntryArchivalHeaderId
		INNER JOIN SalesArchivalEntryPriceQuantity q ON se.SalesArchivalEntryId = q.SalesArchivalEntryId
		LEFT JOIN Material m ON se.MaterialId = m.MaterialId
		WHERE h.SaleTypeId = 1
			AND se.ModeOfTypeId IN (
				1
				,2
				,4
				)
			AND h.CurrentMonthYear = @month
			AND h.ArchiveStatus = 'Y'
			AND h.SaleEntryArchivalHeaderId IN (
				SELECT value
				FROM STRING_SPLIT(@SaleEntryArchivalHeaderIds, ',')
				)
		GROUP BY m.MaterialCode
			,h.CurrentMonthYear
			,se.ModeOfTypeId
		)
	SELECT MaterialCode
		,CurrentMonthYear
		,OAC
		,sum(OrderQty) AS OrderQty
		,Sum(PurchaseQty) AS PurchaseQty
		,sum(InventoryQty) AS InventoryQty
	FROM (
		SELECT *
		FROM CTE_tbl 
		) AS a
	GROUP BY MaterialCode
		,CurrentMonthYear
		,OAC
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INS_RESULTPURCHASE]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_INS_RESULT_PURCHASE '122'
CREATE PROC [dbo].[SP_INS_RESULTPURCHASE] @UserId NVARCHAR(100)
AS
BEGIN
	DECLARE @CurrentMonth INT
		,@ResultMonth INT
		,@PreResultMonth INT

	SELECT @CurrentMonth = ConfigValue
	FROM GlobalConfig
	WHERE ConfigKey = 'Current_Month'

	SELECT @ResultMonth = ConfigValue
	FROM GlobalConfig
	WHERE ConfigKey = 'Result_Month'

	DECLARE @dtCurrentMonth DATETIME = CONVERT(DATETIME, CAST(@CurrentMonth AS VARCHAR(6)) + '01', 112);

	--n-2
	SET @PreResultMonth = (
			SELECT CAST(FORMAT(DATEADD(month, - 2, @dtCurrentMonth), 'yyyyMM') AS INT)
			);

	--print @PreResultMonth
	SELECT SUM(Quantity) AS AccountQty
		,A.MaterialCode
		,C.AccountCode
		,A.MonthYear
	INTO #TempSaleAccounWise
	FROM MST_ResultSales A
	JOIN CustomerView C ON A.CustomerCode = C.CustomerCode
		AND C.AccountCode IS NOT NULL
	WHERE A.MonthYear = @ResultMonth
	GROUP BY A.MaterialCode
		,C.AccountCode
		,A.MonthYear

	-- delete existing record
	DELETE
	FROM MST_ResultPurchase
	WHERE MonthYear = @ResultMonth

	INSERT INTO MST_ResultPurchase (
		MonthYear
		,MaterialCode
		,AccountCode
		,Quantity
		,CreatedDate
		,CreatedBy
		,ATP_CASE
		)
	SELECT @ResultMonth
		,RI.MaterialCode
		,RI.AccountCode
		,(RI.Quantity + RS.AccountQty) - ISNULL(N2I.Quantity, 0) AS Quantity
		,GETDATE()
		,@UserId
		,33 -- can be ignored this since no use for this
	FROM Mst_ResultInventory RI
	LEFT JOIN #TempSaleAccounWise RS ON RI.MaterialCode = RS.MaterialCode
		AND RI.AccountCode = RS.AccountCode
		AND RI.MonthYear = RS.MonthYear
	LEFT JOIN Mst_ResultInventory N2I ON RI.MaterialCode = N2I.MaterialCode
		AND RI.AccountCode = N2I.AccountCode
		AND N2I.MonthYear = @PreResultMonth
	WHERE RI.MonthYear = @ResultMonth

	SELECT *
	FROM MST_ResultPurchase
	WHERE MonthYear = @ResultMonth

	DROP TABLE #TempSaleAccounWise
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Sales_Entries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Insert_Sales_Entries] (  
 @customerId INT  
 ,@productCategoryId INT  
 ,@productSubCategoryId INT  
 ,@tvpSalesEntries dbo.TVP_SALES_ENTRY_ROWS READONLY  
 ,@tvpSalesQuantities dbo.TVP_SALES_ENTRY_QUANTITIES READONLY  
 ,@tvpSalesPrices dbo.TVP_SALES_ENTRY_PRICES READONLY  
 ,@userId NVARCHAR(100)  
 ,@attachmentId INT  
 ,@saleSubType VARCHAR(50)  
 ,@isValid BIT  
 )  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;  
 DECLARE @currentMonthYear CHAR(6)  
  ,@nextMonthYear CHAR(6);  
 DECLARE @CustomerCode NVARCHAR(100);  
  
 SET @CustomerCode = (  
   SELECT CustomerCode  
   FROM Customer  
   WHERE CustomerId = @customerId  
   );  
  
 --SET @currentmonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())), 2);          
 --SET @currentYear = CONVERT(VARCHAR(4),YEAR(getdate()));          
 --SET @currentMonthYear = @currentYear+@currentmonth;         
 IF (@SaleSubType = 'Monthly')  
 BEGIN  
  SET @currentMonthYear = (  
    SELECT ConfigValue  
    FROM GlobalConfig  
    WHERE ConfigKey = 'Current_Month'  
     AND ConfigType = 'Direct And SNS'  
    )  
  
  DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, @currentMonthYear + '01', 112);  
  
  SET @nextMonthYear = (  
    SELECT FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM')  
    );  
 END  
 ELSE  
 BEGIN  
  SET @currentMonthYear = (  
    SELECT ConfigValue  
    FROM GlobalConfig  
    WHERE ConfigKey = 'BP_Year'  
    )  
 END  
  
 --select @currentMonthYear =           
 --ConfigValue from [dbo].[GlobalConfig] where ConfigKey='Current_Month' and ConfigType='Direct And SNS';          
 --SET @nextMonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())+1), 2);          
 --SET @nextYear = CONVERT(VARCHAR(4),YEAR(getdate())+1);          
 --SET @nextMonthYear = @currentYear+@nextMonth;          
 --IF(@currentmonth = '12')  SET @nextMonthYear =@nextYear+'01';          
 SET NOCOUNT ON;  
  
 BEGIN TRY  
  BEGIN TRANSACTION;  
  
  --SET @responseMessage = '';          
  DECLARE @ResultCount INT = 0  
   ,@SalesEntryCount INT = 0;  
  DECLARE @CustomerWithCurrency AS [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY];  
  
  INSERT INTO @CustomerWithCurrency  
  EXEC [dbo].[SP_Get_Customer_Country_Currency] @customerId;  
  
  DECLARE @LocalCurrencyCode NVARCHAR(10);  
  
  SET @LocalCurrencyCode = (  
    SELECT TOP 1 CurrencyCode  
    FROM @CustomerWithCurrency  
    );  
  
  DECLARE @SalesQtyPrices AS dbo.TVP_SALES_ENTRY_QTY_PRICES;  
  DECLARE @TempSaleEntryHeader AS dbo.TVP_SALES_ENTRY_HEADERS;  
  
  INSERT INTO @TempSaleEntryHeader  
  SELECT ROW_NUMBER() OVER (  
    ORDER BY tvp.RowIndex ASC  
    ) AS RowNo  
   ,tvp.RowIndex  
   ,tvp.UploadFlag  
   ,tvp.Class1  
   ,tvp.Class2  
   ,tvp.Class3  
   ,tvp.Class4  
   ,tvp.Class5  
   ,tvp.Class6  
   ,tvp.Class7  
   ,tvp.Class8  
   ,tvp.ItemCode  
   ,material.MaterialId  
   ,tvp.ModelNumber  
   ,modeType.ModeofTypeId  
   ,tvp.TypeCode  
   ,tvp.Comments  
   ,tvp.Currency  
   ,1 --SalesTypeId          
  FROM @tvpSalesEntries AS tvp  
  LEFT JOIN dbo.ModeofType AS modeType ON tvp.TypeCode = modeType.ModeofTypeCode  
  LEFT JOIN dbo.Material AS material ON material.MaterialCode = tvp.ItemCode;  
  
  INSERT INTO @SalesQtyPrices  
  SELECT tvp_price.RowIndex  
   ,TEMP.RowNo  
   ,tvp_price.PriceMonthName  
   ,tvp_price.Price  
   ,tvp_qty.Qty  
   ,CASE   
    WHEN TEMP.TypeCode = 'P'  
     OR TEMP.TypeCode = 'S'  
     OR TEMP.TypeCode = 'I'  
     THEN @LocalCurrencyCode  
    ELSE 'USD'  
    END AS Currency  
  FROM @tvpSalesQuantities AS tvp_qty  
  INNER JOIN @tvpSalesPrices AS tvp_price ON tvp_price.RowIndex = tvp_qty.RowIndex  
   AND tvp_price.PriceMonthName = tvp_qty.QtyMonthName  
  INNER JOIN @TempSaleEntryHeader AS TEMP ON tvp_qty.RowIndex = TEMP.RowIndex;  
  
  --insert into testdata SELECT ItemCode, TypeCode FROM  @tvpSaleEntryHeader where 1=1;      
  --validation sp call          
  INSERT INTO @ResultTable  
  EXEC dbo.[SP_Validate_Sales_Entries] @customerId  
   ,@CustomerWithCurrency  
   ,@TempSaleEntryHeader  
   ,@SalesQtyPrices;  
  
  IF NOT EXISTS (  
    SELECT TOP 1 1  
    FROM @ResultTable  
    )  
   AND @isValid = 1  
  BEGIN  
   --Archive sales entries data          
   DECLARE @IsArchived VARCHAR(1) = '0';  
   DECLARE @PrevSaleEntryHeaderId VARCHAR(12) = '0';  
   DECLARE @ArchivalResultTable AS dbo.TVP_RESULT_TABLE;  
  
   INSERT INTO @ArchivalResultTable  
   EXEC dbo.[SP_Archive_Sales_Entries] @customerId  
    ,@productCategoryId  
    ,@productSubCategoryId  
    ,@saleSubType  
    ,@currentMonthYear  
    ,@nextMonthYear  
    ,@userId  
    ,@TempSaleEntryHeader  
    ,@SalesQtyPrices;  
  
   --Insert Archival Error Log into Result          
   INSERT INTO @ResultTable  
   SELECT *  
   FROM @ArchivalResultTable  
   WHERE ResponseCode != 200  
    AND ResponseCode != 201;  
  
   SET @IsArchived = (  
     SELECT TOP 1 ResponseMessage  
     FROM @ArchivalResultTable  
     WHERE ResponseCode = 200  
     );  
   SET @PrevSaleEntryHeaderId = (  
     SELECT TOP 1 ResponseMessage  
     FROM @ArchivalResultTable  
     WHERE ResponseCode = 201  
     );  
  
   DECLARE @tempPrevSalesEntryPriceQtyTable AS dbo.[TVP_SALESENTRY_PRICE_QTY_INFO];  
  
   --PRINT '@PrevSaleEntryHeaderId';          
   --PRINT @PrevSaleEntryHeaderId;          
   IF @PrevSaleEntryHeaderId IS NOT NULL  
    AND @PrevSaleEntryHeaderId != '0'  
   BEGIN  
    --PRINT @PrevSaleEntryHeaderId;          
    IF EXISTS (  
      SELECT TOP 1 1  
      FROM dbo.SaleEntryHeader  
      WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId  
      )  
    BEGIN  
     INSERT INTO @tempPrevSalesEntryPriceQtyTable  
     SELECT PQ.[SalesEntryPriceQuantityId]  
      ,PQ.[SalesEntryId]  
      ,SE.[SaleEntryHeaderId]  
      ,PQ.[MonthYear]  
      ,PQ.[Price]  
      ,PQ.[Quantity]  
      ,SE.[MaterialId]  
      ,SE.[OCmonthYear]  
      ,SE.[OCstatus]  
      ,SE.[ModeOfTypeId]  
     FROM [dbo].[SalesEntryPriceQuantity] PQ  
     INNER JOIN [dbo].[SalesEntry] SE ON PQ.SalesEntryId = SE.SalesEntryId  
     WHERE SE.SaleEntryHeaderId = @PrevSaleEntryHeaderId;  
    END  
    ELSE  
    BEGIN  
     INSERT INTO @tempPrevSalesEntryPriceQtyTable  
     SELECT PQ.[SalesArchivalEntryPriceQuantityId] AS [SalesEntryPriceQuantityId]  
      ,PQ.[SalesArchivalEntryId] AS [SalesEntryId]  
      ,SE.[SaleEntryArchivalHeaderId] AS [SaleEntryHeaderId]  
      ,PQ.[MonthYear]  
      ,PQ.[Price]  
      ,PQ.[Quantity]  
      ,SE.[MaterialId]  
      ,SE.[OCmonthYear]  
      ,SE.[OCstatus]  
      ,SE.[ModeOfTypeId]  
     FROM [dbo].[SalesArchivalEntryPriceQuantity] PQ  
     INNER JOIN [dbo].[SalesArchivalEntry] SE ON PQ.[SalesArchivalEntryId] = SE.[SalesArchivalEntryId]  
     WHERE SE.[SaleEntryArchivalHeaderId] = @PrevSaleEntryHeaderId  
    END  
   END  
  
   IF EXISTS (  
     SELECT TOP 1 1  
     FROM @ArchivalResultTable  
     WHERE ResponseCode = 200  
     )  
   BEGIN  
    BEGIN  
     DECLARE @SalesEntryHeader_LastId INT = 0;  
  
     INSERT INTO dbo.SaleEntryHeader (  
      CustomerId  
      ,CustomerCode  
      ,SaleTypeId  
      ,ProductCategoryId1  
      ,ProductCategoryId2  
      ,CurrentMonthYear  
      ,LockMonthYear  
      ,CreatedDate  
      ,CreatedBy  
      ,UpdateDate  
      ,UpdateBy  
      ,AttachmentId  
      ,SaleSubType  
      )  
     VALUES (  
      @customerId  
      ,@CustomerCode  
      ,1  
      ,@productCategoryId  
      ,@productSubCategoryId  
      ,@currentMonthYear  
      ,@nextMonthYear  
      ,GETDATE()  
      ,@userId  
      ,GETDATE()  
      ,@userId  
      ,@attachmentId  
      ,@saleSubType  
      );  
  
     SELECT @SalesEntryHeader_LastId = SCOPE_IDENTITY();  
  
     SELECT @ResultCount = count(1)  
     FROM @TempSaleEntryHeader;  
  
     SELECT @SalesEntryCount = count(1)  
     FROM @TempSaleEntryHeader;  
  
     DECLARE @SalesEntryIndex INT = 1;  
  
     WHILE (@SalesEntryIndex <= @SalesEntryCount)  
     BEGIN  
      IF (@SalesEntryHeader_LastId > 0)  
      BEGIN  
       DECLARE @SalesEntry_LastId INT = 0;  
       DECLARE @TempMaterialId INT = 0;  
       DECLARE @TempModeOfTypeId INT = 0;  
  
       SELECT @TempMaterialId = TEMP.ItemCodeId  
        ,@TempModeOfTypeId = TEMP.TypeCodeId  
       FROM @TempSaleEntryHeader AS TEMP  
       WHERE TEMP.RowNo = @SalesEntryIndex;  
  
       INSERT INTO dbo.SalesEntry (  
        SaleEntryHeaderId  
        ,MaterialId  
        ,MaterialCode  
        ,ProductCategoryCode1  
        ,ProductCategoryCode2  
        ,ProductCategoryCode3  
        ,ProductCategoryCode4  
        ,ProductCategoryCode5  
        ,ProductCategoryCode6  
        ,OCmonthYear  
        ,OCstatus  
        ,ModeOfTypeId  
        )  
       SELECT DISTINCT @SalesEntryHeader_LastId  
        ,TEMP.ItemCodeId  
        ,TEMP.ItemCode  
        ,TEMP.Class1  
        ,TEMP.Class2  
        ,TEMP.Class3  
        ,TEMP.Class4  
        ,TEMP.Class5  
        ,TEMP.Class6  
        ,@currentMonthYear  
        ,'Y' AS OCstatus  
        ,TEMP.TypeCodeId  
       FROM @TempSaleEntryHeader AS TEMP  
       WHERE TEMP.RowNo = @SalesEntryIndex;  
  
       SELECT @SalesEntry_LastId = SCOPE_IDENTITY();  
  
       IF (@SalesEntry_LastId > 0)  
       BEGIN  
        IF @PrevSaleEntryHeaderId IS NOT NULL  
        BEGIN  
         --PRINT 'PRICE QTY';          
         DECLARE @tempCurrentSalesQtyPrices AS dbo.[TVP_SALES_ENTRY_MATERIAL_QTY_PRICES];  
         delete @tempCurrentSalesQtyPrices;
         INSERT INTO @tempCurrentSalesQtyPrices  
         SELECT sqp.[RowIndex]  
          ,sqp.[RowNo]  
          ,ROW_NUMBER() OVER (  
           ORDER BY sqp.[PriceMonthName] ASC  
           ) AS PriceQtyRowNo  
          ,sqp.[PriceMonthName]  
          ,sqp.[Price]  
          ,sqp.[Qty]  
          ,sqp.[Currency]  
         FROM @SalesQtyPrices AS sqp  
         WHERE sqp.RowNo = @SalesEntryIndex;  
  
         DECLARE @SalesPriceQtyIndex INT = 1;  
         DECLARE @SalesPriceQtyCount INT = 0;  
  
         SELECT @SalesPriceQtyCount = count(1)  
         FROM @tempCurrentSalesQtyPrices;  
  
         DECLARE @IsPrevDataUpdated VARCHAR(1) = '0';  
  
         --PRINT @SalesPriceQtyCount;          
         WHILE (@SalesPriceQtyIndex <= @SalesPriceQtyCount)  
         BEGIN  
          --PRINT 'LOOP';          
          --PRINT @SalesPriceQtyIndex;          
          --PRINT '@TempMaterialId';          
          --PRINT @TempMaterialId;          
          --PRINT '@TempModeOfTypeId';          
          --PRINT @TempModeOfTypeId;          
          DECLARE @TempMonthYear [nvarchar] (20) = '';  
          DECLARE @TempQty INT = 0;  
          DECLARE @TempPrice DECIMAL(18, 2) = 0;  
  
          SELECT @TempMonthYear = [PriceMonthName]  
           ,@TempQty = [Qty]  
           ,@TempPrice = [Price]  
          FROM @tempCurrentSalesQtyPrices  
          WHERE PriceQtyRowNo = @SalesPriceQtyIndex;  
  
          --PRINT '@TempMonthYear';          
          --PRINT @TempMonthYear;          
          --PRINT '@TempQty';          
          --PRINT @TempQty;          
          --PRINT '@TempPrice';          
          --PRINT @TempPrice;          
          IF EXISTS (  
            SELECT TOP 1 1  
            FROM @tempPrevSalesEntryPriceQtyTable  
            WHERE [MaterialId] = @TempMaterialId  
             AND [ModeOfTypeId] = @TempModeOfTypeId  
             AND [MonthYear] = @TempMonthYear  
               
             AND (  
              [Quantity] != @TempQty  
              OR [Price] != @TempPrice  
              )  
             AND (  
              [MonthYear] = @currentMonthYear  
              OR [MonthYear] = @nextMonthYear  
              )  
            )  
          BEGIN  
           --PRINT 'NO';          
           SET @IsPrevDataUpdated = '1';  
  
           INSERT INTO dbo.SalesEntryPriceQuantity (  
            SalesEntryId  
            ,MonthYear  
            ,Price  
            ,Quantity  
            ,CurrencyCode  
            ,OCstatus  
            )  
           SELECT DISTINCT @SalesEntry_LastId  
            ,PriceMonthName  
            ,Price  
            ,Qty  
            ,Currency  
            ,'N' AS OCstatus  
           FROM @tempCurrentSalesQtyPrices AS sqp  
           WHERE PriceQtyRowNo = @SalesPriceQtyIndex;  
          END  
          ELSE  
          BEGIN  
           --PRINT 'YES';          
           INSERT INTO dbo.SalesEntryPriceQuantity (  
            SalesEntryId  
            ,MonthYear  
            ,Price  
            ,Quantity  
            ,CurrencyCode  
            ,OCstatus  
            )  
           SELECT DISTINCT @SalesEntry_LastId  
            ,PriceMonthName  
            ,Price  
            ,Qty  
            ,Currency  
            ,'Y' AS OCstatus  
           FROM @tempCurrentSalesQtyPrices AS sqp  
           WHERE PriceQtyRowNo = @SalesPriceQtyIndex;  
          END  
  
          SET @SalesPriceQtyIndex = @SalesPriceQtyIndex + 1;  
         END  
  
         IF @IsPrevDataUpdated = '1'  
         BEGIN  
          UPDATE dbo.SalesEntry  
          SET OCstatus = 'N'  
          WHERE SalesEntryId = @SalesEntry_LastId;  
         END  
         ELSE  
         BEGIN  
          DELETE  
          FROM SalesEntryPriceQuantity  
          WHERE SalesEntryId IN (  
            SELECT SalesEntryId  
            FROM SalesEntry  
            WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId  
            );  
  
          DELETE  
          FROM SalesEntry  
          WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;  
  
          DELETE  
          FROM SaleEntryHeader  
          WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;  
         END  
        END  
        ELSE  
        BEGIN  
         INSERT INTO dbo.SalesEntryPriceQuantity (  
          SalesEntryId  
          ,MonthYear  
          ,Price  
          ,Quantity  
          ,CurrencyCode  
          ,OCstatus  
          )  
         SELECT DISTINCT @SalesEntry_LastId  
          ,PriceMonthName  
          ,Price  
          ,Qty  
          ,Currency  
          ,'Y' AS OCstatus  
         FROM @SalesQtyPrices AS sqp  
         WHERE sqp.RowNo = @SalesEntryIndex;  
        END  
       END  
      END  
  
      SET @SalesEntryIndex = @SalesEntryIndex + 1;  
     END  
    END  
   END  
  END  
  
  IF @@TRANCOUNT > 0  
   COMMIT;  
  
  IF NOT EXISTS (  
    SELECT 1  
    FROM @ResultTable  
    )  
   INSERT INTO @ResultTable  
   VALUES (  
    0  
    ,200  
    ,(CONVERT(VARCHAR(10), @ResultCount) + ' Records')  
    );  
 END TRY  
  
 BEGIN CATCH  
  IF @@TRANCOUNT > 0  
   ROLLBACK;  
  
  INSERT INTO @ResultTable  
  VALUES (  
   0  
   ,500  
   ,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()  
   );  
 END CATCH;  
  
 DELETE @TempSaleEntryHeader;  
  
 DELETE @SalesQtyPrices;  
  
 SELECT DISTINCT RowNo  
  ,ResponseCode  
  ,ResponseMessage  
 FROM @ResultTable;  
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Sales_Entries_OLD]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Insert_Sales_Entries_OLD] (
	@customerId INT
	,@productCategoryId INT
	,@productSubCategoryId INT
	,@tvpSalesEntries dbo.TVP_SALES_ENTRY_ROWS READONLY
	,@tvpSalesQuantities dbo.TVP_SALES_ENTRY_QUANTITIES READONLY
	,@tvpSalesPrices dbo.TVP_SALES_ENTRY_PRICES READONLY
	,@userId NVARCHAR(100)
	,@attachmentId INT
	,@saleSubType VARCHAR(50)
	,@isValid BIT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;
	DECLARE @currentMonthYear CHAR(6)
		,@nextMonthYear CHAR(6);
	DECLARE @CustomerCode NVARCHAR(100);

	SET @CustomerCode = (
			SELECT CustomerCode
			FROM Customer
			WHERE CustomerId = @customerId
			);

	--SET @currentmonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())), 2);        
	--SET @currentYear = CONVERT(VARCHAR(4),YEAR(getdate()));        
	--SET @currentMonthYear = @currentYear+@currentmonth;       
	IF (@SaleSubType = 'Monthly')
	BEGIN
		SET @currentMonthYear = (
				SELECT ConfigValue
				FROM GlobalConfig
				WHERE ConfigKey = 'Current_Month'
					AND ConfigType = 'Direct And SNS'
				)

		DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, @currentMonthYear + '01', 112);

		SET @nextMonthYear = (
				SELECT FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM')
				);
	END
	ELSE
	BEGIN
		SET @currentMonthYear = (
				SELECT ConfigValue
				FROM GlobalConfig
				WHERE ConfigKey = 'BP_Year'
				)
	END

	--select @currentMonthYear =         
	--ConfigValue from [dbo].[GlobalConfig] where ConfigKey='Current_Month' and ConfigType='Direct And SNS';        
	--SET @nextMonth = RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MONTH, GETDATE())+1), 2);        
	--SET @nextYear = CONVERT(VARCHAR(4),YEAR(getdate())+1);        
	--SET @nextMonthYear = @currentYear+@nextMonth;        
	--IF(@currentmonth = '12')  SET @nextMonthYear =@nextYear+'01';        
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		--SET @responseMessage = '';        
		DECLARE @ResultCount INT = 0
			,@SalesEntryCount INT = 0;
		DECLARE @CustomerWithCurrency AS [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY];

		INSERT INTO @CustomerWithCurrency
		EXEC [dbo].[SP_Get_Customer_Country_Currency] @customerId;

		DECLARE @LocalCurrencyCode NVARCHAR(10);

		SET @LocalCurrencyCode = (
				SELECT TOP 1 CurrencyCode
				FROM @CustomerWithCurrency
				);

		DECLARE @SalesQtyPrices AS dbo.TVP_SALES_ENTRY_QTY_PRICES;
		DECLARE @TempSaleEntryHeader AS dbo.TVP_SALES_ENTRY_HEADERS;

		INSERT INTO @TempSaleEntryHeader
		SELECT ROW_NUMBER() OVER (
				ORDER BY tvp.RowIndex ASC
				) AS RowNo
			,tvp.RowIndex
			,tvp.UploadFlag
			,tvp.Class1
			,tvp.Class2
			,tvp.Class3
			,tvp.Class4
			,tvp.Class5
			,tvp.Class6
			,tvp.Class7
			,tvp.Class8
			,tvp.ItemCode
			,material.MaterialId
			,tvp.ModelNumber
			,modeType.ModeofTypeId
			,tvp.TypeCode
			,tvp.Comments
			,tvp.Currency
			,1 --SalesTypeId        
		FROM @tvpSalesEntries AS tvp
		LEFT JOIN dbo.ModeofType AS modeType ON tvp.TypeCode = modeType.ModeofTypeCode
		LEFT JOIN dbo.Material AS material ON material.MaterialCode = tvp.ItemCode;

		INSERT INTO @SalesQtyPrices
		SELECT tvp_price.RowIndex
			,TEMP.RowNo
			,tvp_price.PriceMonthName
			,tvp_price.Price
			,tvp_qty.Qty
			,CASE 
				WHEN TEMP.TypeCode = 'P'
					OR TEMP.TypeCode = 'S'
					OR TEMP.TypeCode = 'I'
					THEN @LocalCurrencyCode
				ELSE 'USD'
				END AS Currency
		FROM @tvpSalesQuantities AS tvp_qty
		INNER JOIN @tvpSalesPrices AS tvp_price ON tvp_price.RowIndex = tvp_qty.RowIndex
			AND tvp_price.PriceMonthName = tvp_qty.QtyMonthName
		INNER JOIN @TempSaleEntryHeader AS TEMP ON tvp_qty.RowIndex = TEMP.RowIndex;

		--insert into testdata SELECT ItemCode, TypeCode FROM  @tvpSaleEntryHeader where 1=1;    
		--validation sp call        
		INSERT INTO @ResultTable
		EXEC dbo.[SP_Validate_Sales_Entries] @customerId
			,@CustomerWithCurrency
			,@TempSaleEntryHeader
			,@SalesQtyPrices;

		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM @ResultTable
				)
			AND @isValid = 1
		BEGIN
			--Archive sales entries data        
			DECLARE @IsArchived VARCHAR(1) = '0';
			DECLARE @PrevSaleEntryHeaderId VARCHAR(12) = '0';
			DECLARE @ArchivalResultTable AS dbo.TVP_RESULT_TABLE;

			INSERT INTO @ArchivalResultTable
			EXEC dbo.[SP_Archive_Sales_Entries] @customerId
				,@productCategoryId
				,@productSubCategoryId
				,@saleSubType
				,@currentMonthYear
				,@nextMonthYear
				,@userId
				,@TempSaleEntryHeader
				,@SalesQtyPrices;

			--Insert Archival Error Log into Result        
			INSERT INTO @ResultTable
			SELECT *
			FROM @ArchivalResultTable
			WHERE ResponseCode != 200
				AND ResponseCode != 201;

			SET @IsArchived = (
					SELECT TOP 1 ResponseMessage
					FROM @ArchivalResultTable
					WHERE ResponseCode = 200
					);
			SET @PrevSaleEntryHeaderId = (
					SELECT TOP 1 ResponseMessage
					FROM @ArchivalResultTable
					WHERE ResponseCode = 201
					);

			DECLARE @tempPrevSalesEntryPriceQtyTable AS dbo.[TVP_SALESENTRY_PRICE_QTY_INFO];

			--PRINT '@PrevSaleEntryHeaderId';        
			--PRINT @PrevSaleEntryHeaderId;        
			IF @PrevSaleEntryHeaderId IS NOT NULL
				AND @PrevSaleEntryHeaderId != '0'
			BEGIN
				--PRINT @PrevSaleEntryHeaderId;        
				IF EXISTS (
						SELECT TOP 1 1
						FROM dbo.SaleEntryHeader
						WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId
						)
				BEGIN
					INSERT INTO @tempPrevSalesEntryPriceQtyTable
					SELECT PQ.[SalesEntryPriceQuantityId]
						,PQ.[SalesEntryId]
						,SE.[SaleEntryHeaderId]
						,PQ.[MonthYear]
						,PQ.[Price]
						,PQ.[Quantity]
						,SE.[MaterialId]
						,SE.[OCmonthYear]
						,SE.[OCstatus]
						,SE.[ModeOfTypeId]
					FROM [dbo].[SalesEntryPriceQuantity] PQ
					INNER JOIN [dbo].[SalesEntry] SE ON PQ.SalesEntryId = SE.SalesEntryId
					WHERE SE.SaleEntryHeaderId = @PrevSaleEntryHeaderId;
				END
				ELSE
				BEGIN
					INSERT INTO @tempPrevSalesEntryPriceQtyTable
					SELECT PQ.[SalesArchivalEntryPriceQuantityId] AS [SalesEntryPriceQuantityId]
						,PQ.[SalesArchivalEntryId] AS [SalesEntryId]
						,SE.[SaleEntryArchivalHeaderId] AS [SaleEntryHeaderId]
						,PQ.[MonthYear]
						,PQ.[Price]
						,PQ.[Quantity]
						,SE.[MaterialId]
						,SE.[OCmonthYear]
						,SE.[OCstatus]
						,SE.[ModeOfTypeId]
					FROM [dbo].[SalesArchivalEntryPriceQuantity] PQ
					INNER JOIN [dbo].[SalesArchivalEntry] SE ON PQ.[SalesArchivalEntryId] = SE.[SalesArchivalEntryId]
					WHERE SE.[SaleEntryArchivalHeaderId] = @PrevSaleEntryHeaderId
				END
			END

			IF EXISTS (
					SELECT TOP 1 1
					FROM @ArchivalResultTable
					WHERE ResponseCode = 200
					)
			BEGIN
				BEGIN
					DECLARE @SalesEntryHeader_LastId INT = 0;

					INSERT INTO dbo.SaleEntryHeader (
						CustomerId
						,CustomerCode
						,SaleTypeId
						,ProductCategoryId1
						,ProductCategoryId2
						,CurrentMonthYear
						,LockMonthYear
						,CreatedDate
						,CreatedBy
						,UpdateDate
						,UpdateBy
						,AttachmentId
						,SaleSubType
						)
					VALUES (
						@customerId
						,@CustomerCode
						,1
						,@productCategoryId
						,@productSubCategoryId
						,@currentMonthYear
						,@nextMonthYear
						,GETDATE()
						,@userId
						,GETDATE()
						,@userId
						,@attachmentId
						,@saleSubType
						);

					SELECT @SalesEntryHeader_LastId = SCOPE_IDENTITY();

					SELECT @ResultCount = count(1)
					FROM @TempSaleEntryHeader;

					SELECT @SalesEntryCount = count(1)
					FROM @TempSaleEntryHeader;

					DECLARE @SalesEntryIndex INT = 1;

					WHILE (@SalesEntryIndex <= @SalesEntryCount)
					BEGIN
						IF (@SalesEntryHeader_LastId > 0)
						BEGIN
							DECLARE @SalesEntry_LastId INT = 0;
							DECLARE @TempMaterialId INT = 0;
							DECLARE @TempModeOfTypeId INT = 0;

							SELECT @TempMaterialId = TEMP.ItemCodeId
								,@TempModeOfTypeId = TEMP.TypeCodeId
							FROM @TempSaleEntryHeader AS TEMP
							WHERE TEMP.RowNo = @SalesEntryIndex;

							INSERT INTO dbo.SalesEntry (
								SaleEntryHeaderId
								,MaterialId
								,MaterialCode
								,ProductCategoryCode1
								,ProductCategoryCode2
								,ProductCategoryCode3
								,ProductCategoryCode4
								,ProductCategoryCode5
								,ProductCategoryCode6
								,OCmonthYear
								,OCstatus
								,ModeOfTypeId
								)
							SELECT DISTINCT @SalesEntryHeader_LastId
								,TEMP.ItemCodeId
								,TEMP.ItemCode
								,TEMP.Class1
								,TEMP.Class2
								,TEMP.Class3
								,TEMP.Class4
								,TEMP.Class5
								,TEMP.Class6
								,@currentMonthYear
								,'Y' AS OCstatus
								,TEMP.TypeCodeId
							FROM @TempSaleEntryHeader AS TEMP
							WHERE TEMP.RowNo = @SalesEntryIndex;

							SELECT @SalesEntry_LastId = SCOPE_IDENTITY();

							IF (@SalesEntry_LastId > 0)
							BEGIN
								IF @PrevSaleEntryHeaderId IS NOT NULL
								BEGIN
									--PRINT 'PRICE QTY';        
									DECLARE @tempCurrentSalesQtyPrices AS dbo.[TVP_SALES_ENTRY_MATERIAL_QTY_PRICES];

									INSERT INTO @tempCurrentSalesQtyPrices
									SELECT sqp.[RowIndex]
										,sqp.[RowNo]
										,ROW_NUMBER() OVER (
											ORDER BY sqp.[PriceMonthName] ASC
											) AS PriceQtyRowNo
										,sqp.[PriceMonthName]
										,sqp.[Price]
										,sqp.[Qty]
										,sqp.[Currency]
									FROM @SalesQtyPrices AS sqp
									WHERE sqp.RowNo = @SalesEntryIndex;

									DECLARE @SalesPriceQtyIndex INT = 1;
									DECLARE @SalesPriceQtyCount INT = 0;

									SELECT @SalesPriceQtyCount = count(1)
									FROM @tempCurrentSalesQtyPrices;

									DECLARE @IsPrevDataUpdated VARCHAR(1) = '0';

									--PRINT @SalesPriceQtyCount;        
									WHILE (@SalesPriceQtyIndex <= @SalesPriceQtyCount)
									BEGIN
										--PRINT 'LOOP';        
										--PRINT @SalesPriceQtyIndex;        
										--PRINT '@TempMaterialId';        
										--PRINT @TempMaterialId;        
										--PRINT '@TempModeOfTypeId';        
										--PRINT @TempModeOfTypeId;        
										DECLARE @TempMonthYear [nvarchar] (20) = '';
										DECLARE @TempQty INT = 0;
										DECLARE @TempPrice DECIMAL(18, 2) = 0;

										SELECT @TempMonthYear = [PriceMonthName]
											,@TempQty = [Qty]
											,@TempPrice = [Price]
										FROM @tempCurrentSalesQtyPrices
										WHERE PriceQtyRowNo = @SalesPriceQtyIndex;

										--PRINT '@TempMonthYear';        
										--PRINT @TempMonthYear;        
										--PRINT '@TempQty';        
										--PRINT @TempQty;        
										--PRINT '@TempPrice';        
										--PRINT @TempPrice;        
										IF EXISTS (
												SELECT TOP 1 1
												FROM @tempPrevSalesEntryPriceQtyTable
												WHERE [MaterialId] = @TempMaterialId
													AND [ModeOfTypeId] = @TempModeOfTypeId
													AND [MonthYear] = @TempMonthYear
													
													AND (
														[Quantity] != @TempQty
														OR [Price] != @TempPrice
														)
													AND (
														[MonthYear] = @currentMonthYear
														OR [MonthYear] = @nextMonthYear
														)
												)
										BEGIN
											--PRINT 'NO';        
											SET @IsPrevDataUpdated = '1';

											INSERT INTO dbo.SalesEntryPriceQuantity (
												SalesEntryId
												,MonthYear
												,Price
												,Quantity
												,CurrencyCode
												,OCstatus
												)
											SELECT DISTINCT @SalesEntry_LastId
												,PriceMonthName
												,Price
												,Qty
												,Currency
												,'N' AS OCstatus
											FROM @tempCurrentSalesQtyPrices AS sqp
											WHERE PriceQtyRowNo = @SalesPriceQtyIndex;
										END
										ELSE
										BEGIN
											--PRINT 'YES';        
											INSERT INTO dbo.SalesEntryPriceQuantity (
												SalesEntryId
												,MonthYear
												,Price
												,Quantity
												,CurrencyCode
												,OCstatus
												)
											SELECT DISTINCT @SalesEntry_LastId
												,PriceMonthName
												,Price
												,Qty
												,Currency
												,'Y' AS OCstatus
											FROM @tempCurrentSalesQtyPrices AS sqp
											WHERE PriceQtyRowNo = @SalesPriceQtyIndex;
										END

										SET @SalesPriceQtyIndex = @SalesPriceQtyIndex + 1;
									END

									IF @IsPrevDataUpdated = '1'
									BEGIN
										UPDATE dbo.SalesEntry
										SET OCstatus = 'N'
										WHERE SalesEntryId = @SalesEntry_LastId;
									END
									ELSE
									BEGIN
										DELETE
										FROM SalesEntryPriceQuantity
										WHERE SalesEntryId IN (
												SELECT SalesEntryId
												FROM SalesEntry
												WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId
												);

										DELETE
										FROM SalesEntry
										WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;

										DELETE
										FROM SaleEntryHeader
										WHERE SaleEntryHeaderId = @PrevSaleEntryHeaderId;
									END
								END
								ELSE
								BEGIN
									INSERT INTO dbo.SalesEntryPriceQuantity (
										SalesEntryId
										,MonthYear
										,Price
										,Quantity
										,CurrencyCode
										,OCstatus
										)
									SELECT DISTINCT @SalesEntry_LastId
										,PriceMonthName
										,Price
										,Qty
										,Currency
										,'Y' AS OCstatus
									FROM @SalesQtyPrices AS sqp
									WHERE sqp.RowNo = @SalesEntryIndex;
								END
							END
						END

						SET @SalesEntryIndex = @SalesEntryIndex + 1;
					END
				END
			END
		END

		IF @@TRANCOUNT > 0
			COMMIT;

		IF NOT EXISTS (
				SELECT 1
				FROM @ResultTable
				)
			INSERT INTO @ResultTable
			VALUES (
				0
				,200
				,(CONVERT(VARCHAR(10), @ResultCount) + ' Records')
				);
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

		INSERT INTO @ResultTable
		VALUES (
			0
			,500
			,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()
			);
	END CATCH;

	DELETE @TempSaleEntryHeader;

	DELETE @SalesQtyPrices;

	SELECT DISTINCT RowNo
		,ResponseCode
		,ResponseMessage
	FROM @ResultTable;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_SSD_Entries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Insert_SSD_Entries] (
	@tvpSSDEntries dbo.[TVP_SSD_ENTRIES] READONLY
	,@tvpSSDQtyPrices dbo.[TVP_SSD_ENTRY_QTY_PRICES] READONLY
	,@userId NVARCHAR(100)
	,@attachmentId INT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @ResultCount INT = 0
			,@SSDEntryCount INT = 0
			,@ModeOfTypeCount INT = 0;
		DECLARE @tempModeOfType AS [dbo].[TVP_MODE_OF_TYPE];

		INSERT INTO @tempModeOfType
		SELECT ROW_NUMBER() OVER (
				ORDER BY ModeOfTypeCode ASC
				) AS RowNo
			,ModeOfTypeId
			,ModeOfTypeName
			,ModeOfTypeCode
			,IsACtive
		FROM ModeOfType
		WHERE ModeOfTypeCode IN (
				'O'
				,'P'
				,'S'
				,'I'
				,'ADJ'
				,'MPO'
				);

		DECLARE @tempSSDEntry AS dbo.[TVP_SSD_ENTRIES];
		DECLARE @tempSSDEntryQtyPrices AS dbo.[TVP_SSD_ENTRY_QTY_PRICES];

		INSERT INTO @tempSSDEntry
		SELECT ROW_NUMBER() OVER (
				ORDER BY tvp.RowIndex ASC
				) AS RowNo
			,tvp.RowIndex
			,tvp.[ModeofTypeId]
			,customer.[CustomerId]
			,tvp.[CustomerCode]
			,material.[MaterialId]
			,tvp.[MaterialCode]
			,@attachmentId
		FROM @tvpSSDEntries AS tvp
		LEFT JOIN dbo.Customer AS customer ON tvp.[CustomerCode] = customer.[CustomerCode]
		LEFT JOIN dbo.Material AS material ON material.MaterialCode = tvp.[MaterialCode];

		INSERT INTO @tempSSDEntryQtyPrices
		SELECT tempSSD.RowNo
			,tvpQtyPrices.RowIndex
			,tvpQtyPrices.ColIndex
			,tvpQtyPrices.MonthYear
			,tvpQtyPrices.Qty
			,tvpQtyPrices.Price
		FROM @tvpSSDQtyPrices AS tvpQtyPrices
		INNER JOIN @tempSSDEntry AS tempSSD ON tvpQtyPrices.RowIndex = tempSSD.RowIndex;

		--SELECT * FROM @tempSSDEntry;
		--VALIDATE SP CALL
		INSERT INTO @ResultTable
		EXEC [dbo].[SP_Validate_SSD_Entries] @tempSSDEntry;

		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM @ResultTable
				)
		BEGIN
			--Archive SNS entries data
			BEGIN
				INSERT INTO [dbo].[SSDEntryArchive] (
					[SSDEntryArchiveId]
					,[ModeofTypeId]
					,[CustomerId]
					,[CustomerCode]
					,[MaterialId]
					,[MaterialCode]
					,[AttachmentId]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					)
				SELECT SSDEntryId
					,[ModeofTypeId]
					,[CustomerId]
					,[CustomerCode]
					,[MaterialId]
					,[MaterialCode]
					,[AttachmentId]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
				FROM [dbo].[SSDEntry];

				INSERT INTO [dbo].[SSDEntryQtyPriceArchive] (
					[SSDEntryQtyPriceArchiveId]
					,[SSDEntryArchiveId]
					,[MonthYear]
					,[Qty]
					,[Price]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					)
				SELECT [SSDEntryQtyPriceId]
					,[SSDEntryId]
					,[MonthYear]
					,[Qty]
					,[Price]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
				FROM [dbo].[SSDEntryQtyPrice];

				DELETE
				FROM [dbo].[SSDEntryQtyPrice];

				DELETE
				FROM [dbo].[SSDEntry];
			END

			--INSERT NEW ENTRIES
			BEGIN
				SELECT @ResultCount = count(1)
				FROM @tempSSDEntry;

				SELECT @SSDEntryCount = count(1)
				FROM @tempSSDEntry;

				SELECT @ModeOfTypeCount = count(1)
				FROM @tempModeOfType;

				DECLARE @SSDEntryIndex INT = 1;

				WHILE (@SSDEntryIndex <= @SSDEntryCount)
				BEGIN
					DECLARE @ModeOfTypeIndex INT = 1;
					DECLARE @ModeOfTypeCode [nvarchar] (10) = '';
					DECLARE @ModeofTypeId [int] = 0;

					WHILE (@ModeOfTypeIndex <= @ModeOfTypeCount)
					BEGIN
						SELECT @ModeOfTypeCode = [ModeofTypeCode]
							,@ModeofTypeId = [ModeofTypeId]
						FROM @tempModeOfType
						WHERE RowNo = @ModeOfTypeIndex;

						DECLARE @SSDEntry_LastId INT = 0;

						INSERT INTO [dbo].[SSDEntry] (
							[ModeofTypeId]
							,[CustomerId]
							,[CustomerCode]
							,[MaterialId]
							,[MaterialCode]
							,[AttachmentId]
							,[CreatedDate]
							,[CreatedBy]
							,[UpdatedDate]
							,[UpdatedBy]
							)
						SELECT @ModeofTypeId
							,[CustomerId]
							,[CustomerCode]
							,[MaterialId]
							,[MaterialCode]
							,@attachmentId
							,GETDATE()
							,@userId
							,GETDATE()
							,@userId
						FROM @tempSSDEntry
						WHERE RowNo = @SSDEntryIndex;

						SELECT @SSDEntry_LastId = SCOPE_IDENTITY();

						IF @ModeOfTypeCode = 'O'
						BEGIN
							INSERT INTO [dbo].[SSDEntryQtyPrice] (
								[SSDEntryId]
								,[MonthYear]
								,[Qty]
								,[Price]
								,[CreatedDate]
								,[CreatedBy]
								,[UpdatedDate]
								,[UpdatedBy]
								)
							SELECT @SSDEntry_LastId
								,[MonthYear]
								,[Qty]
								,[Price]
								,GETDATE()
								,@userId
								,GETDATE()
								,@userId
							FROM @tempSSDEntryQtyPrices
							WHERE RowNo = @SSDEntryIndex;
						END
						ELSE
						BEGIN
							INSERT INTO [dbo].[SSDEntryQtyPrice] (
								[SSDEntryId]
								,[MonthYear]
								,[Qty]
								,[Price]
								,[CreatedDate]
								,[CreatedBy]
								,[UpdatedDate]
								,[UpdatedBy]
								)
							SELECT @SSDEntry_LastId
								,[MonthYear]
								,0
								,0
								,GETDATE()
								,@userId
								,GETDATE()
								,@userId
							FROM @tempSSDEntryQtyPrices
							WHERE RowNo = @SSDEntryIndex;
						END

						SET @ModeOfTypeIndex = @ModeOfTypeIndex + 1;
					END

					SET @SSDEntryIndex = @SSDEntryIndex + 1;
				END
			END
		END

		IF @@TRANCOUNT > 0
			COMMIT;

		IF NOT EXISTS (
				SELECT 1
				FROM @ResultTable
				)
			INSERT INTO @ResultTable
			VALUES (
				0
				,200
				,(CONVERT(VARCHAR(10), @ResultCount) + ' Records')
				);
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

		INSERT INTO @ResultTable
		VALUES (
			0
			,500
			,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()
			);
	END CATCH;

	DELETE @tempSSDEntry;

	DELETE @tempSSDEntryQtyPrices;

	DELETE @tempModeOfType;

	SELECT DISTINCT RowNo
		,ResponseCode
		,ResponseMessage
	FROM @ResultTable;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_TRNPricePlanning]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Insert_TRNPricePlanning] (
	@userId NVARCHAR(100)
	,@currentMonthYear INT
	,@lockMonthYear INT
	,@resultMonthYear INT
	,@lastForecastMonthYear INT
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from              
	-- interfering with SELEaCT statements.              
	SET NOCOUNT ON

	-- Insert statements for procedure here              
	BEGIN TRY
		BEGIN TRANSACTION

		--DECLARE @resultMonthYear int, @currentMonthYear int, @lockMonthYear int, @lastForecastMonthYear int;            
		--select @currentMonthYear =             
		--CAST(ConfigValue AS INT) from [dbo].[GlobalConfig] where ConfigKey='Current_Month' and ConfigType='Direct And SNS';            
		DECLARE @dtCurrentMonthYear DATETIME = CONVERT(DATETIME, CAST(@currentMonthYear AS VARCHAR(6)) + '01', 112);
		--SET @currentMonthYear = (SELECT CAST(FORMAT(GETDATE(), 'yyyyMM') AS INT));            
		--SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, GETDATE()), 'yyyyMM') AS INT));            
		--SET @lockMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 1, GETDATE()), 'yyyyMM') AS INT));            
		--SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, GETDATE()), 'yyyyMM') AS INT));            
		--SET @resultMonthYear = (SELECT CAST(FORMAT(DATEADD(month, -1, @dtCurrentMonthYear), 'yyyyMM') AS INT));            
		--SET @lockMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 1, @dtCurrentMonthYear), 'yyyyMM') AS INT));            
		--SET @lastForecastMonthYear = (SELECT CAST(FORMAT(DATEADD(month, 6, @dtCurrentMonthYear), 'yyyyMM') AS INT));            
		DECLARE @tvpAccounMaterialPricePlannings AS [dbo].[TVP_PRICE_PLANNING];
		DECLARE @tvpCustomerMaterialSalesPlannings AS [dbo].[TVP_SALES_PLANNING]

		--ARCHIVE PREVIOUS LOADED DATA            
		INSERT INTO [dbo].[TRNPricePlanningArchival]
		SELECT [AccountCode]
			,[MonthYear]
			,[MaterialCode]
			,[ModeofType]
			,[Type]
			,[Quantity]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,@currentMonthYear
			,getdate()
			,Price
		FROM [dbo].[TRNPricePlanning];

		INSERT INTO [dbo].[TRNSalesPlanningArchival]
		SELECT [MonthYear]
			,[CustomerCode]
			,[MaterialCode]
			,[Quantity]
			,[Amount]
			,[AccountCode]
			,[CreatedDate]
			,[CreatedBy]
			,[UpdatedDate]
			,[UpdatedBy]
			,getdate()
			,Price
		FROM [dbo].[TRNSalesPlanning]

		--TRUNCATE TABLE [dbo].[TRNPricePlanning];            
		--TRUNCATE TABLE [dbo].[TRNSalesPlanning];            
		/*            
  INSERT INTO @tvpAccounMaterialPricePlannings            
   SELECT NULL, AccountCode, MonthYear, MaterialCode, 'GIT Arrivals', NULL,  SUM(Quantity)            
   from Mst_CurrentLockMonthPurchaseGit            
   where MonthYear >= @currentMonthYear AND ATP_CASE in ( '01', '11')            
   GROUP BY MonthYear, AccountCode, MaterialCode;            
   */
		-- result month git from current month purchase            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,@resultMonthYear
			,MaterialCode
			,'GIT Arrivals'
			,NULL
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM [dbo].[Mst_CurrentLockMonthPurchase]
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear = @currentMonthYear
			AND ATP_CASE IN (
				'01'
				,'11'
				)
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		--INSERT ORDER            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'ORDER'
			,NULL
			,SUM(Quantity)
			,0 --amount  
		FROM MST_CurrentMonthOrder
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear >= @resultMonthYear
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		--INSERT PURCHASE            
		-- RESULT PURCHASE            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'PURCHASE'
			,'S&S'
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM MST_ResultPurchase
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear = @resultMonthYear
		--AND ATP_CASE in ( '01', '11')            
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		--CURRENT MONTH PURCHASE            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'PURCHASE'
			,'S&S'
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM [dbo].[Mst_CurrentLockMonthPurchase]
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear = @currentMonthYear
			AND ATP_CASE IN (
				'01'
				,'11'
				)
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		-- LOCK & INDICATION MONTH PURCHASE            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'PURCHASE'
			,'S&S'
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM [dbo].[Mst_CurrentLockMonthPurchase]
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear >= @lockMonthYear
			AND ATP_CASE = '01'
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		-- LOCK & INDICATION MONTH MPO            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'MPO'
			,'MPO'
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM [dbo].[Mst_CurrentLockMonthPurchase]
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear >= @lockMonthYear
			AND ATP_CASE = '11'
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		--INSERT SALES            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'SALES'
			,'S&S'
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Amount), 0) / nullif(SUM(Quantity), 0)
				END AS Price
		FROM MST_ResultSales
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear >= @resultMonthYear
			AND SalesOrganizationCode = 1000
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		--INSERT INVENTORY            
		INSERT INTO @tvpAccounMaterialPricePlannings
		SELECT NULL
			,AccountCode
			,MonthYear
			,MaterialCode
			,'INVENTORY'
			,NULL
			,SUM(Quantity)
			,CASE 
				WHEN SUM(Quantity) = 0
					THEN 0
				ELSE ISNULL(SUM(Wac_Price), 0) / ISNULL(SUM(Quantity), 0)
				END AS Price
		FROM Mst_ResultInventory
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND MonthYear >= @resultMonthYear
		GROUP BY MonthYear
			,AccountCode
			,MaterialCode;

		MERGE [dbo].[TRNPricePlanning] AS Target
		USING @tvpAccounMaterialPricePlannings AS Source
			ON Source.[AccountCode] = Target.[AccountCode]
				AND Source.[MonthYear] = Target.[MonthYear]
				AND Source.[MaterialCode] = Target.[MaterialCode]
				AND Source.[ModeofType] = Target.[ModeofType]
				-- For Insert            
		WHEN NOT MATCHED BY Target
			THEN
				INSERT (
					[AccountCode]
					,[MonthYear]
					,[MaterialCode]
					,[ModeofType]
					,[Type]
					,[Quantity]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					,Price
					)
				VALUES (
					Source.[AccountCode]
					,Source.[MonthYear]
					,Source.[MaterialCode]
					,Source.[ModeofType]
					,Source.[Type]
					,Source.[Quantity]
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
					,Source.[Price]
					)
					-- For Updates            
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Quantity] = Source.[Quantity]
					,Target.[Price] = Source.[Price]
					,Target.[UpdatedDate] = GETDATE()
					,Target.[UpdatedBy] = @userId;

		-- CUSTOMER WISE SALE            
		INSERT INTO @tvpCustomerMaterialSalesPlannings
		SELECT NULL
			,[MonthYear]
			,[CustomerCode]
			,[MaterialCode]
			,[Quantity]
			,[Amount]
			,[AccountCode]
			,CASE 
				WHEN Quantity = 0
					THEN 0
				ELSE ISNULL(Amount, 0) / nullif(Quantity, 0)
				END AS Price
		FROM MST_ResultSales
		WHERE AccountCode IS NOT NULL
			AND MaterialCode IS NOT NULL
			AND [CustomerCode] IS NOT NULL
			AND [MonthYear] >= @resultMonthYear
			AND SalesOrganizationCode = 1000;

		MERGE [dbo].[TRNSalesPlanning] AS Target
		USING @tvpCustomerMaterialSalesPlannings AS Source
			ON Source.[MonthYear] = Target.[MonthYear]
				AND Source.[CustomerCode] = Target.[CustomerCode]
				AND Source.[MaterialCode] = Target.[MaterialCode]
				AND Source.[AccountCode] = Target.[AccountCode]
				-- For Insert            
		WHEN NOT MATCHED BY Target
			THEN
				INSERT (
					[MonthYear]
					,[CustomerCode]
					,[MaterialCode]
					,[Quantity]
					,[Amount]
					,[AccountCode]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					,Price
					)
				VALUES (
					Source.[MonthYear]
					,Source.[CustomerCode]
					,Source.[MaterialCode]
					,Source.[Quantity]
					,Source.[Amount]
					,Source.[AccountCode]
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
					,Source.[Price]
					)
					-- For Updates            
		WHEN MATCHED
			THEN
				UPDATE
				SET Target.[Quantity] = Source.[Quantity]
					,Target.[Price] = Source.[Price]
					,Target.[UpdatedDate] = GETDATE()
					,Target.[UpdatedBy] = @userId;

		COMMIT;
	END TRY

	BEGIN CATCH
		ROLLBACK;
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertAdjustmentEntryDetails_del]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_InsertAdjustmentEntryDetails_del]  
(  
    -- Add the parameters for the stored procedure here  
  @ID int  
)  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET NOCOUNT ON  
  
    -- Insert statements for procedure here  
    select 1  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_InsertSNSEntryDetails-del]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SP_InsertSNSEntryDetails-del]
(
    -- Add the parameters for the stored procedure here
  @ID int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    select 1
END
GO
/****** Object:  StoredProcedure [dbo].[SP_LockPSI]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_LockPSI] @CountryId VARCHAR(max) = NULL
AS
BEGIN
	SELECT LockPSIId
		,l.UserId
		,OPSI_Upload AS OPSI
		,COG_Upload AS COG
		,O_LockMonthConfirm
		,OC_IndicationMonth
		,BP_Upload_DirectSale
		,BP_Upload_SNS
		,BP_COG_Upload
		,ADJ_Upload AS ADJ
		,SSD_Upload AS SSD
		,SNS_Sales_Upload AS SNS
		,Forecast_Projection
		,u.Name
		,STRING_AGG(p.CountryId, ',') AS CountryIds
		,SNS_Planning
	FROM LockPSI l
	INNER JOIN Users u ON l.UserId = u.UserId
	LEFT JOIN UserProfileView p ON u.UserId = p.UserId
	WHERE @CountryId IS NULL
		OR CountryId IN (
			SELECT value
			FROM STRING_SPLIT(@CountryId, ',')
			)
	GROUP BY LockPSIId
		,l.UserId
		,OPSI_Upload
		,COG_Upload
		,O_LockMonthConfirm
		,OC_IndicationMonth
		,BP_Upload_DirectSale
		,BP_Upload_SNS
		,BP_COG_Upload
		,ADJ_Upload
		,SSD_Upload
		,SNS_Sales_Upload
		,Forecast_Projection
		,u.Name
		,SNS_Planning
END
GO
/****** Object:  StoredProcedure [dbo].[sp_NonConsolidateReport]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NonConsolidateReport] (      
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY      
 ,@Mg VARCHAR(20)      
 ,@MG1 VARCHAR(20)      
 ,@SalesSubType VARCHAR(30)      
 ,@ColumnType VARCHAR(50)      
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY      
 )      
AS      
BEGIN      
 DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];      
      
 --Last Month            
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyLM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LM_O_QTY      
   ,LM_P_QTY      
   ,LM_S_QTY      
   ,LM_I_QTY      
   ,LM_O_AMT      
   ,LM_P_AMT      
   ,LM_S_AMT      
   ,LM_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_LM_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyLM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType;      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPLM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LM_O_QTY      
   ,LM_P_QTY      
   ,LM_S_QTY      
   ,LM_I_QTY      
   ,LM_O_AMT      
   ,LM_P_AMT      
   ,LM_S_AMT      
   ,LM_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPLM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 --Last Year            
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyLY'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LY_O_QTY      
   ,LY_P_QTY      
   ,LY_S_QTY      
   ,LY_I_QTY      
   ,LY_O_AMT      
   ,LY_P_AMT      
   ,LY_S_AMT      
   ,LY_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]   
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyLY'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
   FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPLY'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LY_O_QTY      
   ,LY_P_QTY      
   ,LY_S_QTY      
   ,LY_I_QTY      
   ,LY_O_AMT      
   ,LY_P_AMT      
   ,LY_S_AMT      
   ,LY_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPLY'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 --BPBP            
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPBP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,BP_O_QTY      
   ,BP_P_QTY      
   ,BP_S_QTY      
   ,BP_I_QTY      
   ,BP_O_AMT      
   ,BP_P_AMT      
   ,BP_S_AMT      
   ,BP_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPBP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyAgeing'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,Age30      
   ,Age60      
   ,Age90      
   ,Age120      
   ,Age150      
   ,Age180      
   ,Age180Greatherthan      
   ,Age30Amt      
   ,Age60Amt      
   ,Age90Amt      
   ,Age120Amt      
   ,Age150Amt      
   ,Age180Amt      
   ,Age180greatherthanAmt      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,Age30      
   ,Age60      
   ,Age90      
   ,Age120      
   ,Age150      
   ,Age180      
   ,Age180Greatherthan      
   ,Age30Amt      
   ,Age60Amt      
   ,Age90Amt      
   ,Age120Amt      
   ,Age150Amt      
   ,Age180Amt      
   ,Age180greatherthanAmt      
  FROM VW_AGEING_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyAgeing'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyBP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,BP_O_QTY      
   ,BP_P_QTY      
   ,BP_S_QTY      
   ,BP_I_QTY      
   ,BP_O_AMT      
   ,BP_P_AMT      
   ,BP_S_AMT      
   ,BP_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyBP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'CM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY     
   ,TOT_O_QTY    
   ,MPO_QTY    
   ,ADJ_QTY    
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
   ,MPO_AMT    
   ,ADJ_AMT    
   ,TOT_O_AMT  
   ,NEXT_MON_SALES  
   ,NEXT_MON_SALES_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY     
   ,TOT_O_QTY    
   ,MPO_QTY    
   ,ADJ_QTY    
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT      
   ,MPO_AMT    
   ,ADJ_AMT    
   ,TOT_O_AMT    
   , NEXT_MON_SALES   
   , NEXT_MON_SALES_AMT  
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'CM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
 ELSE IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY     
   ,TOT_O_QTY    
   ,MPO_QTY    
   ,ADJ_QTY    
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT     
   ,MPO_AMT    
   ,ADJ_AMT    
   ,TOT_O_AMT 
   , NEXT_MON_SALES   
   , NEXT_MON_SALES_AMT 
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,TOT_O_QTY    
   ,MPO_QTY    
   ,ADJ_QTY    
   ,O_AMT      
   ,P_AMT      
   ,S_AMT      
   ,I_AMT     
   ,MPO_AMT    
   ,ADJ_AMT    
   ,TOT_O_AMT 
   ,NEXT_MON_SALES   
   ,NEXT_MON_SALES_AMT
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 SELECT *      
 FROM @TVPCONSOLIDATELIST;      
END 
GO
/****** Object:  StoredProcedure [dbo].[sp_NonConsolidateReportUSD]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_NonConsolidateReportUSD] (      
 @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY      
 ,@Mg VARCHAR(20)      
 ,@MG1 VARCHAR(20)      
 ,@SalesSubType VARCHAR(30)      
 ,@ColumnType VARCHAR(50)      
 ,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY      
 )      
AS      
BEGIN      
 DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_NONCONSOLIDATE_LIST];      
      
 --Last Month              
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyLM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LM_O_QTY      
   ,LM_P_QTY      
   ,LM_S_QTY      
   ,LM_I_QTY      
   ,LM_O_AMT      
   ,LM_P_AMT      
   ,LM_S_AMT      
   ,LM_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_LM_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyLM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPLM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LM_O_QTY      
   ,LM_P_QTY      
   ,LM_S_QTY      
   ,LM_I_QTY      
   ,LM_O_AMT      
   ,LM_P_AMT      
   ,LM_S_AMT      
   ,LM_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPLM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 --Last Year              
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyLY'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LY_O_QTY      
   ,LY_P_QTY      
   ,LY_S_QTY      
   ,LY_I_QTY      
   ,LY_O_AMT      
   ,LY_P_AMT      
   ,LY_S_AMT      
   ,LY_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyLY'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPLY'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,LY_O_QTY      
   ,LY_P_QTY      
   ,LY_S_QTY      
   ,LY_I_QTY      
   ,LY_O_AMT      
   ,LY_P_AMT      
   ,LY_S_AMT      
   ,LY_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_LY_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPLY'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 --BPBP              
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BPBP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,BP_O_QTY      
   ,BP_P_QTY      
   ,BP_S_QTY      
   ,BP_I_QTY      
   ,BP_O_AMT      
   ,BP_P_AMT      
   ,BP_S_AMT      
   ,BP_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BPBP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
  IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'BP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
      ,O_QTY          
   ,P_QTY          
   ,S_QTY          
   ,I_QTY         
   ,TOT_O_QTY        
   ,MPO_QTY        
   ,ADJ_QTY        
   ,O_AMT          
   ,P_AMT          
   ,S_AMT          
   ,I_AMT         
   ,MPO_AMT        
   ,ADJ_AMT        
   ,TOT_O_AMT     
   ,NEXT_MON_SALES       
   ,NEXT_MON_SALES_AMT     
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,TOT_O_QTY        
   ,MPO_QTY        
   ,ADJ_QTY     
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT    
   ,dbo.UDF_GetUSDByAmount(MPO_AMT, Currency) AS MPO_AMT      
   ,dbo.UDF_GetUSDByAmount(ADJ_AMT, Currency) AS ADJ_AMT      
   ,dbo.UDF_GetUSDByAmount(TOT_O_AMT, Currency) AS TOT_O_AMT     
   ,dbo.UDF_GetUSDByAmount(NEXT_MON_SALES, Currency) AS NEXT_MON_SALES      
   ,dbo.UDF_GetUSDByAmount(NEXT_MON_SALES_AMT, Currency) AS NEXT_MON_SALES_AMT      
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'BP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyBP'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,BP_O_QTY      
   ,BP_P_QTY      
   ,BP_S_QTY      
   ,BP_I_QTY      
   ,BP_O_AMT      
   ,BP_P_AMT      
   ,BP_S_AMT      
   ,BP_I_AMT      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyBP'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
  IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'CM'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,O_QTY          
   ,P_QTY          
   ,S_QTY          
   ,I_QTY         
   ,TOT_O_QTY        
   ,MPO_QTY        
   ,ADJ_QTY        
   ,O_AMT          
   ,P_AMT          
   ,S_AMT          
   ,I_AMT         
   ,MPO_AMT        
   ,ADJ_AMT        
   ,TOT_O_AMT     
   ,NEXT_MON_SALES       
   ,NEXT_MON_SALES_AMT     
       
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,O_QTY      
   ,P_QTY      
   ,S_QTY      
   ,I_QTY      
   ,TOT_O_QTY        
   ,MPO_QTY        
   ,ADJ_QTY     
   ,dbo.UDF_GetUSDByAmount(O_AMT, Currency) AS O_AMT      
   ,dbo.UDF_GetUSDByAmount(P_AMT, Currency) AS P_AMT      
   ,dbo.UDF_GetUSDByAmount(S_AMT, Currency) AS S_AMT      
   ,dbo.UDF_GetUSDByAmount(I_AMT, Currency) AS I_AMT      
   ,dbo.UDF_GetUSDByAmount(MPO_AMT, Currency) AS MPO_AMT      
   ,dbo.UDF_GetUSDByAmount(ADJ_AMT, Currency) AS ADJ_AMT      
   ,dbo.UDF_GetUSDByAmount(TOT_O_AMT, Currency) AS TOT_O_AMT    
   ,(CASE when NEXT_MON_SALES=0 then 0 else dbo.UDF_GetUSDByAmount(NEXT_MON_SALES, Currency)end) AS NEXT_MON_SALES      
   ,(CASE when NEXT_MON_SALES_AMT=0 then 0 else dbo.UDF_GetUSDByAmount(NEXT_MON_SALES_AMT, Currency)end) AS NEXT_MON_SALES_AMT      
  FROM VW_CM_BP_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'CM'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 IF (      
   (      
    SELECT COUNT(*)      
    FROM @TVP_MonthYear_LIST      
    WHERE [type] = 'MonthlyAgeing'      
    ) > 1      
   )      
 BEGIN      
  INSERT INTO @TVPCONSOLIDATELIST (      
   Department      
   ,CustomerCode      
   ,Country      
   ,SalesOffice      
   ,SalesType      
   ,Consignee      
   ,Group_Desc      
   ,SubGroup      
   ,[Type]      
   ,MaterialCode      
   ,MonthYear      
   ,Age30      
   ,Age60      
   ,Age90      
   ,Age120      
   ,Age150      
   ,Age180      
   ,Age180Greatherthan      
   ,Age30Amt      
   ,Age60Amt      
   ,Age90Amt      
   ,Age120Amt      
   ,Age150Amt      
   ,Age180Amt      
   ,Age180greatherthanAmt      
   )      
  SELECT DISTINCT DepartmentName AS Department      
   ,CustomerCode      
   ,CountryName AS Country      
   ,SalesOfficeName AS SalesOffice      
   ,SalesType      
   ,Consignee      
   ,MG AS GROUP_DESC      
   ,MG1 AS SubGroup      
   ,MG2 AS [Type]      
   ,MaterialCode      
   ,C.MonthYear      
   ,Age30      
   ,Age60      
   ,Age90      
   ,Age120      
   ,Age150      
   ,Age180      
   ,Age180Greatherthan      
   ,Age30Amt      
   ,Age60Amt      
   ,Age90Amt      
   ,Age120Amt      
   ,Age150Amt      
   ,Age180Amt      
   ,Age180greatherthanAmt      
  FROM VW_AGEING_NonConsolidatedReport c      
  INNER JOIN @TVP_MonthYear_LIST m ON c.MonthYear = m.MONTHYEAR      
  WHERE m.[type] = 'MonthlyAgeing'      
   AND CustomerCode IN (      
    SELECT [CustomerCode]      
    FROM @TVP_CUSTOMERCODE_LIST      
    )      
   AND ProductCategoryCode1 = @Mg      
   AND ProductCategoryCode2 = @MG1      
   AND c.SaleSubType = @SalesSubType      
 END      
      
 SELECT *      
 FROM @TVPCONSOLIDATELIST;      
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_OcIndicationMonthConfirm]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_OcIndicationMonthConfirm] @CompanyId VARCHAR(max) = NULL
	,@CountryId VARCHAR(max) = NULL
	,@CustomerId VARCHAR(max) = NULL
	,@ProductCategoryId1 VARCHAR(max) = NULL
	,@ProductCategoryId2 VARCHAR(max) = NULL
	,@MonthYear VARCHAR(200) = NULL
	,@CustomerTypeId VARCHAR(max) = NULL
AS
BEGIN
	WITH CTE_tbl as             (
		SELECT OP.MonthYear
		,OP.SalesEntryPriceQuantityId
		,OP.ocIndicationMonthAttachmentIds
		,OP.Remarks
		,h.SaleTypeId
		,OP.OcIndicationMonthStatus
		,(
			CASE 
				WHEN se.ModeOfTypeId = 1
					THEN OP.Quantity
				END
			) AS OrderQunatity
		,(
			CASE 
				WHEN se.ModeOfTypeId = 12
					THEN OP.Quantity
				END
			) AS SNSQunatity
		,0 AS TotalQunatity
		,(
			CASE 
				WHEN se.ModeOfTypeId = 1
					THEN OP.Price
				END
			) AS OrderPrice
		,(
			CASE 
				WHEN se.ModeOfTypeId = 12
					THEN OP.Price
				END
			) AS SNSPrice
		,(
			CASE 
				WHEN se.ModeOfTypeId = 12
					THEN OP.Price
				END
			) AS TotalPrice
		,se.SalesEntryId
		,OP.Reason
		,h.CustomerId
		,m.CompanyId
		,c.CountryId
		,c.CustomerCode
		,C.IsCollabo
		,c.CustomerName
		,m.MaterialCode
		,h.ProductCategoryId1
		,h.ProductCategoryId2
		,p1.ProductCategoryCode + '-' + p1.ProductCategoryName AS Mg
		,p2.ProductCategoryCode + '-' + p2.ProductCategoryName AS Mg1
		,OP.IsSNS
		,ROW_NUMBER() OVER (
			PARTITION BY m.MaterialCode
			,h.CustomerId
			,OP.MonthYear ORDER BY se.SalesEntryId  DESC
			) AS rownumber FROM SaleEntryHeader h LEFT JOIN SalesEntry se ON h.SaleEntryHeaderId = se.SaleEntryHeaderId 
			INNER JOIN SalesEntryPriceQuantity OP ON se.SalesEntryId = OP.SalesEntryId JOIN Customer c 
			ON h.CustomerId = c.CustomerId JOIN Material m ON se.MaterialId = m.MaterialId 
			LEFT JOIN ProductCategory p1 ON h.ProductCategoryId1 = p1.ProductCategoryId 
			LEFT JOIN ProductCategory p2 ON h.ProductCategoryId2 = p2.ProductCategoryId WHERE se.ModeofTypeId IN (1)   
		) SELECT * FROM CTE_tbl  WHERE rownumber = 1
		AND SaleTypeId = 1
		AND (
		@MonthYear IS NULL
		OR (MonthYear = @MonthYear)
		)
		AND (
		@CompanyId IS NULL
		OR CompanyId IN (
			SELECT value
			FROM STRING_SPLIT(@CompanyId, ',')
			)
		)
		AND (
		@CountryId IS NULL
		OR CountryId IN (
			SELECT value
			FROM STRING_SPLIT(@CountryId, ',')
			)
		)
		AND (
		@CustomerTypeId IS NULL
		OR IsCollabo = @CustomerTypeId
		)
		AND (
		@CustomerId IS NULL
		OR CustomerId IN (
			SELECT value
			FROM STRING_SPLIT(@CustomerId, ',')
			)
		)
		AND (
		@ProductCategoryId1 IS NULL
		OR ProductCategoryId1 IN (
			SELECT value
			FROM STRING_SPLIT(@ProductCategoryId1, ',')
			)
		)
		AND (
		@ProductCategoryId2 IS NULL
		OR ProductCategoryId2 IN (
			SELECT value
			FROM STRING_SPLIT(@ProductCategoryId2, ',')
			)
		)



	END
GO
/****** Object:  StoredProcedure [dbo].[SP_OcoLockMonth_del]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
--exec SP_OcoLockMonth NULL,15,2,4,50,'202306,202305'    
CREATE Procedure [dbo].[SP_OcoLockMonth_del]                           
@CountryId varchar(max) =NULL,                              
@CustomerId varchar(max) =NULL,      
@CustomerTypeId varchar(max) =NULL,      
@ProductCategoryId1 varchar(max) =NULL,                              
@ProductCategoryId2 varchar(max) =NULL,    
@MonthYear varchar(200)=NULL      
as begin        
with CTE_tbl as                                 
(  
select OP.MonthYear as MonthYear,      
(case when OP.OCstatus='N' then  OP.Quantity end) as CurrentMonthQty,    
(case when OP.OCstatus='Y' then  OP.Quantity end) as ConfirmedQty,    
(case when OP.OCstatus='Y' then  OP.Quantity end) as LockConfirmedQty,    
(case when OP.OCstatus='N' then  OP.Quantity end) as LockCurrentQty,    
LAG((case when OP.OCstatus='N' then  OP.Quantity end),1) OVER (PARTITION BY OP.SalesEntryId ORDER BY OP.SalesEntryId)    
- (case when OP.OCstatus='Y' then  OP.Quantity end) [Difference],    
se.SalesEntryId,    
c.CustomerCode,                  
c.CustomerName,                  
m.MaterialCode,              
p1.ProductCategoryName as Mg,                  
p2.ProductCategoryName as Mg1,      
OP.IsSNS    ,  
h.CustomerId,                          
m.CompanyId,                          
c.CountryId,                              
h.ProductCategoryId1,                          
h.ProductCategoryId2,  
c.IsCollabo  
from SalesEntry se                
left join SaleEntryHeader h                      
on h.SaleEntryHeaderId=se.SaleEntryHeaderId                   
inner join SalesEntryPriceQuantity OP                        
on se.SalesEntryId=OP.SalesEntryId                
join Customer c on h.CustomerId=c.CustomerId                      
join  Material m on se.MaterialId=m.MaterialId                      
Left join  ProductCategory p1 on h.ProductCategoryId1=p1.ProductCategoryId                      
Left join  ProductCategory p2 on h.ProductCategoryId2=p2.ProductCategoryId       
 where   se.ModeofTypeId in (1,12))select * FROM CTE_tbl where    
    MonthYear in (SELECT value FROM STRING_SPLIT(@MonthYear, ',')) and                      
 (nullif(@CountryId,'') is NULL or CountryId=@CountryId) and                      
 (nullif(@CustomerTypeId,'') is NULL or Cast(IsCollabo as int )=@CustomerTypeId) and                       
(nullif(@CustomerId,'') is NULL or CustomerId=@CustomerId) and                       
(nullif(@ProductCategoryId1,'') is NULL or ProductCategoryId1=@ProductCategoryId1)and        
(nullif(@ProductCategoryId2,'') is NULL or ProductCategoryId2 =@ProductCategoryId2)       
end       
      
GO
/****** Object:  StoredProcedure [dbo].[SP_ResponseResult]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SP_ResponseResult]  
(  
    -- Add the parameters for the stored procedure here  
  @ID int  
)  
AS  
BEGIN  
    -- SET NOCOUNT ON added to prevent extra result sets from  
    -- interfering with SELECT statements.  
    SET NOCOUNT ON  
  
    -- Insert statements for procedure here  
    select 1  
END  
GO
/****** Object:  StoredProcedure [dbo].[SP_SalesEntryOCConfirmation]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SP_SalesEntryOCConfirmation] @CountryId VARCHAR(max) = NULL
	,@CustomerId VARCHAR(max) = NULL
	,@CustomerTypeId VARCHAR(max) = NULL
	,@ProductCategoryId1 VARCHAR(max) = NULL
	,@ProductCategoryId2 VARCHAR(max) = NULL
	,@MonthYear VARCHAR(200) = NULL
AS
BEGIN
		;

	WITH data_withNo
	AS (
		SELECT PQ.OCstatus
			,PQ.SalesEntryPriceQuantityId
			,PQ.SalesEntryId
			,PQ.MonthYear
			,PQ.Price
			,PQ.Quantity
			,SE.SaleEntryHeaderId
			,SH.CustomerId
			,SE.MaterialId
			,SH.ProductCategoryId1
			,SH.ProductCategoryId2
			,SE.ModeOfTypeId
			,ROW_NUMBER() OVER (
				PARTITION BY SH.CustomerId
				,SE.MaterialId
				,PQ.MonthYear
				,PQ.OCstatus
				,SE.ModeOfTypeId ORDER BY SH.CreatedDate DESC
				) AS ROWNumber
		FROM dbo.SalesEntryPriceQuantity PQ
		JOIN dbo.SalesEntry SE ON PQ.SalesEntryId = SE.SalesEntryId
		JOIN SaleEntryHeader SH ON SE.SaleEntryHeaderId = SH.SaleEntryHeaderId
		WHERE ModeOfTypeId IN (
				1
				,12
				)
			AND PQ.OCStatus = 'N'
			AND MonthYear IN (
				SELECT value
				FROM STRING_SPLIT(@MonthYear, ',')
				)
		)
		,data_withYes
	AS (
		SELECT PQ.OCstatus
			,PQ.SalesEntryPriceQuantityId
			,PQ.SalesEntryId
			,PQ.MonthYear
			,PQ.Price
			,PQ.Quantity
			,SE.SaleEntryHeaderId
			,SH.CustomerId
			,SE.MaterialId
			,SH.ProductCategoryId1
			,SH.ProductCategoryId2
			,SE.ModeOfTypeId
			,ROW_NUMBER() OVER (
				PARTITION BY SH.CustomerId
				,SE.MaterialId
				,PQ.MonthYear
				,PQ.OCstatus
				,SE.ModeOfTypeId ORDER BY SH.CreatedDate DESC
				) AS ROWNumber
		FROM dbo.SalesEntryPriceQuantity PQ
		JOIN dbo.SalesEntry SE ON PQ.SalesEntryId = SE.SalesEntryId
		JOIN SaleEntryHeader SH ON SE.SaleEntryHeaderId = SH.SaleEntryHeaderId
		WHERE ModeOfTypeId IN (
				1
				,12
				)
			AND PQ.OCStatus = 'Y'
			AND MonthYear IN (
				SELECT value
				FROM STRING_SPLIT(@MonthYear, ',')
				)
		)
		,data_Archived
	AS (
		SELECT PQ.OCstatus
			,PQ.SalesArchivalEntryPriceQuantityId
			,PQ.SalesArchivalEntryId
			,PQ.MonthYear
			,PQ.Price
			,PQ.Quantity
			,SE.SaleEntryArchivalHeaderId
			,SH.CustomerId
			,SE.MaterialId
			,SH.ProductCategoryId1
			,SH.ProductCategoryId2
			,SE.ModeOfTypeId
			,ROW_NUMBER() OVER (
				PARTITION BY SH.CustomerId
				,SE.MaterialId
				,PQ.MonthYear
				,PQ.OCstatus
				,SE.ModeOfTypeId ORDER BY SH.CreatedDate DESC
				) AS ROWNumber
		FROM dbo.SalesArchivalEntryPriceQuantity PQ
		JOIN dbo.SalesArchivalEntry SE ON PQ.SalesArchivalEntryId = SE.SalesArchivalEntryId
		JOIN SaleEntryArchivalHeader SH ON SE.SaleEntryArchivalHeaderId = SH.SaleEntryArchivalHeaderId
		WHERE ModeOfTypeId IN (
				1
				,12
				)
			AND MonthYear IN (
				SELECT value
				FROM STRING_SPLIT(@MonthYear, ',')
				)
			AND PQ.OCStatus = 'Y'
		)
	SELECT A.OCstatus
		,A.SalesEntryPriceQuantityId
		,A.SalesEntryId
		,A.MonthYear
		,A.Price
		,A.Quantity AS CurrentMonthQty
		,B.Quantity AS ConfirmedQty
		,A.Quantity - (COALESCE(B.Quantity, ARCH.Quantity)) AS Differences
		,A.SaleEntryHeaderId
		,A.CustomerId
		,A.MaterialId
		,B.SaleEntryHeaderId AS OldSaleEntryHeaderId
		,B.SalesEntryPriceQuantityId AS OldPriceQtyId
		,B.SalesEntryId AS OldSaleEntryId
		,p1.ProductCategoryCode + '-' + p1.ProductCategoryName AS Mg
		,p2.ProductCategoryCode + '-' + p2.ProductCategoryName AS Mg1
		,CUST.CustomerCode
		,CUST.CustomerName
		,M.MaterialCode
		,CUST.IsCollabo
		,MT.ModeofTypeName
	FROM data_withNo A
	INNER JOIN data_withYes B ON A.CustomerId = B.CustomerId
		AND B.ROWNumber = 1
		AND A.MaterialId = B.MaterialId
		AND A.ModeOfTypeId = B.ModeOfTypeId
		AND A.MonthYear = B.MonthYear
	JOIN Customer CUST ON A.CustomerId = CUST.CustomerId
	JOIN Material M ON A.MaterialId = m.MaterialId
	LEFT JOIN ProductCategory p1 ON A.ProductCategoryId1 = p1.ProductCategoryId
	LEFT JOIN ProductCategory p2 ON A.ProductCategoryId2 = p2.ProductCategoryId
	LEFT JOIN ModeofType MT ON A.ModeOfTypeId = MT.ModeofTypeId
	LEFT JOIN data_Archived ARCH ON A.CustomerId = ARCH.CustomerId
		AND ARCH.ROWNumber = 1
		AND A.MaterialId = ARCH.MaterialId
		AND A.ModeOfTypeId = ARCH.ModeOfTypeId
		AND A.MonthYear = ARCH.MonthYear
	WHERE A.ROWNumber = 1
		AND A.Quantity - (COALESCE(B.Quantity, ARCH.Quantity)) != 0
		AND A.MonthYear IN (
			SELECT value
			FROM STRING_SPLIT(@MonthYear, ',')
			)
		AND (
			@CustomerTypeId IS NULL
			OR CUST.IsCollabo IN (
				SELECT value
				FROM STRING_SPLIT(@CustomerTypeId, ',')
				)
			)
		AND (
			@CountryId IS NULL
			OR CUST.CountryId IN (
				SELECT value
				FROM STRING_SPLIT(@CountryId, ',')
				)
			)
		AND (
			@CustomerId IS NULL
			OR CUST.CustomerId IN (
				SELECT value
				FROM STRING_SPLIT(@CustomerId, ',')
				)
			)
		AND (
			@ProductCategoryId1 IS NULL
			OR A.ProductCategoryId1 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId1, ',')
				)
			)
		AND (
			@ProductCategoryId2 IS NULL
			OR A.ProductCategoryId2 IN (
				SELECT value
				FROM STRING_SPLIT(@ProductCategoryId2, ',')
				)
			)
		--(nullif(@CountryId,'') is NULL or CUST.CountryId=@CountryId) and                            
		--(nullif(@CustomerTypeId,'') is NULL or CUST.IsCollabo=@CustomerTypeId) and                             
		--(nullif(@CustomerId,'') is NULL or CUST.CustomerId=@CustomerId) and                             
		--(nullif(@ProductCategoryId1,'') is NULL or A.ProductCategoryId1=@ProductCategoryId1) and              
		--(nullif(@ProductCategoryId2,'') is NULL or A.ProductCategoryId2 =@ProductCategoryId2)          
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_TransmissionLCustomer]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_TransmissionLCustomer] @Type VARCHAR(10)
AS
BEGIN
	SELECT DISTINCT c.CustomerName
		,c.CustomerCode
	FROM TransmissionList t
	LEFT JOIN Customer c ON t.CustomerCode = c.CustomerCode
	LEFT JOIN TransmissionPlanType p ON t.PlanTypeCode = p.PlanTypeCode
	WHERE t.IsActive = 1
		AND t.SalesType = @Type
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_TransmissionListCustomer]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[Sp_TransmissionListCustomer] @Type VARCHAR(10)
AS
BEGIN
	SELECT DISTINCT c.CustomerName
		,c.CustomerCode
	FROM TransmissionList t
	LEFT JOIN Customer c ON t.CustomerCode = c.CustomerCode
	LEFT JOIN TransmissionPlanType p ON t.PlanTypeCode = p.PlanTypeCode
	WHERE t.IsActive = 1
		AND t.SalesType = @Type
END
GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateConsinee]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE [dbo].[Sp_UpdateConsinee]      
@userId nvarchar(200),      
@accountCode nvarchar(100)=null,      
@currentMonth int ,  
@lockMonth int ,  
@resultMonth int ,  
@forecasteMonth int  
AS      
BEGIN      
 SET NOCOUNT ON;        
      
        
 EXEC SP_Insert_TRNPricePlanning @userId ,  
 @currentMonth,@lockMonth, @resultMonth,@forecasteMonth  
      
-- For sending Account code and Material code Table datatype    
-- Need to discuss this thing. But for now only testing    
    
Declare @tmp TVP_ACCOUNT_MATERIAL_CODE_LIST;    
Insert into @tmp(AccountCode,MaterialCode)    
values(@accountCode,'')    
    
-- end--    
    
 EXEC SP_Calculate_RollingInventory @userId, @tmp      
      
 select TRNPricePlanningId,AccountCode,MonthYear,MaterialCode,ModeOfType from TRNPricePlanning where MonthYear=@currentMonth      
      
END 
GO
/****** Object:  StoredProcedure [dbo].[SP_Validate_Sales_Entries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Validate_Sales_Entries] (
	@customerId INT
	,@tvpCustomerWithCurrency [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY] READONLY
	,@tvpSaleEntryHeader dbo.TVP_SALES_ENTRY_HEADERS READONLY
	,@tvpSalesQtyPrices dbo.TVP_SALES_ENTRY_QTY_PRICES READONLY
	)
AS
BEGIN
	DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;

	SET NOCOUNT ON;

	BEGIN TRY
		--BEGIN TRANSACTION;  
		DECLARE @CustomerCount INT = 0;

		SELECT @CustomerCount = count(1)
		FROM @tvpCustomerWithCurrency;

		IF @CustomerCount = 0
		BEGIN
			INSERT INTO @ResultTable
			SELECT 0
				,101
				,'Customer is not valid';
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT TOP 1 1
					FROM @tvpCustomerWithCurrency
					WHERE [CurrencyId] IS NULL
					)
			BEGIN
				INSERT INTO @ResultTable
				SELECT 0
					,102
					,'Currency is not available for the Customer/Country';
			END
		END

		DECLARE @DuplicateMaterials AS [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM];

		-- CHECK ITEM CODE IS PRESENT IN DB  
		--IF EXISTS(SELECT TOP 1 1 FROM  @tvpSaleEntryHeader WHERE ItemCodeId IS NULL)  
		INSERT INTO @ResultTable
		SELECT RowIndex + 1
			,104
			,'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + ItemCode + ' is not valid Item_Code.'
		FROM @tvpSaleEntryHeader
		WHERE ItemCodeId IS NULL;

		-- CHECK TYPE CODE IS PRESENT IN DB  
		--IF EXISTS(SELECT TOP 1 1 FROM @tvpSaleEntryHeader WHERE TypeCodeId IS NULL)  
		INSERT INTO @ResultTable
		SELECT RowIndex + 1
			,105
			,'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + TypeCode + ' is not valid Type.'
		FROM @tvpSaleEntryHeader
		WHERE TypeCodeId IS NULL;

		-- CHECK DUPLICATE  
		INSERT INTO @DuplicateMaterials
		SELECT ItemCode
			,TypeCode
			,COUNT(*)
		FROM @tvpSaleEntryHeader
		GROUP BY ItemCode
			,TypeCode
		HAVING COUNT(*) > 1;

		--IF EXISTS(SELECT TOP 1 1 FROM @DuplicateMaterials)  
		INSERT INTO @ResultTable
		SELECT 0
			,106
			,'Item_Code: ' + ItemCode + ' with Type: ' + TypeCode + ' found ' + CONVERT(VARCHAR(10), DuplicateCount) + ' times.'
		FROM @DuplicateMaterials;
			/*IF @@TRANCOUNT > 0  
   COMMIT;*/
	END TRY

	BEGIN CATCH
		/*IF @@TRANCOUNT > 0  
                ROLLBACK;*/
		INSERT INTO @ResultTable
		VALUES (
			0
			,500
			,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()
			);
	END CATCH;

	DELETE @DuplicateMaterials;

	SELECT DISTINCT RowNo
		,ResponseCode
		,ResponseMessage
	FROM @ResultTable;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Validate_SSD_Entries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_Validate_SSD_Entries] (@tvpSSDEntries dbo.[TVP_SSD_ENTRIES] READONLY)
AS
BEGIN
	DECLARE @ResultTable AS dbo.TVP_RESULT_TABLE;

	SET NOCOUNT ON;

	BEGIN TRY
		--BEGIN TRANSACTION;
		DECLARE @tempDuplicateMaterials AS [dbo].[TVP_SSD_ENTRY_DUPLICATE_ITEM];

		-- CHECK CUSTOMER CODE IS PRESENT IN DB
		INSERT INTO @ResultTable
		SELECT RowIndex + 1
			,104
			,'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + [MaterialCode] + ' is not valid Model No.'
		FROM @tvpSSDEntries
		WHERE [MaterialId] IS NULL;

		-- CHECK TYPE CODE IS PRESENT IN DB
		INSERT INTO @ResultTable
		SELECT RowIndex + 1
			,104
			,'RowNo: ' + CAST(RowIndex + 1 AS VARCHAR(10)) + ': ' + [CustomerCode] + ' is not valid Customer.'
		FROM @tvpSSDEntries
		WHERE [CustomerId] IS NULL;

		-- CHECK DUPLICATE
		INSERT INTO @tempDuplicateMaterials
		SELECT [MaterialCode]
			,[CustomerCode]
			,COUNT(*)
		FROM @tvpSSDEntries
		GROUP BY [MaterialCode]
			,[CustomerCode]
		HAVING COUNT(*) > 1;

		INSERT INTO @ResultTable
		SELECT 0
			,106
			,'Model No: ' + [MaterialCode] + ' with Customer: ' + [CustomerCode] + ' found ' + CONVERT(VARCHAR(10), DuplicateCount) + ' times.'
		FROM @tempDuplicateMaterials;
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable
		VALUES (
			0
			,500
			,'Exception: ' + ERROR_MESSAGE() + ' at ' + ERROR_LINE()
			);
	END CATCH;

	DELETE @tempDuplicateMaterials;

	SELECT DISTINCT RowNo
		,ResponseCode
		,ResponseMessage
	FROM @ResultTable;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Consolidated_Process_BACKUP_30062023]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
-- EXEC USP_Consolidated_Process   'Monthly','202304' , 'test' 
CREATE PROCEDURE [dbo].[USP_Consolidated_Process_BACKUP_30062023]    
 -- Add the parameters for the stored procedure here    
 @Type VARCHAR(20),
 @CurrentMonth INT,
 @CreatedBy varchar(max)
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
    -- Insert statements for procedure here    
    
       
 --DECLARE @CurrentMonth Varchar(10);        
 DECLARE @CurrentMonthDate Varchar(10);        
 -- SET @CurrentMonth = ( SELECT ConfigValue FROM GlobalConfig where ConfigKey='Current_Month');        
 ---- Need to get Total Month count -- Current month +5          
 SET @CurrentMonthDate =CAST(CAST( @CurrentMonth as Varchar(10))+'01' as date)        
 --DECLARE @tmpMonthData Table(MonthData INT)        
 Create Table #tmpMonthData(MonthData INT)        
 DECLARE @StartMonth INT=0;        
 DECLARE @EndMonth INT=5;-- Need 6 Month Data including Current Month        
 while @StartMonth<=@EndMonth        
 BEGIN        
   INSERT INTO #tmpMonthData(MonthData)        
   VALUES (CAST ( CONVERT(nvarchar(6), CAST(DATEADD(MONTH, @StartMonth, @CurrentMonthDate) as Date), 112) as INT))        
   set @StartMonth = @StartMonth+1        
 END;

    
CREATE TABLE #TMP    
(CustomerCode VARCHAR(50),    
CurrentMonthYear INT,    
LockMonthYear INT,    
MaterialCode VARCHAR(50),    
OCmonthYear INT,    
MonthYear INT,  
ModeOfTypeId INT,  
ModeOfTypeText Varchar(20),  
TotalPrice INT,    
TotalQuantity INT,  
PLanName Varchar(20),
SaleSequenceType Varchar(2))    
-- SELECT Customer which is TransmissionList -- Collabo    
    
 ;WITH CTECollabo(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName,SaleSequenceType)    
 AS    
 (    
 -- PURCHASE DATA  
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId,'P' As ModeText,     
 [dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode ,MonthYear) as TotalQuantity,    
 CAST( ROUND([dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) AS INT) as TotalPrice, 'DS-Collabo' as PlanName,'01' as SaleSequenceType  FROM TransmissionList TL     
 INNER JOIN  [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode=TL.CustomerCode    
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE VD.SaleSubType=@Type AND VD.ModeOfTypeId in(2)   
  
 -- SALE DATA  
 UNION  
  
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId, 'S' As ModeText,     
 [dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode ,MonthYear) as TotalQuantity,    
 CAST( ROUND([dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) AS INT) as TotalPrice,'DS-Collabo' as PlanName ,'02' as SaleSequenceType  
   
 FROM TransmissionList TL     
 INNER JOIN  [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode=TL.CustomerCode
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE VD.SaleSubType=@Type AND VD.ModeOfTypeId in(3)   
 -- INVENTORY DATA  
UNION   
  
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId, 'I' As ModeText,      
 0, --[dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode ,MonthYear) as TotalQuantity,    
 0,--CAST( ROUND([dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) AS INT) as TotalPrice  
 'DS-Collabo' as PlanName,'03' as SaleSequenceType  
  
 FROM TransmissionList TL     
 INNER JOIN  [dbo].[VW_DIRECT_SALE] VD ON VD.CustomerCode=TL.CustomerCode 
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE VD.SaleSubType=@Type AND VD.ModeOfTypeId in(4)   
  
 )    
 INSERT INTO #TMP(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear,ModeOfTypeId,ModeOfTypeText, TotalPrice,TotalQuantity, PLanName, SaleSequenceType )    
 SELECT CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear,  ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName, SaleSequenceType  FROM CTECollabo    
     
    
-- SELECT Customer which is not in TransmissionList -- NON Collabo    
 ;WITH CTENonCollabo(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice,PLanName,SaleSequenceType)    
 AS    
 (    
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId, 'P' as ModeText,    
 [dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode  ,MonthYear) as TotalQuantity,    
     
 CAST( ROUND( [dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) as INT) as TotalPrice,  
 'DS-NonCollabo' as PlanName,'01' as SaleSequenceType   
 FROM [dbo].[VW_DIRECT_SALE] VD     
 LEFT JOIN TransmissionList TL ON VD.CustomerCode = TL.CustomerCode
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE TL.TransmissionListId is null  AND VD.SaleSubType=@Type AND VD.ModeOfTypeId in(2)   
  
 UNION  
  
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId,    'S' as ModeText,   
 [dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode  ,MonthYear) as TotalQuantity,    
     
 CAST( ROUND( [dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) as INT) as TotalPrice,  
 'DS-NonCollabo' as PlanName,'02' as SaleSequenceType   
 FROM [dbo].[VW_DIRECT_SALE] VD     
 LEFT JOIN TransmissionList TL ON VD.CustomerCode = TL.CustomerCode   
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE TL.TransmissionListId is null  AND VD.SaleSubType=@Type AND VD.ModeOfTypeId in(3)   
  
 UNION  
  
 SELECT VD.CustomerCode,VD.CurrentMonthYear,VD.LockMonthYear,VD.MaterialCode,VD.OCmonthYear,VD.MonthYear,VD.ModeOfTypeId,    
 'I' as ModeText,  
0,-- [dbo].[UDF_GetPSQuantityValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode  ,MonthYear) as TotalQuantity,    
     
 0,--CAST( ROUND( [dbo].[UDF_GetPSValueForConsolidation]( SaleEntryHeaderId,MaterialCode,TL.CustomerCode,MonthYear),0) as INT) as TotalPrice  
 'DS-NonCollabo' as PlanName ,'03' as SaleSequenceType  
 FROM [dbo].[VW_DIRECT_SALE] VD     
 LEFT JOIN TransmissionList TL ON VD.CustomerCode = TL.CustomerCode  
 INNER  JOIN #tmpMonthData TD on TD.MonthData=VD.MonthYear
 WHERE TL.TransmissionListId is null  AND VD.SaleSubType=@Type AND VD.ModeOfTypeId in(4)   
 )    
INSERT INTO #TMP(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalPrice,TotalQuantity, PLanName,SaleSequenceType)    
SELECT CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName,SaleSequenceType FROM CTENonCollabo    
    
   
    
 -- ADJUSTMENT--    
 ;WITH CTEAdjustment(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText,
 TotalQuantity,TotalPrice, PLanName,SaleSequenceType)    
 AS    
 (    
	 
SELECT  AE.CustomerCode,0,0,AE.MaterialCode,0,AP.MonthYear,2,'P', AP.Qty, ROUND(AP.Price,0) as Price,'Adjustment', '01' as SaleSequenceType  from [dbo].[AdjustmentEntry] AE
INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP
ON AE.AdjustmentEntryId =AP.AdjustmentEntryId
INNER  JOIN #tmpMonthData TD on TD.MonthData=AP.MonthYear

UNION
SELECT  AE.CustomerCode,0,0,AE.MaterialCode,0,AP.MonthYear,3,'S', AP.Qty, ROUND(AP.Price,0) as Price,'Adjustment','02' as SaleSequenceType  from [dbo].[AdjustmentEntry] AE
INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP
ON AE.AdjustmentEntryId =AP.AdjustmentEntryId
INNER  JOIN #tmpMonthData TD on TD.MonthData=AP.MonthYear

UNION
SELECT  AE.CustomerCode,0,0,AE.MaterialCode,0,AP.MonthYear,4,'I', '0', '0','Adjustment','03' as SaleSequenceType  from [dbo].[AdjustmentEntry] AE
INNER JOIN [dbo].[AdjustmentEntryQtyPrice] AP
ON AE.AdjustmentEntryId =AP.AdjustmentEntryId
INNER  JOIN #tmpMonthData TD on TD.MonthData=AP.MonthYear

)


INSERT INTO #TMP(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalPrice,TotalQuantity, PLanName,SaleSequenceType)    
SELECT CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName,SaleSequenceType FROM CTEAdjustment    
    
   
    
 ---SSD--    
    
	 ;WITH CTESSD(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName,SaleSequenceType)    
 AS    
 (    



SELECT     SE.CustomerCode,0,0,SE.MaterialCode, 0, SP.MonthYear,2,'P', SP.Qty, ROUND((SP.Price * SP.Qty),0),'SSD' as PlanName,'01' as SaleSequenceType  FROM [dbo].[SSDEntryQtyPrice] SP
INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID= SP.SSDEntryID
INNER  JOIN #tmpMonthData TD on SP.MonthYear= TD.MonthData
 where SE.ModeOfTypeId=2
--order by SE.SSDEntryID,  MaterialCode

UNION


SELECT     SE.CustomerCode,0,0,SE.MaterialCode, 0, SP.MonthYear,2,'S', SP.Qty,ROUND((SP.Price * SP.Qty),0),'SSD' as PlanName,'02' as SaleSequenceType  FROM [dbo].[SSDEntryQtyPrice] SP
INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID= SP.SSDEntryID
INNER  JOIN #tmpMonthData TD on SP.MonthYear= TD.MonthData
 where SE.ModeOfTypeId=3


UNION

SELECT     SE.CustomerCode,0,0,SE.MaterialCode, 0, SP.MonthYear,2,'I',0,0,'SSD' as PlanName,'03' as SaleSequenceType  FROM [dbo].[SSDEntryQtyPrice] SP
INNER JOIN [dbo].[SSDEntry] SE ON SP.SSDEntryID= SP.SSDEntryID
INNER  JOIN #tmpMonthData TD on SP.MonthYear= TD.MonthData
 where SE.ModeOfTypeId=4
--order by SE.SSDEntryID,  MaterialCode
	
	)

INSERT INTO #TMP(CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalPrice,TotalQuantity, PLanName,SaleSequenceType)    
SELECT CustomerCode,CurrentMonthYear,LockMonthYear,MaterialCode,OCmonthYear,MonthYear, ModeOfTypeId,ModeOfTypeText, TotalQuantity,TotalPrice, PLanName,SaleSequenceType FROM CTESSD    
    

	-- Insert Data in Transmission data for file write              
 INSERT INTO TransmissionData(CustomerCode,MaterialCode,CurrentMonthYear,LockMonthYear,MonthYear,ModeOfTypeID,              
 Qty,Amount,SaleValue,[Plan],SaleType,SaleSequenceType,SalesSequenceTypeText,CreatedBy)              
  SELECT CustomerCode,MaterialCode,CurrentMonthYear,LockMonthYear,MonthYear,ModeOfTypeID,TotalQuantity,TotalPrice ,TotalPrice ,PLanName ,@Type,SaleSequenceType ,ModeOfTypeText,   @CreatedBy FROM #TMP order by ModeOfTypeID ,MonthYear      
         




 DROP TABLE #TMP  
    
END    
  
  
--SELECT * from ModeofType  

--SELECT * FROM TransmissionData
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSNSEntryForDownload]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_GetSNSEntryForDownload]-- NULL,NULL,NULL,NULL,NULL          
(          
@OACAccountID varchar(20)=NULL,      
@CountryID varchar(20)=NULL,      
@CustomreID varchar(20)=NULL,      
@ProductCategoryID varchar(20)=NULL,      
@ProductSubCategoryID varchar(20)=NULL   ,  
@SaleSubType varchar(20)=NULL   
)          
as          
BEGIN          
          
--select SNSEntryId, SaleTypeId,CustomerId, CustomerCode,MaterialId, MaterialCode, CategoryId,'' as CategoryCode, AttachmentID, MonthYear, OACCode , SaleSubType         
--from SNSEntry where CustomerCode=@CustomerCode          
      
select SNSEntryId,CustomerId, CustomerCode,MaterialId, MaterialCode, CategoryId,CAST(CategoryId as VARCHAR)+'-'+ProductCategoryName as CategoryCode, AttachmentID, MonthYear, OACCode , SaleSubType         
from SNS_Entries_View      
where       
AccountId=Coalesce( NULLIF(@OACAccountID,''),AccountId)      
AND CountryID=Coalesce( NULLIF(@CountryID,''),CountryID)      
AND CustomerID=Coalesce( NULLIF(@CustomreID,''),CustomerID)      
AND ProductCategoryID=Coalesce( NULLIF(@ProductSubCategoryID,''),ProductCategoryID)      
AND SaleSubType=Coalesce( NULLIF(@SaleSubType,''),SaleSubType)      
          
END   
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSNSEntryQtyPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[USP_GetSNSEntryQtyPrice]
(
@CustomerCode varchar(200)
)
as
BEGIN

select SQ.SNSEntryQtyPriceId, SE.SNSEntryId,SQ.MonthYear, Qty,Price,TotalAmount from SNSEntry SE
INNER JOIN SNSEntryQtyPrice SQ ON SE.SNSEntryId = SQ.SNSEntryId
where CustomerCode=@CustomerCode

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSNSEntryQtyPriceForDownload]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_GetSNSEntryQtyPriceForDownload] --NULL,NULL,NULL,NULL,NULL    
(    
@OACAccountID varchar(20)=NULL,
@CountryID varchar(20)=NULL,
@CustomreID varchar(20)=NULL,
@ProductCategoryID varchar(20)=NULL,
@ProductSubCategoryID varchar(20)=NULL
)    
as    
BEGIN    
 
Declare @T Table
(SNSEntryID INT,CustomerCode varchar(500),CustomerName varchar(500),MaterialCode varchar(50))
Insert into @T(SNSEntryID,CustomerCode,CustomerName,MaterialCode)
select SNSEntryID,CustomerCode, CustomerName, MaterialCode from SNS_Entries_View 
where 
AccountId=Coalesce( NULLIF(@OACAccountID,''),AccountId)
AND CountryID=Coalesce( NULLIF(@CountryID,''),CountryID)
AND CustomerID=Coalesce( NULLIF(@CustomreID,''),CustomerID)
AND ProductCategoryID=Coalesce( NULLIF(@CountryID,''),ProductCategoryID)

select T.*,SP.MonthYear,SP.Qty,SP.FinalPrice as Price,SP.Qty*SP.FinalPrice as TotalPrice from @T T
INNER JOIN SNSEntryQtyPrice SP on SP.SNSEntryId = T.SNSEntryID


    
END 



GO
/****** Object:  StoredProcedure [dbo].[USP_GetSNSEntryQtyPriceSummaryForDownload]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_GetSNSEntryQtyPriceSummaryForDownload] --2,64,nULL,NULL,NULL            
(            
@OACAccountID varchar(20)=NULL,        
@CountryID varchar(20)=NULL,        
@CustomreID varchar(20)=NULL,        
@ProductCategoryID varchar(20)=NULL,        
@ProductSubCategoryID varchar(20)=NULL ,
@SaleSubType varchar(20)=NULL 
)            
as            
BEGIN            
       
select T.SNSEntryID,T.CustomerID,T.CustomerCode,T.CustomerName,T.MaterialCode ,SP.MonthYear,SP.Qty,SP.FinalPrice as Price,SP.Qty*SP.FinalPrice as TotalPrice from  SNS_Entries_View T        
INNER JOIN SNSEntryQtyPrice SP on SP.SNSEntryId = T.SNSEntryID        
where         
AccountId=Coalesce( NULLIF(@OACAccountID,''),AccountId)      
AND CountryID=Coalesce( NULLIF(@CountryID,''),CountryID)      
AND CustomerID=Coalesce( NULLIF(@CustomreID,''),CustomerID)      
AND ProductCategoryID=Coalesce( NULLIF(@ProductSubCategoryID,''),ProductCategoryID)          
AND SaleSubType=Coalesce( NULLIF(@SaleSubType,''),SaleSubType)     
        
            
END         
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertAdjustmentEntries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
             
CREATE PROCEDURE [dbo].[USP_InsertAdjustmentEntries]                
(                
 @tvpAdjustmentEntries [dbo].[TVP_Adjustment_ENTRIES] READONLY,                
 @tvpAdjustmentPrice dbo.TVP_Adjustment_PRICE_INFO READONLY,                
 @tvpAdjustmentQuantities dbo.TVP_Adjustment_QTY_INFO READONLY,                
 @userId NVARCHAR(200)             
)                
AS                
BEGIN                
    -- SET NOCOUNT ON added to prevent extra result sets from                
    -- interfering with SELEaCT statements.                
    SET NOCOUNT ON                
                
 -- TEMP TABLE FOR RETURN MESSAGE                
 DECLARE @ResultTable  AS [dbo].[TVP_RESULT_TABLE]                
 CREATE TABLE #TMP                
 (ResponseCode varchar(20),                
 ResponseMessage NVARCHAR(max))                
                
                
    -- Insert statements for procedure here                
                
 BEGIN TRY                
                
  BEGIN TRANSACTION                
       
 -- Current Month Year from Global Config--              
              
Declare @CurrentMonth varchar(10)              
SET @CurrentMonth = (select ConfigValue from GlobalConfig where ConfigKey='Current_Month')              
                
   --- VALIDATE RAW DATA                
                
   -- Validate INvalid Customer                
                
   DECLARE @InValidCustomer TABLE (                
    CustomerCode varchar(200),                
    RowIndex int                
   );                
   Insert INTO @InValidCustomer(CustomerCode,RowIndex)                
   select SE.CustomerCode, SE.RowNum  from @tvpAdjustmentEntries SE                
   left join Customer c on SE.CustomerCode= c.CustomerCode                
   where c.CustomerCode is null      
     
      -- Validate INvalid Customer PIC               
                
   DECLARE @InValidCustomerPIC TABLE (                
    CustomerCode varchar(200),                
    RowIndex int                
   );                
   Insert INTO @InValidCustomerPIC(CustomerCode,RowIndex)                
   select SE.CustomerCode, SE.RowNum  from @tvpAdjustmentEntries SE                
   left join Customer c on SE.CustomerCode= c.CustomerCode  and c.PersonInChargeId=@userId              
   where c.CustomerCode is null                
            
                
    -- Table variable for Material                
   DECLARE @InValidMaterial TABLE (                
    MaterialCode varchar(200),                
    RowIndex int                
                   
   );                
    Insert INTO @InValidMaterial(MaterialCode,RowIndex)                
    select SE.MaterialCode, SE.RowNum from @tvpAdjustmentEntries SE                
    left join Material M on SE.MaterialCode = M.MaterialCode                
    where M.MaterialId is null                
                
                
     --- IF EVERY THING FINE THEN MAKE ENTRY IN TABLE                
                
      IF (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomer)) 
	  AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidMaterial))  
    and (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerPIC))       
              
      BEGIN                
 --- IF EVERY THING FINE-- THEN MOVE THAT CODE IN ARCHIVE TABLE                
                     
      INSERT INTO [dbo].[AdjustmentEntryArchive](                
         [AdjustmentEntryId]                
           ,[CustomerId]                
           ,[CustomerCode]                
           ,[MaterialId]                
           ,[MaterialCode]                
           ,[AttachmentId]                
           ,[MonthYear]                
           ,[CreatedDate]                
           ,[CreatedBy]                
           ,[UpdateDate]                
           ,[UpdateBy]                
           ,[ArchiveDate]                
           ,[ArchiveBy]                
               )                
        SELECT SE.[AdjustmentEntryId]           
           , SE.[CustomerId]                
           , SE.[CustomerCode]                
           , SE.[MaterialId]                
           , SE.[MaterialCode]                
           , SE.[AttachmentId]                
           , SE.[MonthYear]                
           , SE.[CreatedDate]                
           , SE.[CreatedBy]                
           , SE.[UpdateDate]                
           , SE.[UpdateBy]                
           ,GETDATE()                
           , SE.[CreatedBy]                
              from AdjustmentEntry SE                
        INNER JOIN @tvpAdjustmentEntries T on T.CustomerCode= SE.CustomerCode and T.MaterialCode = SE.MaterialCode                      
        WHERE MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112)                
                
      -- Move child DATa                
                      
       INSERT INTO [dbo].[AdjustmentEntryQtyPrice]                
            ([AdjustmentEntryId]                
            ,[MonthYear]                
            ,[Qty]                
            ,[Price]               
            )                
            SELECT       
             SP.[AdjustmentEntryId]                
             ,SP.[MonthYear]                
             ,SP.[Qty]                
             ,SP.[Price]               
             from (                
          SELECT SE.AdjustmentEntryId, SE.CustomerCode from AdjustmentEntry SE                
          INNER JOIN @tvpAdjustmentEntries SN on SE.CustomerCode = SN.CustomerCode and SE.MaterialCode= SN.MaterialCode                
          where SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)) a                 
          INNER JOIN AdjustmentEntryQtyPrice SP on SP.AdjustmentEntryId= a.AdjustmentEntryId                
                
                
                          
          ---- DELETE FROM AdjustmentEntryQtyPrice                
                
          DELETE FROM AdjustmentEntryQtyPrice where AdjustmentEntryId in(                
           SELECT SP.AdjustmentEntryId from (                
          SELECT SE.AdjustmentEntryId, SE.CustomerCode from AdjustmentEntry SE                
          INNER JOIN @tvpAdjustmentEntries SN on SE.CustomerCode = SN.CustomerCode and SE.MaterialCode= SN.MaterialCode              where SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)) a                 
          INNER JOIN AdjustmentEntryQtyPrice SP on SP.AdjustmentEntryId= a.AdjustmentEntryId)                
                
          -- -- DELETE FROM AdjustmentEntry TABLE                
                
            DELETE FROM AdjustmentEntry where AdjustmentEntryId IN(                
           SELECT SE.AdjustmentEntryId from AdjustmentEntry SE                
          INNER JOIN @tvpAdjustmentEntries T on T.CustomerCode= SE.CustomerCode and T.MaterialCode = SE.MaterialCode                      
          where MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112))                
                
    DECLARE @TOTALCOUNT INT;                
    DECLARE @Adjustment_LASTIDENTITY INT = 0 ;                
    Declare  @Adjustment TABLE                 
    (                
    [CustomerID] INT,                
    [CustomerCode] NVARCHAR(20),                
     [MaterialID] INT,                
     [MaterialCode] NVARCHAR(20),                
    [AttachmentID] INT,                
     EXLROWNUM INT,                
     RN INT                
     )                
     INSERT INTO @Adjustment( [CustomerID],CustomerCode,MaterialCode,MaterialID, AttachmentID, EXLROWNUM ,RN)                
     SELECT C.CustomerID,   C.[CustomerCode], SE.[MaterialCode], M.MaterialID, [AttachmentID], [RowNum],  ROW_NUMBER()OVER(ORDER BY C.[CustomerCode])                
     FROM @tvpAdjustmentEntries SE                
     INNER JOIN Material M on SE.MaterialCode = M.MaterialCode                
     INNER JOIN Customer C on SE.CustomerCode = C.CustomerCode                
                
      
      -- SET TOTAL COUNT --                
     SET @TOTALCOUNT = (SELECT COUNT(*) FROM @Adjustment)                
     DECLARE @STARTFROM INT=1;                
                 
     WHILE @STARTFROM<=@TOTALCOUNT                
     BEGIN                
        
                   
                
      DECLARE @ROWNUM INT                
        SET @ROWNUM = (SELECT EXLROWNUM FROM @Adjustment WHERE RN=@STARTFROM)                
        --SELECT @ROWNUM                
        INSERT INTO AdjustmentEntry(                
       [CustomerID]                
      ,[CustomerCode]                
        ,[MaterialID]                
        ,[MaterialCode]                
       ,[AttachmentId]                
        ,[CreatedDate]                
        ,[CreatedBy]                
       ,[UpdateDate]                
        ,[UpdateBy]       
  ,MonthYear      
       )                
        SELECT                 
        CustomerID,                
        CustomerCode,                
        MaterialID,                
        MaterialCode,                
        AttachmentID,                
        GETDATE(),                
        @userId,                
        GETDATE(),                
        @userId ,      
  @CurrentMonth      
        FROM @Adjustment WHERE RN=@STARTFROM                
                
         SELECT @Adjustment_LASTIDENTITY = SCOPE_IDENTITY();                
                
              
                
       INSERT INTO [dbo].[AdjustmentEntryQtyPrice]                
        (      
  [AdjustmentEntryId]                
        ,[MonthYear]                
        ,[Qty]                
        ,[Price]               
        )                
                
        SELECT  @Adjustment_LASTIDENTITY,P.[MonthYear], [Qty], [Price]         
        FROM @tvpAdjustmentQuantities Q INNER JOIN @tvpAdjustmentPrice P                
        ON Q.[RowNum] = P.[RowNum] AND Q.[MonthYear] = P.[MonthYear]                
        WHERE Q.[RowNum]=@ROWNUM                
         
        SET @STARTFROM=@STARTFROM+1                
     END                
            
              
  --- UPDATE PRICE FROM PRICING              
    -- EXEC  USP_UpdateFinalPrice @CurrentMonth              
                
    INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
      VALUES(200, 'Added '+CAST( @TOTALCOUNT as NVARCHAR(10))+' Record successfully');                 
                     
      END                
                
    --- INSERT INVALID CUSTOMER                
                
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ','+CAST(RowIndex+1 AS NVARCHAR(10)) + ' : Customer Code : ' +CustomerCode +' is invalid.' from @InValidCustomer                
                
        --- INSERT INVALID CUSTOMER Pic                
                
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ','+CAST(RowIndex+1 AS NVARCHAR(10)) + ' : Customer Code :You are not PIC of this customer ' +CustomerCode +' .' from @InValidCustomerPIC                
             
            
     --- INSERT INVALID MATERIAL                
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ','+CAST(RowIndex+1 AS NVARCHAR(10)) + ': Material Code : ' +MaterialCode +' is not model.' from @InValidMaterial                 
                
 
                
                
   COMMIT;                
       
 END TRY                
 BEGIN CATCH                
  ROLLBACK;                
   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
  VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));                  
                 
 END CATCH                
                
 SELECT  DISTINCT  [ResponseCode], [ResponseMessage] FROM @ResultTable                
                  
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertCOGEntries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
            
CREATE PROCEDURE [dbo].[USP_InsertCOGEntries]                
(                    
 @tvpCOGEntries [dbo].[TVP_COG_ENTRIES] READONLY,          
 @tvpCOGQtyPrice [dbo].[TVP_COG_QTY_PRICE_INFO] READONLY,        
 @AttachmentId INT,        
 @SaleTypeId INT,        
 @SaleSubType NVARCHAR(20),        
 @UserId NVARCHAR(200)                        
)                
AS                
BEGIN                
    -- SET NOCOUNT ON added to prevent extra result sets from                
    -- interfering with SELEaCT statements.                
    SET NOCOUNT ON                
                    
    -- TEMP TABLE FOR RETURN MESSAGE                
    DECLARE @ResultTable  AS [dbo].[TVP_RESULT_TABLE]                
    CREATE TABLE #TMP                
    (ResponseCode varchar(20),                
    ResponseMessage NVARCHAR(max))                
                    
    -- Insert statements for procedure here                
    BEGIN TRY                
    BEGIN TRANSACTION                
                    
    -- Current Month Year from Global Config--              
    Declare @CurrentMonth varchar(10)              
    SET @CurrentMonth = (select ConfigValue from GlobalConfig where ConfigKey='Current_Month')              
                
   --- VALIDATE RAW DATA                
                
   -- Validate Invalid Customer                
                
   DECLARE @InvalidCustomer TABLE (                
    CustomerCode varchar(200),                
    RowIndex int                           
   );                
   Insert INTO @InvalidCustomer(CustomerCode,RowIndex)                
   select SE.CustomerCode, SE.RowNum  from @tvpCOGEntries SE                
   left join Customer c on SE.CustomerCode= c.CustomerCode                
   where c.CustomerCode is null        
         
         -- Validate INvalid Customer PIC                   
                    
   DECLARE @InValidCustomerPIC TABLE (                    
    CustomerCode varchar(200),                    
    RowIndex int                    
   );                    
   Insert INTO @InValidCustomerPIC(CustomerCode,RowIndex)                    
   select SE.CustomerCode, SE.RowNum  from @tvpCOGEntries SE                    
   left join Customer c on SE.CustomerCode= c.CustomerCode  and c.PersonInChargeId=@userId                  
   where c.CustomerCode is null       
         
     -- Table variable for Material                    
   DECLARE @InValidMaterial TABLE (                    
    MaterialCode varchar(200),                    
    RowIndex int                    
                       
   );                    
    Insert INTO @InValidMaterial(MaterialCode,RowIndex)                    
    select SE.MaterialCode, SE.RowNum from @tvpCOGEntries SE                    
    left join Material M on SE.MaterialCode = M.MaterialCode                    
    where M.MaterialId is null        
       
       
    --- Validate Customer and name              
   DECLARE @InvalidCustomerName TABLE (                
     CustomerCode varchar(200),                
     CustomerName varchar(200),                
     RowIndex int)             
            
   INSERT INTO @InvalidCustomerName(CustomerCode,CustomerName,RowIndex)                    
     select SE.CustomerCode,SE.CustomerName,SE.RowNum from @tvpCOGEntries SE                
     left join Customer CM                
     on SE.CustomerCode = CM.CustomerCode and SE.CustomerName = CM.CustomerName                
     WHERE CM.CustomerName is null                
            
           
     --- IF EVERY THING FINE THEN MAKE ENTRY IN TABLE                
                        
      IF (NOT EXISTS(SELECT TOP 1 1 FROM @InvalidCustomer))         
      AND (NOT EXISTS(SELECT TOP 1 1 FROM @InvalidMaterial))              
      AND (NOT EXISTS(SELECT TOP 1 1 FROM @InvalidCustomerName))       
  and (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerPIC))      
            
    BEGIN                
               
      --- IF EVERY THING FINE-- THEN MOVE THAT CODE IN ARCHIVE TABLE                             
      INSERT INTO [dbo].[COGEntryArchive](                  
           [COGEntryID]                
           ,SaleTypeId                
           ,[CustomerId]                
           ,[CustomerCode]                
           ,[MaterialId]                
           ,[MaterialCode]                
           ,[AttachmentId]                
           ,[MonthYear]          
           ,[SaleSubType]              
           ,[CreatedDate]                
           ,[CreatedBy]                
           ,[UpdateDate]                
           ,[UpdateBy]                               
           ,[ArchiveDate]                
           ,[ArchiveBy]                
           ,[ArchiveStatus]                
           )                
        SELECT SE.[COGEntryID]                
           , SE.SaleTypeId                
           , SE.[CustomerId]                
           , SE.[CustomerCode]                
           , SE.[MaterialId]                
           , SE.[MaterialCode]                             
           , SE.[AttachmentId]                
           , SE.[MonthYear]            
           , SE.[SaleSubType]            
           , SE.[CreatedDate]                
           , SE.[CreatedBy]                
           , SE.[UpdateDate]                
           , SE.[UpdateBy]                                
           ,GETDATE()                
           , SE.[CreatedBy]                
           ,'Y'                
            FROM COGEntry SE                
            INNER JOIN @tvpCOGEntries T         
            on T.CustomerCode= SE.CustomerCode and T.MaterialCode = SE.MaterialCode                      
            WHERE MonthYear=@CurrentMonth  AND SaleSubType=@SaleSubType       
              and se.SaleTypeId=@SaleTypeId  
      -- Move child Data                              
       INSERT INTO [dbo].[COGEntryQtyPriceArchive]                
            ([COGEntryQtyPriceId]                
            ,[COGEntryId]                
            ,[MonthYear]            
            ,[ChargeType]        
            ,[Qty]                
            ,[Price]                        
            ,[ArchiveStatus]                
            )                
            SELECT SP.[COGEntryQtyPriceId]                
             ,SP.[COGEntryId]                
             ,SP.[MonthYear]            
             ,SP.[ChargeType]        
             ,SP.[Qty]                
             ,SP.[Price]                     
             ,'Y' from (                
          SELECT SE.COGEntryId, SE.CustomerCode from COGEntry SE                
          INNER JOIN @tvpCOGEntries SN on SE.CustomerCode = SN.CustomerCode and SE.MaterialCode= SN.MaterialCode                
          where SE.MonthYear=  @CurrentMonth AND se.SaleSubType=@SaleSubType and  se.SaleTypeId=@SaleTypeId) a                 
          INNER JOIN COGEntryQtyPrice SP on SP.COGEntryId= a.COGEntryId                
                                         
          ---- DELETE FROM COGEntryQtyPrice                        
        DELETE FROM COGEntryQtyPrice        
        WHERE COGEntryID IN (        
        SELECT SP.COGEntryId        
        FROM COGEntryQtyPrice SP        
        INNER JOIN (    
            SELECT SE.COGEntryId        
            FROM COGEntry SE        
            INNER JOIN @tvpCOGEntries SN ON SE.CustomerCode = SN.CustomerCode AND SE.MaterialCode = SN.MaterialCode        
            WHERE SE.MonthYear = @CurrentMonth and SE.SaleSubType=@SaleSubType  and se.SaleTypeId=@SaleTypeId      
        ) a ON SP.COGEntryId = a.COGEntryId        
        );        
        
          -- -- DELETE FROM COGEntry TABLE                        
          DELETE FROM COGEntry where COGEntryId IN(                
          SELECT SE.COGEntryId from COGEntry SE                
          INNER JOIN @tvpCOGEntries T on T.CustomerCode= SE.CustomerCode and T.MaterialCode = SE.MaterialCode                      
          where MonthYear=@CurrentMonth and  SE.SaleSubType=@SaleSubType and se.SaleTypeId=@SaleTypeId)                
                    
        
             DECLARE @TOTALCOUNT INT;                
             DECLARE @COG_LASTIDENTITY INT = 0 ;                
             Declare  @COG TABLE               
             (                
             [CustomerID] INT,                
             [CustomerCode] NVARCHAR(20),                
             [MaterialID] INT,                
             [MaterialCode] NVARCHAR(20),                                             
             EXLROWNUM INT,                
             SaleTypeId INT,           
             AttachmentId INT,             
             [SaleSubType] NVARCHAR(20),                           
             RN INT                
              )                
              INSERT INTO @COG( [CustomerID],CustomerCode,MaterialCode,MaterialID, EXLROWNUM,SaleTypeId,AttachmentId, SaleSubType, RN)                
              SELECT         
              C.CustomerID, C.[CustomerCode], SE.[MaterialCode],M.MaterialID, [RowNum],         
              @SaleTypeId,@AttachmentId, @SaleSubType, ROW_NUMBER()OVER(ORDER BY C.[CustomerCode])                
              FROM @tvpCOGEntries SE                
              INNER JOIN Material M on SE.MaterialCode = M.MaterialCode                
              INNER JOIN Customer C on SE.CustomerCode = C.CustomerCode                
                     
              SET @TOTALCOUNT = (SELECT COUNT(*) FROM @COG)                
              DECLARE @STARTFROM INT=1;                
              WHILE @STARTFROM<=@TOTALCOUNT                
              BEGIN                    
                    DECLARE @ROWNUM INT                
                    SET @ROWNUM = (SELECT EXLROWNUM FROM @COG WHERE RN=@STARTFROM)                
                       INSERT INTO COGEntry(                
                         [CustomerID]                
                         ,[CustomerCode]                
                          ,[MaterialID]                
                          ,[MaterialCode]                                              
                         ,[SaleTypeId]                                           
                          ,[CreatedDate]                
                          ,[CreatedBy]                
                         ,[UpdateDate]                
                          ,[UpdateBy]                
                          ,[MonthYear]               
                          ,[AttachmentId]         
                          ,[SaleSubType]        
                         )                                 
                          SELECT                 
                          CustomerID,                
                          CustomerCode,                
                          MaterialID,                
                          MaterialCode,                                                
                          [SaleTypeId],                                             
                          GETDATE(),                
                          @UserId,                
                          GETDATE(),                        
                          @UserId,                
          @CurrentMonth,        
                          AttachmentId,        
                          SaleSubType        
                          FROM @COG WHERE RN=@STARTFROM                
                
                        SELECT @COG_LASTIDENTITY = SCOPE_IDENTITY();                
                                       
                         INSERT INTO [dbo].[COGEntryQtyPrice]                
                          ([COGEntryID]                
                          ,[MonthYear]         
                          ,[ChargeType]        
                          ,[Qty]                
                          ,[Price])            
                          SELECT  @COG_LASTIDENTITY,[MonthYear], CHARGETYPE, [Qty], CAST([Price] as decimal(18,2))        
                          FROM @tvpCOGQtyPrice                 
                          WHERE [RowNum]=@ROWNUM AND MonthYear = @CurrentMonth        
                                
                        SET @STARTFROM=@STARTFROM+1                
              END                
                  
            INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
            VALUES(200, 'Added '+CAST( @TOTALCOUNT as NVARCHAR(10))+' Record successfully');                              
      END                
                
           --- INSERT INVALID CUSTOMER                    
                    
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                    
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Customer Code : ' +CustomerCode +' is invalid.' from @InValidCustomer                    
        
  --- INSERT INVALID CUSTOMER NAME AND CODE                        
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) +'  : Customer Code : ' +CustomerCode +' not belong to this Customer(' +CustomerName +') ' from @InvalidCustomerName                
            
  --- INSERT INVALID CUSTOMER Pic                    
                    
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                    
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) +'  : Customer Code :You are not PIC of this customer ' +CustomerCode +' .' from @InValidCustomerPIC                    
                 
           
     --- INSERT INVALID MATERIAL                
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) +'   : Material Code : ' +MaterialCode +' is not model.' from @InvalidMaterial                 
                
           
   COMMIT;                   
 END TRY                
 BEGIN CATCH                
  ROLLBACK;                
   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                
  VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));                  
                 
 END CATCH                
                
 SELECT  DISTINCT  [ResponseCode], [ResponseMessage] FROM @ResultTable                
                  
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertSNSEntries]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertSNSEntries] (
	@OACID INT
	,@tvpSNSEntries [dbo].[TVP_SNS_ENTRIES] READONLY
	,@tvpSNSPrice dbo.TVP_SNS_PRICE_INFO READONLY
	,@tvpSNSQuantities dbo.TVP_SNS_QTY_INFO READONLY
	,@userId NVARCHAR(200)
	,@SaleSubType NVARCHAR(20)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                        
	-- interfering with SELEaCT statements.                        
	SET NOCOUNT ON

	-- TEMP TABLE FOR RETURN MESSAGE                        
	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	CREATE TABLE #TMP (
		ResponseCode VARCHAR(20)
		,ResponseMessage NVARCHAR(max)
		)

	-- Insert statements for procedure here                        
	BEGIN TRY
		BEGIN TRANSACTION TRANS

		-- OAC Code--                        
		DECLARE @OACCode VARCHAR(20)

		SET @OACCode = (
				SELECT AccountCode
				FROM Account
				WHERE AccountId = @OACID
				)

		-- Current Month Year from Global Config--                      
		DECLARE @CurrentMonth VARCHAR(10);

		IF (@SaleSubType = 'Monthly')
		BEGIN
			SET @CurrentMonth = (
					SELECT ConfigValue
					FROM GlobalConfig
					WHERE ConfigKey = 'Current_Month'
						AND ConfigType = 'Direct And SNS'
					)
		END
		ELSE
		BEGIN
			SET @CurrentMonth = (
					SELECT ConfigValue
					FROM GlobalConfig
					WHERE ConfigKey = 'BP_Year'
					)
		END

		--- VALIDATE RAW DATA                        
		-- Validate INvalid Customer                        
		DECLARE @InValidCustomer TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);
		DECLARE @InValidSNSCustomer TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);
		DECLARE @InValidCustomerAccountMapping TABLE (
			CustomerCode VARCHAR(200)
			,RowIndex INT
			);

		INSERT INTO @InValidCustomer (
			CustomerCode
			,RowIndex
			)
		SELECT SE.CustomerCode
			,SE.RowNum
		FROM @tvpSNSEntries SE
		LEFT JOIN Customer c ON SE.CustomerCode = c.CustomerCode
		WHERE c.CustomerCode IS NULL

		IF NOT EXISTS (
				SELECT TOP 1 1
				FROM @InValidCustomer
				)
		BEGIN
			-- CustomerIS SNS Customer                        
			INSERT INTO @InValidSNSCustomer (
				CustomerCode
				,RowIndex
				)
			SELECT DISTINCT SE.CustomerCode
				,SE.RowNum
			FROM @tvpSNSEntries SE
			LEFT JOIN (
				SELECT C.CustomerId
					,C.CustomerCode
					,CD.AccountId
					,CD.SaleTypeId
				FROM Customer C
				INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId
				) a ON SE.CustomerCode = a.CustomerCode
				AND SE.SaleTypeId = a.SaleTypeId
			WHERE a.CustomerCode IS NULL

			-- Customer mapped account                        
			INSERT INTO @InValidCustomerAccountMapping (
				CustomerCode
				,RowIndex
				)
			SELECT DISTINCT SE.CustomerCode
				,SE.RowNum
			FROM @tvpSNSEntries SE
			LEFT JOIN (
				SELECT C.CustomerId
					,C.CustomerCode
					,CD.AccountId
					,CD.SaleTypeId
				FROM Customer C
				INNER JOIN CustomerDID CD ON C.CustomerId = CD.CustomerId
				) a ON SE.CustomerCode = a.CustomerCode
				AND a.AccountId = @OACID
			WHERE a.CustomerCode IS NULL
		END

		-- Table variable for Material                        
		DECLARE @InValidMaterial TABLE (
			MaterialCode VARCHAR(200)
			,RowIndex INT
			);

		INSERT INTO @InValidMaterial (
			MaterialCode
			,RowIndex
			)
		SELECT SE.MaterialCode
			,SE.RowNum
		FROM @tvpSNSEntries SE
		LEFT JOIN Material M ON SE.MaterialCode = M.MaterialCode
		WHERE M.MaterialId IS NULL

		-- --- Validate Customer and name                      
		--DECLARE @InValidCustomerName TABLE (                        
		--  CustomerCode varchar(200),                        
		--  CustomerName varchar(200),                        
		--  RowIndex int)                     
		--INSERT INTO @InValidCustomerName(CustomerCode,CustomerName,RowIndex)                            
		--  select SE.CustomerCode,SE.CustomerName,SE.RowNum from @tvpSNSEntries SE                        
		--  left join Customer CM                        
		--  on SE.CustomerCode = CM.CustomerCode and SE.CustomerName = CM.CustomerName                        
		--  WHERE CM.CustomerName is null                        
		--- Validation for Model and Product Category                        
		DECLARE @InValidModeleProdcutCategory TABLE (
			CategoryID INT
			,MaterialCode VARCHAR(200)
			,RowIndex INT
			)

		INSERT INTO @InValidModeleProdcutCategory (
			CategoryID
			,MaterialCode
			,RowIndex
			)
		SELECT T.CategoryID
			,T.MaterialCode
			,T.RowNum
		FROM @tvpSNSEntries T
		LEFT JOIN ProductCategory P ON P.ProductCategoryCode = Cast(T.CategoryID AS VARCHAR)
			AND P.ProductCategoryName = T.Category
		LEFT JOIN Material M ON (
				P.ProductCategoryId = M.ProductCategoryId1
				OR P.ProductCategoryId = M.ProductCategoryId2
				OR P.ProductCategoryId = M.ProductCategoryId3
				OR P.ProductCategoryId = M.ProductCategoryId4
				OR P.ProductCategoryId = M.ProductCategoryId5
				OR P.ProductCategoryId = M.ProductCategoryId6
				)
		WHERE M.MaterialId IS NULL

		--select SE.CategoryID,SE.MaterialCode,SE.RowNum from @tvpSNSEntries SE                        
		--left join Material M on (SE.CategoryID = M.ProductCategoryId1 OR                         
		--SE.CategoryID = M.ProductCategoryId2 or SE.CategoryID = M.ProductCategoryId3 or SE.CategoryID = M.ProductCategoryId4 or SE.CategoryID = M.ProductCategoryId5 or                         
		--SE.CategoryID = M.ProductCategoryId6) and M.MaterialCode = SE.MaterialCode                        
		--WHERE M.MaterialId is null                        
		--- IF EVERY THING FINE THEN MAKE ENTRY IN TABLE                        
		IF (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidCustomer
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidMaterial
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidMaterial
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidModeleProdcutCategory
					)
				)
			--AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))  
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidSNSCustomer
					)
				)
			AND (
				NOT EXISTS (
					SELECT TOP 1 1
					FROM @InValidCustomerAccountMapping
					)
				)
		BEGIN
			--- IF EVERY THING FINE-- THEN MOVE THAT CODE IN ARCHIVE TABLE                        
			INSERT INTO [dbo].[SNSEntryArchive] (
				[SNSEntryID]
				,[SaleTypeId]
				,[CustomerId]
				,[CustomerCode]
				,[MaterialId]
				,[MaterialCode]
				,[CategoryId]
				,[Category]
				,[AttachmentId]
				,[MonthYear]
				,[CreatedDate]
				,[CreatedBy]
				,[UpdatedDate]
				,[UpdatedBy]
				,[ModeofTypeId]
				,[ArchiveDate]
				,[ArchiveBy]
				,[ArchiveStatus]
				,[OACCode]
				,[SaleSubType]
				)
			SELECT SE.[SNSEntryID]
				,SE.[SaleTypeId]
				,SE.[CustomerId]
				,SE.[CustomerCode]
				,SE.[MaterialId]
				,SE.[MaterialCode]
				,SE.[CategoryId]
				,SE.[Category]
				,SE.[AttachmentId]
				,SE.[MonthYear]
				,SE.[CreatedDate]
				,SE.[CreatedBy]
				,SE.[UpdatedDate]
				,SE.[UpdatedBy]
				,SE.[ModeofTypeId]
				,GETDATE()
				,SE.[CreatedBy]
				,'Y'
				,SE.[OACCode]
				,SE.SaleSubType
			FROM SNSEntry SE
			INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode
				AND T.MaterialCode = SE.MaterialCode
			WHERE
				--MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112)           
				MonthYear = @CurrentMonth
				AND SaleSubType = @SaleSubType
				AND OACCode = @OACCode

			-- Move child DATa                        
			INSERT INTO [dbo].[SNSEntryQtyPriceArchive] (
				[SNSEntryQtyPriceId]
				,[SNSEntryId]
				,[MonthYear]
				,[Qty]
				,[Price]
				,[FinalPrice]
				,[TotalAmount]
				,[Currency]
				,[CreatedDate]
				,[CreatedBy]
				,[UpdatedDate]
				,[UpdatedBy]
				,[ArchiveDate]
				,[ArchiveBy]
				,[ArchiveStatus]
				)
			SELECT SP.[SNSEntryQtyPriceId]
				,SP.[SNSEntryId]
				,SP.[MonthYear]
				,SP.[Qty]
				,SP.[Price]
				,SP.[FinalPrice]
				,SP.[TotalAmount]
				,SP.[Currency]
				,SP.[CreatedDate]
				,SP.[CreatedBy]
				,SP.[UpdatedDate]
				,SP.[UpdatedBy]
				,GETDATE()
				,SP.[UpdatedBy]
				,'Y'
			FROM (
				SELECT SE.SNSEntryId
					,SE.CustomerCode
				FROM SNSEntry SE
				INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode
					AND SE.MaterialCode = SN.MaterialCode
				WHERE
					--SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)           
					se.MonthYear = @CurrentMonth
					AND OACCode = @OACCode
					AND se.SaleSubType = @SaleSubType
				) a
			INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId

			---- DELETE FROM SNSEntryQtyPrice                        
			DELETE
			FROM SNSEntryQtyPrice
			WHERE SNSEntryID IN (
					SELECT SP.SNSEntryId
					FROM (
						SELECT SE.SNSEntryId
							,SE.CustomerCode
						FROM SNSEntry SE
						INNER JOIN @tvpSNSEntries SN ON SE.CustomerCode = SN.CustomerCode
							AND SE.MaterialCode = SN.MaterialCode
						WHERE
							--SE.MonthYear=  CONVERT(NVARCHAR(6), GETDATE(), 112)           
							SE.MonthYear = @CurrentMonth
							AND OACCode = @OACCode
							AND se.SaleSubType = @SaleSubType
						) a
					INNER JOIN SNSEntryQtyPrice SP ON SP.SNSEntryId = a.SNSEntryId
					)

			-- -- DELETE FROM SNSEntry TABLE          
			DELETE
			FROM SNSEntry
			WHERE SNSEntryId IN (
					SELECT SE.SNSEntryId
					FROM SNSEntry SE
					INNER JOIN @tvpSNSEntries T ON T.CustomerCode = SE.CustomerCode
						AND T.MaterialCode = SE.MaterialCode
					WHERE
						--MonthYear=CONVERT(NVARCHAR(6), GETDATE(), 112))             
						MonthYear = @CurrentMonth
					)
				AND OACCode = @OACCode
				AND SaleSubType = @SaleSubType

			DECLARE @TOTALCOUNT INT;
			DECLARE @SNS_LASTIDENTITY INT = 0;
			DECLARE @SNS TABLE (
				[CustomerID] INT
				,[CustomerCode] NVARCHAR(20)
				,[MaterialID] INT
				,[MaterialCode] NVARCHAR(20)
				,[CategoryID] INT
				,[Category] NVARCHAR(500)
				,[AttachmentID] INT
				,EXLROWNUM INT
				,[SaleTypeId] INT
				,[ModeofTypeId] INT
				,RN INT
				)

			INSERT INTO @SNS (
				[CustomerID]
				,CustomerCode
				,MaterialCode
				,CategoryID
				,[Category]
				,MaterialID
				,AttachmentID
				,EXLROWNUM
				,[SaleTypeId]
				,[ModeofTypeId]
				,RN
				)
			SELECT C.CustomerID
				,C.[CustomerCode]
				,SE.[MaterialCode]
				,[CategoryID]
				,[Category]
				,M.MaterialID
				,[AttachmentID]
				,[RowNum]
				,[SaleTypeId]
				,[ModeofTypeId]
				,ROW_NUMBER() OVER (
					ORDER BY C.[CustomerCode]
					)
			FROM @tvpSNSEntries SE
			INNER JOIN Material M ON SE.MaterialCode = M.MaterialCode
			INNER JOIN Customer C ON SE.CustomerCode = C.CustomerCode

			DECLARE @tvpAccontCodeList AS dbo.[TVP_CODE_LIST];
			DECLARE @TVPAccountCodeMaterialCodeList AS dbo.[TVP_ACCOUNT_MATERIAL_CODE_LIST];
			DECLARE @tvpMaterialCodeList AS dbo.[TVP_CODE_LIST];

			-- SET TOTAL COUNT --                        
			SET @TOTALCOUNT = (
					SELECT COUNT(*)
					FROM @SNS
					)

			DECLARE @STARTFROM INT = 1;

			-- SELECT * FROM @SNS                        
			WHILE @STARTFROM <= @TOTALCOUNT
			BEGIN
				--SELECT * FROM @SNS                        
				DECLARE @ROWNUM INT

				SET @ROWNUM = (
						SELECT EXLROWNUM
						FROM @SNS
						WHERE RN = @STARTFROM
						)

				--SELECT @ROWNUM                        
				INSERT INTO SNSEntry (
					[CustomerID]
					,[CustomerCode]
					,[MaterialID]
					,[MaterialCode]
					,[CategoryID]
					,[Category]
					,[AttachmentID]
					,[SaleTypeId]
					,[ModeofTypeId]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					,[MonthYear]
					,[OACCode]
					,[SaleSubType]
					)
				SELECT CustomerID
					,CustomerCode
					,MaterialID
					,MaterialCode
					,CategoryID
					,Category
					,AttachmentID
					,[SaleTypeId]
					,[ModeofTypeId]
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
					,@CurrentMonth -- CONVERT(NVARCHAR(6), GETDATE(), 112)                        
					,@OACCode
					,@SaleSubType
				FROM @SNS
				WHERE RN = @STARTFROM

				SELECT @SNS_LASTIDENTITY = SCOPE_IDENTITY();

				-- INSERT INTO [dbo].[SNSEntryQtyPrice] TABLE                        
				INSERT INTO [dbo].[SNSEntryQtyPrice] (
					[SNSEntryID]
					,[MonthYear]
					,[Qty]
					,[Price]
					,[FinalPrice]
					,[TotalAmount]
					,[Currency]
					,[CreatedDate]
					,[CreatedBy]
					,[UpdatedDate]
					,[UpdatedBy]
					)
				SELECT @SNS_LASTIDENTITY
					,P.[MonthYear]
					,[Qty]
					,CAST([Price] AS DECIMAL(18, 2))
					,CAST([Price] AS DECIMAL(18, 2))
					,[Qty] * [Price]
					,'USD'
					,GETDATE()
					,@userId
					,GETDATE()
					,@userId
				FROM @tvpSNSQuantities Q
				INNER JOIN @tvpSNSPrice P ON Q.[RowNum] = P.[RowNum]
					AND Q.[MonthYear] = P.[MonthYear]
				WHERE Q.[RowNum] = @ROWNUM

				INSERT INTO @tvpAccontCodeList
				SELECT @OACCode;

				INSERT INTO @tvpMaterialCodeList
				SELECT MaterialCode
				FROM @SNS
				WHERE RN = @STARTFROM

				INSERT INTO @TVPAccountCodeMaterialCodeList
				SELECT @OACCode
					,MaterialCode
				FROM @SNS
				WHERE RN = @STARTFROM

				SET @STARTFROM = @STARTFROM + 1
			END

			--- UPDATE PRICE FROM PRICING                      
			-- EXEC  USP_UpdateFinalPrice @CurrentMonth                      
			INSERT INTO @ResultTable (
				[ResponseCode]
				,[ResponseMessage]
				)
			VALUES (
				200
				,'Added ' + CAST(@TOTALCOUNT AS NVARCHAR(10)) + ' Record successfully'
				);
		END

		----- INSERT INVALID CUSTOMER NAME AND CODE                        
		--   INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])                        
		--   SELECT 107,' : Customer Code : ' +CustomerCode +' not belong to this Customer.' from @InValidCustomerName                        
		--- INSERT INVALID  CUSTOMER                        
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not correct.'
		FROM @InValidCustomer

		--- INSERT INVALID SNS CUSTOMER                        
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not SNS Customer.'
		FROM @InValidSNSCustomer

		--- INSERT INVALID CUSTOMER Account Mapping                       
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Customer Code : ' + CustomerCode + ' is not belong to this account.'
		FROM @InValidCustomerAccountMapping

		--- INSERT INVALID MATERIAL                        
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Material Code : ' + MaterialCode + ' is not model.'
		FROM @InValidMaterial

		-- INSERT INVALID PRODUCTCATEGORY AND MODEL                        
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		SELECT 107
			,' : Product category : ' + CAST(CategoryID AS VARCHAR(10)) + ' and Material Code : ' + MaterialCode + ' is not a mapped.'
		FROM @InValidModeleProdcutCategory

		IF (@SaleSubType = 'Monthly')
		BEGIN
			IF (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidCustomer
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidMaterial
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidMaterial
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidModeleProdcutCategory
						)
					)
				--AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerName))  
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidSNSCustomer
						)
					)
				AND (
					NOT EXISTS (
						SELECT TOP 1 1
						FROM @InValidCustomerAccountMapping
						)
					)
			BEGIN
				EXEC [dbo].[SP_Calculate_RollingInventory] @userId
					,@TVPAccountCodeMaterialCodeList;
			END
		END

		COMMIT TRANSACTION TRANS;
			--EXEC [dbo].[SP_Calculate_RollingInventory] @userId, @tvpAccontCodeList, @tvpMaterialCodeList;              
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION TRANS;

		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertSNSFOBPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[USP_InsertSNSFOBPrice]  
 @SNSFOB SNS_FOB_Price READONLY,  
 @UserId varchar(100)  
AS  
BEGIN  
 SET NOCOUNT ON  
  -- TEMP TABLE FOR RETURN MESSAGE  
 DECLARE @ResultTable  AS [dbo].[TVP_RESULT_TABLE]  
 DECLARE @InsertedRows INT;  
CREATE TABLE #TMP  
 (ResponseCode varchar(20),  
 ResponseMessage varchar(max))  
BEGIN TRY  
  BEGIN TRANSACTION  
   DECLARE @InSNSFOBPrice TABLE (  
    MaterailCode varchar(200),  
    RowIndex int     
   );  
  
   DECLARE @InValidSNSFOBPrice TABLE (  
    MaterailCode varchar(200),  
    RowIndex int     
   );  
   Insert INTO @InValidSNSFOBPrice(MaterailCode,RowIndex)    
   select isnull(SE.MaterailCode,''), SE.RowIndex  from @SNSFOB SE    
   left join CustomerModelMapping c on SE.MaterailCode = c.ModelCode    
   where c.ModelCode is null  
   
     -- Table variable for Currency    
   DECLARE @InValidCurrency TABLE (    
    CurrencyCode varchar(200),    
    RowIndex int    
   );  
    Insert INTO @InValidCurrency(CurrencyCode,RowIndex)  
	 select SE.Curr, SE.RowIndex  from @SNSFOB SE 
   where SE.Curr !='USD' 
  
IF (NOT EXISTS(SELECT TOP 1 1 FROM @InValidSNSFOBPrice)) 
AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCurrency)) 
Begin  
Insert into SNS_Pricing (ModeofTypeId,Plant,Vendor,CustomerId,CustomerCode,MaterialCode,Inco_Term,TermId,MaterialId,  
 From_Date,To_Date, Price,Price_Unit,CurrencyId,UOM,[Port],[Status],CreatedDate,CreatedBy)  
 select mt.ModeofTypeId,sp.Plant,sp.Vendor,com.CustomerId,sp.Cust_Code,sp.MaterailCode,sp.Inco_Term,  
 Termid,M.MaterialId, sp.From_Dt, sp.To_Dt,sp.Price,isnull(sp.Price_Unit,''),c.CurrencyId,sp.Uom,sp.[Port],  
 'N',getdate(),@userId from @SNSFOB as sp   
 INNER JOIN CustomerModelMapping cmm on cmm.ModelCode=sp.MaterailCode  
INNER JOIN Material M ON M.MaterialCode=sp.MaterailCode   
LEFT JOIN Customer com ON com.CustomerCode=isnull(sp.Cust_Code,'')  
LEFT JOIN Currency c ON c.CurrencyCode=sp.Curr  
LEFT JOIN ModeofType mt on mt.ModeofTypeCode=sp.ModeTypeOf   
 SET @InsertedRows = @@ROWCOUNT;   
--End  
IF @InsertedRows<>0   
BEGIN  
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])  
 VALUES(200, 'Added '+CAST( @InsertedRows as NVARCHAR(10))+' Record successfully')   
END  
End  
--- INSERT INVALID CUSTOMER  
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])  
     SELECT 107, 'RowNo :'+CAST(RowIndex AS VARCHAR(10)) +': Materail Code :'+MaterailCode+' is not mapped with SNS Customer.' from @InValidSNSFOBPrice  
   --- INSERT INVALID Currency    
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])    
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Currency Code :'+CurrencyCode+' Currency code should be in USD' from @InValidCurrency      
    
COMMIT;  
 END TRY  
 BEGIN CATCH  
  ROLLBACK; 
  
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])  
  VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));    
   
 END CATCH  
  
  SELECT    [ResponseCode], [ResponseMessage] FROM @ResultTable  
END  
  
  
  
  
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertSNSPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[USP_InsertSNSPrice]      
 @SNSSalePrice SNS_Sales_Price READONLY,      
 @UserId nvarchar(100)      
AS      
BEGIN      
SET NOCOUNT ON      
  -- TEMP TABLE FOR RETURN MESSAGE      
 DECLARE @ResultTable  AS [dbo].[TVP_RESULT_TABLE]      
 DECLARE @InsertedRows INT;      
CREATE TABLE #TMP      
 (ResponseCode varchar(20),      
 ResponseMessage NVARCHAR(max))      
BEGIN TRY      
  BEGIN TRANSACTION      
   --select * from CustomerModelMapping      
   -- Validate Sale Price      
      
   DECLARE @InValidCustomerModelMapping TABLE (      
     CustomerCode varchar(200),      
     MaterialCode varchar(200),      
     RowIndex int)      
           
     Insert INTO @InValidCustomerModelMapping(CustomerCode,MaterialCode,RowIndex)      
   select isnull(SE.Cust_Code,''),isnull(SE.MaterailCode,''), SE.RowIndex from @SNSSalePrice SE      
   left join CustomerModelMapping c on SE.MaterailCode= c.ModelCode and SE.Cust_Code=c.CustomerCode      
   where c.ModelCode is null      
        
 -- Validate customer org     
    DECLARE @InValidCustomerOrg TABLE (      
     CustomerCode varchar(200),      
     OrgCode varchar(200),      
     RowIndex int)      
           
     Insert INTO @InValidCustomerOrg(CustomerCode,OrgCode,RowIndex)      
   select isnull(SE.Cust_Code,''),isnull(SE.Sales_Org,''), SE.RowIndex from @SNSSalePrice SE      
   left join Customerview c  on  SE.Cust_Code=c.CustomerCode     
   and se.Sales_Org=c.SalesOrganizationCode    
  where  c.SalesOrganizationCode is null     
    
     -- Validate ship mode     
    DECLARE @InValidShipMode TABLE (      
     CustomerCode varchar(200),      
     ShipCode varchar(200),      
     RowIndex int)      
           
     Insert INTO @InValidShipMode(CustomerCode,ShipCode,RowIndex)      
   select isnull(SE.Cust_Code,''),isnull(SE.Ship_Mode,''), SE.RowIndex from @SNSSalePrice SE      
 left join Material m on se.MaterailCode=m.MaterialCode    
 left join AirPort a on m.AirPortId=a.AirPortId    
  where  a.airportcode!=se.Ship_Mode or a.AirPortId is null    
    
   -- Table variable for Currency        
   DECLARE @InValidCurrency TABLE (        
    CurrencyCode varchar(200),        
    RowIndex int        
   );      
    Insert INTO @InValidCurrency(CurrencyCode,RowIndex)      
  select SE.Curr, SE.RowIndex  from @SNSSalePrice SE     
   where SE.Curr !='USD'      
--Insert into  SSN price for sales      
      
-- Exit SSN Price data      
IF (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerModelMapping))     
AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCurrency))     
AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidCustomerOrg))     
AND  (NOT EXISTS(SELECT TOP 1 1 FROM @InValidShipMode))     
Begin      
DECLARE @InsertSNSSalePrice TABLE (      
    MaterailCode varchar(200),      
    CustomerCode varchar(200)         
   );    
   DECLARE @ExistSNSSalePrice TABLE (      
    SNS_PricingId varchar(200)      
         
   );  
  
      
Insert into @InsertSNSSalePrice (MaterailCode,CustomerCode)      
select sp.CustomerCode,sp.MaterialCode from SNS_Pricing sp inner join @SNSSalePrice ssp       
on sp.MaterialCode<>ssp.MaterailCode and sp.CustomerCode<>ssp.Cust_Code   
  
Insert into @ExistSNSSalePrice (SNS_PricingId)      
select sp.SNS_PricingId from SNS_Pricing sp inner join @SNSSalePrice ssp       
on sp.MaterialCode=ssp.MaterailCode and sp.CustomerCode=ssp.Cust_Code   
and sp.From_Date=ssp.From_Dt and sp.To_Date=ssp.To_Dt  
-- delete record if exists  
delete from SNS_Pricing where SNS_PricingId in (select SNS_PricingId from @ExistSNSSalePrice);  
      
Insert into SNS_Pricing (ModeofTypeId,SalesOrg,DistributtonChannel,CustomerId,CustomerCode,MaterialCode,Ship_Mode,      
Inco_Term,TermId,MaterialId,From_Date,To_Date,      
 Price,Price_Unit,CurrencyId,UOM,[Status],CreatedDate,CreatedBy)      
 select mt.ModeofTypeId,Sales_Org,Dist_Chnl,com.CustomerId,sp.Cust_Code,sp.MaterailCode,Ship_Mode,Inco_Term,Termid,M.MaterialId,      
 From_Dt, To_Dt,Price,Price_Unit,c.CurrencyId,Uom,'N',getdate(),@userId       
 from @SNSSalePrice as sp       
      
INNER JOIN Material M ON M.MaterialCode=sp.MaterailCode       
INNER JOIN Customer com ON com.CustomerCode=sp.Cust_Code      
--INNER JOIN @InsertSNSSalePrice ISSP on ISSP.MaterailCode<>sp.MaterailCode and      
--ISSP.CustomerCode<>sp.Cust_Code      
LEFT JOIN Currency c ON c.CurrencyCode=sp.Curr      
LEFT JOIN ModeofType mt on mt.ModeofTypeCode=sp.ModeTypeOf      
      
---Update      
--Update sp set sp.SalesOrg=ssp.Sales_Org,sp.DistributtonChannel=ssp.Dist_Chnl,      
--sp.CustomerId=com.CustomerId,sp.CustomerCode=ssp.Cust_Code,sp.MaterialCode=ssp.MaterailCode,      
--sp.Ship_Mode=ssp.Ship_Mode,sp.Inco_Term=ssp.Inco_Term,sp.TermId=ssp.TermId,      
--sp.MaterialId=M.MaterialId,sp.From_Date=ssp.From_Dt,sp.To_Date=ssp.To_Dt,      
-- sp.Price=ssp.Price,sp.Price_Unit=ssp.Price_Unit,sp.CurrencyId=c.CurrencyId,      
-- sp.UOM=ssp.Uom,sp.UpdateDate=GetDate(),sp.UpdateBy=@userId from SNS_Pricing sp       
--inner join @SNSSalePrice as ssp on sp.MaterialCode=ssp.MaterailCode       
--INNER JOIN Material M ON M.MaterialCode=ssp.MaterailCode       
--INNER JOIN Customer com ON com.CustomerCode=ssp.Cust_Code      
--INNER JOIN @InsertSNSSalePrice ISSP on ISSP.MaterailCode=ssp.MaterailCode and      
--ISSP.CustomerCode=ssp.Cust_Code      
--LEFT JOIN Currency c ON c.CurrencyCode=ssp.Curr      
--and sp.CustomerCode=ssp.Cust_Code      
      
SET @InsertedRows = @@ROWCOUNT;      
IF  @InsertedRows <>0      
BEGIN      
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])      
 VALUES(200, 'Added '+CAST(@InsertedRows as NVARCHAR(10))+' Record successfully')       
END      
End      
    
 --- INSERT INVALID Currency        
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])        
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Currency Code :'+CurrencyCode+' Currency code should be in USD' from @InValidCurrency          
        
--- INSERT INVALID CUSTOMER      
     INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])      
       SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Customer Code : ' +CustomerCode +' and Material Code : '+MaterialCode+' is not a valid model customer mapping.' from @InValidCustomerModelMapping      
         
 --- INSERT INVALID customer org        
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])        
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Customer Code :'+CustomerCode+' and Sales Organization : '+OrgCode+' is not a valid customer sales organization mapping.' from @InValidCustomerOrg      
        
  --- INSERT INVALID ship mode        
       INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])        
     SELECT 107,'RowNo :'+CAST(RowIndex AS NVARCHAR(10)) + ': Customer Code :'+CustomerCode+' and Ship Mode : '+ShipCode+' is not a valid model/customer mapping.' from @InValidShipMode      
        
    
COMMIT;      
 END TRY      
 BEGIN CATCH      
  ROLLBACK;      
  INSERT INTO @ResultTable ([ResponseCode],[ResponseMessage])      
  VALUES(500, 'Exception: ' + ERROR_MESSAGE()+ 'at '+ CAST( ERROR_LINE() as varchar(max)));        
       
 END CATCH      
      
 SELECT  DISTINCT  [ResponseCode], [ResponseMessage] FROM @ResultTable      
END 
GO
/****** Object:  StoredProcedure [dbo].[USP_Transmission_Process]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Transmission_Process] @TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@CurrentMonth INT
	,@ResultMonth INT
	,@Type VARCHAR(10)
	,@CreatedBy NVARCHAR(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from                                      
	-- interfering with SELECT statements.                                      
	SET NOCOUNT ON;

	DECLARE @ResultTable AS [dbo].[TVP_RESULT_TABLE]

	-- Insert statements for procedure here                                      
	BEGIN TRY
		-- Insert Data in Transmission data for file write                       
		CREATE TABLE #TMP (
			CustomerCode NVARCHAR(50)
			,PlanTypeCode INT
			,PlanType VARCHAR(50)
			,RN INT
			)

		INSERT INTO #TMP (
			CustomerCode
			,PlanTypeCode
			,PlanType
			,RN
			)
		SELECT TL.CustomerCode
			,TL.PlanTypeCode
			,TT.PlanTypeName
			,ROW_NUMBER() OVER (
				ORDER BY TL.CustomerCode
				)
		FROM TransmissionList TL
		INNER JOIN @TVP_CUSTOMERCODE_LIST CL ON CL.CustomerCode = TL.CustomerCode
		INNER JOIN [dbo].[TransmissionPlanType] TT ON TT.PlanTypeCode = TL.PlanTypeCode
			AND TL.SalesType = @Type
			AND TL.IsActive = 1

		DECLARE @ST INT = 1;
		DECLARE @TOTALCOUNT INT;

		SET @TOTALCOUNT = (
				SELECT COUNT(1)
				FROM #TMP
				)

		WHILE @ST <= @TOTALCOUNT
		BEGIN
			DECLARE @PlanTypeCode INT;
			DECLARE @PlanTypeName NVARCHAR(20);
			DECLARE @CustomerCode NVARCHAR(100);

			SET @PlanTypeCode = (
					SELECT PlanTypeCode
					FROM #TMP
					WHERE RN = @ST
					)
			SET @PlanTypeName = (
					SELECT PlanType
					FROM #TMP
					WHERE RN = @ST
					)
			SET @CustomerCode = (
					SELECT CustomerCode
					FROM #TMP
					WHERE RN = @ST
						AND PlanTypeCode = @PlanTypeCode
					)

			DECLARE @CustomerList AS [dbo].[TVP_CUSTOMERCODE_LIST]

			DELETE
			FROM @CustomerList;

			INSERT INTO @CustomerList (CustomerCode)
			VALUES (@CustomerCode)

			IF (@PlanTypeCode = 100)
			BEGIN
				--PLAN                
				EXEC [dbo].[SP_ADD_PLAN_FOR_DIRECTSALE_TRANSMISSION] @CustomerList
					,@Type
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName

				EXEC SP_ADD_PLAN_FOR_SNS_TRANSMISSION @CustomerList
					,@CurrentMonth
					,@Type
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName

				EXEC SP_ADD_ZERO_PLAN_TRANSMISSION @CustomerList
					,@CurrentMonth
					,@Type
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName
			END
			ELSE IF (@PlanTypeCode = 101)
			BEGIN
				--DIS-RESULT                
				EXEC [dbo].[SP_ADD_DIS_RESULT_TRANSMISSION] @CustomerList
					,@ResultMonth
					,@Type
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName
			END
			ELSE IF (@PlanTypeCode = 102)
			BEGIN
				--DIS-PLAN                
				EXEC [dbo].[SP_ADD_DIS_PLAN_TRANSMISSION] @CustomerList
					,@Type
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName
			END
			ELSE IF (@PlanTypeCode = 103)
			BEGIN
				--CONSOLI                
				EXEC dbo.SP_ADD_CONSOLIDATED_TRANSMISSION @CustomerList
					,@Type
					,@CurrentMonth
					,@CreatedBy
					,@PlanTypeCode
					,@PlanTypeName
			END

			SET @ST = @ST + 1
		END

		SELECT *
		FROM #TMP
	END TRY

	BEGIN CATCH
		INSERT INTO @ResultTable (
			[ResponseCode]
			,[ResponseMessage]
			)
		VALUES (
			500
			,'Exception: ' + ERROR_MESSAGE() + 'at ' + CAST(ERROR_LINE() AS VARCHAR(max))
			);
	END CATCH

	DROP TABLE #TMP

	SELECT DISTINCT [ResponseCode]
		,[ResponseMessage]
	FROM @ResultTable
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateFinalPrice]    Script Date: 7/17/2023 9:10:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE PROCEDURE [dbo].[USP_UpdateFinalPrice] --'202305'    
(    
   @CurrentMonthYear varchar(10) 
)    
AS    
BEGIN    
    -- SET NOCOUNT ON added to prevent extra result sets from    
    -- interfering with SELECT statements.    
    SET NOCOUNT ON    
    
    -- Insert statements for procedure here    
      
Declare @t Table    
(    
SNSEntryID INT,    
CustomerCode varchar(200),    
MaterialCode varchar(200),    
Price decimal(18,2),    
CreateDate Datetime,
MonthYear varchar(200),
ModeofTypeId int)    
Insert into @t(SNSEntryID,CustomerCode,MaterialCode,Price,CreateDate,MonthYear,ModeofTypeId)    
select SN.SNSEntryId, SP.CustomerCode,SP.MaterialCode,SP.Price, SP.CreatedDate,SN.MonthYear,SN.ModeofTypeId  from SNSEntry SN     
inner join SNS_Pricing SP on SN.CustomerCode= SP.CustomerCode and SN.MaterialCode= SP.MaterialCode AND  CONVERT(NVARCHAR(6), SP.To_Date, 112)>=SN.MonthYear    
AND SP.CreatedDate>=SN.CreatedDate    
WHERE SN.MonthYear=@CurrentMonthYear    order by CreatedDate desc
    
--select * from @t    
    
--select SP.SNSEntryId,MonthYear,Qty,Sp.Price,FinalPrice,TotalAmount from SNSEntryQtyPrice SP     
--inner join @t T on T.SNSEntryID = Sp.SNSEntryId    
    
--UPdate SP SET FinalPrice= coalesce(T.Price,SP.FinalPrice),  TotalAmount = coalesce(T.Price,SP.FinalPrice)*SP.Qty from SNSEntryQtyPrice SP     
--inner join @t T on T.SNSEntryID = Sp.SNSEntryId   and SP.MonthYear=@CurrentMonthYear 

UPdate SP SET FinalPrice= T.Price,  TotalAmount = coalesce(T.Price,SP.FinalPrice)*SP.Qty from SNSEntryQtyPrice SP     
inner join @t T on T.SNSEntryID = Sp.SNSEntryId   and SP.MonthYear=@CurrentMonthYear 
  
select 'Run Price Process done successfully' as Message  
END 
GO
