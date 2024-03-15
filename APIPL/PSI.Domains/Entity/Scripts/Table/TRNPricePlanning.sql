CREATE TABLE [dbo].[TRNPricePlanning](
	[TRNPricePlanningId] [int] IDENTITY(1,1) NOT NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TRNPricePlanningId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[TRNPricePlanningArchival](
	[TRNPricePlanningArchivalId] [int] IDENTITY(1,1) NOT NULL,
	[AccountCode] [varchar](50) NULL,
	[MonthYear] [int] NULL,
	[MaterialCode] [varchar](50) NULL,
	[ModeofType] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Quantity] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[TRNPricePlanningArchivalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO