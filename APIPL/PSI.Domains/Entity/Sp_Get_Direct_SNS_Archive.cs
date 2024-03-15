using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class Sp_Get_Direct_SNS_Archive
    {
        public string? MaterialCode { get; set; }
        public string? CurrentMonthYear { get; set; }
        public string? OAC { get; set; }
        public int? OrderQty { get; set; }
        public int? PurchaseQty { get; set; }
        public int? InventoryQty { get; set; }
    }
}
