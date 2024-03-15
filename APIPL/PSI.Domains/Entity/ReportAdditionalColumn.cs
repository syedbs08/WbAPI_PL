using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class ReportAdditionalColumn
    {
        public int ReportAdditionColumnId { get; set; }
        public string? ColumnName { get; set; }
        public string? ColumnType { get; set; }
        public string? ReportType { get; set; }
        public int? OrderColumn { get; set; }
        public string? DisplayName { get; set; }
        public bool? IsActive { get; set; }
        
    }
}
