
namespace PSI.Modules.Backends.SNS.Results
{
    public class SNSPlanningSummary
    {
        public List<string> MonthList{get; set; }
        public List<SNSPlanningDetail> PlanningData{get; set;}
    }

    public class SNSPlanningDetail
    {
        public List<int?> SNSSummaryIdList{get;set;}
        public int? MaterialId{get;set;}
        public string? MaterialCode{get;set;}
        public string? MaterialAndSubGroupDesc{get;set;}
        public string? SubGroup{get;set;}
        public string? Description{get;set;}
        public string? Type{get;set;}
        public int? CustomerId{get;set;}
        public string? CustomerCode{get;set;}
        public string? CustomerName{get;set;}
        public int? Month0Quantity{get;set;}
        public int? Month1Quantity{get;set;}
        public int? Month2Quantity{get;set;}
        public int? Month3Quantity{get;set;}
        public int? Month4Quantity{get;set;}
        public int? Month5Quantity{get;set;}
        public int? Month6Quantity{get;set;}
        public int? Month7Quantity{get;set;}
        public int? Month8Quantity{get;set;}
        public int? Month9Quantity{get;set;}
        public int? Month10Quantity{get;set;}
        public int? Month11Quantity{get;set;}
        public int? Month12Quantity{get;set;}
        public bool? DisableEditQuantity{get;set;}
        public List<int?> SNSEntryIdList{get;set;}
        public List<int?> SNSEntryQtyPriceIdList{get;set;}
        public bool? IsUpdated{get;set;}
        public string? AccountCode{get;set;}
        public string? ModeofType{get;set;}
    }
}
