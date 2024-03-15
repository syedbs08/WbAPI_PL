using Core.BaseUtility.Utility;

using Microsoft.EntityFrameworkCore;
using PSI.Domains.BWEntity;

namespace PSI.Domains;

public partial class BWDbConext : DbContext
{

    public BWDbConext()
    {

    }

    public BWDbConext(DbContextOptions<BWDbConext> options)
        : base(options)
    {
    }
    public virtual DbSet<BI_BP_AGENT_OPSI> BI_BP_AGENT_OPSI { get; set; }
    public virtual DbSet<BI_LM_AGENT_OPSI> BI_LM_AGENT_OPSI { get; set; }    
    public virtual DbSet<BI_FCS_AGENT_SNS_SALES> BI_FCS_AGENT_SNS_SALES { get; set; }
    public virtual DbSet<BI_FORECAST_AGENT_OPSI> BI_FORECAST_AGENT_OPSI { get; set; }
    public virtual DbSet<BI_BP_AGENT_SNS> BI_BP_AGENT_SNS { get; set; }
    public virtual DbSet<BI_LM_AGENT_SNS> BI_LM_AGENT_SNS { get; set; }
    

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {

            optionsBuilder.UseSqlServer(ConfigHelper.Settings("AppConfig:BWConnectionString"),
             a => a.CommandTimeout(300));
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<BI_BP_AGENT_OPSI>()
            .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE,a.PSI_CONS_CODE });
       
        modelBuilder.Entity<BI_LM_AGENT_OPSI>()
          .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE, a.PSI_CONS_CODE,a.SALES_TYPE });

        modelBuilder.Entity<BI_FCS_AGENT_SNS_SALES>()
          .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE, a.PSI_CONS_CODE, a.SALES_TYPE });


        modelBuilder.Entity<BI_FORECAST_AGENT_OPSI>()
          .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE, a.PSI_CONS_CODE, a.SALES_TYPE });
        modelBuilder.Entity<BI_BP_AGENT_SNS>()
              .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE, a.PSI_CONS_CODE, a.SALES_TYPE });
        

        modelBuilder.Entity<BI_LM_AGENT_SNS>()
              .HasKey(a => new { a.PSI_YYYYMM, a.PSI_ITEM_CODE, a.PSI_CONS_CODE, a.SALES_TYPE });



        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
