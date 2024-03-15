using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class TRNPricePlanning : BaseEntity
    {
        public int TRNPricePlanningId { get; set; }
        public string? AccountCode { get; set; }
        public string ModeofType { get; set; }
        public int MonthYear { get; set; }
        public int? BP_YEAR { get; set; }
        public string MaterialCode { get; set; }
        public string? SaleSubType { get; set; }
        public int? Quantity { get; set; }
        public decimal? Price { get; set; }
        public string? Type { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
