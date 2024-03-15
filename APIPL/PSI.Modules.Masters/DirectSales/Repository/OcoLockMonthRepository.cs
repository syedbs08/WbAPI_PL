using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.DirectSales.Repository
{
    public partial interface IOcoLockMonthRepository : IBaseRepository<SalesEntry>
    {

    }
    public partial class OcoLockMonthRepository :BaseRepository<SalesEntry>,IOcoLockMonthRepository
    {
        public OcoLockMonthRepository():base(new PSIDbContext())
        {

        }
    }
}
