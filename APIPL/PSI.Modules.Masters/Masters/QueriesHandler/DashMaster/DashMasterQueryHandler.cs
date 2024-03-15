using DevExtreme.AspNet.Data;
using DevExtreme.AspNet.Data.ResponseModel;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Queries.DashMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.DashMaster
{
    public class DashMasterQueryHandler : IRequestHandler<DashMasterSearchQuery, LoadResult>
    {
        private readonly PSIDbContext _context;
        public DashMasterQueryHandler()
        {
            _context = new PSIDbContext();
        }
        public async Task<LoadResult> Handle(DashMasterSearchQuery request, CancellationToken cancellationToken)
        {
            var data = _context.VW_DASHMASTER;
            var result= await DataSourceLoader.LoadAsync(data, request.LoadOptions);
            return result;
        }

    }
}
