using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class TransmissionList:BaseEntity
    {
        public int TransmissionListId { get; set; }
        public string? PlanTypeCode { get; set; }
        public string? CustomerCode { get; set; }
        public bool? IsActive { get; set; }
        public string? SalesType { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? CreatedBy { get; set; }
        public string? UpdateBy { get; set; }
    }
}
