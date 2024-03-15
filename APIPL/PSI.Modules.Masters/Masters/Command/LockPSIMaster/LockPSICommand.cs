using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.LockPSIMaster
{
    public class LockPSICommand
    {
        public int LockPSIId { get; set; }
        public string[] UserIds { get; set; }
        public string[] Types { get; set; }
        public string CustomerId { get; set; }
        public string SubcategoryId { get; set; }
    }
}
