CREATE TABLE [dbo].[TRNSalesPlanning](
	[TRNSalesPlanningId] [int] IDENTITY(1,1) NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TRNSalesPlanningId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[TRNSalesPlanningArchival](
	[TRNSalesPlanningArchivalId] [int] IDENTITY(1,1) NOT NULL,
	[MonthYear] [int] NULL,
	[CustomerCode] [varchar](50) NULL,
	[MaterialCode] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[Amount] [decimal](18, 2) NULL,
	[AccountCode] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TRNSalesPlanningArchivalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO