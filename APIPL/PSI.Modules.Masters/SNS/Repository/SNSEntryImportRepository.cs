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
   
    public partial interface ISNSEntryImportRepository : IBaseRepository<SP_InsertSNSEntryDetails>
    {
    }
    public partial class SNSEntryImportRepository : BaseRepository<SP_InsertSNSEntryDetails>, ISNSEntryImportRepository
    {
        public SNSEntryImportRepository() : base(new PSIDbContext()) { }
    }
}
