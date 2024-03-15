-- drop proc [dbo].[sp_consolidatereport];
-- go

 -- drop type [dbo].[tvp_consolidate_list];
 -- go

IF TYPE_ID('dbo.TVP_CONSOLIDATE_LIST') IS  NULL  
BEGIN  
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

	[Qty] [bigint] DEFAULT 0,
	[Amount] [bigint] DEFAULT 0,
	[Frt_AMT] [decimal](18, 2) DEFAULT 0,
	[Cst_AMT] [decimal](18, 2) DEFAULT 0,
	[Fob_AMT] [decimal](18, 2) DEFAULT 0,
	[Cog_AMT] [decimal](18, 2) DEFAULT 0,
	[Gp_AMT] [decimal](18, 2) DEFAULT 0,
	[Gp_Percentage] [decimal](18, 2) DEFAULT 0,

	[BP_QTY] [bigint] DEFAULT 0,
	[BP_AMT] [bigint] DEFAULT 0,
	[BPFrt_AMT] [decimal](18, 2) DEFAULT 0,
	[BPCst_AMT] [decimal](18, 2) DEFAULT 0,
	[BPFob_AMT] [decimal](18, 2) DEFAULT 0,
	[BPCog_AMT] [decimal](18, 2) DEFAULT 0,
	[BPGp_AMT] [decimal](18, 2) DEFAULT 0,
	[BPGp_Percentage] [decimal](18, 2) DEFAULT 0,

	[LM_QTY] [bigint] DEFAULT 0,
	[LM_AMT] [bigint] DEFAULT 0,
	[LMFrt_AMT] [decimal](18, 2) DEFAULT 0,
	[LMCst_AMT] [decimal](18, 2) DEFAULT 0,
	[LMFob_AMT] [decimal](18, 2) DEFAULT 0,
	[LMCog_AMT] [decimal](18, 2) DEFAULT 0,
	[LMGp_AMT] [decimal](18, 2) DEFAULT 0,
	[LMGp_Percentage] [decimal](18, 2) DEFAULT 0,

	[LY_Qty] [bigint] DEFAULT 0,
	[LY_AMT] [bigint] DEFAULT 0,
	[LYFrt_AMT] [decimal](18, 2) DEFAULT 0,
	[LYCst_AMT] [decimal](18, 2) DEFAULT 0,
	[LYFob_AMT] [decimal](18, 2) DEFAULT 0,
	[LYCog_AMT] [decimal](18, 2) DEFAULT 0,
	[LYGp_AMT] [decimal](18, 2) DEFAULT 0,
	[LYGp_Percentage] [decimal](18, 2) DEFAULT 0
)
END
GO


