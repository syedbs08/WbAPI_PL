using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Results
{
    public class ConsolidatedSummary
    {
        public List<MonthList> MonthList { get; set; }
        public List<DataFieldList> DataFieldList { get; set; }
        public List<sp_ConsolidateReport> ConsolidatedData { get; set; }
        public List<string> Variants { get; set; }
    }
    public class MonthList
    {
        public string Month { get; set; }
        public string type { get; set; }
    }
    public class DataFieldList
    {
       
        public string caption { get; set; }
        public string dataField { get; set; }
        public string? dataType { get; set; }
        public int width { get; set; }
        public string? summaryType { get; set; } 
        public string area { get; set; } 
        public bool expanded { get; set; } 
        public string? runningTotal { get; set; } 
        public bool? allowCrossGroupCalculation { get; set; } 

        
    }

}