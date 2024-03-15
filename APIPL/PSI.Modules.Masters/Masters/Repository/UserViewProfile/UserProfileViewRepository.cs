using Core.BaseEntitySql.BaseRepository;
using Microsoft.EntityFrameworkCore;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UserViewProfile
{
    public partial interface IUserViewProfileRepository : IBaseRepository<UserProfileView>
    {

    }
    public partial class UserProfileViewRepository  : BaseRepository<UserProfileView>, IUserViewProfileRepository
    {
        public UserProfileViewRepository(): base(new PSIDbContext()) { }
    }
}
