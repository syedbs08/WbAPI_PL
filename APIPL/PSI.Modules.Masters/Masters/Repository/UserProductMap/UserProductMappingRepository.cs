using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UserProductMap
{
    public partial interface IUserProductMappingRepository : IBaseRepository<UserProductMapping>
    {
    }
    public partial class UserProductMappingRepository : BaseRepository<UserProductMapping>, IUserProductMappingRepository
    {
        public UserProductMappingRepository():base(new PSIDbContext())
        {

        }
    }
}
