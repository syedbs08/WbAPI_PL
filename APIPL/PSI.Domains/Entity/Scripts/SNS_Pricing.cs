using Core.BaseUtility;

namespace PSI.Domains.Entity.Scripts
{
    public class SNS_Pricing : BaseEntity
    {
        public int SNS_PricingId { get; set; }
        public int? ModeofTypeId { get; set; }
        public int? CustomerId { get; set; }
        public int? MaterialId { get; set; }
        public int? CurrencyId { get; set; }
        public decimal? Price { get; set; }
        public int? Price_Unit { get; set; }
        public DateTime? From_Date { get; set; }
        public DateTime? To_Date { get; set; }
        public int? TermId { get; set; }
        public string? SalesOrg { get; set; }
        public string? DistributtonChannel { get; set; }
        public string? Ship_Mode { get; set; }
        public string? Inco_Term { get; set; }
        public string? UOM { get; set; }
        public string? Plant { get; set; }
        public string? Vendor { get; set; }
        public string? Port { get; set; }
        public string? Status { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public int? AttachmentId { get; set; }
    }
}
