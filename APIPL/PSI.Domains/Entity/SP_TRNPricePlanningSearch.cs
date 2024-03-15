using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_TRNPricePlanningSearch : BaseEntity
    {

        public int? TRNPricePlanningId { get; set; }
        public string? AccountCode { get; set; }
        public string ModeofType { get; set; }
        public int MonthYear { get; set; }
        public string MaterialCode { get; set; }
        public int? Quantity { get; set; }
        public string? Type { get; set; }
    }
}
