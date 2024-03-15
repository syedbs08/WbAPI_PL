using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace SessionManagers.Repository
{
    public partial interface IUserViewProfileRepository : IBaseRepository<UserProfileView>
    {

    }
    public partial class UserProfileViewRepository  : BaseRepository<UserProfileView>, IUserViewProfileRepository
    {
        public UserProfileViewRepository(): base(new PSIDbContext()) { }
    }
}
