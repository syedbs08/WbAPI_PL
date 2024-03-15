using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISaleEntryHeaderRepository : IBaseRepository<SaleEntryHeader>
    {
    }
    public partial class SaleEntryHeaderRepository : BaseRepository<SaleEntryHeader>, ISaleEntryHeaderRepository
    {
        public SaleEntryHeaderRepository() : base(new PSIDbContext()) { }
    }
}
