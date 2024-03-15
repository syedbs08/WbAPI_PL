


using DevExtreme.AspNet.Data.ResponseModel;
using DevExtreme.AspNet.Data;
using MediatR;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Queries.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.CustomerMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.RegionMaster
{
    public class RegionSearchHandler : IRequestHandler<RegionSearchQuery, LoadResult>
    {
        private readonly IRegionRepository _regionRepository;
        public RegionSearchHandler(IRegionRepository regionRepository)
        {
            _regionRepository = regionRepository;
        }
        public async Task<LoadResult> Handle(RegionSearchQuery request, CancellationToken cancellationToken)
        {
            try
            {
                var data = _regionRepository.GetAllRegions();
                var result = DataSourceLoader.Load(data, request.LoadOptions);
                return await Task.FromResult(result);
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
