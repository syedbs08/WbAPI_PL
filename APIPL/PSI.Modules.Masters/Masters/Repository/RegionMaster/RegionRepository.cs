using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;


namespace PSI.Modules.Backends.Masters.Repository.RegionMaster
{
    public partial interface IRegionRepository : IBaseRepository<Region>
    {
    }
    public partial class RegionRepository : BaseRepository<Region>, IRegionRepository
    {
        public RegionRepository() : base(new PSIDbContext()) { }
    }
}
