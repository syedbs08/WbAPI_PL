using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UsersMaster
{
    public partial interface IUsersRepository:IBaseRepository<Users>
    {
    }
    public partial class UsersRepository:BaseRepository<Users>,IUsersRepository
    {
        public UsersRepository():base(new PSIDbContext()) { }
    }
}
