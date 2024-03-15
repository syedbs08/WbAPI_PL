using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_AdjustmentSearch
    {
        public int? ProductCategoryId1 { get; set; }
        public int? ProductCategoryId2 { get; set; }
        public int? CustomerId { get; set; }
        public int? CountryId { get; set; }
        public string? CustomerName { get; set; }
        public string? CustomerCode { get; set; }
        public string? MaterialCode { get; set; }
        public int? MonthYear { get; set; }
        public decimal? Price { get; set; }
        public int? Qty { get; set; }
        public decimal? Amount { get; set; }
        public string? Mg1 { get; set; }
        public string? Mg2 { get; set; }
    }
}
