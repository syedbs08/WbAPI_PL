
DROP TABLE IF EXISTS [dbo].[GlobalConfig];
GO

/****** Object:  Table [dbo].[GlobalConfig]    Script Date: 5/3/2023 8:54:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[GlobalConfig](
	[GlobalConfigId] [int] IDENTITY(1,1) NOT NULL,
	[ConfigKey] [varchar](100) NULL,
	[ConfigValue] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[GlobalConfigId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO

SET ANSI_PADDING OFF
GO