using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.SupplierMaster
{
    public partial interface ISupplierRepository : IBaseRepository<Supplier>
    {
    }
    public partial class SupplierRepository : BaseRepository<Supplier>, ISupplierRepository
    {
        public SupplierRepository() : base(new PSIDbContext()) { }
    }

}
