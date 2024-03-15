
using Core.BaseUtility.Utility;
using Microsoft.EntityFrameworkCore;
using PSI.Domains.Entity;

namespace AttachmentService
{
    public partial class AttachmentsContext : DbContext
    {
        public AttachmentsContext()
        {//attch
        }

        public AttachmentsContext(DbContextOptions<AttachmentsContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Attachments> Attachments { get; set; }
        

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {

                optionsBuilder.UseSqlServer(ConfigHelper.Settings("AppConfig:PSIDbContext"));
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Attachments>(entity =>
            {
                entity.Property(e => e.Id).ValueGeneratedOnAdd();


                entity.Property(e => e.DocumentName).HasMaxLength(500);

                entity.Property(e => e.DocumentPath).HasMaxLength(200);

                entity.Property(e => e.Extension).HasMaxLength(50);

               
            });

           

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
