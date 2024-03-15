using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.LockPSIMaster
{
    public partial interface ILockPSIRepository : IBaseRepository<LockPSI>
    {
    }
    public partial class LockPSIRepository : BaseRepository<LockPSI>, ILockPSIRepository
    {
        public LockPSIRepository() : base(new PSIDbContext()) { }
    }
}
