using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISNSEntryWithQtyPriceViewRepository
    {
        IEnumerable<VW_SNSEntryWithQtyPrice> GetSNSEntryQtyPriceForPlanningQuery(SNSPlanning snsPlanning);
    }
    public partial class SNSEntryWithQtyPriceViewRepository
    {
        public IEnumerable<VW_SNSEntryWithQtyPrice> GetSNSEntryQtyPriceForPlanningQuery(SNSPlanning snsPlanning)
        {
            var result = Get(Query.WithFilter(Filter<VW_SNSEntryWithQtyPrice>
                   .Create(p => p.OACCode == snsPlanning.AccountCode && 
                    p.MonthYear >= snsPlanning.StartMonthYear && p.MonthYear <= snsPlanning.EndMonthYear &&
                    snsPlanning.MaterialCodeList.Contains(p.MaterialCode)
                    && snsPlanning.CustomerIdList.Contains(p.CustomerId))))
                    .OrderBy(c=> c.MaterialCode);
            return result;
        }
    }
}