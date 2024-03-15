using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_TRANSMISSION_SEARCH
    {
        public int ID { get; set; }
        public string CustomerCode { get; set; }
        public string MaterialCode { get; set; }
        public int? MonthYear { get; set; }
        public int? Qty { get; set; }
        public long? Amount { get; set; }
        public long? SaleValue { get; set; }
        public string SalesSequenceTypeText { get; set; }
        public string SaleSequenceType { get; set; }
    }

}
