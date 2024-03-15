using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;


namespace PSI.Modules.Backends.Masters.Repository.RegionMaster
{
    public partial interface IModeofTypeRepository : IBaseRepository<ModeofType>
    {
    }
    public partial class ModeofTypeRepository : BaseRepository<ModeofType>, IModeofTypeRepository
    {
        public ModeofTypeRepository() : base(new PSIDbContext()) { }
    }
}
