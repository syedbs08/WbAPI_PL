using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.Masters.Repository.MaterialMaster
{
    public partial interface IMaterialViewReopsitory : IBaseRepository<MaterialView>
    {
    }
    public partial class MaterialViewReopsitory : BaseRepository<MaterialView>, IMaterialViewReopsitory
    {
        public MaterialViewReopsitory() : base(new PSIDbContext()) { }

    }
}
