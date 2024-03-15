using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Results
{
    public class SNSArchiveResult
    {
        public string? Model { get; set; }
        public string? Month { get; set; }
        public string? Order { get; set; }
        public string? Purchase { get; set; }
        public string? Inventory { get; set; }
        public string? Account { get; set; }
    }
}
