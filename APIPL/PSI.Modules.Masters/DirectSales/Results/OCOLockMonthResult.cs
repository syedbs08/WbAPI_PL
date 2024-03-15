using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace PSI.Modules.Backends.DirectSales.Results
{
    public class OCOLockMonthResult
    {
        public string? MonthYear { get; set; }
        public int? CurrentMonthQty { get; set; }
        public int? ConfirmedQty { get; set; }
        public int? LockConfirmedQty { get; set; }
        public int? LockCurrentQty { get; set; }
        public int? Difference { get; set; }
        public int? SalesEntryId { get; set; }
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public string? MaterialCode { get; set; }
        public string? Mg { get; set; }
        public string? Mg1 { get; set; }
        public bool? IsSNS { get; set; }
    }
}
