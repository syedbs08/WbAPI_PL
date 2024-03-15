using Core.BaseEntitySql.BaseRepository;
using Core.BaseUtility;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.Adjustments.Repository
{
    public partial interface IAdjustmentEntryRepository: IBaseRepository<AdjustmentEntry>
    {
    }
    public partial class AdjustmentEntryRepository:BaseRepository<AdjustmentEntry>,IAdjustmentEntryRepository
    {
      public  AdjustmentEntryRepository():base(new PSIDbContext()) { }
    }
}
