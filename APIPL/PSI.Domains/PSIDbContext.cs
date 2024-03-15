using Core.BaseUtility.Utility;
using Microsoft.EntityFrameworkCore;
using PSI.Domains.Entity;

namespace PSI.Domains;

public partial class PSIDbContext : DbContext
{

    public PSIDbContext()
    {

    }

    public PSIDbContext(DbContextOptions<PSIDbContext> options)
        : base(options)
    {
    }
    public virtual DbSet<SNS_Mapping> SNS_Mapping { get; set; }
    public virtual DbSet<ReportVariant> ReportVariant { get; set; }
    public virtual DbSet<SP_SNSMAPPINGSEARCH> SP_SNSMAPPINGSEARCH { get; set; }
    public virtual DbSet<SP_TRANSMISSION_SEARCH> SP_TRANSMISSION_SEARCH { get; set; }
    public virtual DbSet<SP_ACCURANCY_REPORT_SEARCH> SP_ACCURANCY_REPORT_SEARCH { get; set; }
    public virtual DbSet<SP_MATERIALSEARCH> SP_MATERIALSEARCH { get; set; }
    public virtual DbSet<SP_Insert_TRNSalesPlanning_BP> SP_Insert_TRNSalesPlanning_BP { get; set; }
    public virtual DbSet<DashMaterial> DashMaterial { get; set; }
    public virtual DbSet<SalesEntry_BP> SalesEntry_BP { get; set; }
    public virtual DbSet<TransmissionPlanType> TransmissionPlanType { get; set; }
    public virtual DbSet<TransmissionList> TransmissionList { get; set; }
    public virtual DbSet<LockPSI> LockPSI { get; set; }

    public virtual DbSet<SalesEntry> SalesEntries { get; set; }
    public virtual DbSet<SalesArchivalEntry> SalesArchivalEntry { get; set; }
    public virtual DbSet<ModeofType> ModeofType { get; set; }
    public virtual DbSet<Attachment> Attachments { get; set; }
    public virtual DbSet<PSIDates> PSIDates { get; set; }
    public virtual DbSet<Account> Accounts { get; set; }
    public virtual DbSet<MaterialView> MaterialViews { get; set; }
    public virtual DbSet<CustomerView> CustomerViews { get; set; }
    public virtual DbSet<VW_Customers> VW_Customers { get; set; }

    public virtual DbSet<Company> Companies { get; set; }

    public virtual DbSet<Country> Countries { get; set; }

    public virtual DbSet<Currency> Currencies { get; set; }

    public virtual DbSet<Customer> Customers { get; set; }

    public virtual DbSet<CustomerDID> CustomerDIDs { get; set; }

    public virtual DbSet<Department> Departments { get; set; }
    public virtual DbSet<SaleType> SaleTypeS { get; set; }
    public virtual DbSet<MaterialCountryMapping> MaterialCountryMappings { get; set; }
    public virtual DbSet<Material> Materials { get; set; }
    public virtual DbSet<ProductCategory> ProductCategories { get; set; }
    public virtual DbSet<Region> Regions { get; set; }
    public virtual DbSet<TurnoverDays> TurnoverDays { get; set; }
    public virtual DbSet<SalesOffice> SalesOffices { get; set; }
    public virtual DbSet<SalesOrganization> SalesOrganizations { get; set; }
    public virtual DbSet<Supplier> Suppliers { get; set; }
    public virtual DbSet<SeaPort> SeaPorts { get; set; }
    public virtual DbSet<AirPort> AirPorts { get; set; }
    public virtual DbSet<Product> Products { get; set; }
    public virtual DbSet<TRNPricePlanning> TRNPricePlannings { get; set; }
    public virtual DbSet<TRNSalesPlanning> TRNSalesPlannings { get; set; }
    public virtual DbSet<SNSEntryQtyPrice> SNSEntryQtyPrices { get; set; }
    public virtual DbSet<SNSEntry> SNSEntries { get; set; }
    public virtual DbSet<UserDepartmentMapping> UserDepartmentMappings { get; set; }
    public virtual DbSet<UserProductMapping> UserProductMappings { get; set; }
    public virtual DbSet<UserProfileView> UserProfileViews { get; set; }
    public virtual DbSet<VW_DASHMASTER> VW_DASHMASTER { get; set; }
    public virtual DbSet<SP_DashMasterMonthly> SP_DashMasterMonthly { get; set; }
    public virtual DbSet<VW_DashMasterMonthWise> VW_DashMasterMonthWise { get; set; }
    public virtual DbSet<UserDepartmentCountryView> UserDepartmentCountryView { get; set; }
    public virtual DbSet<VW_DASHMASTERBP> VW_DASHMASTERBP { get; set; }
    public virtual DbSet<SP_OcIndicationMonthConfirm> SP_OcIndicationMonthConfirm { get; set; }
    public virtual DbSet<DirectSaleView> DirectSaleView { get; set; }
    public virtual DbSet<SP_InsertSalesEntries> SP_InsertSalesEntries { get; set; }
    public virtual DbSet<SP_OcoLockMonth> SP_OcoLockMonths { get; set; }
    public virtual DbSet<SP_SalesEntryOCConfirmation> SP_SalesEntryOCConfirmation { get; set; }
    public virtual DbSet<SP_Get_Customer_Country_Currency> SP_Get_Customer_Country_Currency { get; set; }
    public virtual DbSet<GlobalConfig> GlobalConfig { get; set; }
    public virtual DbSet<USP_InsertSNSPrice> USP_InsertSNSPrices { get; set; }
    public virtual DbSet<USP_InsertSNSFOBPrice> USP_InsertSNSFOBPrices { get; set; }


    public virtual DbSet<SP_ResponseResult> SP_ResponseResult { get; set; }
    public virtual DbSet<SP_InsertSNSEntryDetails> SP_InsertSNSEntryDetails { get; set; }
    public virtual DbSet<Sp_Direct_SNS_Archive> Sp_Direct_SNS_Archive { get; set; }
    public virtual DbSet<Sp_Get_Direct_SNS_Archive> Sp_Get_Direct_SNS_Archive { get; set; }
    public virtual DbSet<USP_UpdateFinalPrice> USP_UpdateFinalPrice { get; set; }

    public virtual DbSet<SP_SNSEntryDownload> SP_SNSEntryDownload { get; set; }

    public virtual DbSet<SP_SNSEntryQtyPriceDowload> SP_SNSEntryQtyPriceDowload { get; set; }
    public virtual DbSet<SNSEntryQtyPrice> SNSEntryQtyPrice { get; set; }

    public virtual DbSet<SP_SNSEntryQtyPriceForDownload> SP_SNSEntryQtyPriceForDownload { get; set; }
    public virtual DbSet<SNS_Planning_Comment> SNS_Planning_Comment { get; set; }
    public virtual DbSet<VW_SNSPlanningComment> VW_SNSPlanningComment { get; set; }
    public virtual DbSet<SP_Get_CustomerWiseSaleQtyPrice> SP_Get_CustomerWiseSaleQtyPrice { get; set; }
    public virtual DbSet<AdjustmentEntry> Adjustment { get; set; }
    public virtual DbSet<AdjustmentEntryQtyPrice> AdjustmentQtyPrice { get; set; }

    public virtual DbSet<SP_INSERT_ADJUSTMENT> SP_INSERT_ADJUSTMENT { get; set; }
    public virtual DbSet<SP_AdjustmentSearch> SP_AdjustmentSearch { get; set; }
    public virtual DbSet<Users> Users { get; set; }
    public virtual DbSet<SP_LockPSI> SP_LockPSI { get; set; }
    public virtual DbSet<SP_Insert_SSD_Entries> SP_Insert_SSD_Entries { get; set; }

    public virtual DbSet<VW_ATTACHMENT> VW_ATTACHMENT { get; set; }
    public virtual DbSet<SP_InsertCOGEntryDetails> SP_InsertCOGEntryDetails { get; set; }
    public virtual DbSet<TransmissionListView> TransmissionListView { get; set; }

    public virtual DbSet<SP_COGSearch> SP_COGSearch { get; set; }
    public virtual DbSet<SPINSRESULTPURCHASE> SPINSRESULTPURCHASE { get; set; }
    public virtual DbSet<Sp_UpdateConsinee> Sp_UpdateConsinee { get; set; }
    public virtual DbSet<Sp_TransmissionListCustomer> Sp_TransmissionListCustomer { get; set; }
    public virtual DbSet<TransmissionData> TransmissionData { get; set; }
    public virtual DbSet<SP_TRANSMISSIONDATA> SP_TRANSMISSIONDATA { get; set; }
    public virtual DbSet<sp_ConsolidateReport> sp_ConsolidateReport { get; set; }
    public virtual DbSet<sp_NonConsolidateReport> sp_NonConsolidateReport { get; set; }
    public virtual DbSet<ReportAdditionalColumn> ReportAdditionalColumn { get; set; }

    public virtual DbSet<SP_BI_BP_AGENT_OPSI> SP_BI_BP_AGENT_OPSI { get; set; }

    public virtual DbSet<SP_BI_LM_AGENT_OPSI> SP_BI_LM_AGENT_OPSI { get; set; }

    public virtual DbSet<SP_BI_FORECAST_AGENT_SNS_SALES> SP_BI_FORECAST_AGENT_SNS_SALES { get; set; }

    public virtual DbSet<SP_BI_FORECAST_AGENT_OPSI> SP_BI_FORECAST_AGENT_OPSI { get; set; }

    public virtual DbSet<SP_BI_BP_AGENT_SNS> SP_BI_BP_AGENT_SNS { get; set; }
    public virtual DbSet<SP_BI_LM_AGENT_SNSI> SP_BI_LM_AGENT_SNSI { get; set; }
    public virtual DbSet<SP_GET_PLANNEDCUSTOMER> SP_GET_PLANNEDCUSTOMER { get; set; }
    public virtual DbSet<SP_GLOBALCONFIG_MONTH> SP_GLOBALCONFIG_MONTH { get; set; }
    public virtual DbSet<SP_DirectSales_Report> SP_DirectSales_Report { get; set; }
    public virtual DbSet<VW_SalesEntryMaterial> VW_SalesEntryMaterial { get; set; }
    public virtual DbSet<SP_SALES_DOWNLOAD_BP> SP_SALES_DOWNLOAD_BP { get; set; }


    public virtual DbSet<BWExecutionLog> BWExecutionLog { get; set; }
    public virtual DbSet<SP_TRNPricePlanningSearch> SP_TRNPricePlanningSearch { get; set; }

    public virtual DbSet<DashTransmit> DashTransmit { get; set; }

    public virtual DbSet<SP_GETLOCKPSI> SP_GETLOCKPSI { get; set; }
    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {

            optionsBuilder.UseSqlServer(ConfigHelper.Settings("AppConfig:PSIDbContext"),
                sqlServerOptionsAction: sqlOptioins =>
                {
                    sqlOptioins.EnableRetryOnFailure();
                    sqlOptioins.CommandTimeout(1500);
                });

        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {

        modelBuilder.Entity<ReportVariant>(entity =>
        {
            entity.ToTable("ReportVariant");
            entity.HasKey(p => p.ReportVariantId);
        });
        modelBuilder.Entity<SP_SNSMAPPINGSEARCH>(entity =>
        {
            entity.ToTable("SP_SNSMAPPINGSEARCH");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SNS_Mapping>(entity =>
        {
            entity.ToTable("SNS_Mapping");
            entity.HasKey(e => e.SNS_MappingId);
        });
        modelBuilder.Entity<SP_ACCURANCY_REPORT_SEARCH>(entity =>
        {
            entity.ToTable("SP_ACCURANCY_REPORT_SEARCH");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_MATERIALSEARCH>(entity =>
        {
            entity.ToTable("SP_MATERIALSEARCH");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_TRANSMISSION_SEARCH>(entity =>
        {
            entity.ToTable("SP_TRANSMISSION_SEARCH");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_SALES_DOWNLOAD_BP>(entity =>
        {
            entity.ToTable("SP_SALES_DOWNLOAD_BP");
            entity.HasNoKey();
        });

        modelBuilder.Entity<ReportAdditionalColumn>(entity =>
        {
            entity.ToTable("ReportAdditionalColumn");
            entity.HasKey(p => p.ReportAdditionColumnId);
        });
        modelBuilder.Entity<DashMaterial>(entity =>
        {
            entity.ToTable("DashMaterial");
            entity.HasKey(p => p.DashMaterialId);
        });
        modelBuilder.Entity<sp_NonConsolidateReport>(entity =>
        {
            entity.ToTable("sp_NonConsolidateReport");
            entity.HasNoKey();
        });
        modelBuilder.Entity<VW_SalesEntryMaterial>(entity =>
        {
            entity.ToTable("VW_SalesEntryMaterial");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_DirectSales_Report>(entity =>
        {
            entity.ToTable("SP_DirectSales_Report");
            entity.HasNoKey();
        });
        modelBuilder.Entity<sp_ConsolidateReport>(entity =>
        {
            entity.ToTable("SP_Consolidated_Report");
            entity.HasNoKey();
        });
        modelBuilder.Entity<TransmissionList>(entity =>
        {
            entity.ToTable("TransmissionList");
            entity.HasKey(p => p.TransmissionListId);
        });

        modelBuilder.Entity<SP_TRANSMISSIONDATA>(entity =>
        {
            entity.ToTable("SP_TRANSMISSIONDATA");
            entity.HasNoKey();
        });
        modelBuilder.Entity<Sp_TransmissionListCustomer>(entity =>
        {
            entity.ToTable("Sp_TransmissionLCustomer");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_ResponseResult>(entity =>
        {
            entity.ToTable("SP_ResponseResult");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_Insert_TRNSalesPlanning_BP>(entity =>
        {
            entity.ToTable("SP_Insert_TRNSalesPlanning_BP");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_LockPSI>(entity =>
        {
            entity.ToTable("SP_LockPSI");
            entity.HasNoKey();
        });
        modelBuilder.Entity<TransmissionListView>(entity =>
        {
            entity.ToTable("TransmissionListView");
            entity.HasNoKey();
        });
        modelBuilder.Entity<TransmissionPlanType>(entity =>
        {
            entity.ToTable("TransmissionPlanType");
            entity.HasKey(p => p.TransmissionPlanTypeId);
        });

        modelBuilder.Entity<SP_AdjustmentSearch>(entity =>
        {
            entity.ToTable("SP_AdjustmentSearch");
            entity.HasNoKey();
        });
        modelBuilder.Entity<AdjustmentEntry>(entity =>
        {
            entity.ToTable("AdjustmentEntry");
            entity.HasKey(p => p.AdjustmentEntryId);
        });
        modelBuilder.Entity<AdjustmentEntryQtyPrice>(entity =>
        {
            entity.ToTable("AdjustmentEntryQtyPrice");
            entity.HasKey(p => p.AdjustmentEntryQtyPriceId);
        });
        modelBuilder.Entity<Users>(entity =>
        {
            entity.ToTable("Users");
            entity.HasKey(p => p.UserId);
        });
        modelBuilder.Entity<SalesEntry_BP>(entity =>
        {
            entity.ToTable("SalesEntry_BP");
            entity.HasKey(p => p.SalesEntryId);
        });

        modelBuilder.Entity<SNS_Planning_Comment>(entity =>
        {
            entity.ToTable("SNS_Planning_Comment");
        });
        modelBuilder.Entity<USP_UpdateFinalPrice>(entity =>
        {
            entity.ToTable("USP_UpdateFinalPrice");
            entity.HasNoKey();
        });
        modelBuilder.Entity<Sp_Direct_SNS_Archive>(entity =>
        {
            entity.ToTable("Sp_Direct_SNS_Archive");
            entity.HasNoKey();
        });
        modelBuilder.Entity<Sp_Get_Direct_SNS_Archive>(entity =>
        {
            entity.ToTable("Sp_Get_Direct_SNS_Archive");
            entity.HasNoKey();
        });


        modelBuilder.Entity<LockPSI>(entity =>
          {
              entity.ToTable("LockPSI");
          });
        modelBuilder.Entity<SalesEntry>(entity =>
        {
            entity.ToTable("SalesEntry");
        });


        modelBuilder.Entity<SalesArchivalEntry>(entity =>
        {
            entity.ToTable("SalesArchivalEntry");
        });


        modelBuilder.Entity<ModeofType>(entity =>
        {
            entity.ToTable("ModeofType");
        });
        modelBuilder.Entity<Supplier>(entity =>
        {
            entity.ToTable("Supplier");
            entity.Property(e => e.SupplierName).HasMaxLength(100);
        });
        modelBuilder.Entity<SeaPort>(entity =>
        {
            entity.ToTable("SeaPort");
            entity.Property(e => e.SeaPortName).HasMaxLength(100);
        });
        modelBuilder.Entity<AirPort>(entity =>
        {
            entity.ToTable("AirPort");
            entity.Property(e => e.AirPortName).HasMaxLength(100);
        });
        modelBuilder.Entity<PSIDates>(entity =>
        {
            entity.ToTable("PSIDates");
            entity.Property(e => e.Month).HasMaxLength(100);

            entity.Property(e => e.TransmitDate).HasColumnType("datetime");

            entity.Property(e => e.ATPDate).HasColumnType("datetime");
            entity.Property(e => e.PODate).HasColumnType("datetime");

            entity.Property(e => e.IsActive).HasMaxLength(100);
        });
        modelBuilder.Entity<TurnoverDays>(entity =>
        {
            entity.ToTable("TurnoverDays");
            entity.Property(e => e.Month).HasMaxLength(100);

            entity.Property(e => e.BP_Year).HasMaxLength(200);

        });

        modelBuilder.Entity<Attachment>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK_Attachments");

            entity.Property(e => e.DocumentName).HasMaxLength(100);

            entity.Property(e => e.DocumentPath).HasMaxLength(200);

            entity.Property(e => e.Extension).HasMaxLength(10);

            entity.Property(e => e.FileTypeName).HasMaxLength(100);

            entity.Property(e => e.VirtualFileName).HasMaxLength(100);
        });
        modelBuilder.Entity<Account>(entity =>
        {
            entity.HasKey(e => e.AccountId).HasName("PK__Account__349DA5A6A3C953CE");

            entity.ToTable("Account");

            entity.Property(e => e.AccountCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.AccountName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Company>(entity =>
        {
            entity.ToTable("Company");

            entity.Property(e => e.CompanyCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CompanyName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Country>(entity =>
        {
            entity.ToTable("Country");

            entity.Property(e => e.CountryCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CountryName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Currency>(entity =>
        {
            entity.ToTable("Currency");
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CurrencyCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CurrencyName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.ExchangeRate).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Customer>(entity =>
        {
            entity.ToTable("Customer");
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.CustomerCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CustomerName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CustomerShortName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.EmailId)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.IsBp).HasColumnName("IsBP");
            entity.Property(e => e.IsPsi).HasColumnName("IsPSI");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<CustomerDID>(entity =>
        {
            entity.HasKey(e => e.CustomerDIDId).HasName("PK__Customer__2D57AB896E34288D");

            entity.ToTable("CustomerDID");

            entity.Property(e => e.CustomerDIDId).HasColumnName("CustomerDIDId");
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Department>(entity =>
        {
            entity.ToTable("Department");
            entity.Property(e => e.DepartmentCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.DepartmentName)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<SaleType>(entity =>
        {
            entity.HasKey(e => e.SaleTypeId);
            entity.ToTable("SaleType");

        });

        modelBuilder.Entity<MaterialCountryMapping>(entity =>
        {
            entity.HasKey(e => e.MaterialCountryMappingId).HasName("PK_MaterialCountryMapping");

            entity.ToTable("MaterialCountryMapping");

            entity.Property(e => e.MaterialCountryMappingId).ValueGeneratedNever();
        });

        modelBuilder.Entity<Material>(entity =>
        {
            entity.ToTable("Material");
            entity.Property(e => e.AirPortId)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.BarCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.MaterialCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.SeaPortId)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
            entity.Property(e => e.Volume).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.Weight).HasColumnType("decimal(18, 0)");
        });

        modelBuilder.Entity<ProductCategory>(entity =>
        {
            entity.ToTable("ProductCategory");
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.ProductCategoryName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<Region>(entity =>
        {
            entity.ToTable("Region");

            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.RegionCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.RegionName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<SalesOffice>(entity =>
        {
            entity.HasKey(e => e.SalesOfficeId).HasName("PK__SalesOff__E1E442F5BA1C717D");

            entity.ToTable("SalesOffice");

            entity.Property(e => e.CompanyCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.SalesOfficeCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.SalesOfficeName)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdateDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<SalesOrganization>(entity =>
        {
            entity.HasKey(e => e.SalesOrganizationId).HasName("PK__SalesOrg__474FD0B1CF90425B");

            entity.ToTable("SalesOrganization");

            entity.Property(e => e.SalesOrganizationCode)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.SalesOrganizationName)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<UserDepartmentMapping>(entity =>
        {
            entity
                .HasKey(p => p.Id);
            entity.ToTable("UserDepartmentMapping");
            entity.Property(e => e.Id).ValueGeneratedOnAdd();
            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .IsUnicode(false);
        });
        modelBuilder.Entity<UserProductMapping>(entity =>
        {
            entity.HasKey(p => p.Id);
            entity.ToTable("UserProductMapping");
            entity.Property(e => e.Id).ValueGeneratedOnAdd();

            entity.Property(e => e.UserId)
                .HasMaxLength(50)
                .IsUnicode(false);
        });
        modelBuilder.Entity<Product>(entity =>
        {
            entity.HasKey(e => e.ProductId).HasName("PK__Product__B40CC6CD4C85D42E");

            entity.ToTable("Product");
            entity.Property(e => e.ProductCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.ProductDescription)
                .HasMaxLength(250)
                .IsUnicode(false);
            entity.Property(e => e.ProductName)
                .HasMaxLength(50)
                .IsUnicode(false);
        });
        modelBuilder.Entity<GlobalConfig>(entity =>
        {
            entity.ToTable("GlobalConfig");
            entity.HasKey(p => p.GlobalConfigId);
            entity.Property(e => e.ConfigKey)
                .HasMaxLength(100)
                .IsUnicode(false);
        });

        modelBuilder.Entity<TRNPricePlanning>(entity =>
        {
            entity.ToTable("TRNPricePlanning");
            entity.HasKey(p => p.TRNPricePlanningId);
            entity.Property(e => e.AccountCode)
            .HasMaxLength(50)
            .IsUnicode(false);
            entity.Property(e => e.ModeofType)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.MaterialCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Type)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<TRNSalesPlanning>(entity =>
        {
            entity.ToTable("TRNSalesPlanning");
            entity.HasKey(p => p.TRNSalesPlanningId);
            entity.Property(e => e.AccountCode)
            .HasMaxLength(50)
            .IsUnicode(false);
            entity.Property(e => e.CustomerCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.MaterialCode)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });

        modelBuilder.Entity<SNSEntry>(entity =>
        {
            entity.ToTable("SNSEntry");
            entity.HasKey(p => p.SNSEntryId);
            entity.Property(e => e.CustomerCode)
            .HasMaxLength(20)
            .IsUnicode(false);
            entity.Property(e => e.MaterialCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.OACCode)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.SaleSubType)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");
        });
        modelBuilder.Entity<BWExecutionLog>(entity =>
        {
            entity.ToTable("BWExecutionLog").HasKey(p => p.Process);


        });
        modelBuilder.Entity<DashTransmit>(entity =>
        {
            entity.ToTable("DashTransmit").HasKey(p => p.Id);


        });


        #region View table
        modelBuilder.Entity<VW_DASHMASTER>(entity =>
        {
            entity.ToView("VW_DASHMASTER").HasNoKey();
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

        });

        modelBuilder.Entity<VW_DashMasterMonthWise>(entity =>
        {
            entity.ToView("VW_DashMasterMonthWise").HasNoKey();
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

        });
        modelBuilder.Entity<UserProfileView>().ToView("UserProfileView").HasNoKey();
        modelBuilder.Entity<SP_DashMasterMonthly>().ToView("SP_DashMasterMonthly").HasNoKey();

        modelBuilder.Entity<MaterialView>().ToView("MaterialView").HasNoKey();
        modelBuilder.Entity<CustomerView>().ToView("CustomerView").HasNoKey();
        modelBuilder.Entity<UserDepartmentCountryView>().ToView("UserDepartmentCountryView").HasNoKey();
        modelBuilder.Entity<VW_DASHMASTERBP>().ToView("VW_DASHMASTERBP").HasNoKey();
        modelBuilder.Entity<VW_SNSEntryWithQtyPrice>().ToView("VW_SNSEntryWithQtyPrice").HasNoKey();
        modelBuilder.Entity<SP_OcIndicationMonthConfirm>().ToView("SP_OcIndicationMonthConfirm").HasNoKey();
        modelBuilder.Entity<DirectSaleView>().ToView("DirectSaleView").HasNoKey();
        modelBuilder.Entity<SP_InsertSalesEntries>().ToView("SP_Insert_Sales_Entries").HasNoKey();
        modelBuilder.Entity<SP_Insert_SSD_Entries>().ToView("SP_Insert_SSD_Entries").HasNoKey();
        modelBuilder.Entity<Sp_Get_Direct_SNS_Archive>().ToView("Sp_Get_DirectSale_Archive").HasNoKey();
        modelBuilder.Entity<VW_Customers>().ToView("VW_Customers").HasNoKey();
        modelBuilder.Entity<SP_OcoLockMonth>().ToView("SP_OcoLockMonth").HasNoKey(); // later to check

        modelBuilder.Entity<SP_Get_Customer_Country_Currency>().ToView("SP_Get_Customer_Country_Currency").HasNoKey();

        modelBuilder.Entity<SP_SalesEntryOCConfirmation>().ToView("SP_SalesEntryOCConfirmation").HasNoKey(); // later to check
        modelBuilder.Entity<SP_InsertSNSEntryDetails>().ToView("SP_InsertSNSEntryDetails").HasNoKey(); // later to check
        modelBuilder.Entity<SP_INSERT_ADJUSTMENT>().ToView("SP_INSERT_ADJUSTMENT").HasNoKey();
        //modelBuilder.Entity<SP_OcoLockMonth>().ToView("SP_OcoLockMonth").HasNoKey();
        modelBuilder.Entity<SP_InsertSNSEntryDetails>().ToView("USP_InsertSNSEntries").HasNoKey();

        modelBuilder.Entity<SP_SNSEntryDownload>().ToView("USP_GetSNSEntryForDownload").HasNoKey();
        modelBuilder.Entity<SP_SNSEntryQtyPriceDowload>().ToView("USP_GetSNSEntryQtyPrice").HasNoKey();

        modelBuilder.Entity<SP_SNSEntryQtyPriceForDownload>().ToView("USP_GetSNSEntryQtyPriceSummaryForDownload").HasNoKey();


        modelBuilder.Entity<USP_InsertSNSPrice>().ToView("USP_InsertSNSPrice").HasNoKey();
        modelBuilder.Entity<USP_InsertSNSFOBPrice>().ToView("USP_InsertSNSFOBPrice").HasNoKey();
        modelBuilder.Entity<VW_SNSPlanningComment>().ToView("VW_SNS_Planning_Comment").HasNoKey();
        modelBuilder.Entity<SPINSRESULTPURCHASE>().ToView("SPINSRESULTPURCHASE").HasNoKey();
        modelBuilder.Entity<Sp_UpdateConsinee>().ToView("Sp_UpdateConsinee").HasNoKey();
        modelBuilder.Entity<SP_BI_BP_AGENT_OPSI>().ToView("SP_BI_BP_AGENT_OPSI").HasNoKey();

        modelBuilder.Entity<SP_BI_LM_AGENT_OPSI>().ToView("SP_BI_LM_AGENT_OPSI").HasNoKey();
        modelBuilder.Entity<SP_BI_FORECAST_AGENT_SNS_SALES>().ToView("SP_BI_FORECAST_AGENT_SNS_SALES").HasNoKey();
        modelBuilder.Entity<SP_BI_FORECAST_AGENT_OPSI>().ToView("SP_BI_FORECAST_AGENT_OPSI").HasNoKey();
        modelBuilder.Entity<SP_BI_BP_AGENT_SNS>().ToView("SP_BI_BP_AGENT_SNS").HasNoKey();
        modelBuilder.Entity<SP_BI_LM_AGENT_SNSI>().ToView("SP_BI_LM_AGENT_SNSI").HasNoKey();
        modelBuilder.Entity<SP_GET_PLANNEDCUSTOMER>().ToView("SP_GET_PLANNEDCUSTOMER").HasNoKey();

        modelBuilder.Entity<SP_GETLOCKPSI>().ToView("SP_GETLOCKPSI").HasNoKey();

        modelBuilder.Entity<SNSEntryQtyPrice>(entity =>
        {
            entity.ToTable("SNSEntryQtyPrice");
            entity.Property(e => e.CreatedBy)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.CreatedDate).HasColumnType("datetime");
            entity.Property(e => e.UpdatedBy)
               .HasMaxLength(100)
               .IsUnicode(false);
            entity.Property(e => e.UpdatedDate).HasColumnType("datetime");

        });

        modelBuilder.Entity<SP_Get_CustomerWiseSaleQtyPrice>().ToView("SP_Get_CustomerWiseSaleQtyPrice").HasNoKey();
        modelBuilder.Entity<SP_GLOBALCONFIG_MONTH>().ToView("SP_GLOBALCONFIG_MONTH").HasNoKey();
        modelBuilder.Entity<SP_TRNPricePlanningSearch>().ToView("SP_TRNPricePlanningSearch").HasNoKey();

        modelBuilder.Entity<SP_COGSearch>(entity =>
        {
            entity.ToTable("SP_COGSearch");
            entity.HasNoKey();
        });
        modelBuilder.Entity<SP_InsertCOGEntryDetails>().ToView("SP_InsertCOGEntryDetails").HasNoKey(); // later to check


        #endregion



        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
