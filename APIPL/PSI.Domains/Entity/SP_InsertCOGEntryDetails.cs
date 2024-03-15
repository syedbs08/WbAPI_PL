using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SP_InsertCOGEntryDetails : BaseEntity
    {
        public string? ResponseCode { get; set; }
        public string? ResponseMessage { get; set; }
    }
}
