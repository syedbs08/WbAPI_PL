using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISNS_MappingRepository
    {
        SNS_Mapping GetSNS_Mapping(int? sns_MappingId, string accountCode, string fromModel, string toModel);
    }
    public partial class SNS_MappingRepository
    {
        public SNS_Mapping GetSNS_Mapping(int? sns_MappingId, string accountCode, string fromModel,string toModel)
        {

            if (sns_MappingId == 0)
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<SNS_Mapping>
                  .Create(p => (p.AccountCode == accountCode && p.FromModel == fromModel && p.ToModel==toModel)
                  )));
                return result;
            }
            else
            {
                var result = FirstOrDefault(Query.WithFilter(Filter<SNS_Mapping>
                 .Create(p => p.SNS_MappingId != sns_MappingId && p.AccountCode == accountCode
                 && p.FromModel == fromModel && p.ToModel == toModel
                 )));
                return result;
            }
        }

    }
}
