

using Core.BaseUtility.TableSearchUtil;
using MediatR;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.RegionMaster;
using PSI.Modules.Backends.Masters.Repository.RegionMaster;

namespace PSI.Modules.Backends.Masters.QueriesHandler.RegionMaster
{
    public class RegionSingleHandler : IRequestHandler<RegionSingleQuery, Region>
    {

        private readonly IRegionRepository _regionRepository;
        public RegionSingleHandler(IRegionRepository regionRepository)
        {
            _regionRepository = regionRepository;
        }

        public async Task<Region> Handle(RegionSingleQuery request, CancellationToken cancellationToken)
        {
            return await Task.Run(() =>
            {
                var result = _regionRepository.GetRegion(request.RegionCode, request.RegionName,request.RegionShortDescription, request.RegionId);

                return result;
            });

        }
    }
}