using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class AirPort : BaseEntity
    {
        public int AirPortId { get; set; }
        public string AirPortName { get; set; }
        public string? AirportCode { get; set; }
        public bool IsActive { get; set; }
    }
}
