using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;

namespace AttachmentService.Repository
{
    public partial interface IGlobalConfigRepository
    {
        GlobalConfig GetGlobalConfigByKey(string type);
    }
    public partial class GlobalConfigRepository
    {
        public GlobalConfig GetGlobalConfigByKey(string type)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<GlobalConfig>.Create(p => p.ConfigKey == type)));
            return result;
        }
    }
}
