using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.Report
{
    public class ReportCommand
    {
        public int? ReportVariantId { get; set; }
        public string? UserId { get; set; }
        public string ReportType { get; set; }
        public string VariantName { get; set; }
        public List<string> ColumnName { get; set; }

    }
}
