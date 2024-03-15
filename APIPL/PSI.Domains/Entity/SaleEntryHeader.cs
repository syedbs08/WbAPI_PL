using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SaleEntryHeader : BaseEntity
    {
        public int SaleEntryHeaderId { get; set; }
        public int? CustomerId { get; set; }
        public int? SaleTypeId { get; set; }
        public string? ProductCategoryId1 { get; set; }
        public string? ProductCategoryId2 { get; set; }
        public string? CurrentMonthYear { get; set; }
        public string? LockMonthYear { get; set; }
        public string? SaleSubType { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
        public int? AttachmentId { get; set; }
        public string? CustomerCode { get; set; }
    }
}
