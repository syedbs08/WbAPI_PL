using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_DirectSales_Report
    {
        public string? Consignee { get; set; }
        public string? Item_Code { get; set; }
        public string? Group { get; set; }
        public string? SubGroup { get; set; }
        public string? MonthYear { get; set; }
        public int? OrderQty { get; set; }
        public int? PurchaseQty { get; set; }
        public int? SaleQty { get; set; }
        public int? InventoryQty { get; set; }
        public int? MpoQty { get; set; }
        public int? AdjQty { get; set; }
        public decimal? OrderAmount { get; set; }
        public decimal? PurchaseAmount { get; set; }
        public decimal? SaleAmount { get; set; }
        public decimal? InventoryAmount { get; set; }
        public decimal? MpoAmount { get; set; }
        public decimal? AdjAmount { get; set; }
    }
}
