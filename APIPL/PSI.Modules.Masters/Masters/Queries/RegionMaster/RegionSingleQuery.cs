using MediatR;
using PSI.Domains.Entity;


namespace PSI.Modules.Backends.Masters.Queries.RegionMaster
{
  
        public class RegionSingleQuery : IRequest<Region>
        {
            public RegionSingleQuery(string regionName,
              string regionCode,string regionShortDescription,int regionId)
            {
                RegionCode = regionCode;
                RegionName = regionName;
            RegionShortDescription = regionShortDescription;
            RegionId = regionId;
            }
            public int RegionId { get; }
            public string RegionName { get; }
            public string RegionCode { get; }
            public string RegionShortDescription { get;  }
    }
    
}
