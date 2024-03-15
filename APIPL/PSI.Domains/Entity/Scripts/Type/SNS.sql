CREATE TYPE [dbo].[TVP_CODE_LIST] AS TABLE(
	[Code] [nvarchar](MAX) NULL
);
GO

CREATE TYPE [dbo].[TVP_PRICE_PLANNING] AS TABLE(
	[TRNPricePlanningId] [int] NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL
)
GO

CREATE TYPE [dbo].[TVP_SALES_PLANNING] AS TABLE(
	[TRNSalesPlanningId] [int] NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL
)
GO

CREATE TYPE [dbo].[TVP_SNS_ENTRY_QTY_PRICES] AS TABLE(
	[SNSEntryId] [int] NOT NULL,
	[SNSEntryQtyPriceId] [int] NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [nvarchar](20) NULL
)
GO


CREATE TYPE [dbo].[TVP_CODE_LIST_WITH_ROW_NO] AS TABLE(
	[RowNo] [int] NOT NULL,
	[Code] [nvarchar](max) NULL
)
GO

CREATE TYPE [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST] AS TABLE(
	[AccountCode] [nvarchar](max) NULL,
	[MaterialCode] [nvarchar](max) NULL
)
GO

CREATE TYPE [dbo].[TVP_ACCOUNT_MATERIAL_CODE_LIST_WITH_ROWNO] AS TABLE(
	[RowNo] [int] NOT NULL,
	[AccountCode] [nvarchar](max) NULL,
	[MaterialCode] [nvarchar](max) NULL
)
GO