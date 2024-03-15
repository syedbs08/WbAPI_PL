using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISalesEntryRepository : IBaseRepository<SalesEntry>
    {
    }
    public partial class SalesEntryRepository : BaseRepository<SalesEntry>, ISalesEntryRepository
    {
        public SalesEntryRepository() : base(new PSIDbContext()) { }
    }
}
