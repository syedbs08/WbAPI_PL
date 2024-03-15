using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.SNS.Repository
{
    public partial interface ISNSEntryQtyPriceRepository : IBaseRepository<SNSEntryQtyPrice>
    {
    }
    public partial class SNSEntryQtyPriceRepository : BaseRepository<SNSEntryQtyPrice>, ISNSEntryQtyPriceRepository
    {
        public SNSEntryQtyPriceRepository() : base(new PSIDbContext()) { }
    }
   
}
