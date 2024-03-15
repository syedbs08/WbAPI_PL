using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface ISalesEntryPriceQuantityRepository : IBaseRepository<SalesEntryPriceQuantity>
    {
    }
    public partial class SalesEntryPriceQuantityRepository : BaseRepository<SalesEntryPriceQuantity>, ISalesEntryPriceQuantityRepository
    {
        public SalesEntryPriceQuantityRepository() : base(new PSIDbContext()) { }
    }
}
