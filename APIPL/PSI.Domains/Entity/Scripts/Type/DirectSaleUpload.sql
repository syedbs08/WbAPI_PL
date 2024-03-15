
DROP TYPE IF EXISTS [dbo].[TVP_CUSTOMER_COUNTRY_CURRENCY];
Go
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

DROP TYPE IF EXISTS [dbo].[TVP_RESULT_TABLE];
Go
CREATE TYPE [dbo].[TVP_RESULT_TABLE] AS TABLE(
	[RowNo] INT NULL DEFAULT (0),
	[ResponseCode] [nvarchar](10) NULL DEFAULT ('0'),
	[ResponseMessage] [nvarchar](max) NULL DEFAULT ('')
)
GO

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM];
Go
CREATE TYPE [dbo].[TVP_SALES_ENTRY_DUPLICATE_ITEM] AS TABLE(
	[ItemCode] [nvarchar](50) NULL,
	[TypeCode] [nvarchar](50) NULL,
	[DuplicateCount] [int] NULL
)
GO

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_HEADERS];
Go
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

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_PRICES];
Go
CREATE TYPE [dbo].[TVP_SALES_ENTRY_PRICES] AS TABLE(
	[RowIndex] [int] NULL,
	[PriceMonthName] [nvarchar](50) NULL,
	[Price] [decimal](18, 6) NULL
)
GO

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_QTY_PRICES];
Go
CREATE TYPE [dbo].[TVP_SALES_ENTRY_QTY_PRICES] AS TABLE(
	[RowIndex] [int] NULL,
	[RowNo] [int] NULL,
	[PriceMonthName] [nvarchar](20) NULL,
	[Price] [decimal](18, 6) NULL,
	[Qty] [int] NULL,
	[Currency] [nvarchar](20) NULL
)
GO

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_QUANTITIES];
Go
CREATE TYPE [dbo].[TVP_SALES_ENTRY_QUANTITIES] AS TABLE(
	[RowIndex] [int] NULL,
	[QtyMonthName] [nvarchar](50) NULL,
	[Qty] [int] NULL
)
GO

DROP TYPE IF EXISTS [dbo].[TVP_SALES_ENTRY_ROWS];
Go
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