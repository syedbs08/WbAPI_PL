using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;

namespace PSI.Modules.Backends.Masters.Repository.PSIDatesMaster
{
   
    public partial interface IPSIDatesRepository : IBaseRepository<PSIDates>
    {
    }
    public partial class PSIDatesRepository : BaseRepository<PSIDates>, IPSIDatesRepository
    {
        public PSIDatesRepository() : base(new PSIDbContext()) { }
    }
}
