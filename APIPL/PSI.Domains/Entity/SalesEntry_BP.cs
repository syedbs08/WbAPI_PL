using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SalesEntry_BP : BaseEntity
    {
        public int SalesEntryId { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public string? CustomerCode { get; set; }
        public int? CustomerId { get; set; }
        public string? BPYear { get; set; }
        public string? LockMonthYear { get; set; }
        public int? SaleTypeId { get; set; }
        public string? SaleSubType { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? ModeOfTypeId { get; set; }
        public string? MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? Quantity { get; set; }
        public string? ProductCategoryCode1 { get; set; }
        public string? ProductCategoryCode2 { get; set; }
        public string? ProductCategoryCode3 { get; set; }
        public string? ProductCategoryCode4 { get; set; }
        public string? ProductCategoryCode5 { get; set; }
        public string? ProductCategoryCode6 { get; set; }
        public string? OCmonthYear { get; set; }
        public int? AttachmentId { get; set; }
        public string? Reason { get; set; }
        public bool? IsSNS { get; set; }
        public bool? IsPO { get; set; }
        public string? TermId { get; set; }
        public string? Remarks { get; set; }
        public string? CurrencyCode { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
