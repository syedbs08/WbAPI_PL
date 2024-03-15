using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Queries.CountryMaster
{
    public class CountrySingleQuery : IRequest<Country>
    {
        public CountrySingleQuery(string countryCode, string countryName)
        {
            CountryCode = countryCode;
            CountryName = countryName;  
        }

        public string CountryCode { get; set; }
        public string CountryName { get; set; } 
    }
}
