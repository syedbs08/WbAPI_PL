using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;

namespace PSI.Modules.Backends.SNS.Repository
{
   
    public partial interface ITRNPricePlanningRepository : IBaseRepository<TRNPricePlanning>
    {
    }
    public partial class TRNPricePlanningRepository : BaseRepository<TRNPricePlanning>, ITRNPricePlanningRepository
    {
        public TRNPricePlanningRepository() : base(new PSIDbContext()) { }
    }
}
