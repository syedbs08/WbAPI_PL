
using Core.BaseUtility;


namespace PSI.Domains.Entity
{
    public partial class DashTransmit : BaseEntity
    {
        public int Id { get; set; }
        public string? AccountCode { get; set; }
        public string? ConsigneeCode { get; set; }
        public string? SalesCompany { get; set; }
        public string? CurrentMonthYear { get; set; }
        public string? Replier { get; set; }
        public string? DemandModelNumber { get; set; }
        public string? ModelNumber { get; set; }
        public string? Supplier { get; set; }
        public string? ForeCastMonth { get; set; }
        public string? CustomerETAWeek { get; set; }
        public string? StatusType { get; set; }
        public string? TranportMode { get; set; }
        public string? DemandSlideType { get; set; }
        public int? DemandQuantity { get; set; }
        public string? ATPSlideType { get; set; }
        public string? ReferenceATPType { get; set; }
        public int? ATPQuantity { get; set; }
        public string? ShipmentDate { get; set; }
        public string? CustomerETADate { get; set; }
        public int? OneWeekRepliedQuantity { get; set; }
        public string? OneWeekShipmentDate { get; set; }
        public string? OneWeekCustomerETADate { get; set; }
        public int? TwoWeekRepliedQuantity { get; set; }
        public string? TwoWeekShipmentDate { get; set; }
        public string? TwoWeekCustomerETADate { get; set; }
        public int? ThreeWeekRepliedQuantity { get; set; }
        public string? ThreeWeekShipmentDate { get; set; }
        public string? ThreeWeekCustomerETADate { get; set; }
        public string? DemandATPComaprisonType { get; set; }
        public string? ATPPartialShipmentReply { get; set; }
        public string? SalesRouteCode { get; set; }
        public int? AttachmentId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
    }
}