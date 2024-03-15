using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.DashMaster
{
    public partial interface IDashMasterRepository : IBaseRepository<VW_DASHMASTER>
    {

    }
    public partial class DashMasterRepository : BaseRepository<VW_DASHMASTER>, IDashMasterRepository
    {
        public DashMasterRepository() : base(new PSIDbContext())
        {

        }

    }
}
