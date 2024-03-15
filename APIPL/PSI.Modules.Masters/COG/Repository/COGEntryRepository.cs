using Core.BaseEntitySql.BaseRepository;
using PSI.Domains;
using PSI.Domains.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PSI.Modules.Backends.COG.Repository
{

    public partial interface ICOGEntryImportRepository : IBaseRepository<COGEntry>
    {
    }
    public partial class COGEntryImportRepository : BaseRepository<COGEntry>, ICOGEntryImportRepository
    {
        public COGEntryImportRepository() : base(new PSIDbContext()) { }
    }
}
