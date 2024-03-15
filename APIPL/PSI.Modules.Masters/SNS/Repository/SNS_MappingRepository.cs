using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    
    public partial interface ISNS_MappingRepository : IBaseRepository<SNS_Mapping>
    {
    }
    public partial class SNS_MappingRepository : BaseRepository<SNS_Mapping>, ISNS_MappingRepository
    {
        public SNS_MappingRepository() : base(new PSIDbContext()) { }
    }
}
