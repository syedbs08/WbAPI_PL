using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Modules.Backends.Masters.Queries.CompanyMaster;
using PSI.Modules.Backends.Masters.Repository.CompanyMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Domains;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.SNS.QueriesHandler
{
     public class SNSMappingSearchHandler : IRequestHandler<SNSMappingSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public SNSMappingSearchHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(SNSMappingSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _context.SP_SNSMAPPINGSEARCH.FromSql($"SP_SNSMAPPINGSEARCH").AsNoTracking().ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }

    }
}