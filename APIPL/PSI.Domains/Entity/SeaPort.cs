using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SeaPort : BaseEntity
    {
        public int SeaPortId { get; set; }
        public string SeaPortName { get; set; }
        public string? SeaPortCode { get; set; }
        public bool IsActive { get; set; }
    }
}
