using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_TRANSMISSIONDATA
    {
        public int? PlanTypeCode { get; set; }
        public string? PlanTypeName { get; set; }
        public string? CustomerName { get; set; }
        public string? CustomerCode { get; set; }
        public string? Status { get; set; }
        public string? EDIStatus { get; set; }
        public string? SaleType { get; set; }
        
    }
}
