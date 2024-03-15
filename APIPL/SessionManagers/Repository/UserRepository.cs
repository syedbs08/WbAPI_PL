using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace SessionManagers.Repository
{
    public partial interface IUserRepository : IBaseRepository<Users>
    {

    }
    public partial class UserRepository : BaseRepository<Users>, IUserRepository
    {
        public UserRepository(): base(new PSIDbContext()) { }
    }
}
