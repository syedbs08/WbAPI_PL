using Core.BaseUtility.Utility;
using MediatR;

namespace PSI.Modules.Backends.SNS.Command
{
    public class SNSPlanningCommand : IRequest<Result>
    {
        public SNSPlanningCommand(SNSPlanning snsPlanning, SessionData sessionData)
        {
            SNSPlanning = snsPlanning;
            SessionData = sessionData;
        }
        public SNSPlanning SNSPlanning { get; set; }
        public SessionData SessionData { get; set; }
    }

    public class SNSPlanning
    {
        public string AccountCode { get; set; }
        public List<int?> CustomerIdList { get; set; }
        public List<string?> CustomerCodeList { get; set; }
        public List<int> ProductCategoryId { get; set; }
        public List<int?> ProductSubCategoryIdList { get; set; }
        //public List<int> MaterialIdList { get; set; }
        public List<string> MaterialCodeList { get; set; }
        public int PeriodId { get; set; }
        public int StartMonthYear { get; set; }
        public int EndMonthYear { get; set; }
        public bool IsWildCardSearch { get; set; }
        public bool IsStockDays { get; set; }
        public string? SearchedMaterialCode { get; set; }
    }
}
