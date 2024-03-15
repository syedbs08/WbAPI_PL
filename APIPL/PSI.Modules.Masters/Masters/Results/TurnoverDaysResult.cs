using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class TurnoverDaysResult
    {
        public string? SubgroupCode { get; set; }
        public string? Month { get; set; }
        public string OACCode { get; set; }
        public int? TurnoverDay { get; set; }
        public int? BPYear { get; set; }
        public int? GitDays { get; set; }
    }
}
