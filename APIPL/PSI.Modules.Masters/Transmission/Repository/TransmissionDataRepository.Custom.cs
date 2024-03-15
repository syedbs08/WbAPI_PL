using Core.BaseEntitySql.BaseRepository;
using Microsoft.Data.SqlClient;
using PSI.Domains.Entity;
using PSI.Modules.Backends.SNS.Command;

namespace PSI.Modules.Backends.Transmission.Repository
{
    public partial interface ITransmissionDataRepository
    {
        IEnumerable<TransmissionData> GetTransmissionDataByIds(List<int> ids);
        IEnumerable<TransmissionData> GetTransmissionDataByIdsByPlan(List<int> ids,string plan);
        IEnumerable<TransmissionData> GetDistResultPlan(string customerCode,int monthYear, string type);
        IEnumerable<TransmissionData> GetDisPlan(string customerCode,int monthYear,int forecasteMonthYear, string type, int plantype);
        IEnumerable<TransmissionData> GetPlanForSNS(string accountCode, int monthYear,int forecasteMonthYear, string type, int plantype);
        IEnumerable<TransmissionData> GetPlan(string customerCode,int monthYear,int forecasteMonthYear, string type, int plantype);
        IEnumerable<TransmissionData> GetZeroPlan(string customerCode,int monthYear,int forecasteMonthYear, string type, int plantype);
        IEnumerable<TransmissionData> GetConsoliTransmissionData(string customerCode, int monthYear, int forecasteMonthYear, string type, int plantype);


    }
    public partial class TransmissionDataRepository
    {
        public IEnumerable<TransmissionData> GetTransmissionDataByIds(List<int> ids)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p => ids.Contains(p.ID)));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetTransmissionDataByIdsByPlan(List<int> ids, string plan)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p => ids.Contains(p.ID) && p.Plan==plan));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetDistResultPlan(string customerCode, int monthYear, string type)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
                                            p.PlanTypeCode ==Constants.Contants.DistResult
                                            && p.CustomerCode==customerCode
                                             && p.SaleType == type
                                            && p.MonthYear==monthYear 
                                            && p.Status== "Pending"
            ));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetDisPlan(string customerCode, int monthYear, int forecasteMonthYear, string type, int plantype)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
            p.PlanTypeCode == Constants.Contants.DistPlan 
            && p.MonthYear >= monthYear && p.MonthYear <= forecasteMonthYear
            && p.SaleType == type
            && p.CustomerCode == customerCode
            && p.Status == "Pending"
            ));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetPlanForSNS(string accountCode, int monthYear, int forecasteMonthYear, string type, int plantype)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
           (p.Plan == Constants.Contants.Plan_For_SNS)
            && p.MonthYear >= monthYear && p.MonthYear <= forecasteMonthYear
            && p.SaleType == type
            && p.CustomerCode == accountCode
            && p.Status == "Pending"
            ));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetPlan(string customerCode, int monthYear,int forecasteMonthYear, string type, int plantype)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
           ( p.Plan == Constants.Contants.Plan_For_Directsale)
            && p.MonthYear >= monthYear && p.MonthYear <= forecasteMonthYear
            && p.SaleType==type
            && p.CustomerCode == customerCode
            && p.Status == "Pending"
            ));
            return Get(result);
        }
        public IEnumerable<TransmissionData> GetZeroPlan(string customerCode, int monthYear, int forecasteMonthYear, string type, int plantype)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
            p.Plan == Constants.Contants.ZeroPlan
            && p.MonthYear >= monthYear && p.MonthYear <= forecasteMonthYear
            && p.SaleType == type
            && p.CustomerCode == customerCode
            && p.Status == "Pending"
            ));
            return Get(result);
        }



        public IEnumerable<TransmissionData> GetConsoliTransmissionData(string customerCode, int monthYear, int forecasteMonthYear, string type, int plantype)
        {
            var result = Query.WithFilter(Filter<TransmissionData>.Create(p =>
            p.PlanTypeCode == Constants.Contants.Consoli
            && p.MonthYear >= monthYear && p.MonthYear <= forecasteMonthYear
            && p.SaleType == type
            && p.CustomerCode == customerCode
            && p.Status == "Pending"
            ));
            return Get(result);
        }



    }
}
