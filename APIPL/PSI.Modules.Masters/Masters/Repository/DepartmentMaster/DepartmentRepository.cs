using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.DepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.DepartmentMaster
{
    public partial interface IDepartmentMasterRepository : IBaseRepository<Department>
    {

    }
    public partial class DepartmentRepository : BaseRepository<Department>, IDepartmentMasterRepository
    {
        public DepartmentRepository() : base(new PSIDbContext())
        {

        }

    }
}
