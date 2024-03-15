using PSI.Domains.Entity;
using PSI.Modules.Backends.Transmission.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Report.Results
{
    public class AccuracySummary
    {
        public List<MonthList> MonthList { get; set; }
        public List<DataFieldList> DataFieldList { get; set; }
        public List<SP_ACCURANCY_REPORT_SEARCH> AccurancyData { get; set; }
    }
}
