using Core.BaseUtility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_MATERIALSEARCH : BaseEntity
    {
        public int MaterialId { get; set; }
        public string MaterialCode { get; set; }
    }
}
