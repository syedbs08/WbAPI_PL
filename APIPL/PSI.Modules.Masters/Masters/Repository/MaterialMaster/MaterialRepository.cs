using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.MaterialMaster
{
    public partial interface IMaterialRepository : IBaseRepository<Material>
    {
       
    }
    public partial class MaterialRepository : BaseRepository<Material>, IMaterialRepository
    {
        public MaterialRepository() : base(new PSIDbContext()) { }
    }
}
