using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;


namespace AttachmentService.Repository
{
    public partial interface IGlobalConfigRepository : IBaseRepository<GlobalConfig>
    {
    }
    public partial class GlobalConfigRepository : BaseRepository<GlobalConfig>, IGlobalConfigRepository
    {
        public GlobalConfigRepository() : base(new PSIDbContext()) { }
    }
}
