using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Repository.MaterialMaster
{
    public partial interface IMaterialCountryMappingRepository : IBaseRepository<MaterialCountryMapping>
    {
    }
    public partial class MaterialCountryMappingRepository : BaseRepository<MaterialCountryMapping>, IMaterialCountryMappingRepository
    {
        public MaterialCountryMappingRepository() : base(new PSIDbContext()) { }
    }
}
