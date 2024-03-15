using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.UserViewProfile;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UsersMaster
{
    public partial interface IUsersRepository
    {
        IEnumerable<Users> GetUserActive();
    }
    public partial class UsersRepository
    {
        public IEnumerable<Users> GetUserActive()
        {
            var filterExpression = Filter<Users>.Create(p => p.IsActive == true);
            var result = Get(Query.WithFilter(filterExpression));
            return result;
        }
    }
}
