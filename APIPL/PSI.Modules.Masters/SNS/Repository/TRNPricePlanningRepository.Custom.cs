using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ITRNPricePlanningRepository
    {
        IEnumerable<TRNPricePlanning> GetTRNPricePlanningsByQuery(SNSPlanning snsPlanning);
        IEnumerable<TRNPricePlanning> GetTRNPricePlanningsByIds(List<int?> SummaryIds);
    }
    public partial class TRNPricePlanningRepository
    {
        public IEnumerable<TRNPricePlanning> GetTRNPricePlanningsByQuery(SNSPlanning snsPlanning )
        {
            var result = Get(Query.WithFilter(Filter<TRNPricePlanning>
                   .Create(p => p.AccountCode == snsPlanning.AccountCode  &&
                    p.MonthYear >= snsPlanning.StartMonthYear && p.MonthYear <= snsPlanning.EndMonthYear && 
                    snsPlanning.MaterialCodeList.Contains(p.MaterialCode))))
                    .OrderBy(c=> c.MaterialCode);
            
            return result;
        }

        public IEnumerable<TRNPricePlanning> GetTRNPricePlanningsByIds(List<int?> SummaryIds)
        {
            var result = Get(Query.WithFilter(Filter<TRNPricePlanning>
                   .Create(p => SummaryIds.Contains(p.TRNPricePlanningId))));
            return result;
        }
    }
}