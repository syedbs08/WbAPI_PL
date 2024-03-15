using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility.MapperProfiles;
using Core.BaseUtility.TableSearchUtil;
using Microsoft.Graph;
using PSI.Domains.Entity;
using PSI.Modules.Backends.Masters.Queries.RegionMaster;
using PSI.Modules.Backends.Masters.Results;
using System.Drawing;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;
using Region = PSI.Domains.Entity.Region;

namespace PSI.Modules.Backends.Masters.Repository.RegionMaster
{
    public partial interface IRegionRepository
    {
        List<RegionResult> GetRegions();
        Region GetRegion(string regionCode, string regionName, string regionShortDescription, int regionId);
        IEnumerable<Region> GetAllRegions();
    }
    public partial class RegionRepository
    {
        public List<RegionResult> GetRegions()
        {
            var result = GetAll().Where(x => x.IsDeleted != true);
            var mapResult = MappingProfile<Region, RegionResult>.MapList(result.ToList());
            return mapResult;
        }
        public IEnumerable<Region> GetAllRegions()
        {
            return GetAll().Where(x=> x.IsDeleted != true);
        }
        public Region GetRegion(string regionCode, string regionName, string regionShortDescription, int regionId)
        {
            if(regionId==0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Region>
                  .Create(p =>p.IsDeleted != true
                  && (p.RegionCode == regionCode
                  || p.RegionName == regionName
                  ))));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<Region>
                 .Create(p =>p.IsDeleted != true && p.RegionId != regionId
                 && (p.RegionCode == regionCode
                 || p.RegionName == regionName)
                 )));
                return result;
            }
        }
      
    }
}
