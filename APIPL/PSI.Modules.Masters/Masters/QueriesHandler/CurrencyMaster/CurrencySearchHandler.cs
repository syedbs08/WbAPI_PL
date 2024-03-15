

using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CurrencyMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.CurrencyMaster
{
    public class CurrencySearchHandler : IRequestHandler<CurrencySearchQuery, LoadResult>
    {
        private readonly ICurrencyRepository _currencyRepository;
        public CurrencySearchHandler(ICurrencyRepository currencyRepository)
        {
            _currencyRepository = currencyRepository;
        }
        public async Task<LoadResult> Handle(CurrencySearchQuery request, CancellationToken cancellationToken)
        {
            var data = _currencyRepository.GetAll();
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return await Task.FromResult(result);
        }

    }
}