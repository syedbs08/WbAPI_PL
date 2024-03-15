using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Domains.Entity
{
    public class SP_GLOBALCONFIG_MONTH
    {
        public int GlobalConfigId { get; set; }
        public string? ConfigKey { get; set; }
        public string? ConfigValue { get; set; }
        public string? ConfigType { get; set; }

    }
}
