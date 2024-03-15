using Microsoft.Graph;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class PSIDatesResult
    {
        public string? Month { get; set; }
        public string TransmitDate { get; set; }
        public string? ATPDate { get; set; }
        public string? PODate { get; set; }
    }
}
