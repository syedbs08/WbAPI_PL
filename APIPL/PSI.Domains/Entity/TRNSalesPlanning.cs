using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class TRNSalesPlanning : BaseEntity
    {
        public int TRNSalesPlanningId { get; set; }
        public int MonthYear { get; set; }
        public int? BP_YEAR { get; set; }
        public string? SaleSubType { get; set; }
        public string? CustomerCode { get; set; }
        public string? MaterialCode { get; set; }
        public int? Quantity { get; set; }
        public decimal? Price { get; set; }
        public decimal? Amount { get; set; }
        public string? AccountCode { get; set; }
        public bool? IsPlannes { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }
    }
}
