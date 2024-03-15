using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
   
    public partial interface ISNSEntryRepository : IBaseRepository<SNSEntry>
    {
    }
    public partial class SNSEntryRepository : BaseRepository<SNSEntry>, ISNSEntryRepository
    {
        public SNSEntryRepository() : base(new PSIDbContext()) { }
    }
}
