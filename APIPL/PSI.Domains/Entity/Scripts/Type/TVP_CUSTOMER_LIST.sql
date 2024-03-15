
-- DROP PROC [dbo].[SP_CM_BP_ConsolidatedReport]
-- GO

-- DROP PROC [dbo].[SP_BP_ConsolidatedReport]
-- GO

-- DROP PROC [dbo].[SP_BP_LY_ConsolidatedReport]
-- GO

-- DROP  PROC [dbo].[SP_CM_LY_ConsolidatedReport]
-- GO

-- DROP  PROC [dbo].[SP_LM_ConsolidatedReport]
-- GO

-- DROP PROC [dbo].[sp_ConsolidateReport] 
-- GO

-- DROP TYPE [dbo].[TVP_CUSTOMER_LIST]
-- GO

IF TYPE_ID('dbo.TVP_CUSTOMER_LIST') IS  NULL  
BEGIN  
	CREATE TYPE [dbo].[TVP_CUSTOMER_LIST] AS TABLE(
	[CustomerId] [int] NULL,
	[CustomerName] [nvarchar](200) NULL,
	[CustomerCode] [nvarchar](10) NULL,
	[DepartmentName] [nvarchar](100) NULL,
	[CountryId] [int] NULL,
	[CountryName] [nvarchar](200) NULL,
	[SalesOfficeName] [nvarchar](200) NULL,
	[AccountCode] [nvarchar](200) NULL
	);
END

