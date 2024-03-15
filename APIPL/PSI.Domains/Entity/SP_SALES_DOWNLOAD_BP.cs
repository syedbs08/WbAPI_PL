using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_SALES_DOWNLOAD_BP
    {
        public int SaleEntryId { get; set; }
        public string ItemCode { get; set; } = string.Empty;
        //public string ModelNo { get; set; } = string.Empty;
        public string TypeCode { get; set; } = string.Empty;
        public string PriceMonthName { get; set; } = string.Empty;
        public string QtyMonthName { get; set; } = string.Empty;
        public int? Qty { get; set; }
        public decimal? Price { get; set; }
        public decimal? Amount { get; set; }
        public string MonthYear { get; set; } = string.Empty;
        public string Currency { get; set; }
        public int? AttachmentId { get; set; }
    }
}
