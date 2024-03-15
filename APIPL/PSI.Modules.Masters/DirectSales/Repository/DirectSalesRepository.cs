using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.DirectSales.Repository
{

    public partial interface IDirectSalesRepository : IBaseRepository<SP_InsertSalesEntries>
    {
    }
    public partial class DirectSalesRepository : BaseRepository<SP_InsertSalesEntries>, IDirectSalesRepository
    {
        public DirectSalesRepository() : base(new PSIDbContext()) { }
    }
}
