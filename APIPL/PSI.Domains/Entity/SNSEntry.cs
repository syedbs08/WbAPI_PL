using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class SNSEntry:BaseEntity
    {
        public int SNSEntryId { get; set; }
        public int? SaleTypeId { get; set; }
        public int? CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public int? CategoryId { get; set; }
        public int? AttachmentId { get; set; }
        public int? MonthYear { get; set; }
        public int? ModeofTypeId { get; set; }
        public string? OACCode { get; set; }
        public string? SaleSubType { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string? UpdatedBy { get; set; }

    }
}
