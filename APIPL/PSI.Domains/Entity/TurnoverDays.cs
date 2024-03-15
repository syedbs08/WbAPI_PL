using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class TurnoverDays : BaseEntity
    {
        public int TurnoverDaysId { get; set; }
        public string? SubGroupProductCategoryCode { get; set; }
        public int? TurnoverDay { get; set; }
        public string? Month { get; set; }
        public int? AccountId { get; set; }
        public int? BP_Year { get; set; }
        public int? Git_Year { get; set; }
        public bool? IsActive { get; set; }
        public bool? IsDeleted { get; set; }
        public int? AttachmentId { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string? CreatedBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public string? UpdateBy { get; set; }

    }
}
