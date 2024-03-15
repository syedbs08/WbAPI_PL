using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster
{
    public partial interface IUserDepartmentMapRepository : IBaseRepository<UserDepartmentMapping>
    {

    }
    public partial class UserDepartmentMapRepository : BaseRepository<UserDepartmentMapping>, IUserDepartmentMapRepository
    {
        public UserDepartmentMapRepository():base(new PSIDbContext())
        {

        }
    }
}
