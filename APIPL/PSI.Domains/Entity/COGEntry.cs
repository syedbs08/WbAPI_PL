using System;
using Core.BaseUtility;

namespace PSI.Domains.Entity
{
    public partial class COGEntry : BaseEntity
    {
        public int COGEntryId { get; set; }
        public int? SaleTypeId { get; set; }
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public int? AttachmentId { get; set; }
        public int? MonthYear { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }

    }
}
