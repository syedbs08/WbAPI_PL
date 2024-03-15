using Core.BaseEntitySql.BaseRepository;
using PSI.Domains.Entity;
using PSI.Domains;
using PSI.Modules.Backends.Masters.Repository.CurrencyMaster;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Masters.Repository.TurnoverDaysMaster
{
    public partial interface ITurnoverDaysRepository : IBaseRepository<TurnoverDays>
    {
    }
    public partial class TurnoverDaysRepository : BaseRepository<TurnoverDays>, ITurnoverDaysRepository
    {
        public TurnoverDaysRepository() : base(new PSIDbContext()) { }
    }
}
