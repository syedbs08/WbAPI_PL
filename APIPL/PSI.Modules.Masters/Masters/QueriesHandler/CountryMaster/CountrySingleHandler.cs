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
    public class CountrySingleHandler : IRequestHandler<CountrySingleQuery, Country>
    {
        private readonly ICountryRepository _countryRepository;

        public CountrySingleHandler(ICountryRepository countryRepository)
        {
            _countryRepository = countryRepository;
        }

        public async Task<Country> Handle(CountrySingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _countryRepository.GetCountry(request.CountryCode, request.CountryName);

                return result;
            });
        }
    }
}
