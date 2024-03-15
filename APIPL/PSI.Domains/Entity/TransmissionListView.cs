using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class TransmissionListView:BaseEntity
    {
        public int TransmissionListId { get; set; }
        public string? CustomerName { get; set; }
        public string? CustomerCode { get; set; }
        public string? PlanTypeCode { get; set; }
        public string? PlanTypeName { get; set; }
        public string? SalesType { get; set; }
    }
}
