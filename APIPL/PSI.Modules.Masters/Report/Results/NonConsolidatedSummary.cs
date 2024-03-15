using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Results
{
    public class NonConsolidatedSummary
    {
        public List<MonthList> MonthList { get; set; }
        public List<DataFieldList> DataFieldList { get; set; }
        public List<sp_NonConsolidateReport> NonConsolidatedData { get; set; }
    }
   
}