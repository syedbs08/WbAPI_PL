using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Transmission.Queries;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.Transmission.QueriesHandler
{
    internal class PreTransmissionCustomerListQueryHandler : IRequestHandler<PreTransmissionCustomerListQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public PreTransmissionCustomerListQueryHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(PreTransmissionCustomerListQuery request, CancellationToken cancellationToken)
        {
            var data = _context.Sp_TransmissionListCustomer.FromSqlRaw($"Sp_TransmissionListCustomer {request.PreTransmissionCustomerSearch.Type}").ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }
    }
}
