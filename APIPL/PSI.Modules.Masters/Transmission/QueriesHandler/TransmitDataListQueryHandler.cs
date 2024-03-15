using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Transmission.Queries;
using Microsoft.EntityFrameworkCore;

namespace PSI.Modules.Backends.Transmission.QueriesHandler
{
    public class TransmitDataListQueryHandler : IRequestHandler<TransmitDataListQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public TransmitDataListQueryHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(TransmitDataListQuery request, CancellationToken cancellationToken)
        {
            var data = _context.SP_TRANSMISSIONDATA.FromSql($"SP_TRANSMISSIONDATA").AsNoTracking().ToList();
            var loadOptions = request?.LoadOptions;
            var result = DataSourceLoader.Load(data, loadOptions);
            return result;
        }
    }
}