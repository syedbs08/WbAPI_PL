using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
   
    public partial interface ITRNSalesPlanningRepository : IBaseRepository<TRNSalesPlanning>
    {
    }
    public partial class TRNSalesPlanningRepository : BaseRepository<TRNSalesPlanning>, ITRNSalesPlanningRepository
    {
        public TRNSalesPlanningRepository() : base(new PSIDbContext()) { }
    }
}
