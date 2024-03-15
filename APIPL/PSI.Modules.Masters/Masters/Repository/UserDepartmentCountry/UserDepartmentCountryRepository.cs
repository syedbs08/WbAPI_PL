using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Repository.UserDepartmentMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.UserDepartmentCountry
{
    public partial interface IUserDepartmentCountryRepository : IBaseRepository<UserDepartmentCountryView>
    {

    }
    public partial class UserDepartmentCountryRepository : BaseRepository<UserDepartmentCountryView>, IUserDepartmentCountryRepository
    {
        public UserDepartmentCountryRepository() : base(new PSIDbContext())
        {

        }
    }
}
