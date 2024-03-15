using Core.BaseUtility.TableSearchUtil;
using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.CurrencyMaster;
using PSI.Modules.Backends.Masters.Queries.PSIDatesMaster;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using PSI.Modules.Backends.Masters.Repository.PSIDatesMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.QueriesHandler.PSIDatesMaster
{
    public class PSIDatesSearchHandler : IRequestHandler<PSIDatesSearchQuery, LoadResult>
    {
        private readonly IPSIDatesRepository _psiDatesRepository;
        public PSIDatesSearchHandler(IPSIDatesRepository psiDatesRepository)
        {
            _psiDatesRepository = psiDatesRepository;
        }
        public async Task<LoadResult> Handle(PSIDatesSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _psiDatesRepository.GetAll();
            var result = DataSourceLoader.Load(data, request.LoadOptions);
            return await Task.FromResult(result);

        }

    }
}
