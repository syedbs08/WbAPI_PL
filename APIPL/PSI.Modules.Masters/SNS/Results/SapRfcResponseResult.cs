using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Results
{
    public class SapRfcResponseResult
    {
        public string Type { get; set; }
        public int SapCount { get; set; } = 0;
        public int InsertedCount { get; set; } = 0;

       public string ErrorMessage { get; set; }
    }
}
