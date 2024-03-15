using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class ModeofType : BaseEntity
    {
        public int ModeofTypeId { get; set; }
        public string? ModeofTypeName { get; set; }
        public string? ModeofTypeCode { get; set; }
        public bool? IsActive { get; set; }
    }
}
