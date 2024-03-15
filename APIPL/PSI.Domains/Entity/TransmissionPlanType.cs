using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class TransmissionPlanType: BaseEntity
    {
        public int TransmissionPlanTypeId { get; set; }
        public string? PlanTypeName { get; set; }
        public string? PlanTypeCode { get; set; }
        public bool IsActive { get; set; }

    }
}
