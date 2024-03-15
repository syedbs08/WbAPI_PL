using MediatR;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Command.CountryMaster
{
    public class CountryLookupCommand : IRequest<IEnumerable<Country>>
    {
        public int CountryId { get; set; }
        public string? CountryCode { get; set; }
    }
}
