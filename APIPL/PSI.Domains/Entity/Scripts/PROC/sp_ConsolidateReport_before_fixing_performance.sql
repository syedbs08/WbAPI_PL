/****** Object:  StoredProcedure [dbo].[sp_ConsolidateReport]    Script Date: 8/20/2023 10:39:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[sp_ConsolidateReport] (
	@TVP_CUSTOMERCODE_LIST [dbo].[TVP_CUSTOMERCODE_LIST] READONLY
	,@Mg VARCHAR(20)
	,@MG1 VARCHAR(20)
	,@SalesSubType VARCHAR(30)
	,@ColumnType VARCHAR(50)
	,@TVP_MonthYear_LIST [dbo].[TVP_MONTHYEAR_TYPE] READONLY
	)
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @TVPCONSOLIDATELIST AS [dbo].[TVP_CONSOLIDATE_LIST];
	DECLARE @CustomerCodeCount AS INT;
	SET @CustomerCodeCount =0;

	SELECT @CustomerCodeCount = COUNT([CustomerCode])
	FROM @TVP_CUSTOMERCODE_LIST
	WHERE [CustomerCode] > 0;

	--Last Month    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyLM'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LM_QTY
			,LM_AMT
			,LMFrt_AMT
			,LMCst_AMT
			,LMFob_AMT
			,LMCog_AMT
			,LMGp_AMT
			,LMGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM @TVP_MonthYear_LIST m 
		 JOIN VW_LM_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyLM'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPLM'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LM_QTY
			,LM_AMT
			,LMFrt_AMT
			,LMCst_AMT
			,LMFob_AMT
			,LMCog_AMT
			,LMGp_AMT
			,LMGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM @TVP_MonthYear_LIST m 
		 JOIN VW_LY_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPLM'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	--Last Year    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyLY'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LY_QTY
			,LY_AMT
			,LYFrt_AMT
			,LYCst_AMT
			,LYFob_AMT
			,LYCog_AMT
			,LYGp_AMT
			,LYGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM @TVP_MonthYear_LIST m 
		 JOIN VW_CM_LY_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyLY'
			AND  (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPLY'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,LY_QTY
			,LY_AMT
			,LYFrt_AMT
			,LYCst_AMT
			,LYFob_AMT
			,LYCog_AMT
			,LYGp_AMT
			,LYGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM @TVP_MonthYear_LIST m 
		 JOIN VW_LY_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPLY'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	--BPBP    
	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BPBP'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,BP_QTY
			,BP_AMT
			,BPFrt_AMT
			,BPCst_AMT
			,BPFob_AMT
			,BPCog_AMT
			,BPGp_AMT
			,BPGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM  @TVP_MonthYear_LIST m 
		 JOIN VW_LY_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BPBP'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'MonthlyBP'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,BP_QTY
			,BP_AMT
			,BPFrt_AMT
			,BPCst_AMT
			,BPFob_AMT
			,BPCog_AMT
			,BPGp_AMT
			,BPGp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM  @TVP_MonthYear_LIST m 
		 JOIN VW_CM_BP_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'MonthlyBP'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'CM'
				) >= 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,Qty
			,Amount
			,Frt_AMT
			,Cst_AMT
			,Fob_AMT
			,Cog_AMT
			,Gp_AMT
			,Gp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM @TVP_MonthYear_LIST m 
		 JOIN VW_CM_BP_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'CM'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END
	ELSE IF (
			(
				SELECT COUNT(*)
				FROM @TVP_MonthYear_LIST
				WHERE [type] = 'BP'
				) > 1
			)
	BEGIN
		INSERT INTO @TVPCONSOLIDATELIST (
			Department
			,CustomerCode
			,Country
			,SalesOffice
			,SalesType
			,Consignee
			,Group_Desc
			,SubGroup
			,[Type]
			,MaterialCode
			,MonthYear
			,Qty
			,Amount
			,Frt_AMT
			,Cst_AMT
			,Fob_AMT
			,Cog_AMT
			,Gp_AMT
			,Gp_Percentage
			)
		SELECT DISTINCT DepartmentName AS Department
			,CustomerCode
			,CountryName AS Country
			,SalesOfficeName AS SalesOffice
			,SalesType
			,Consignee
			,MG AS GROUP_DESC
			,MG1 AS SubGroup
			,MG2 AS [Type]
			,MaterialCode
			,C.MonthYear
			,Qty
			,Amount
			,FRT_AMT
			,CST_AMT
			,FOB_AMT
			,COG_AMT
			,GP_AMT
			,GP_PER
		FROM  @TVP_MonthYear_LIST m 
		 JOIN VW_CM_BP_ConsolidatedReport c ON c.MonthYear = m.MONTHYEAR
		WHERE m.[type] = 'BP'
			AND (CustomerCode IN (
					SELECT [CustomerCode]
					FROM @TVP_CUSTOMERCODE_LIST
					)
					OR @CustomerCodeCount = 0)
			AND (ProductCategoryId2 = @Mg OR @Mg = 0)
			AND (ProductCategoryId3 = @MG1 OR @MG1 = 0 )
			AND c.SaleSubType = @SalesSubType
	END

	SELECT *
	FROM @TVPCONSOLIDATELIST;
END