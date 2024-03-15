using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class  SaleEntryArchivalHeader : BaseEntity
    {
        public int SaleEntryArchivalHeaderId { get; set; }
        public int? CustomerId { get; set; }
        public int? SaleTypeId { get; set; }
        public int? ProductCategoryId1 { get; set; }
        public string? ProductCategoryCode1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? ProductCategoryCode2 { get; set; }
        public string? CurrentMonthYear { get; set; }
        public string? LockMonthYear { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
