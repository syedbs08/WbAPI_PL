using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Queries.DashMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.DashMaster
{
    internal class DashMasterBPQueryHandler : IRequestHandler<DashMasterBPSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public DashMasterBPQueryHandler()
        {
            _context = new PSIDbContext();

        }
        public async Task<LoadResult> Handle(DashMasterBPSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _context.VW_DASHMASTERBP;
            var result = await DataSourceLoader.LoadAsync(data, request.LoadOptions);
            return result;
        }
    
    }
}
