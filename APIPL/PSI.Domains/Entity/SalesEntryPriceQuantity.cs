using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class SalesEntryPriceQuantity : BaseEntity
    {
        public int SalesEntryPriceQuantityId { get;set; }

        public int? SalesEntryId { get; set; }
        public string? MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? Quantity { get; set; }
        public string? OrderIndicationConfirmedBySaleTeam { get; set; }
        public DateTime? OrderIndicationConfirmedBySaleTeamDate { get; set; }
        public string? OrderIndicationConfirmedByMarketingTeam { get; set; }
        public DateTime? OrderIndicationConfirmedByMarketingTeamDate { get; set; }
        public string? O_LockMonthConfirmedBy { get; set; }
        public DateTime? O_LockMonthConfirmedDate { get; set; }
        public string? Reason { get; set; }
        public bool? IsSNS { get; set; }
        public bool? IsPO { get; set; }
        public string? TermId { get; set; }
        public string? OcIndicationMonthAttachmentIds { get; set; }
        public string? CurrencyCode { get; set; }
        public string? OcIndicationMonthStatus { get; set; }
        public string? Remarks { get; set; }
        public string? OCstatus { get; set; }
    }
}
