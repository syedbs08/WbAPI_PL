using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class AdjustmentEntry:BaseEntity
    {
        public int AdjustmentEntryId { get; set; }
        public int? CustomerId { get; set; }
        public string? CustomerCode { get; set; }
        public int? MaterialId { get; set; }
        public string? MaterialCode { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
