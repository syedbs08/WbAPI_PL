using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster
{
    public partial interface IUserDepartmentMapRepository
    {
        IEnumerable<UserDepartmentMapping> GetByUserId(string userId);
        UserDepartmentMapping GetUserDepartmentMapping(int departmentId, string userId);
    }
    public partial class UserDepartmentMapRepository
    {
        public UserDepartmentMapping GetUserDepartmentMapping(int departmentId, string userId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<UserDepartmentMapping>
                 .Create(p => p.DepartmentId == departmentId
                 || p.UserId == userId
                 )));
            return result;
        }
        public IEnumerable<UserDepartmentMapping> GetByUserId(string userId)
        {
            return GetAll().Where(w => w.UserId == userId).ToList();
        }
    }
}
