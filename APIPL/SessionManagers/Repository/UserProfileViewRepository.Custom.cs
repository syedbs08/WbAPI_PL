

using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

namespace SessionManagers.Repository
{
    public partial interface IUserViewProfileRepository
    {
        IEnumerable<UserProfileView> UserProfileLookUp(string userId);

    }
    public partial class UserProfileViewRepository
    {
       public IEnumerable<UserProfileView> UserProfileLookUp(string userId)
        {
            var filterExpression = Filter<UserProfileView>.Create(p => p.UserId== userId);           
            var result = Get(Query.WithFilter(filterExpression));
            return result;        
        }
    }
}
