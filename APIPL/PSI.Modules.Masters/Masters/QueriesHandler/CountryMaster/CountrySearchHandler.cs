using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CountryMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using PSI.Modules.Backends.Masters.Results;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.CountryMaster
{
    public class CountrySearchHandler : IRequestHandler<CountrySearchQuery, LoadResult>
    {
        private readonly ICountryRepository _countryRepository;
        private readonly ICurrencyRepository _currencyRepository;
        public CountrySearchHandler(ICountryRepository countryRepository, ICurrencyRepository currencyRepository)
        {
            _countryRepository = countryRepository;
            _currencyRepository = currencyRepository;

        }
        public async Task<LoadResult> Handle(CountrySearchQuery request, CancellationToken cancellationToken)
        {
            var countrydata = _countryRepository.GetAllCountry();
            var getCurrency = _currencyRepository.GetAll();
            var data = countrydata.Select(x => new CountryResult()
            {
                CountryId = x.CountryId,
                CountryName = x.CountryName,
                CountryCode = x.CountryCode,
                CurrencyName =x.CurrencyId==null ?"":getCurrency.FirstOrDefault(z=>z.CurrencyId== x.CurrencyId).CurrencyName,
                IsActive = x.IsActive,
                CurrencyId = x.CurrencyId,
                CountryShortDesc = x.CountryshortName,

            });
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return await Task.FromResult(result);
        }
    }
}
