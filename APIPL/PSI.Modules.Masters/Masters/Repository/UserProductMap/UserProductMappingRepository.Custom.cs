using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using System.Collections.Generic;

namespace PSI.Modules.Backends.Masters.Repository.UserProductMap
{
    public partial interface IUserProductMappingRepository
    {
        List<UserProductMapping> GetUserProductByUserIds(string userId);
        UserProductMapping GetUserProductMapping(int productId, string userId);
    }
    public partial class UserProductMappingRepository
    {
        public UserProductMapping GetUserProductMapping(int productId, string userId)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<UserProductMapping>
                 .Create(p => p.ProductId == productId && p.UserId == userId)));
            return result;
        }
        public List<UserProductMapping> GetUserProductByUserIds(string userId)
        {
            var result = Get(Query.WithFilter(Filter<UserProductMapping>
                   .Create(p => p.UserId == userId)))
                   ;
            return result.ToList();
        }
    }
}
