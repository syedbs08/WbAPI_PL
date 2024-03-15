using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.CountryMaster
{
    public class CountryLookupHandle : IRequestHandler<CountryLookupQuery, IEnumerable<Country>>
    {
        private readonly ICountryRepository _countryRepository;

        public CountryLookupHandle(ICountryRepository countryRepository)
        {
            _countryRepository = countryRepository;
        }

        public async Task<IEnumerable<Country>> Handle(CountryLookupQuery request, CancellationToken cancellationToken)
        {            
            var countries = _countryRepository.GetAllCountry().OrderBy(x=>x.CountryName).ToList();
            return await Task.FromResult(countries);
        }
    }
}
