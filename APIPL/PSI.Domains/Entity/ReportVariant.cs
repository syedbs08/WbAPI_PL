using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class ReportVariant : BaseEntity
    {
        public int ReportVariantId { get; set; }

        public string? UserId { get; set; }
        public string? ReportType { get; set; }
        public string? VariantName { get; set; }
        public string? ColumnName { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
    }
}
