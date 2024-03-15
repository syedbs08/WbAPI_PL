CREATE TABLE [dbo].[SSDEntry](
	[SSDEntryId] [int] IDENTITY(1,1) NOT NULL,
	[ModeofTypeId] [int] NULL,
	[CustomerId] [int] NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[MaterialId] [int] NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[AttachmentId] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](200) NULL,
 CONSTRAINT [PK_SSDEntry] PRIMARY KEY CLUSTERED 
(
	[SSDEntryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[SSDEntryQtyPrice](
	[SSDEntryQtyPriceId] [int] IDENTITY(1,1) NOT NULL,
	[SSDEntryId] [int] NULL,
	[MonthYear] [int] NULL,
	[Qty] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](200) NULL,
 CONSTRAINT [PK_SSDEntryQtyPrice] PRIMARY KEY CLUSTERED 
(
	[SSDEntryQtyPriceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SSDEntryQtyPrice]  WITH CHECK ADD  CONSTRAINT [FK_SSDEntryQtyPrice_SSDEntry] FOREIGN KEY([SSDEntryId])
REFERENCES [dbo].[SSDEntry] ([SSDEntryId])
GO

ALTER TABLE [dbo].[SSDEntryQtyPrice] CHECK CONSTRAINT [FK_SSDEntryQtyPrice_SSDEntry]
GO

----------Archive-------


CREATE TABLE [dbo].[SSDEntryArchive](
	[SSDEntryArchiveId] [int] NOT NULL,
	[ModeofTypeId] [int] NULL,
	[CustomerId] [int] NULL,
	[CustomerCode] [nvarchar](20) NULL,
	[MaterialId] [int] NULL,
	[MaterialCode] [nvarchar](20) NULL,
	[AttachmentId] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](200) NULL,
 CONSTRAINT [PK_SSDEntryArchive] PRIMARY KEY CLUSTERED 
(
	[SSDEntryArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[SSDEntryQtyPriceArchive](
	[SSDEntryQtyPriceArchiveId] [int] NOT NULL,
	[SSDEntryArchiveId] [int] NULL,
	[MonthYear] [int] NULL,
	[Qty] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](200) NULL,
 CONSTRAINT [PK_SSDEntryQtyPriceArchive] PRIMARY KEY CLUSTERED 
(
	[SSDEntryQtyPriceArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SSDEntryQtyPriceArchive]  WITH CHECK ADD  CONSTRAINT [FK_SSDEntryQtyPrice_SSDEntryArchive] FOREIGN KEY([SSDEntryArchiveId])
REFERENCES [dbo].[SSDEntryArchive] ([SSDEntryArchiveId])
GO

ALTER TABLE [dbo].[SSDEntryQtyPriceArchive] CHECK CONSTRAINT [FK_SSDEntryQtyPrice_SSDEntryArchive]
GO