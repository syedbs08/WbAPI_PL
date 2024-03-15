using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.SNS.Queries;
using PSI.Modules.Backends.Transmission.Queries;
using PSI.Modules.Backends.Transmission.Repository;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Transmission.QueriesHandler
{
    public class TransmissionListQueryHandler : IRequestHandler<TransmissionListQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public TransmissionListQueryHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(TransmissionListQuery request, CancellationToken cancellationToken)
        {
            var data = _context.TransmissionListView.ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }
    }
}
