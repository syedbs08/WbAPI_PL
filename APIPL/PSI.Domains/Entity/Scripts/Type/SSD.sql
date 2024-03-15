CREATE TYPE [dbo].[TVP_MODE_OF_TYPE] AS TABLE(
	[RowNo] [int] NULL,
	[ModeofTypeId] [int] NULL,
	[ModeofTypeName] [nvarchar](100) NULL,
	[ModeofTypeCode] [nvarchar](10) NULL,
	[IsACtive] [bit] NULL
)
GO


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

CREATE TYPE [dbo].[TVP_SSD_ENTRY_DUPLICATE_ITEM] AS TABLE(
	[MaterialCode] [nvarchar](20) NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[DuplicateCount] [int] NULL
)
GO

CREATE TYPE [dbo].[TVP_SSD_ENTRY_QTY_PRICES] AS TABLE(
	[RowNo] [int] NULL,
	[RowIndex] [int] NULL,
	[ColIndex] [int] NULL,
	[MonthYear] [int] NULL,
	[Qty] [int] NULL,
	[Price] [decimal](18, 2) NULL
)
GO