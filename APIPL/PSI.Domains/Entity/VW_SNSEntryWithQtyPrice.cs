using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class VW_SNSEntryWithQtyPrice:BaseEntity
    {
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public string? OACCode { get; set; }
        public int SNSEntryId { get; set; }
        public int SNSEntryQtyPriceId { get; set; }
        public int? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
    }
}
