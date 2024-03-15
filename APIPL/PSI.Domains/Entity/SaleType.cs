using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class SaleType:BaseEntity
    {
        public int SaleTypeId { get; set; }

        public string? SaleTypeName { get; set; }
        public string? SaleTypeCode { get; set; }
        public bool? IsActive { get; set; }
    }
}
