DROP TABLE IF EXISTS [dbo].[SalesArchivalEntryPriceQuantity];
DROP TABLE IF EXISTS [dbo].[SalesArchivalEntry];
DROP TABLE IF EXISTS [dbo].[SaleEntryArchivalHeader];
GO

CREATE TABLE [dbo].[SaleEntryArchivalHeader](
	[SaleEntryArchivalHeaderId] [int] NOT NULL,
	[CustomerId] [int] NULL,
	[SaleTypeId] [int] NULL,
	[ProductCategoryId1] [nvarchar](20) NULL,
	[ProductCategoryId2] [nvarchar](20) NULL,
	[CurrentMonthYear] [varchar](50) NULL,
	[LockMonthYear] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](100) NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateBy] [varchar](100) NULL,
	[AttachmentId] [int] NULL,
	[SaleSubType] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[SaleEntryArchivalHeaderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[SalesArchivalEntry](
	[SalesArchivalEntryId] [int] NOT NULL,
	[SaleEntryArchivalHeaderId] [int] NULL,
	[MaterialId] [int] NULL,
	[ProductCategoryCode1] [nvarchar](20) NULL,
	[ProductCategoryCode2] [nvarchar](20) NULL,
	[ProductCategoryCode3] [nvarchar](20) NULL,
	[ProductCategoryCode4] [nvarchar](20) NULL,
	[ProductCategoryCode5] [nvarchar](20) NULL,
	[ProductCategoryCode6] [nvarchar](20) NULL,
	[OCmonthYear] [varchar](200) NULL,
	[OCstatus] [varchar](50) NULL,
	[FileInfoId] [int] NULL,
	[O_LockMonthConfirmedStatus] [varchar](100) NULL,
	[O_LockMonthConfirmedBy] [varchar](100) NULL,
	[O_LockMonthConfirmedDate] [varchar](100) NULL,
	[ModeOfTypeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesArchivalEntryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SalesArchivalEntry]  WITH CHECK ADD FOREIGN KEY([FileInfoId])
REFERENCES [dbo].[FileInfo] ([FileInfoId])
GO

ALTER TABLE [dbo].[SalesArchivalEntry]  WITH CHECK ADD FOREIGN KEY([MaterialId])
REFERENCES [dbo].[Material] ([MaterialId])
GO

ALTER TABLE [dbo].[SalesArchivalEntry]  WITH CHECK ADD FOREIGN KEY([SaleEntryArchivalHeaderId])
REFERENCES [dbo].[SaleEntryArchivalHeader] ([SaleEntryArchivalHeaderId])
GO


CREATE TABLE [dbo].[SalesArchivalEntryPriceQuantity](
	[SalesArchivalEntryPriceQuantityId] [int] NOT NULL,
	[SalesArchivalEntryId] [int] NULL,
	[MonthYear] [varchar](50) NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[OrderIndicationConfirmedBySaleTeam] [varchar](500) NULL,
	[OrderIndicationConfirmedBySaleTeamDate] [datetime] NULL,
	[OrderIndicationConfirmedByMarketingTeam] [varchar](500) NULL,
	[OrderIndicationConfirmedByMarketingTeamDate] [datetime] NULL,
	[O_LockMonthConfirmedBy] [varchar](500) NULL,
	[O_LockMonthConfirmedDate] [datetime] NULL,
	[Reason] [varchar](200) NULL,
	[IsSNS] [bit] NULL,
	[IsPO] [bit] NULL,
	[TermId] [varchar](100) NULL,
	[Remarks] [varchar](max) NULL,
	[CurrencyCode] [nvarchar](20) NULL,
    [OcIndicationMonthAttachmentIds] [varchar](max) NULL,
	[OcIndicationMonthStatus] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[SalesArchivalEntryPriceQuantityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SalesArchivalEntryPriceQuantity]  WITH CHECK ADD FOREIGN KEY([SalesArchivalEntryId])
REFERENCES [dbo].[SalesArchivalEntry] ([SalesArchivalEntryId])
GO
