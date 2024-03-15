using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_SNSMAPPINGSEARCH : BaseEntity
    {
        public int? SNS_MappingId { get; set; }
        public string? AccountCode { get; set; }
        public string? AccountName { get; set; }
        public int? MG2 { get; set; }
        public int? MG3 { get; set; }
        public string? FromModel { get; set; }
        public string? ToModel { get; set; }
        public bool? IsActive { get; set; }
    }
}
