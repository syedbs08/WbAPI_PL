using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class PSIDates : BaseEntity
    {
        public int PSIDatesId { get; set; }
        public string? Month { get; set; }
        public DateTime TransmitDate { get; set; }
        public DateTime ATPDate { get; set; }
        public DateTime PODate { get; set; }
        public int? AttachmentId { get; set; }
        public bool? IsActive { get; set; }
        public string? FY_YEAR { get; set; }
        public DateTime? DOC_DATE { get; set; }
        public DateTime? PSI_START_DATE { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }
    }
}
