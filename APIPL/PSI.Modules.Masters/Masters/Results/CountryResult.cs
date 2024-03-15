using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Results
{
    public class CountryResult
    {
        public int CountryId { get; set; }

        public string? CountryName { get; set; }

        public string? CountryCode { get; set; }
        public string? CurrencyName { get; set; }
        public bool? IsActive { get; set; }
        public int? CurrencyId { get; set; }
        public string? CountryShortDesc { get; set; }
    }
}
