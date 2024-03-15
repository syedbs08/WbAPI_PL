using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.Command
{
    public class TransmissionListCommand
    {
        public string? PlanTypeCode { get; set; }
        public int TransmissionListId { get; set; }
        public string? CustomerCode { get; set; }
        public string? SalesType { get; set; }
    }
}
