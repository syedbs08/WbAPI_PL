using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class AdjustmentEntryQtyPrice:BaseEntity
    {
        public int AdjustmentEntryQtyPriceId { get; set; }
        public int? AdjustmentEntryId { get; set; }
        public string? MonthYear { get; set; }
        public string? Qty { get; set; }
        public string? Price { get; set; }
    }
}
