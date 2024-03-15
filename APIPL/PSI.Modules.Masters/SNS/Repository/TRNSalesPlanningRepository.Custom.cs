using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ITRNSalesPlanningRepository
    {
        IEnumerable<TRNSalesPlanning> GetTRNPricePlanningsByQuery(SNSPlanning snsPlanning);
        IEnumerable<TRNSalesPlanning> GetTRNPricePlanningsByIds(List<int?> SummaryIds);
        TRNSalesPlanning GetTRNSalesPlanning(string accountCode, string materialCode, string customerCode,int monthYear, string saleSubType);
    }
    public partial class TRNSalesPlanningRepository
    {
        public IEnumerable<TRNSalesPlanning> GetTRNPricePlanningsByQuery(SNSPlanning snsPlanning)
        {
            var result = Get(Query.WithFilter(Filter<TRNSalesPlanning>
                   .Create(p => p.AccountCode == snsPlanning.AccountCode && 
                    p.MonthYear >= snsPlanning.StartMonthYear && p.MonthYear <= snsPlanning.EndMonthYear &&
                    snsPlanning.MaterialCodeList.Contains(p.MaterialCode) &&
                    snsPlanning.CustomerCodeList.Contains(p.CustomerCode))))
                    .OrderBy(c=> c.MaterialCode);
            return result;
        }

        public IEnumerable<TRNSalesPlanning> GetTRNPricePlanningsByIds(List<int?> SummaryIds)
        {
            var result = Get(Query.WithFilter(Filter<TRNSalesPlanning>
                   .Create(p => SummaryIds.Contains(p.TRNSalesPlanningId))));
            return result;
        }
        public TRNSalesPlanning GetTRNSalesPlanning(string accountCode, string materialCode, string customerCode, int monthYear,string saleSubType)
        {
            var result = FirstOrDefault(Query.WithFilter(Filter<TRNSalesPlanning>
              .Create(p => p.MaterialCode == materialCode && p.SaleSubType=="Monthly"
              && p.AccountCode == accountCode
              && p.CustomerCode == customerCode
              && p.MonthYear == monthYear
              )));
            return result;
        }
    }
}