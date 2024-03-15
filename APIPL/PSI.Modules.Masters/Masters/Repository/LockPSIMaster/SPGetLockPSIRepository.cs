using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Repository.LockPSIMaster
{
    public partial interface ISPGetLockPSIRepository : IBaseRepository<SP_GETLOCKPSI>
    {
    }
    public partial class SPGetLockPSIRepository : BaseRepository<SP_GETLOCKPSI>, ISPGetLockPSIRepository
    {
        public SPGetLockPSIRepository() : base(new PSIDbContext()) { }
    }
}
