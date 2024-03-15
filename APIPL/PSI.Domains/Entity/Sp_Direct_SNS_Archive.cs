using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public partial class Sp_Direct_SNS_Archive:BaseEntity
    {
        public string? Error { get; set; }
        public string? Id { get; set; }
        public string? SaleType { get; set; }
       
    }
}
