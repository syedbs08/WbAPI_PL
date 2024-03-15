using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SNS_Planning_Comment:BaseEntity
    {
        public int SNS_Planning_CommentId { get; set; }
        public string? MaterialCode { get; set; }
        public string? AccountCode { get; set; }
        public string? Comment { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
