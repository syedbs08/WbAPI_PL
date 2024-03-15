using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class COGEntryQtyPrice : BaseEntity
    {
        public int COGEntryQtyPriceId { get; set; }
        public int? COGEntryId { get; set; }
        public string? MonthYear { get; set; }
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
