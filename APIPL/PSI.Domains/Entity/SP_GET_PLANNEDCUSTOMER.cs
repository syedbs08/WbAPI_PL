using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_GET_PLANNEDCUSTOMER : BaseEntity
    {
        public string? CustomerCode { get; set; }
        public string? CustomerName { get; set; }
        public int? CustomerId { get; set; }
        public int? Id { get; set; }
        public string? ItemName { get; set; }

    }
}
