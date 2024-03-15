using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
   
    public partial interface ISNSEntryWithQtyPriceViewRepository : IBaseRepository<VW_SNSEntryWithQtyPrice>
    {
    }
    public partial class SNSEntryWithQtyPriceViewRepository : BaseRepository<VW_SNSEntryWithQtyPrice>, ISNSEntryWithQtyPriceViewRepository
    {
        public SNSEntryWithQtyPriceViewRepository() : base(new PSIDbContext()) { }
    }
}
